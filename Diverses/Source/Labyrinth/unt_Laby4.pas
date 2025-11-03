unit unt_Laby4;

{$mode objfpc}{$H+}

(*
  Einheit: unt_Laby4
  Autor:   [unbekannt]
  Zweck:
    - Erzeugung eines höhenbasierten Labyrinths (Zellenraster mit ganzzahligen "Höhenwerten")
    - Zellen mit Wert 0 gelten als "leer/ungeritzt" (noch nicht gesetzt)
    - Positive Werte (>= 1) repräsentieren die gesetzte Zellhöhe

  Überblick über die Datenstrukturen:
    - FDimension: Begrenzendes Rechteck (Spielfeldgröße). Width x Height legt die Rasterdimension fest.
    - FZValues:   2D-Array [0..Width-1, 0..Height-1] mit int-Werten (0 = unbesetzt)
    - sstr:       Pseudozufallsquelle als Zeichenkette. Wenn leer, wird Random() genutzt.
    - dir4:       4-Neighbourhood (N, E, S, W) aus `unt_Point2d` als T2DPoint-Array (1-basiert).
                  Jedes Element bietet .AsPoint (TPoint), sowie Operationen Add/Subtract.

  Algorithmus (Generate):
    1) Initialisierung:
       - Optionaler Seed/Sequenz sstr (wenn leer => echter Zufall)
       - Clear() setzt alle Zellen in FZValues auf 0
       - SetLData(FPrest2, 8, 6, 2) lädt ein kompaktes, vordefiniertes Startmuster (als "Rohdaten") in das Raster.
         Hinweis: Diese Startdaten sind als Hilfs-/Ankerpunkte gedacht und beeinflussen die spätere Höhenverteilung.

    2) Wachstumsschritt (Hauptschleife):
       - Startzelle ActCell := (1,6) wird auf (Baselevel-1) gesetzt.
       - Es wird in Schleifen über mögliche Richtungen (dir4) iteriert.
       - Für jede mögliche Richtung wird Next := ActCell - dir getestet.
         CalcPStepHeight(ActCell, Next, out Height)
           - Prüft, ob Next unbesetzt ist und ob die Nachbarschaftsbedingungen eingehalten werden:
             • Höhenunterschiede werden beschränkt (ph-1, ph, ph+1 sind die angestrebten Schritte)
             • Seiten-/Schrägnachbarn dürfen keine "verbotenen" Höhenrelationen haben.
             • Bevorzugt wird ein Schritt in Richtung Baselevel-Gradient (bl).
           - Liefert geeignete Zielhöhe HH[i] für Next zurück, wenn erlaubt.
       - Zufällige Auswahl unter den gültigen Richtungen (GetRnd).
       - Bei Verzweigungen (mehr als eine gültige Richtung) wird die aktuelle Zelle in ein FIFO geschrieben
         (einfaches Backtracking über FifoPopIdx/FifoPushIdx).
       - Wird keine Richtung gefunden, wird über FIFO zurückgesprungen (Pop), bis wieder ein Pfad fortgesetzt werden kann.

    3) Nachbearbeitung (Füllen restlicher 0-Zellen):
       - Iteration in einer Paritätsreihenfolge (Bitoperationen "or 1" und "xor 1" erzeugen ein Schachbrett/Versatzmuster).
       - Für eine leere Zelle pp werden min(zm) und max(zx) der Nachbarn bestimmt.
       - Heuristik:
         • Wenn mindestens ein Nachbar gesetzt ist (zm > 0):
             - Wenn (cx = 1) und (zx - zm < 6), dann pp := zx + cx (leichte Anhebung).
             - Sonst pp := zm - cn (leichte Absenkung).
         • Falls kein Nachbar gesetzt ist, pp := Baselevel(pp.x, pp.y).
       - Ziel: Glatte Integration der verbleibenden Zellen in das bestehende Höhenbild.

  Wichtige Designentscheidungen / Constraints:
    - Höhenänderung pro Schritt ist auf -1, 0 oder +1 beschränkt, sofern die Nachbarschaft das zulässt.
    - Starke lokale Sprünge werden vermieden (Seitenchecks in CalcPStepHeight).
    - Baselevel(x,y) definiert ein großskaliges Gefälle/Offset (zur globalen Steuerung des Terrains).
    - FDimension muss vor Verwendung gesetzt sein (SetDimension). Es wird dabei FZValues passend dimensioniert.

  Randfälle:
    - Ist FDimension leer/klein, können Indizes ungültig werden. Die meisten Operationen prüfen via Contains().
    - ActCell-Startkoordinate (1,6) muss innerhalb FDimension liegen, sonst bleibt das Grid leer.
    - sstr: Wenn die Zeichenfolge nicht zu den benötigten Zufallsbereichen passt, wird fallback auf Random(cnt) genutzt.

  Debug-/Visualisierungs-Hinweise:
    - {$ifdef ShowLabyCreation} optionaler Visualisierungsabschnitt (externes PaintField / Application.ProcessMessages).
    - {$ifdef DEBUG} definierte RandSeed zur Reproduzierbarkeit.

  Abhängigkeiten:
    - `unt_Point2d` liefert T2DPoint-Definition, dir4, und Punktoperationen.
    - Types TRect/TPoint/Funktionalität (Contains etc.) kommen über FPC/LCL (SysUtils, Classes).

  Hinweise zur Erweiterung:
    - OnUpdateCell-Event: Kann verwendet werden, um GUI/Logging während der Generierung zu aktualisieren.
    - Baselevel kann durch eine andere Terrainfunktion ersetzt werden, um andere globale Gradienten zu erzeugen.
