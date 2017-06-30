unit unt_Dodekaeder;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{==========================================================}
{ Programm zur Demonstration von 3-dimensionalen Drehungen }
{----------------------------------------------------------}
{ Ein Dodekaeder wird in Schritten von 1ø gedreht.         }
{ Es werden die zwei Bildschirmseiten der VGA ausgenutzt,  }
{ um eine kontinuirliche Drehung erscheinen zu lassen.     }
{ Mit den Cursortaten kann die Drehachse selbst um die     }
{ Bildschirmvertikale bzw. Horizontale gedreht werden      }
{ Sprache: Turbo-Pascal                                    }
{ U. Sternberg und P. Losso                                }
{==========================================================}

interface

Procedure Execute;

implementation

{$R Prj_Dodekaeder.res}
Uses
  SysUtils,
  Graph;

Type Matrix = Array[1..3, 1..3] Of real;
  Vektor = Array[1..3] Of real;
Const Grad = Pi / 360; { zur Umrechnung von Winkeln in Grad in das Bogenmaá }
{ Definition der Eckpunkte des Dodekaeders }
Const OrgDodekaeder: Array[1..20, 1..3] Of extended =
  ((0.52573, 0.38197, 0.85065), (-0.20081, 0.61803, 0.85065),
    (-0.64984, 0., 0.85065), (-0.20081, -0.618034, 0.85065),
    (0.52573, -0.38197, 0.85065), (0.85065, 0.618034, 0.20081),
    (-0.32492, 1., 0.20081), (-1.05146, 0., 0.20081),
    (-0.32492, -1., 0.20081), (0.85065, -0.61803, 0.20081),
    (0.32492, 1., -0.20081), (-0.85065, 0.61803, -0.20081),
    (-0.85065, -0.61803, -0.20081), (0.32492, -1., -0.20081),
    (1.05146, 0., -0.20081), (0.20081, 0.61803, -0.85065),
    (-0.52573, 0.38197, -0.85065), (-0.52573, -0.38197, -0.85065),
    (0.20081, -0.61803, -0.85065), (0.64984, 0., -0.85065));
{ Definition der Kanten des Dodekaeders als Indizes der verbundenen Ecken }
Const VonBis: Array[1..30, 1..2] Of integer =
  ((1, 2), (2, 3), (3, 4), (4, 5), (5, 1), (5, 10), (10, 15), (15, 6), (1, 6),
    (6, 11), (11, 7),
    (7, 2), (7, 12), (12, 8), (8, 3), (8, 13), (13, 9), (9, 4), (10, 14), (14,
    9), (15, 20),
    (20, 16), (16, 11), (16, 17), (17, 12), (17, 18), (18, 13), (18, 19), (19,
    14), (19, 20));
{ zwei orthogonale Drehachsen zur Drehung mit den Cursortasten }
Const DrehachseX: Vektor = (1, 0, 0); { x-Achse }
Const DrehachseY: Vektor = (0, 1, 0); { y-Achse }
Var DrehachseEVektor: Vektor; { Einheitsvektor in Richtung der Drehachse }
  DodekaederPunkt: Vektor; { Vektor zu einer Dodekaederecke }
{ Variablen zur Umrechnung von 3D-Koordinaten in 2D-Pixelkoordinaten }
  PixelUmrechnungX: real; { Umrechnungsfaktor 3D-Koord. in Pixel X }
  PixelUmrechnungY: real; { Umrechnungsfaktor 3D-Koord. in Pixel Y }
  BildMitteX: real;
  BildMitteY: real;
  XAspectRatio: word; { Pixelbreite }
  YAspectRatio: word; { Pixelh”he }
  Dodekaeder: Array[1..20, 1..3] Of extended;
{-----------DefiniereDrehmatrix------------------------------}

Procedure DefiniereDrehmatrix3D(Drehachse: Vektor; theta: real;
  Var Drehmatrix3D: Matrix);
{ Berechnung der 3D-Drehmatrix fr die Drehung um die Drehachse mit dem }
{ Winkel theta (im Bogenmaá) }
Var alpha, beta: integer; { Laufindize fr die Komponenten x,y,z }
  SinusTheta, CosinusTheta: real;
  W_Element, V_Element: real; { Elemente der W- und V-Matrix }
