unit frm_laby4b;

{$IFDEF FPC}
 {$MODE Delphi}
{$ENDIF}

{------------------------------------------------------------------------------
 Einheit: frm_laby4b
 Zweck:
 - Formular zur Generierung, Vorschau, Darstellung (isometrisch) und Druck
 eines Höhen-Labyrinths auf Basis von `THeightLaby` (siehe unt_Laby4).
 - Bietet eine Vorschau im `pbxPreview` (Raster-Preview) und eine perspektivisch
 wirkende Darstellung im `pbxResult` (Pseudo-3D/Isometrie mittels `Drawbox`).
 - Ermöglicht das Erzeugen neuer Höhenfelder, deren Aktualisierung sowie den
 Ausdruck auf einen Drucker via `TPrintDialog`.

 Aufbau:
 - Form-Controls: Buttons (Generieren/Zeichnen/Drucken), Label, zwei PaintBoxen,
 Panels, SpinEdit (Größe), PrintDialog.
 - Workflow:
1. Größe (CLen) wählen ? `btnGenerateClick` erzeugt Feld via `FHLaby.Generate`.
2. Aktualisierung der Preview (`UpdateGField`) bzw. dynamische Updates bei
 Debug mittels `LabyUpdateCell`.
3. Zeichnung isometrischer Sicht mit `btnDrawClick` ? `Drawbox` auf `pbxResult`.
4. Drucken mit `btnPrintClick` in Querformat.

 Hinweise:
 - `FHLaby` implementiert Indexer-Zugriffe: `FHLaby[x, y]` liefert die Höhe.
 - Nachbarschaften/Gangbarkeit werden farblich angedeutet: Verbindungen mit
 geringer Höhendifferenz (<2) werden als weiße Linien eingezeichnet.
 - `c` skaliert die Größe einer einzelnen Preview-Zelle.
 - `Baselevel(x,y)` definiert eine Basis-/Unterkante für die3D-Darstellung.
------------------------------------------------------------------------------}

{ $define ShowLabyCreation}

interface

uses
{$IFnDEF FPC}
 Windows,
{$ELSE}
 LCLIntf, LCLType,
{$ENDIF}
 SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, ExtCtrls, Buttons, StdCtrls, Spin, PrintersDlgs, unt_Laby4;

type

 { TFrmLaby4
 Formular mit UI zur Steuerung der Labyrinth-Generierung und -Darstellung. }

 TFrmLaby4 = class(TForm)
 btnPrint: TBitBtn; // Startet Druckdialog und druckt die3D-Ansicht
 btnGenerate: TBitBtn; // Generiert ein neues Höhenlabyrinth
 btnDraw: TBitBtn; // Zeichnet die isometrische Darstellung (3D)
 lblLabySize: TLabel; // Beschriftung für die Größe
 pbxResult: TPaintBox; // Zeichenfläche für isometrische Darstellung
 pbxPreview: TPaintBox; // Zeichenfläche für Raster-Vorschau (2D)
 pnlRight: TPanel; // Seitenpanel (Layout)
 pnlRightCl2: TPanel; // Unterpanel (Layout)
 PrintDialog1: TPrintDialog; // Druckdialog
 edtLabySize: TSpinEdit; // Eingabefeld für Labyrinth-Kantenlänge
 procedure btnGenerateClick(Sender: TObject); // Generiert Feld und aktualisiert Preview
 procedure btnDrawClick(Sender: TObject); // Zeichnet3D-Sicht
 procedure btnPrintClick(Sender: TObject); // Druckt3D-Sicht
 procedure FormCreate(Sender: TObject); // Initialisiert FHLaby/Defaultwerte
 procedure FormDestroy(Sender: TObject); // Gibt Ressourcen frei
 procedure pbxPreviewPaint(Sender: TObject); // Re-Render der Preview bei Paint
 procedure edtLabySizeChange(Sender: TObject);// Änderung der Kantenlänge/Skalierung
 private
 FHLaby: THeightLaby; // Kernmodell für Höhenlabyrinth
 Clen :integer; // Kantenlänge (Anzahl Zellen pro Seite)
 FMargin: Integer; // (aktuell) ungenutzter Rand für pbxResult
 lastCell: TPoint; // Letztveränderte Zelle (für Debug-Update)
 { Zeichnet eine einzelne Zelle in der2D-Preview in Farbe abhängig von Höhe. }
 procedure Drawbox(Canvas: TCanvas; x, y, z: integer; DrawHead: boolean);
 { Ereignis-Handler (Debug): wird bei Zell-Updates während `Generate` aufgerufen. }
 procedure LabyUpdateCell(Sender: TObject; Cell: TPoint);
 { Malt eine Zelle (x,y) im Preview. `mark=true` hebt die Zelle farblich hervor. }
 procedure PaintField(x, y: integer; mark: boolean = False);
 { Malt das gesamte Preview-Feld entsprechend aktueller `FHLaby`-Daten. }
 procedure UpdateGField;
 { Private-Deklarationen }
 public
 { Public-Deklarationen }
 end;