*)

interface

uses
  Classes, SysUtils;

type
  // Event, das aufgerufen wird, wenn eine einzelne Zelle aktualisiert werden soll
  TUpdateCellEvent = procedure(Sender: TObject; Cell: TPoint) of object;

  { THeightLaby
    Erzeugt ein höhenbasiertes Labyrinth auf einem rechteckigen Raster.
    Zugriff auf Zellen über LabyHeight[x,y] bzw. LabyHeightp[TPoint].
    Die äußere Welt konfiguriert über Dimension (SetDimension).
  }
  THeightLaby = class // (TBaseLaby)
  private
    FOnUpdate: TNotifyEvent;         // Optionaler "Alles hat sich geändert"-Callback (hier derzeit nicht aktiv genutzt)
    FOnUpdateCell: TUpdateCellEvent; // Wird pro bearbeiteter Zelle ausgelöst (falls gesetzt)

    type
      // Puffer für die 4 möglichen Richtungen im Raster
      TPosArray = array[0..3] of TPoint;

    const
      // Optionale deterministische Zufallsvorgaben (als Zeichenkettenkodierung)
      FPrest: string =
        '111102010111101001020301102100010001112201210011103101010010211112';
      FPrest2: string = '4465452.7575331.6566211.' +
        '213265103021342243312434';

    var
      sstr: string;                   // "Zufalls"-Eingabesequenz; leer => echter Zufall
      FDimension: TRect;              // Arbeitsbereich des Labyrinths
      FZValues: array of array of integer; // Höhenwerte je Zelle (0 = unbesetzt)

    // Getter/Setter und Hilfsroutinen
    function GetLabyHeight(x, y: integer): integer; overload; inline;
    function GetLabyHeight(pnt: TPoint): integer; overload; inline;
    procedure SetDimension(const AValue: TRect);
    procedure SetOnUpdate(const AValue: TNotifyEvent);
    procedure SetOnUpdateCell(const AValue: TUpdateCellEvent);

  {$ifdef DEBUG}
  public
  {$endif}
    // Setzt das komplette Grid (FZValues) auf 0
    procedure Clear;

    // Prüft, ob von ActPlace nach NextPlace ein Schritt möglich ist und liefert die gewünschte Zielhöhe.
    // Liefert:
    //   - Height: ph-1, ph, oder ph+1 (abhängig von Nachbarschafts- und Baselevel-Regeln)
    //   - Result = True, wenn möglich; False, wenn geblockt (NextPlace bereits belegt oder Regelverstoß)
    function CalcPStepHeight(ActPlace, NextPlace: TPoint; out Height: integer): boolean;

    // Deterministischer/zufälliger Index 0..cnt-1
    function GetRnd(cnt: integer): integer;

    // Lädt kodierte Rohdaten (z.B. FPrest2) in FZValues mit Versatz Offset.
    // Erwartet xm*ym Zeichen; Zeichen '0'..'9' werden auf 0..9 gemappt und +Offset verschoben.
    // Indizierung dreht dabei die Sequenz um (Rückwärtslesen), um die Einbettung zu erleichtern.
    procedure SetLData(Sdat: string; xm, ym, Offset: integer);

    // Setzt eine einzelne Höhe, wenn innerhalb der Dimension und wenn sich der Wert ändert.
    procedure SetLabyHeight(x, y, val: integer); overload; inline;

  public
    // Startet die Labyrinth-Generierung:
    //  - Initialisiert das Feld
    //  - Wächst einen Pfad gemäß lokalen und globalen Regeln
    //  - Füllt danach verbleibende leere Zellen heuristisch
    procedure Generate;

    // Liefert eine "Grundhöhe" (globaler Gradient) für (x,y)
    function Baselevel(x, y: integer): integer;

    // Events/Properties
    property OnUpdate: TNotifyEvent read FOnUpdate write SetOnUpdate;
    property OnUpdateCell: TUpdateCellEvent read FOnUpdateCell write SetOnUpdateCell;
    property Dimension: TRect read FDimension write SetDimension;
    property LabyHeight[x, y: integer]: integer read GetLabyHeight; default;
    property LabyHeightp[pnt: TPoint]: integer read GetLabyHeight;
  end;

