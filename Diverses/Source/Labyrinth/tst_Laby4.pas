unit tst_Laby4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, unt_Laby4;

type

  { TTestLaby4 }

  TTestLaby4= class(TTestCase)
  private
    FHeightLaby:THeightLaby;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    Procedure TestCalcPStepHeight;
    Procedure TestCalcPStepHeight2;
    Procedure TestCalcPStepHeight_n;
  end;

implementation

procedure TTestLaby4.TestSetUp;
begin
  CheckNotNull(FHeightLaby,'Object is assigned');
end;

procedure TTestLaby4.TestCalcPStepHeight;
var
  OutHgt: integer;
begin
  FHeightLaby.Dimension:=rect(0,0,3,3);
  FHeightLaby.SetLData('789...321',3,3,2);
  CheckEquals(5,FHeightLaby.LabyHeight[2,0],'LabyHeight[2,0]');
  CheckEquals(4,FHeightLaby.LabyHeight[1,0],'LabyHeight[1,0]');
  CheckEquals(3,FHeightLaby.LabyHeight[0,0],'LabyHeight[0,0]');
  CheckEquals(0,FHeightLaby.LabyHeight[2,1],'LabyHeight[2,1]');
  CheckEquals(0,FHeightLaby.LabyHeight[1,1],'LabyHeight[1,1]');
  CheckEquals(0,FHeightLaby.LabyHeight[0,1],'LabyHeight[0,1]');
  CheckEquals(9,FHeightLaby.LabyHeight[2,2],'LabyHeight[2,2]');
  CheckEquals(10,FHeightLaby.LabyHeight[1,2],'LabyHeight[1,2]');
  CheckEquals(11,FHeightLaby.LabyHeight[0,2],'LabyHeight[0,2]');
  // (0,1,0,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
  CheckEquals(4,OutHgt,'(1,0)->(1,1): 4');
  // (0,1,1,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(2,0),point(2,1),OutHgt),'Heightstep Found');
  CheckEquals(5,OutHgt,'(2,0)->(2,1): 5');
  // (1,1,0,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(0,0),point(0,1),OutHgt),'Heightstep Found');
  CheckEquals(2,OutHgt,'(0,0)->(0,1): 2');
  // (0,1,0,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(1,2),point(1,1),OutHgt),'Heightstep Found');
  CheckEquals(10,OutHgt,'(1,2)->(1,1): 10');
  // (0,1,1,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(2,2),point(2,1),OutHgt),'Heightstep Found');
  CheckEquals(8,OutHgt,'(2,2)->(2,1): 8');
  // (1,1,0,-1)
  CheckTrue(FHeightLaby.CalcPStepHeight(point(0,2),point(0,1),OutHgt),'Heightstep Found');
  CheckEquals(11,OutHgt,'(0,2)->(0,1): 11');
end;

procedure TTestLaby4.TestCalcPStepHeight2;
var
  OutHgt: integer;
begin
   FHeightLaby.Dimension:=rect(0,0,3,3);
   FHeightLaby.SetLData('4.23.12.0',3,3,2);
   CheckEquals(4,FHeightLaby.LabyHeight[2,0],'LabyHeight[2,0]');
   CheckEquals(0,FHeightLaby.LabyHeight[1,0],'LabyHeight[1,0]');
   CheckEquals(2,FHeightLaby.LabyHeight[0,0],'LabyHeight[0,0]');
   CheckEquals(5,FHeightLaby.LabyHeight[2,1],'LabyHeight[2,1]');
   CheckEquals(0,FHeightLaby.LabyHeight[1,1],'LabyHeight[1,1]');
   CheckEquals(3,FHeightLaby.LabyHeight[0,1],'LabyHeight[0,1]');
   CheckEquals(6,FHeightLaby.LabyHeight[2,2],'LabyHeight[2,2]');
   CheckEquals(0,FHeightLaby.LabyHeight[1,2],'LabyHeight[1,2]');
   CheckEquals(4,FHeightLaby.LabyHeight[0,2],'LabyHeight[0,2]');
   // (0,1,0,-1)
   CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
   // (0,1,0,0)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(0,1),point(1,1),OutHgt),'Heightstep Found');
   CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');
   // (0,1,0,0)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(0,2),point(1,2),OutHgt),'Heightstep Found');
   CheckEquals(4,OutHgt,'(2,0)->(2,1): 4');
   // (1,1,0,0)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(0,0),point(1,0),OutHgt),'Heightstep Found');
   CheckEquals(2,OutHgt,'(0,0)->(0,1): 2');
   // (0,1,0,-1)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(2,1),point(1,1),OutHgt),'Heightstep Found');
   CheckEquals(5,OutHgt,'(1,2)->(1,1): 5');
   // (0,1,1,-1)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(2,2),point(1,2),OutHgt),'Heightstep Found');
   CheckEquals(6,OutHgt,'(2,2)->(2,1): 6');
   // (0,1,0,-1)
   CheckTrue(FHeightLaby.CalcPStepHeight(point(2,0),point(1,0),OutHgt),'Heightstep Found');
   CheckEquals(4,OutHgt,'(0,2)->(0,1): 4');