var
 FrmLaby4: TFrmLaby4;



implementation

uses unt_Point2d, Printers;

{$IFnDEF FPC}
 {$R *.lfm}

{$ELSE}
 {$R *.lfm}
{$ENDIF}

const
 c:integer =3; // Basisskalierung pro Zelle in der Preview (Pixelhalbkanten)

{------------------------------------------------------------------------------
 PaintField
 Zeichnet die Zelle (x,y) in `pbxPreview` als gefülltes Rechteck. Farbe hängt
 von der Höhe `FHLaby[x,y]` und von `mark` ab. Zusätzlich werden Verbindungen
 zu linken/unteren Nachbarn mit geringer Höhendifferenz (<2) als weiße Linien
 eingezeichnet, um gangbare Übergänge zu visualisieren.
------------------------------------------------------------------------------}
procedure TFrmLaby4.PaintField(x, y: integer; mark: boolean = False);
var
 yy, xx: integer;
begin
 with pbxPreview do
 begin
 // Farbgebung: stärkerer Blauanteil; bei markierter Zelle mehr Rot
 if mark then
 Canvas.Brush.Color :=
 rgb(63 + (FHLaby[x, y] *192) div (Clen *2 +5),
0 + (FHLaby[x, y] *192) div (Clen *2 +5),
 (FHLaby[x, y] *192) div (Clen *2 +5))
 else
 Canvas.Brush.Color :=
 rgb((FHLaby[x, y] *196) div (Clen *2 +5),
 (FHLaby[x, y] *196) div (Clen *2 +5),
 (FHLaby[x, y] *255) div (Clen *2 +5));

 // Umrechnung Koordinaten: Preview ist gespiegelt/gedreht
 yy := clen - y -1;
 xx := clen - x -1;

 // Zellen-Rechteck füllen
 Canvas.FillRect(Rect(xx * c *2, yy * c *2, (xx +1) *
 c *2, (yy +1) * c *2));

 // Kanten zeichnen, wenn Nachbar in x-Richtung ähnliche Höhe hat
 if (x >=1) and (abs(FHLaby[x, y] - FHLaby[x -1, y]) <2) then
 begin
 Canvas.pen.Color := clwhite;
 Canvas.moveto(xx * c *2 + c, yy * c *2 + c);
 Canvas.Lineto(xx * c *2 + c *3, yy * c *2 + c);

 end;
 // Kanten zeichnen, wenn Nachbar in y-Richtung ähnliche Höhe hat
 if (y >=1) and (abs(FHLaby[x, y] - FHLaby[x, y -1]) <2) then
 begin
 Canvas.pen.Color := clwhite;
 Canvas.moveto(xx * c *2 + c, yy * c *2 + c);
 Canvas.Lineto(xx * c *2 + c, yy * c *2 + c *3);
 end;
 end;
end;

{------------------------------------------------------------------------------
 UpdateGField
 Zeichnet das komplette Preview-Raster neu, indem jede Zelle mit `PaintField`
 gerendert wird.
------------------------------------------------------------------------------}
procedure TFrmLaby4.UpdateGField;
var
 y: integer;
 x: integer;
begin
 for x :=0 to FHLaby.Dimension.Width -1 do
 for y :=0 to FHLaby.Dimension.Height -1 do
 PaintField(x, y);
end;

{------------------------------------------------------------------------------
 btnGenerateClick
 Erzeugt ein neues Höhenlabyrinth mit aktueller Kantenlänge `CLen`, setzt die
 Größen der Preview-Flächen und startet die Generierung. In DEBUG-Konfiguration
 wird `OnUpdateCell` auf `LabyUpdateCell` gesetzt, um schrittweise Updates
 anzuzeigen.
------------------------------------------------------------------------------}
procedure TFrmLaby4.btnGenerateClick(Sender: TObject);

begin
 pnlRight.Width := CLen * c *2 +2; // Layout anpassen
 pbxPreview.Width := CLen * c *2;
 FHLaby.Dimension := rect(0,0, Clen, Clen);
 pbxPreview.Height := CLen * c *2;
 Application.ProcessMessages;
{$ifdef DEBUG}
 FHLaby.OnUpdateCell:=LabyUpdateCell; // Live-Updates beim Generieren
{$endif }
 FHLaby.Generate; // Labyrinth erzeugen
 UpdateGField; // Preview auffrischen
end;