implementation

(*
  Visualisierung zu FPrest2 (Kommentare; Punkt = Trenner)
         4465452.
         7575331.
         6566211.
         21326510
         30213422
         43312434
*)

uses
  unt_Point2d; // liefert u.a. dir4 (4-Nachbarn), T2DPoint, Punktarithmetik

{ THeightLaby }

function THeightLaby.GetRnd(cnt: integer): integer;
var
  st: byte;
begin
  // Liefert 0..cnt-1. Wenn sstr vorhanden ist, wird das erste Zeichen als Zahl interpretiert,
  // entnommen und anschließend entfernt; liegt die Zahl außerhalb des Bereichs, Fallback auf Random().
  if length(sstr) = 0 then
    exit(random(cnt))
  else
  begin
    st := Ord(sstr[1]) - Ord('0'); // Zeichen in Zahl 0..9
    Delete(sstr, 1, 1);
  end;
  if (st <= cnt) then
    exit(st)
  else
    exit(random(cnt));
end;

procedure THeightLaby.SetLData(Sdat: string; xm, ym, Offset: integer);
var
  x, y: integer;
begin
  // Mapt die Zeichenkette Sdat (Länge = xm*ym) auf das 2D-Raster.
  // Achtung: Indizierung liest rückwärts ([(xm*ym) - y*xm - x]) und subtrahiert '0' (48),
  //          anschließend Offset addieren.
  for x := 0 to xm - 1 do
    for y := 0 to ym - 1 do
      FZValues[x, y] := Ord(Sdat[(xm * ym) - y * xm - x]) - 48 + Offset;
end;

procedure THeightLaby.SetLabyHeight(x, y, val: integer);
begin
  // Setzt die Zelle, wenn sie innerhalb der Dimension liegt und der Wert sich ändert.
  if FDimension.Contains(Point(x, y)) and (FZValues[x, y] <> val) then
    FZValues[x, y] := val;
end;

function THeightLaby.Baselevel(x, y: integer): integer;
begin
  // Ein einfacher schräger Gradient (45°-ähnlich), leicht skaliert
  Result := trunc((x / 1.3) + (y / 1.3)) + 1;
end;

function THeightLaby.GetLabyHeight(x, y: integer): integer;
begin
  // Sicheres Lesen: Außerhalb => 0 (unbesetzt)
  if FDimension.Contains(Point(x, y)) then
    Result := FZValues[x, y]
  else
    Result := 0;
end;

function THeightLaby.GetLabyHeight(pnt: TPoint): integer;
begin
  // Überladung für TPoint
  if FDimension.Contains(pnt) then
    Result := FZValues[pnt.x, pnt.y]
  else
    Result := 0;
end;