Begin
  CosinusTheta := Cos(theta);
  SinusTheta := Sin(theta);
  For alpha := 1 To 3 Do { Hauptdiagonalelemente berechnen }
    Drehmatrix3D[alpha, alpha] := CosinusTheta +
      Sqr(Drehachse[alpha]) * (1 - CosinusTheta);
    { obere rechte Ecke der W-Matrix }
  Drehmatrix3D[1, 2] := Drehachse[3] * SinusTheta;
  Drehmatrix3D[1, 3] := -Drehachse[2] * SinusTheta;
  Drehmatrix3D[2, 3] := Drehachse[1] * SinusTheta;
  For alpha := 1 To 2 Do
    For beta := alpha + 1 To 3 Do
      Begin
        W_Element := Drehmatrix3D[alpha, beta];
        V_Element := Drehachse[alpha] * Drehachse[beta] * (1 - CosinusTheta);
      { Nichtdiagonalelemente der obreren rechten Ecke von D }
        Drehmatrix3D[alpha, beta] := V_Element + W_Element;
      { Nichtdiagonalelemente der linken unteren Ecke von D }
        Drehmatrix3D[beta, alpha] := V_Element - W_Element;
      End; { for alpha }
End; { DefiniereDrehmatrix }
{------------Drehung------------------------------------}

Procedure Drehung(Drehmatrix: Matrix; Var Punkt: Vektor);
   { Transformation eines Punkts im Raum durch eine Drehung }
Var PunktNeu: Array[1..3] Of real; { Koordinaten nach der Drehung }
  alpha, beta: integer;
  Summe: real;
Begin
  For alpha := 1 To 3 Do
    Begin
      Summe := 0;
      For beta := 1 To 3 Do
        Summe := Summe + Drehmatrix[alpha, beta] * Punkt[beta];
      PunktNeu[alpha] := Summe;
    End; { for alpha }
  For alpha := 1 To 3 Do
    Punkt[alpha] := PunktNeu[alpha];
End; { Drehung }
{------------DodekaederBild---------------------------}

Procedure DodekaederBild;
Var KantenIndex: integer;
  VonPixelX, VonPixelY: integer; { 2D-x-Koordinaten in Bildschirm-Pixeln }
  NachPixelX, NachPixelY: integer; { 2D-y-Koordinaten in Bildschirm-Pixeln }
Begin
{ Dodekaeder als Kantennetz zeichnen }
  SetColor(Yellow); { gelbe Linien }
  For KantenIndex := 1 To 30 Do
    Begin
      VonPixelX := Trunc(Dodekaeder[VonBis[KantenIndex, 1], 1] * PixelUmrechnungX
        +
        BildMitteX);
      VonPixelY := Trunc(Dodekaeder[VonBis[KantenIndex, 1], 2] * PixelUmrechnungY
        +
        BildMitteY);
      NachPixelX := Trunc(Dodekaeder[VonBis[KantenIndex, 2], 1] *
        PixelUmrechnungX +
        BildMitteX);
      NachPixelY := Trunc(Dodekaeder[VonBis[KantenIndex, 2], 2] *
        PixelUmrechnungY +
        BildMitteY);
      Line(VonPixelX, VonPixelY, NachPixelX, NachPixelY);
    End; { for Kantenindex:=1 }
{ Drehachse Einzeichnen }
  SetColor(Green);
  VonPixelX := Trunc(BildMitteX);
  VonPixelY := Trunc(BildMitteY);
  NachPixelX := Trunc(DrehachseEVektor[1] * PixelUmrechnungX * 0.5 +
    BildMitteX);
  NachPixelY := Trunc(DrehachseEVektor[2] * PixelUmrechnungY * 0.5 +
    BildMitteY);
  Line(VonPixelX, VonPixelY, NachPixelX, NachPixelY);
End; { DodekaederBild }

Procedure Execute;

{ Vareiablen zu Drehung3D }
Var DrehmatrixE: Matrix; { Drehmatrix zum Einheitsvektor }
  DrehmatrixX: Matrix; { Drehmatrix fr x-Achse }
  DrehmatrixY: Matrix; { Drehmatrix fr y-Achse }
  alpha, beta: integer; { Laufindizes fr die Komponenten x,y,z }
  EckenIndex: integer; { Laufindex fr die Ecken des Dodekaeder }
  grDriver: integer; { Grafiktreiber }
  grMode: integer; { Grafikmodus }
  ErrCode: integer; { Fehlercode fr die Grafik }
  DrehWinkel: real; { Drehwinkel in Grad }
  DrehwinkelXY: real; { Drehwinkel fr die x-y-Drehung }
  SeitenSchalter: Boolean; { Umschalter fr die sichtbare Bildschirmseite }
  Taste: char; { gedrckte Taste }