{------------------------------------------------------------------------------
 Drawbox
 Zeichnet eine einzelne Zelle (x,y) auf einer "Ebene" z (Höhenstufe) im
 isometrischen Stil auf das übergebene `Canvas`. Bei `DrawHead=true` wird die
 oberste Kante (Deckel) gezeichnet; ansonsten Seitenflächen abhängig von
 Nachbarschaft und relativer Höhe.

 Parameter:
 - Canvas: Ziel-Zeichenfläche (Preview oder Drucker)
 - x, y: Zellenkoordinaten
 - z: aktuelle Darstellungs-Höhenstufe
 - DrawHead: true, wenn Deckfläche gezeichnet werden soll

 Interne Logik:
 - L/H werden aus der ClipRect-Größe abgeleitet, sodass Darstellung sich
 an verfügbare Zeichenfläche anpasst.
 - x2/y2 bestimmen die Lage der Kachel in2D (isometrische Projektion).
 - Seitenflächen werden abhängig von benachbarten Höhen gezeichnet, um
 Stufen/Abstufungen plastisch zu zeigen.
------------------------------------------------------------------------------}
procedure TFrmLaby4.Drawbox(Canvas: TCanvas; x, y, z: integer; DrawHead: boolean);
var
 x2, y2, L, H, s, s2, d: integer;
 pts: array of TPoint;

begin

 L := Canvas.ClipRect.Right div (Clen *2);
 H := Canvas.ClipRect.Height div (Clen *4 + FHLaby.Baselevel(Clen -1, Clen -1)+4);
 x2 := (Clen - x + y) * L;
 y2 := Canvas.ClipRect.bottom - (x *2 + y *2 + z +2) * H;
 setlength(pts{%H-},4);
 pts[0] := point(x2, y2);

 // Linke Seitenfläche, wenn links keine höhere/gleich hohe Stufe vorhanden
 if (x =0) or (FHLaby[x -1, y] < z) then
 begin
 // pbxResult.Canvas.pen.Color := pbxResult.Canvas.Brush.Color;
 pts[1] := point(x2 + L, y2 - H *2);
 pts[2] := point(x2 + L, y2 - H);
 pts[3] := point(x2, y2 + H);
 Canvas.pen.Color := clBlack;
 Canvas.Brush.Color := clDkGray;
 Canvas.Polygon(pts);
 end;

 // Rechte Seitenfläche, wenn oben keine höhere/gleich hohe Stufe vorhanden
 if (y =0) or (FHLaby[x, y -1] < z) then
 begin
 Canvas.Brush.Color := clLtGray;
 Canvas.pen.Color := clWhite;
 pts[1] := point(x2 - L, y2 - H *2);
 pts[2] := point(x2 - L, y2 - H);
 pts[3] := point(x2, y2 + H);
 Canvas.Polygon(pts);

 // Schräge Verbindung an der Kante (Detail) basierend auf diagonaler Zelle
 if (x < clen -1) and (y >0) and (FHLaby[x +1, y -1] - z >=0) then
 begin
 d := FHLaby[x +1, y -1];
 s := trunc((d - z) * L /8);
 s2 := trunc((d - z +1) * L /8);
 if s2 <= L then
 begin
 pts[0] := point(x2 + s - L, y2 - H *2 + trunc(s * H / L *2));
 pts[3] := point(x2 + s2 - L, y2 - H *1 + trunc(s2 * H / L *2 +0.5));
 Canvas.pen.Color := clDkGray;
 Canvas.Brush.Color := clDkGray;
 Canvas.Polygon(pts);
 Canvas.pen.Color := clBlack;
 Canvas.Line(pts[1], pts[2]);
 Canvas.Line(pts[2], pts[3]);
 pts[0] := point(x2, y2);
 end;
 end;
 end;
 // pbxResult.Canvas.PolyLine(pts);
 // pbxResult.Canvas.pen.Color := pbxResult.Canvas.Brush.Color;

 // Deckfläche zeichnen, wenn oberer Abschluss erreicht
 if DrawHead then
 begin
 pts[1] := point(x2 + L, y2 - H *2);
 pts[2] := point(x2, y2 - H *4);
 pts[3] := point(x2 - L, y2 - H *2);
 Canvas.Brush.Color := clwhite;
 Canvas.pen.Color := clLtGray;
 Canvas.Polygon(pts);
 // pbxResult.Canvas.PolyLine(pts);

 // Rechte, oben ansteigende Fläche, wenn rechts höhere Zelle vorhanden
 if (x < clen -1) and (FHLaby[x +1, y] - z >0) then
 begin
 s := trunc((FHLaby[x +1, y] - z) * L /8);
 pts[1] := point(x2 + s, y2 - H *4 + trunc(s * H / L *2));
 pts[0] := point(x2 + s - L, y2 - H *2 + trunc(s * H / L *2));
 Canvas.pen.Color := clltGray;
 Canvas.Brush.Color := clDkGray;
 Canvas.Polygon(pts);
 end;
 end;