procedure THeightLaby.SetDimension(const AValue: TRect);
begin
  // Setzt die Dimension und dimensioniert das Zellenfeld neu.
  // Hinweis: Daten gehen hierbei verloren (Neuallokation).
  if FDimension = AValue then
    Exit;
  FDimension := AValue;
  setlength(FZValues, AValue.Width, AValue.Height);
end;

procedure THeightLaby.SetOnUpdate(const AValue: TNotifyEvent);
begin
  if FOnUpdate = AValue then
    Exit;
  FOnUpdate := AValue;
end;

procedure THeightLaby.SetOnUpdateCell(const AValue: TUpdateCellEvent);
begin
  if FOnUpdateCell = AValue then
    Exit;
  FOnUpdateCell := AValue;
end;

function THeightLaby.CalcPStepHeight(ActPlace, NextPlace: TPoint; out Height: integer): boolean;
var
  bFlCanm1, bFlCanz, bFlCanp1: boolean; // Flags: Ist ph-1 / ph / ph+1 an NextPlace erlaubt?
  iLbht, bl, ph, i: integer;
  t, dd, dr: TPoint;
begin
  // ph = aktuelle Höhe am aktuellen Ort
  ph := GetLabyHeight(ActPlace);

  // NextPlace muss leer sein und ActPlace darf nicht leer sein
  if (ph = 0) or (GetLabyHeight(NextPlace) <> 0) then
    exit(false);

  // Startannahme: Alle drei Optionen sind erlaubt, bis eine Regel sie verbietet
  bFlCanm1 := True;
  bFlCanz := True;
  bFlCanp1 := True;

  // Nachbarschaftsprüfung: unmittelbare 4-Nachbarn von NextPlace (ohne ActPlace selbst)
  for i := 1 to 4 do
  begin
    t := NextPlace.Add(dir4[i].AsPoint);
    if not (t = ActPlace) then
    begin
      iLbht := GetLabyHeight(t);
      // Restriktionslogik:
      //  - ph-1 ist unzulässig, wenn ein Nachbar genau ph-1 ist (sonst "engen" wir die lokale Variation ein)
      //  - ph   ist unzulässig, wenn ein Nachbar genau ph ist
      //  - ph+1 ist unzulässig, wenn ein Nachbar genau ph+1 ist
      // plus weichere Abstandsbedingungen (iLbht < ph-2 oder iLbht > ph+2 erlauben mehr Freiraum)
      bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht < ph - 2) or (iLbht > ph));
      bFlCanz  := bFlCanz  and ((iLbht = 0) or (iLbht < ph - 1) or (iLbht > ph + 1));
      bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht < ph)     or (iLbht > ph + 2));
    end
    else
      dd := dir4[i].AsPoint; // dd = Richtung von NextPlace zurück zu ActPlace
  end;

  // dr = dd um 90° gedreht (Seitenrichtung), um diagonale Konflikte indirekt zu berücksichtigen
  dr := point(-dd.Y, dd.x); // rotate dd by 90°

  // Seitennachbar links von dd prüfen (NextPlace - dr)
  if (GetLabyHeight(NextPlace.Subtract(dr)) = 0) then
  begin
    // Zelle (Next - dr + dd): "vorne-links"
    iLbht := GetLabyHeight(NextPlace.Subtract(dr).add(dd));
    bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht <> ph - 1));
    bFlCanz  := bFlCanz  and ((iLbht = 0) or (iLbht <> ph));
    bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht <> ph + 1));
    // Zelle (Next - dr - dd): "hinten-links"
    iLbht := GetLabyHeight(NextPlace.Subtract(dr).Subtract(dd));
    bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht <> ph - 1));
    bFlCanz  := bFlCanz  and ((iLbht = 0) or (iLbht <> ph));
    bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht <> ph + 1));
  end;

  // Seitennachbar rechts von dd prüfen (NextPlace + dr)
  if (GetLabyHeight(NextPlace.add(dr)) = 0) then
  begin
    // Zelle (Next + dr + dd): "vorne-rechts"
    iLbht := GetLabyHeight(NextPlace.add(dr).add(dd));
    bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht <> ph - 1));
    bFlCanz  := bFlCanz  and ((iLbht = 0) or (iLbht <> ph));
    bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht <> ph + 1));
    // Zelle (Next + dr - dd): "hinten-rechts"
    iLbht := GetLabyHeight(NextPlace.add(dr).subtract(dd));
    bFlCanm1 := bFlCanm1 and ((iLbht = 0) or (iLbht <> ph - 1));
    bFlCanz  := bFlCanz  and ((iLbht = 0) or (iLbht <> ph));
    bFlCanp1 := bFlCanp1 and ((iLbht = 0) or (iLbht <> ph + 1));
  end;

  // Baselevel an NextPlace als globaler Trend
  bl := Baselevel(NextPlace.x, NextPlace.y);
  Height := 0;

  // Falls alle drei Optionen verboten sind, ist der Schritt nicht möglich
  if not (bFlCanm1 or bFlCanp1 or bFlCanz) then
    exit(False);

  // Optimale Wahl (Tendenz zum Baselevel):
  //  - wenn bl > ph, bevorzuge +1,
  //  - wenn bl < ph, bevorzuge -1,
  //  - sonst 0 (gleich halten)
  if bFlCanp1 and ((bl > ph) or (not bFlCanz) and (not bFlCanm1 or (bl = ph))) then
  begin
    Height := ph + 1;
    exit(True);
  end;

  if bFlCanm1 and ((bl < ph) or (not bFlCanz) and (not bFlCanp1 or (bl = ph))) then
  begin
    Height := ph - 1;
    exit(True);
  end;

  if bFlCanz then
  begin
    Height := ph;
    exit(True);
  end;

  // Sollte nicht erreichbar sein
  exit(False);