end;

procedure TTestLaby4.TestCalcPStepHeight_n;
   var
     OutHgt: integer;
begin
      FHeightLaby.Dimension:=rect(0,0,3,3);
      FHeightLaby.SetLabyHeight(1,0,2);
      // (1,1,1,1)
      CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');
      FHeightLaby.SetLabyHeight(1,0,3);
      // (1,1,1,0)
      CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');
      FHeightLaby.SetLabyHeight(1,0,4);
      // (1,1,1,-1)
      CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');
      // No Solution
      FHeightLaby.SetLabyHeight(1,1,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(1,1,0);
      //
      FHeightLaby.SetLabyHeight(0,1,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(0,1,0);
      //
      FHeightLaby.SetLabyHeight(1,2,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(1,2,0);
      //
      FHeightLaby.SetLabyHeight(2,1,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(2,1,0);
end;

procedure TTestLaby4.SetUp;
begin
   FHeightLaby := THeightLaby.Create;
end;

procedure TTestLaby4.TearDown;
begin
   Freeandnil(FHeightLaby);
end;

initialization

  RegisterTest(TTestLaby4);
end.

unit tst_Laby4;

{$mode objfpc}{$H+}

{------------------------------------------------------------------------------
  Test-Unit für das Labyrinth-Höhensystem (unt_Laby4)

  Ziel dieser Testklasse:
  - Absicherung der Funktionalität von `THeightLaby` aus `unt_Laby4`.
  - Verifikation der korrekten Interpretation/Abbildung einer Hohendatenquelle
    (String/Manuell) in das interne Höhenraster `LabyHeight[x,y]`.
  - Verifikation der Pfadschritt-Höhenberechnung via `CalcPStepHeight`:
      - True/False (Schritt möglich/Schritt nicht möglich)
      - Erwartete Höhe im Out-Parameter `OutHgt` im Erfolgsfall.

  Wichtige Annahmen/Beobachtungen aus den Tests:
  - Die Dimensionierung erfolgt über `Dimension := rect(Left,Top,Right,Bottom)`.
    Für alle Tests wird ein 3x3-Raster verwendet: X = 0..2, Y = 0..2.
  - Der Zugriff auf die Höhe erfolgt via `LabyHeight[X, Y]`.
  - `SetLData(Data, Width, Height, Offset)` liest Zeichen aus `Data` zeilenweise
    in das Raster ein (Details der genauen Dekodierung liegen in unt_Laby4).
    Die Tests validieren danach die konkreten erwarteten Höhenwerte.
  - `CalcPStepHeight(FromPoint, ToPoint, OutHgt)`:
      - Liefert True, wenn ein gültiger Schritt von From -> To möglich ist,
        andernfalls False.
      - Setzt im Erfolgsfall `OutHgt` auf die berechnete "Schritthöhe".
    Die Tests prüfen unterschiedliche Konstellationen:
      - Freies Feld vs. blockierte/undefinierte Felder (0 als "leer/gesperrt").
      - Verschiedene Nachbarschaftsrelationen (oben/unten/links/rechts).
      - Fälle ohne Lösung (Rückgabe False), wenn angrenzende Zellen für den
        angestrebten Schritt die Bedingung nicht erfüllen.

  Testfall-Übersicht:
  - TestSetUp:
      - Sicherstellung, dass das Testobjekt korrekt erzeugt wurde.
  - TestCalcPStepHeight:
      - Raster wird aus Zeichenfolge '789...321' mit Offset 2 erzeugt.
      - Validierung der geladenen Rasterhöhen.
      - Mehrere Schrittprüfungen (erwartet True) mit den dazugehörigen
        `OutHgt`-Erwartungswerten.
  - TestCalcPStepHeight2:
      - Raster aus '4.23.12.0' ('.' → 0/leer). Prüft gemischte Fälle:
        - Unmöglicher Schritt (False), wenn Ziel-/Umfeldbedingungen fehlen.
        - Mögliche Schritte (True) mit konkreten `OutHgt`-Werten.
  - TestCalcPStepHeight_n:
      - Manuelles Setzen von Einzelhöhen.
      - Verifikation, dass ein Schritt über verschiedene Start-Höhen weiterhin
        gleich interpretiert wird (konstante erwartete OutHgt=3 in Beispielen).
      - Negativfälle: Bestimmte Nachbarfelder werden auf 4 gesetzt und sollen
        den Schritt unmöglich machen (False).

  Hinweis:
  - Die in Klammern notierten Muster wie "(0,1,0,-1)" sind vorhandene
    Entwickler-Hinweise zur Klassifikation der Schrittumgebung und werden hier
    nicht verändert. Die genaue Semantik ergibt sich aus der Implementierung
    in `unt_Laby4`.

------------------------------------------------------------------------------}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, unt_Laby4;

type

  { TTestLaby4
    Testklasse für die Komponente `THeightLaby`.
    Erzeugt/zerstört pro Test ein eigenes Instanzobjekt und
    prüft gezielt `LabyHeight`-Belegungen sowie `CalcPStepHeight`. }

  TTestLaby4= class(TTestCase)
  private
    FHeightLaby:THeightLaby;       // Testobjekt: verwaltet Dimension, Daten und Berechnungen
  protected
    procedure SetUp; override;     // Erzeugt FHeightLaby
    procedure TearDown; override;  // Gibt FHeightLaby wieder frei
  published
    procedure TestSetUp;                // Objekt korrekt angelegt?
    Procedure TestCalcPStepHeight;      // Positivfälle bei Daten aus String '789...321'
    Procedure TestCalcPStepHeight2;     // Gemischte Fälle (inkl. False) bei '4.23.12.0'
    Procedure TestCalcPStepHeight_n;    // Manuelle Einzelbelegungen + Negativfälle
  end;

implementation

{------------------------------------------------------------------------------
  Basisprüfung: Objekt wurde korrekt erstellt.
------------------------------------------------------------------------------}
procedure TTestLaby4.TestSetUp;
begin
  CheckNotNull(FHeightLaby,'Object is assigned');
end;

{------------------------------------------------------------------------------
  Test 1: Datenquelle '789...321' (3x3, Offset=2)
  - Nach Laden werden die erwarteten Höhen im Raster verifiziert.
  - Anschließend werden mehrere gültige Schrittbewegungen geprüft.
------------------------------------------------------------------------------}
procedure TTestLaby4.TestCalcPStepHeight;
var
  OutHgt: integer; // out-Parameter für die berechnete Schritthöhe
begin
  // 3x3-Raster anlegen
  FHeightLaby.Dimension:=rect(0,0,3,3);

  // Daten laden:
  // - Die konkrete Zeichen-zu-Höhen-Konvertierung erfolgt intern in `unt_Laby4`.
  // - Hier wird nur das Ergebnis über Asserts verifiziert.
  FHeightLaby.SetLData('789...321',3,3,2);

  // Erwartete Höhen nach dem Laden prüfen (Indexierung: [X,Y])
  // Zeile Y=0
  CheckEquals(5,FHeightLaby.LabyHeight[2,0],'LabyHeight[2,0]');
  CheckEquals(4,FHeightLaby.LabyHeight[1,0],'LabyHeight[1,0]');
  CheckEquals(3,FHeightLaby.LabyHeight[0,0],'LabyHeight[0,0]');
  // Zeile Y=1 (Leer/0)
  CheckEquals(0,FHeightLaby.LabyHeight[2,1],'LabyHeight[2,1]');
  CheckEquals(0,FHeightLaby.LabyHeight[1,1],'LabyHeight[1,1]');
  CheckEquals(0,FHeightLaby.LabyHeight[0,1],'LabyHeight[0,1]');
  // Zeile Y=2
  CheckEquals(9,FHeightLaby.LabyHeight[2,2],'LabyHeight[2,2]');
  CheckEquals(10,FHeightLaby.LabyHeight[1,2],'LabyHeight[1,2]');
  CheckEquals(11,FHeightLaby.LabyHeight[0,2],'LabyHeight[0,2]');

  // Ab hier: Schrittprüfungen mit erwarteter Schritthöhe OutHgt
  // (0,1,0,-1)
  // Von (1,0) -> (1,1) ist erlaubt, erwartete Höhe 4
  CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
  CheckEquals(4,OutHgt,'(1,0)->(1,1): 4');

  // (0,1,1,-1)
  // Von (2,0) -> (2,1) ist erlaubt, erwartete Höhe 5
  CheckTrue(FHeightLaby.CalcPStepHeight(point(2,0),point(2,1),OutHgt),'Heightstep Found');
  CheckEquals(5,OutHgt,'(2,0)->(2,1): 5');

  // (1,1,0,-1)
  // Von (0,0) -> (0,1) ist erlaubt, erwartete Höhe 2
  CheckTrue(FHeightLaby.CalcPStepHeight(point(0,0),point(0,1),OutHgt),'Heightstep Found');
  CheckEquals(2,OutHgt,'(0,0)->(0,1): 2');

  // (0,1,0,-1)
  // Von (1,2) -> (1,1) ist erlaubt, erwartete Höhe 10
  CheckTrue(FHeightLaby.CalcPStepHeight(point(1,2),point(1,1),OutHgt),'Heightstep Found');
  CheckEquals(10,OutHgt,'(1,2)->(1,1): 10');

  // (0,1,1,-1)
  // Von (2,2) -> (2,1) ist erlaubt, erwartete Höhe 8
  CheckTrue(FHeightLaby.CalcPStepHeight(point(2,2),point(2,1),OutHgt),'Heightstep Found');
  CheckEquals(8,OutHgt,'(2,2)->(2,1): 8');

  // (1,1,0,-1)
  // Von (0,2) -> (0,1) ist erlaubt, erwartete Höhe 11
  CheckTrue(FHeightLaby.CalcPStepHeight(point(0,2),point(0,1),OutHgt),'Heightstep Found');
  CheckEquals(11,OutHgt,'(0,2)->(0,1): 11');
end;

{------------------------------------------------------------------------------
  Test 2: Datenquelle '4.23.12.0' (3x3, Offset=2)
  - '.' steht hier für 0 (leeres/gesperrtes Feld).
  - Zunächst werden die erwarteten Rasterwerte verifiziert.
  - Danach werden gemischte Schrittfälle geprüft:
      - Unmöglich (False), wenn die Bedingungen nicht erfüllt sind.
      - Möglich (True) mit validen OutHgt-Erwartungen.
------------------------------------------------------------------------------}
procedure TTestLaby4.TestCalcPStepHeight2;
var
  OutHgt: integer; // out-Parameter für die berechnete Schritthöhe
begin
   // 3x3-Raster anlegen
   FHeightLaby.Dimension:=rect(0,0,3,3);

   // Daten laden und anschließend erwartete Höhen prüfen
   FHeightLaby.SetLData('4.23.12.0',3,3,2);

   // Zeile Y=0
   CheckEquals(4,FHeightLaby.LabyHeight[2,0],'LabyHeight[2,0]');
   CheckEquals(0,FHeightLaby.LabyHeight[1,0],'LabyHeight[1,0]');
   CheckEquals(2,FHeightLaby.LabyHeight[0,0],'LabyHeight[0,0]');
   // Zeile Y=1
   CheckEquals(5,FHeightLaby.LabyHeight[2,1],'LabyHeight[2,1]');
   CheckEquals(0,FHeightLaby.LabyHeight[1,1],'LabyHeight[1,1]');
   CheckEquals(3,FHeightLaby.LabyHeight[0,1],'LabyHeight[0,1]');
   // Zeile Y=2
   CheckEquals(6,FHeightLaby.LabyHeight[2,2],'LabyHeight[2,2]');
   CheckEquals(0,FHeightLaby.LabyHeight[1,2],'LabyHeight[1,2]');
   CheckEquals(4,FHeightLaby.LabyHeight[0,2],'LabyHeight[0,2]');

   // Schrittprüfungen

   // (0,1,0,-1)
   // Von (1,0) -> (1,1): erwartet False, da Ziel-/Umfeldbedingungen nicht erfüllt
   CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');

   // (0,1,0,0)
   // Von (0,1) -> (1,1): erlaubt, erwartete Höhe 3
   CheckTrue(FHeightLaby.CalcPStepHeight(point(0,1),point(1,1),OutHgt),'Heightstep Found');
   CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');

   // (0,1,0,0)
   // Von (0,2) -> (1,2): erlaubt, erwartete Höhe 4
   CheckTrue(FHeightLaby.CalcPStepHeight(point(0,2),point(1,2),OutHgt),'Heightstep Found');
   CheckEquals(4,OutHgt,'(2,0)->(2,1): 4');

   // (1,1,0,0)
   // Von (0,0) -> (1,0): erlaubt, erwartete Höhe 2
   CheckTrue(FHeightLaby.CalcPStepHeight(point(0,0),point(1,0),OutHgt),'Heightstep Found');
   CheckEquals(2,OutHgt,'(0,0)->(0,1): 2');

   // (0,1,0,-1)
   // Von (2,1) -> (1,1): erlaubt, erwartete Höhe 5
   CheckTrue(FHeightLaby.CalcPStepHeight(point(2,1),point(1,1),OutHgt),'Heightstep Found');
   CheckEquals(5,OutHgt,'(1,2)->(1,1): 5');

   // (0,1,1,-1)
   // Von (2,2) -> (1,2): erlaubt, erwartete Höhe 6
   CheckTrue(FHeightLaby.CalcPStepHeight(point(2,2),point(1,2),OutHgt),'Heightstep Found');
   CheckEquals(6,OutHgt,'(2,2)->(2,1): 6');

   // (0,1,0,-1)
   // Von (2,0) -> (1,0): erlaubt, erwartete Höhe 4
   CheckTrue(FHeightLaby.CalcPStepHeight(point(2,0),point(1,0),OutHgt),'Heightstep Found');
   CheckEquals(4,OutHgt,'(0,2)->(0,1): 4');
end;

{------------------------------------------------------------------------------
  Test 3: Manuelle Belegungen (Negativ- und Randfälle)
  - Es wird nur schrittweise eine Zelle belegt und getestet.
  - Ziel: Verhalten bei fehlenden/inkonsistenten Nachbarn, sowie erzwungene
    Unmöglichkeit durch Setzen bestimmter Nachbarn auf 4.
------------------------------------------------------------------------------}
procedure TTestLaby4.TestCalcPStepHeight_n;
   var
     OutHgt: integer; // out-Parameter für die berechnete Schritthöhe
begin
      // 3x3-Raster anlegen
      FHeightLaby.Dimension:=rect(0,0,3,3);

      // Start: Nur (1,0) = 2 gesetzt, Ziel (1,1) leer
      // Schritt soll möglich sein, erwartete OutHgt = 3
      FHeightLaby.SetLabyHeight(1,0,2);
      // (1,1,1,1)
      CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');

      // Anpassung Start: (1,0) = 3
      // Erwartete OutHgt bleibt 3 (Robustheit der Schrittlogik)
      FHeightLaby.SetLabyHeight(1,0,3);
      // (1,1,1,0)
      CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');

      // Anpassung Start: (1,0) = 4
      // Erwartete OutHgt weiterhin 3
      FHeightLaby.SetLabyHeight(1,0,4);
      // (1,1,1,-1)
      CheckTrue(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      CheckEquals(3,OutHgt,'(1,0)->(1,1): 3');

      // Negativfälle:
      // Jeweils einen der vier direkten Nachbarn des Zieles (1,1) auf 4 setzen,
      // Schritt soll dadurch unmöglich werden (False). Danach Nachbar wieder auf 0.

      // Ziel selbst blockiert?
      FHeightLaby.SetLabyHeight(1,1,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(1,1,0);

      // Linker Nachbar von Ziel (0,1) blockiert
      FHeightLaby.SetLabyHeight(0,1,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(0,1,0);

      // Oberer Nachbar von Ziel (1,2) blockiert
      FHeightLaby.SetLabyHeight(1,2,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(1,2,0);

      // Rechter Nachbar von Ziel (2,1) blockiert
      FHeightLaby.SetLabyHeight(2,1,4);
      CheckFalse(FHeightLaby.CalcPStepHeight(point(1,0),point(1,1),OutHgt),'Heightstep Found');
      FHeightLaby.SetLabyHeight(2,1,0);
end;

{------------------------------------------------------------------------------
  Testvorbereitung: Instanz von THeightLaby erzeugen.
------------------------------------------------------------------------------}
procedure TTestLaby4.SetUp;
begin
   FHeightLaby := THeightLaby.Create;
end;

{------------------------------------------------------------------------------
  Testaufräumung: Instanz freigeben.
------------------------------------------------------------------------------}
procedure TTestLaby4.TearDown;
begin
   Freeandnil(FHeightLaby);
end;

initialization

  // Registrierung der Testklasse, damit die Tests via Test Runner auffindbar sind.
  RegisterTest(TTestLaby4);
end.