end;

{------------------------------------------------------------------------------
 LabyUpdateCell (nur DEBUG)
 Visualisiert Schritt-für-Schritt die Generierung: Zunächst der3x3-Block um
 `lastCell` neu zeichnen, dann die neue Zelle hervorheben und kurz pausieren.
------------------------------------------------------------------------------}
procedure TFrmLaby4.LabyUpdateCell(Sender: TObject; Cell: TPoint);
var
 i: Integer;
begin
 for i :=0 to8 do
 if FHLaby.Dimension.Contains(lastcell.add(point(i mod3,i div3) )) then
 PaintField(lastcell.x+(i mod3), lastcell.y+(i div3),false);
 PaintField(cell.x, cell.y,true);
 lastCell := cell;
 Application.ProcessMessages;
 sleep(100);
end;

{------------------------------------------------------------------------------
 btnDrawClick
 Zeichnet die isometrische Ansicht auf `pbxResult`. Falls noch nicht erzeugt,
 wird zunächst generiert. Es werden alle Zellen von oben nach unten und von
 rechts nach links, für alle Höhenstufen `z`, gezeichnet. Die Bedingung
 `(z > Baselevel(x,y) -6)` blendet tiefe Bereiche teilweise aus, um eine
 plastische Darstellung zu erreichen.
------------------------------------------------------------------------------}
procedure TFrmLaby4.btnDrawClick(Sender: TObject);

var
 x, y, z: integer;

begin
 if FHLaby.Dimension.Width < Clen then
 btnGenerateClick(Sender);
 pbxResult.Canvas.Brush.Color := Color;
 pbxResult.Canvas.FillRect(pbxResult.Canvas.ClipRect);
 FMargin:=10;
 for z :=0 to (Clen *2 +4) do
 for x := Clen -1 downto0 do
 for y := Clen -1 downto0 do
 if (FHLaby[x, y] >= z) and ((x =0) or (y =0) or
 (z > FHLaby.baselevel(x, y) -6)) then
 Drawbox(pbxResult.Canvas, x, y, z, FHLaby[x, y] = z);

end;

{------------------------------------------------------------------------------
 btnPrintClick
 Druckt die isometrische Darstellung auf dem Standarddrucker. Falls nötig,
 wird zuvor generiert. Zeichnung wie in `btnDrawClick`, jedoch auf dem
 Drucker-Canvas, Hoch-/Querformat auf Querformat gesetzt.
------------------------------------------------------------------------------}
procedure TFrmLaby4.btnPrintClick(Sender: TObject);
var
 x, y, z: integer;
 cl: TRect;
 pr: TPaperRect;
begin
 if FHLaby.Dimension.Width < Clen then
 btnGenerateClick(Sender);
 if PrintDialog1.Execute then
 begin
 printer.Orientation := poLandscape;
 printer.Title := 'Laby #4 ' + DateToStr(now());
 Printer.BeginDoc;
 for z :=0 to (Clen *2 +4) do
 for x := Clen -1 downto0 do
 for y := Clen -1 downto0 do
 if (FHLaby[x, y] >= z) and
 ((x =0) or (y =0) or (z > FHLaby.baselevel(x, y) -6)) then
 Drawbox(printer.Canvas, x, y, z, FHLaby[x, y] = z);
 Printer.EndDoc;
 end;
end;

{------------------------------------------------------------------------------
 FormCreate
 Initialisiert das Labyrinth-Objekt und setzt eine Default-Kantenlänge.
------------------------------------------------------------------------------}
procedure TFrmLaby4.FormCreate(Sender: TObject);
begin
 FHLaby := THeightLaby.Create;
 Clen:=21;
end;

{------------------------------------------------------------------------------
 FormDestroy
 Gibt das Labyrinth-Objekt frei.
------------------------------------------------------------------------------}
procedure TFrmLaby4.FormDestroy(Sender: TObject);
begin
 FreeAndNil(FHLaby);
end;

{------------------------------------------------------------------------------
 pbxPreviewPaint
 Vollständige Neuzeichnung der Preview bei Bedarf (z. B. Fenster-Invalidierung).
------------------------------------------------------------------------------}
procedure TFrmLaby4.pbxPreviewPaint(Sender: TObject);
begin
 UpdateGField;
end;

{------------------------------------------------------------------------------
 edtLabySizeChange
 Übernimmt die neue Kantenlänge aus dem SpinEdit und justiert den
 Preview-Skalierungsfaktor `c` so, dass kleine Labyrinthe größer dargestellt
 werden.
------------------------------------------------------------------------------}
procedure TFrmLaby4.edtLabySizeChange(Sender: TObject);
begin
 with sender as TSpinEdit do
 begin
 Clen := Value;
 c :=100 div clen +1
 end;
end;

end.