end;

procedure THeightLaby.Clear;
var
  x, y: integer;
begin
  // Setzt alle Rasterwerte auf 0 (unbesetzt)
  for x := 0 to FDimension.Width - 1 do
    for y := 0 to FDimension.Height - 1 do
      FZValues[x, y] := 0;
end;

procedure THeightLaby.Generate;
var
  x, y, DirCount, FifoPushIdx, FifoPopIdx, I, zz, zm: integer;
  ActCell, Accu: TPoint;
  StoredCell, t: TPoint;
  Fifo: array of TPoint;      // Backtracking-Struktur: speichert "offene" Zellen bei Verzweigungen
  HH: array[0..3] of integer; // Kandidatenhöhen für bis zu 4 Richtungen
  PosibDir: TPosArray;        // Puffer für Richtungsvektoren (als TPoint)
  ActDirP, cn, zx, cx: integer;
  First: boolean;
  pp, Next: TPoint;
  ActDir: T2DPoint;
begin
  Randomize;
  {$ifdef DEBUG}
  RandSeed := 123; // deterministisch in DEBUG
  {$endif }
  sstr := ''; // FPrest; // Optional: deterministische Sequenz aktivieren

  // Rohdaten - Init
  Clear;
  SetLData(FPrest2, 8, 6, 2); // lädt ein kleines Startmuster in FZValues (Offset 2)

  // Laby-Algorithmus
  ActCell := Point(1, 6);
  StoredCell := ActCell;
  Accu := Point(0, 0); // aktuell ungenutzt, Platzhalter für evtl. spätere Erweiterungen

  try
    // Startwert an der Startzelle leicht unter Baselevel
    FZValues[ActCell.x, ActCell.y] := Baselevel(ActCell.x, ActCell.y) - 1;

    // FIFO initialisieren
    FifoPushIdx := 0;
    FifoPopIdx := 0;
    SetLength(Fifo{%H-}, FDimension.Width * FDimension.Height);

    Dircount := 1; // Startbedingung für Schleife

    // Solange mindestens eine Richtung existiert ODER noch Einträge im FIFO vorliegen
    while (DirCount <> 0) or (FifoPushIdx >= FifoPopIdx) do
    begin
      // Switch ActCell <-> StoredCell (ein kleiner Trick, um die "aktive" Zelle rotiert zu halten)
      t := ActCell;
      ActCell := StoredCell;
      StoredCell := t;

      // Optionaler Hook: UI/Logging über den aktuellen Arbeitspunkt informieren
      if assigned(FOnUpdateCell) then
        FOnUpdateCell(Self, ActCell);

      // Gültige Richtungen sammeln
      Dircount := 0;
      for ActDir in dir4 do
      begin
        PosibDir[DirCount] := ActDir.asPoint;
        Next := ActCell.Subtract(PosibDir[DirCount]); // "Vorwärtsbewegung" in diese Richtung

        // Testen, ob Richtung möglich und die resultierende Höhe zur Heuristik passt
        if FDimension.Contains(Next) and
           CalcPStepHeight(ActCell, Next, HH[Dircount]) and
           // Heuristik: Höhe darf nicht zu weit vom Baselevel abweichen (Schwelle 3)
           (abs(HH[Dircount] - Baselevel(Next.x, Next.y) - 1) < 3) then
        begin
          Inc(Dircount);
        end;
      end;

      // Zufallsauswahl aus den gefundenen Richtungen
      if Dircount > 0 then
        ActDirP := GetRnd(Dircount);

      if (DirCount > 0) and (ActDirP < Dircount) then
      begin
        // Push der aktuellen Zelle in FIFO, wenn mehrere Optionen existieren (Backtracking ermöglichen)
        if Dircount > 1 then
        begin
          Fifo[FifoPushIdx] := ActCell;
          Inc(FifoPushIdx);
        end;

        // tatsächlicher Schritt
        Next := ActCell.Subtract(PosibDir[ActDirP]);
        ActCell := Next;
        FZValues[Next.x, Next.y] := HH[ActDirP];
      end
      else
      begin
        // Kein Schritt möglich: Backtracking per FIFO (Pop)
        if FifoPushIdx >= FifoPopIdx then
        begin
          ActCell := Fifo[FifoPopIdx];
          Inc(FifoPopIdx);
        end;
      end;

      {$ifdef ShowLabyCreation}
      // Optional: Zwischendarstellung
      if (FifoPushIdx mod FDimension.Width = 0) {or (length(sstr)>0)} then
      begin
        for x := 0 to FDimension.Width - 1 do
          for y := 0 to FDimension.Height - 1 do
          begin
            PaintField(x, y);
          end;
        Application.ProcessMessages;
        sleep(1);
      end;
      {$endIf}
    end;
  finally
    SetLength(Fifo, 0); // Speicher räumen
  end;

  // Nachbearbeitung: nicht besetzte Zellen (Wert = 0) auffüllen
  // Die Iteration mit "(Width-1) or 1" setzt das niederwertigste Bit => erzeugt eine Startparität (odd).
  // Zusammen mit "pp := point(x xor 1, y xor 1)" wird so ein Versatzmuster erzeugt, das die Verteilung glättet.
  for x := (FDimension.Width - 1) or 1 downto 0 do
    for y := (FDimension.Height - 1) or 1 downto 0 do
    begin
      pp := point(x xor 1, y xor 1);
      if FDimension.Contains(pp) and (GetLabyHeight(pp) = 0) then
      begin
        First := True;
        zm := 0; // min Nachbarhöhe (>0)
        cn := 0; // Zähler für min-Annäherung (max 2)
        zx := 0; // max Nachbarhöhe (>0)
        cx := 0; // Zähler für max-Annäherung (max 2)

        // Nachbarschaft prüfen
        for I := 1 to 4 do
        begin
          zz := GetLabyHeight(pp.Add(dir4[i].AsPoint));
          if (zz > 0) and ((First) or (zz <= zm)) then
          begin
            if zz < zm then
              cn := 0;
            zm := zz;
            if cn < 2 then
              Inc(cn);
          end;
          if (zz > 0) and ((First) or (zz >= zx)) then
          begin
            if zz > zx then
              cx := 0;
            zx := zz;
            if cx < 2 then
              Inc(cx);
            First := False;
          end;
        end;

        // Heuristik: leichte Anhebung an lokalen Maxima oder Absenkung an lokalen Minima
        if zm > 0 then
          if (cx = 1) and (zx - zm < 6) then
            FZValues[pp.x, pp.y] := zx + cx
          else
            FZValues[pp.x, pp.y] := zm - cn
        else
          // Falls keine Nachbarn gesetzt sind, fallback auf Baselevel
          FZValues[pp.x, pp.y] := Baselevel(pp.x, pp.y);
      end;
    end;
end;

end.