Begin { Drehung 3D }
  For Eckenindex := 1 To 20 Do
    Begin
      For alpha := 1 To 3 Do
        Dodekaeder[Eckenindex, alpha] := orgDodekaeder[Eckenindex, alpha];
    End; { for Eckenindex }
{ Anfangswerte fr die Drehachse }
  For alpha := 1 To 3 Do
    DrehachseEVektor[alpha] := 1 / Sqrt(3);
{ Drehmatrizen mit Startwert des Einheitsvektors ausrechnen }
  DrehWinkel := 1 * Grad;
  DefiniereDrehmatrix3D(DrehachseEVektor, DrehWinkel, DrehmatrixE);
{ Grafik starten }
  grDriver := Detect;
  InitGraph(grDriver, grMode, '');
{ An Stelle von 'c:\bp\bgi' muá hier eventuell der richtige Pfad zu den
  BGI-Treibern eingetragen werden }
  ErrCode := GraphResult;
  If ErrCode <> grOk Then
    Begin
      Writeln(' Fehler in der Grafik: ', GraphErrorMsg(ErrCode));
      exit;
    End; { if ErrCode<>grOk }
  If grDriver <> VGA Then
    Begin
      CloseGraph;
      Writeln(' Das Programm ist nur mit VGA-Grafik lauff„hig ');
      exit;
    End; { if grDriver<>VGA }
  SetGraphMode(VGAmed); { VGAmed-Modus einschalten - 2 Bildschirmseiten }
  GetAspectRatio(XAspectRatio, YAspectRatio); { Pixel-Verh„ltnis ermitteln }
{ Gr”áe des Dodekaeders ist 80% vom Bildschirm }
  SeitenSchalter := True; { Umschalten der Bildschirmseiten in jedem Zyklus }
  SetBkColor(Blue); { Hintergrund blau }
  Repeat { Schleife fr kontinuierliche Drehung bis <Esc> }
{ Gr”áe des Dodekaeders ist 80% vom Bildschirm }
  PixelUmrechnungX := 0.4 * GetMaxX * XAspectRatio / YAspectRatio;
  BildMitteX := 0.5 * GetMaxX;
  PixelUmrechnungY := -0.4 * GetMaxY; { Pixel-y-Achse zeigt von oben nach unten }
  BildMitteY := 0.5 * GetMaxY;
    SeitenSchalter := Not SeitenSchalter;
    If SeitenSchalter Then
      Begin
        SetActivePage(0); { auf Seite 0 zeichnen }
        SetVisualPage(1); { Seite 1 sichtbar machen }
      End
    Else
      Begin
        SetActivePage(1); { auf Seite 1 zeichnen }
        SetVisualPage(0); { Seite 0 sichtbar machen }
      End;
    ClearDevice; { Bildschirm l”schen }
    DodekaederBild; { Dodekaeder zeichnen }
{ Neue Dodekaederkoordinaten durch Drehung berechnen }
    For Eckenindex := 1 To 20 Do
      Begin
        For alpha := 1 To 3 Do
          DodekaederPunkt[alpha] := Dodekaeder[Eckenindex, alpha];
        Drehung(DrehmatrixE, DodekaederPunkt);
        For alpha := 1 To 3 Do
          Dodekaeder[Eckenindex, alpha] := DodekaederPunkt[alpha];
      End; { for Eckenindex }
    Taste := #1; { beliebiger Anfangswert }
    While (KeyPressed) Do
      Taste := ReadKey; { Tastaturpuffer leeren }
    If Taste = #0 Then
      Taste := ReadKey; { 2xRedKey fr die Pfeiltasten }
    If (Taste = #77) Or (Taste = #80) { Taste 'rechts' oder Taste 'unten' ? }
      Then
      DrehwinkelXY := -5 * DrehWinkel { Drehrichtung negativ }
    Else
      DrehwinkelXY := 5 * DrehWinkel; { Drehrichtung positiv }
    If (Taste = #72) Or (Taste = #80) Then { Drehung um die x-Achse }
      Begin
        DefiniereDrehmatrix3D(DrehachseX, DrehwinkelXY, DrehmatrixX);
{ Drehung der Drehachse selbst um die x-Achse }
        Drehung(DrehMatrixX, DrehachseEVektor);
      End; { if (Taste=#75) }
    If (Taste = #75) Or (Taste = #77) Then { Drehung um die y-Achse }
      Begin
        DefiniereDrehmatrix3D(DrehachseY, DrehwinkelXY, DrehmatrixY);
{ Drehung der Drehachse selbst um die y-Achse }
        Drehung(DrehMatrixY, DrehachseEVektor);
      End; { if (Taste=#72) }
{ Neue Drehmatrix aus gedrehtem Einheitsvektor ausrechnen }
    DefiniereDrehmatrix3D(DrehachseEVektor, Drehwinkel, DrehmatrixE);
  Until Taste = #27; { ESC-Taste gedrckt }
  CloseGraph; { Grafik schlieáen }
End; { Drehung 3D }
end.
