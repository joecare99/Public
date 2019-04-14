Unit graph;

{ *v 1.0.3 }
{ *h 1.0.2  Graph3 Kompatibilitaetsroutinen }
{ *h 1.0.1  SetBGRColor }
{ *h 1.0.0  TImgHeader }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
  {$IFNDEF FPC}
    jpeg, Windows , XPMan,
  {$ELSE}
     LCLIntf, LCLType,LResources,
  {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus,  ExtDlgs, ExtCtrls, int_Graph;

Type
  PaletteType = Record
    size: integer;
    colors: Array [0 .. 63] Of Tcolor;
  End;

  ViewPortType = Record
    x1, y1, x2, y2: integer;
  End;

  LineSettingsType = Record
    LineStyle, Thickness: integer;
  End;

  FillSettingsType = Record
    Pattern, Color: integer;
  End;

  TextSettingsType = Record
    Font, Direction, CharSize, Horiz, Vert: integer;
  End;

  ArcCoordsType = Record
    X, Y, XStart, YStart, Xend, YEnd: integer;
  End;

  FillPatternType = Array [0 .. 7] Of byte;

  PointType = TPoint;

  { TGraphForm }

  TGraphForm = Class(TForm, TintGraph)
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    BildSpeichern1: TMenuItem;
    N1: TMenuItem;
    Schliessen1: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    Aktualisieren1: TMenuItem;
    Test1: TMenuItem;
    Timer1: TTimer;
    Procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    Procedure Timer1Timer(Sender: TObject);
    Procedure FormPaint(Sender: TObject);
    Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Procedure Aktualisieren1Click(Sender: TObject);
    Procedure BildSpeichern1Click(Sender: TObject);
    Procedure Clear1Click(Sender: TObject);
    Procedure Schliessen1Click(Sender: TObject);
    Procedure FormResize(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure FormKeyPress(Sender: TObject; Var Key: Char);
    Procedure FormCreate(Sender: TObject);
    Procedure Test1Click(Sender: TObject);
  Private
    { Private-Deklarationen }
    Fbmp: TBitmap;
    FDrawColor: integer;
    FBkColor: Tcolor;
    FkKEY: Char;
    FChanged: Boolean;
    FActiveViewPort: TRect;
    {%H-}constructor Create(TheOwner: TComponent);reintroduce;
  Public
    df: integer;
    LmousePos: TPoint;
    LShift: TShiftState;
    Procedure SetVisible(val: Boolean);reintroduce;
    Function GetVisible: Boolean;
    Procedure SetBitmap(val: TBitmap);
    Function GetBitmap: TBitmap;
    Function GetChanged: Boolean;
    Procedure SetChanged(val: Boolean);
    Function GetbkColor: Tcolor;
    Procedure SetbkColor(val: Tcolor);
    Function GetActiveViewPort: TRect;
    Procedure SetActiveViewPort(val: TRect);
    Procedure UpdateGraph(Sender: TObject);
    Function GetDrawColor: Tcolor;
    Procedure SetDrawColor(val: Tcolor);
    Function Getkkey: Char;
    Procedure Setkkey(val: Char);
    { Public-Deklarationen }
  End;

Var
  GraphForm: TGraphForm;
  iGraph: TintGraph;

Procedure Arc(X, Y, Radius1, Radius2, Color: integer);
Procedure Ellipse(X, Y, WStart, Wend, Radius, Color: integer);
Procedure FillEllipse(X, Y, Radius1, Radius2: integer);
Procedure Bar3d(x1, y1, x2, y2, Depth: integer; Topmode: Boolean);
Procedure Sector(X, Y, Angle1, Angle2, Radius1, Radius2: integer);
Procedure PieSlice(X, Y, Radius1, Radius2, Color: integer);
Procedure InitGraph(Var grd, grm: integer; bgipath: String);
Procedure setgraphmode(grm: integer);
/// <author>Rosewich</author>
Procedure SetAspectRatio(Xasp, Yasp: word);
/// <author>Rosewich</author>
Procedure SetPalette(i1, i2: integer);
/// <author>Rosewich</author>
Procedure SetUserCharSize(size, Top, Bottom, Under: integer);
Function Graphresult: integer;
Procedure GetAspectRatio(Var xf, yf: word);
Procedure restorecrtmode;
Function GetMaxX: integer;
Function GetMaxY: integer;
Procedure FloodFill(X, Y, Color: integer);
Procedure PutPixel(X, Y, Color: integer);
Function GetPixel(X, Y: integer): integer;
Procedure Line(x1, y1, x2, y2: integer);
Procedure LineTo(x1, y1: integer);
Procedure MoveTo(x1, y1: integer);
Procedure LineRel(x1, y1: integer);
Procedure MoveRel(x1, y1: integer);
Procedure GetPenPos(Var x1, y1: integer);
Function GetX: integer;
Function GetY: integer;
Function GetColor: integer;
Procedure Getpalette(Var Palette: PaletteType);
Procedure GetLineSettings(Var LineInfo: LineSettingsType);
Procedure GetFillSettings(Var FillInfo: FillSettingsType);
Procedure GetTextSettings(Var TextInfo: TextSettingsType);
Procedure SetColor(NewCol: integer); Overload;
Procedure SetRGBColor(NewCol: Tcolor);
Function detect: integer;
Function stopmode: Boolean;
Procedure Closegraph;
Procedure ClearDevice;
Procedure ClearViewport;
Function keypressed: Boolean;
Function readkey: Char;
Function GraphErrorMsg(Error: integer): String;
Procedure SetFillStyle(FillType: Tbrushstyle; Color: integer); Overload;
Procedure SetFillStyle(FillType, Color: integer); Overload;
Procedure SetLineStyle(LineType, Color, Width: integer);
Function TextWidth(Text: String): integer;
Function TextHeight(Text: String): integer;
Procedure OutText(Text: String);
Procedure OutTextXY(X, Y: integer; Text: String);
Procedure Bar(x1, y1, x2, y2: integer);
Procedure Circle(X, Y, Radius: integer); Overload;
Procedure GetImage(x1, y1, x2, y2: integer; Var Buff); Overload;
Procedure PutImage(x1, y1: integer; Var Buff; PutType: integer); Overload;
Procedure GetImage(P1, P2: TPoint; Var Buff: TBitmap); Overload;
Procedure PutImage(p: TPoint; Buff: TBitmap; PutType: integer); Overload;
Function ImageSize(x1, y1, x2, y2: integer): integer;
/// <author>Rosewich</author>
Procedure setallPalette(Palette: PaletteType);
Procedure SetFillPattern(UserFillPattern: FillPatternType; Color: integer);
Procedure SetWriteMode(NewWritemode: integer);

Function RGB(r, g, b: byte): Tcolor;
Procedure DrawPoly(Count: integer; Pts: Array Of PointType);
Procedure FillPoly(Count: integer; Pts: Array Of PointType);
Procedure SetbkColor(Color: integer);
/// <author>Rosewich</author>
Procedure SetActivePage(pgn: byte);
Procedure SetVisualPage(pgn: byte);
Procedure SetViewPort(x1, y1, x2, y2: integer; clip: Boolean);
Procedure Rectangle(x1, y1, x2, y2: integer);
Procedure DetectGraph(Var grk, grm: integer);
Procedure SetTextStyle(Fonttype, Direction, size: integer);
Procedure SetTextJustify(HAlign, VAlign: integer);
Procedure GetViewSettings(Var ViewPort: ViewPortType);
Procedure GetArcCoords(Out ArcKoords: ArcCoordsType);

Function GetModeName(GraphMode: integer): String;

Procedure RegisterBGIdriver(BGIDriverProc: pointer);
Procedure RegisterBGIFont(BGIDriverProc: pointer);

// -----------------------------------------------------------------------------
// Kompatibilitaetsroutinen zu Graph3

Const
Plot:
Procedure(X, Y, Color: integer) = PutPixel;
Procedure Draw(x1, y1, x2, y2, Color: integer);
Procedure GraphMode;
Procedure textmode(mode: integer);

Const
HiRes:
Procedure = GraphMode;
GraphColorMode:
Procedure = GraphMode;
HiresColor:
Procedure(NewCol: integer) = SetColor;
GraphBackGround:
Procedure(NewCol: integer) = SetbkColor;
getdotcolor:
Function(X, Y: integer): integer = GetPixel;
// fillshape:procedure (x,y,color
Procedure FillScreen(Fill: integer);
Procedure Circle(X, Y, Radius, Color: integer); Overload;
Procedure Palette(pal: integer);
// -----------------------------------------------------------------------------
// Teile aus CRT

Const
  white = clWhite;
  Yellow = clYellow;
  Red = clRed;
  Green = clGreen;
  Blue = clBlue;
  Black = clBlack;
  LightGreen = clLime;
  LightBlue = $FF8080;
  Brown = $4040;

  GraphErr = 0;
  grOk = 0;
  grInvalidMode = 13;
  grFileNotFound = 14;

  CGA = 0;
  MCGA = 1;
  EGA = 2;
  EGA64 = 4;
  HercMono = 5;
  EGAMono = 6;
  PC3270 = 7;
  ATT400 = 8;
  IBM8514 = 9;
  VGA = 3;

  CGAC1 = 0;

  MCGAMed = 0;
  MCGAHi = 1;
  MCGAC1 = 2;

  EGALo = 0;
  EGAHi = 1;

  EGA64Lo = 0;
  EGA64Hi = 1;

  ATT400C1 = 0;
  ATT400C2 = 1;
  ATT400Med = 2;
  ATT400Hi = 3;

  IBM8514Lo = 0;
  IBM8514Med = 1;
  ibm8514Hi = 2;

  VGAmed = 1;
  VGAhi = 2;
  bgipath = '';
  getDriverName = 'Win32 GDI';
  GetGraphMode = 3;

  solidfill = bsSolid;
  EmptyFill = bsClear;
  InterleaveFill = 9;
  WideDotFill = 10;
  CloseDotFill = 11;
  HatchFill = 7;
  XHatchFill = 8;
  SlashFill = bsFDiagonal;
  BkSlashFill = bsBDiagonal;

  NormalPut = cmSrcCopy;
  OrPut = cmSrcPaint;
  NotPut = cmSrcErase;
  AndPut = cmSrcAnd;
  XORPut = cmSrcInvert;
  CopyPut = cmSrcCopy;

  DefaultFont = 0;
  triplexfont = 1;
  SmallFont = 2;
  SansSerifFont = 3;
  GOTHICFONT = 4;

  lastmode = 0;
  ClipOn = true;

  HorizDir = 0;
  VertDir = 90;

  NormWidth = 1;
  ThickWidth = 3;

  SolidLn = 0;
  UserBitLn = 9;

  LeftText = 0;
  CenterText = 1;
  RightText = 2;

  TopText = 0;
  Bottomtext = 2;

  UserCharSize = -1;

  GetMaxColor = 15;
  MaxColors = 255;

  TopOn = true;
  TopOff = false;

Implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

Resourcestring
  StrDefaultFontName = 'Tahoma';
  StrTriplexFontName = 'Times New Roman';
  StrSansSerifFontName = 'Arial';
  StrSmallFontName = 'Small Fonts';

Const
  oldcolorindex: Array [0 .. 15] Of Tcolor = (clBlack, clBlue, clRed Div 2,
    $800080, clGreen, $808000, $8080, clltGray, $404040, $FF0000, clRed,
    $FF00FF, clLime, $FFFF00, clYellow, clWhite);

Type
  TImgHeader = Packed Record
    ID: Array [0 .. 3] Of Char;
    Width, Height: integer;
    Bpp: byte; // Byte per Pixel
    Format: byte;
    reserve: word;
  End;

  UserCharsizeType = Record
    size, Top, Bottom, Underline: integer;
  End;

Var
  LastArcData: ArcCoordsType;
  UserCharDef: UserCharsizeType;

Function MapColor(Color: integer): Tcolor; Inline;
  Begin
    If Color < 16 Then
      result := oldcolorindex[Color]
    Else
      result := Color;
  End;

Procedure InitGraph(Var grd, grm: integer; bgipath: String);

  Begin
    If Not assigned(iGraph) Then
      Begin
        Application.CreateForm(TGraphForm, GraphForm);
        iGraph := GraphForm;
      End;
    // GraphForm.Show;
    setgraphmode(0);
    SetColor(GetMaxColor);
    ClearDevice;
    grd := VGA;
  End;

Procedure setgraphmode;

  Begin
    // GraphForm.;
    If Not iGraph.visible Then
      iGraph.show
    Else;
    iGraph.FormResize(Nil);
    Application.HandleMessage;
  End;

Procedure SetPalette(i1, i2: integer);

  Begin
    //
  End;

Procedure GetAspectRatio(Var xf, yf: word);

  Begin
    xf := 1;
    yf := 1;
  End;

Procedure restorecrtmode;

  Begin
    If assigned(iGraph) Then
      iGraph.hide;
  End;

Function GetMaxX;

  Begin
    If Not assigned(iGraph) Then
      Begin
        Application.CreateForm(TGraphForm, GraphForm);
        iGraph := GraphForm;
      End;
    result := iGraph.bmp.Width;
  End;

Function GetMaxY;

  Begin
    If Not assigned(iGraph) Then
      Begin
        Application.CreateForm(TGraphForm, GraphForm);
        iGraph := GraphForm;
      End;
    result := iGraph.bmp.Height;
  End;

Function Graphresult;

  Begin
    result := grOk;
  End;

Procedure ClearDevice;

  Begin
    iGraph.bmp.Canvas.Brush.Color := iGraph.bkcolor;
    iGraph.bmp.Canvas.FillRect(iGraph.bmp.Canvas.ClipRect);
    iGraph.ActiveViewPort := iGraph.bmp.Canvas.ClipRect;
    iGraph.Bmp.Canvas.pen.Color := iGraph.getDrawColor;
  End;

Procedure ClearViewport;

  Begin
    iGraph.bmp.Canvas.Brush.Color := iGraph.bkcolor;
    iGraph.bmp.Canvas.FillRect(iGraph.ActiveViewPort)
  End;

Procedure SetbkColor(Color: integer);

  Begin
    iGraph.bkcolor := MapColor(Color);
  End;

Procedure SetActivePage(pgn: byte);

  Begin
    //
  End;

Procedure SetVisualPage(pgn: byte);

  Begin
    If iGraph.visible Then
      iGraph.UpdateGraph(Nil);
  End;

Procedure FloodFill(X, Y, Color: integer);

  Begin
    // iGraph.Bmp.Canvas.brush.Style := bsSolid;
    // iGraph.Bmp.Canvas.brush.color := iGraph.DrawColor;
    iGraph.bmp.Canvas.FloodFill(X, Y, MapColor(Color), fsBorder);
    iGraph.Changed := true;
  End;

Procedure PutPixel(X, Y, Color: integer);

  Begin
    iGraph.bmp.Canvas.Pixels[X, Y] := MapColor(Color);
    iGraph.Changed := true;
  End;

Procedure PutRGBPixel(X, Y, Color: integer);

  Begin
    iGraph.bmp.Canvas.Pixels[X, Y] := Color;
    iGraph.Changed := true;
  End;

Function GetPixel(X, Y: integer): integer;

  Begin
    result := iGraph.bmp.Canvas.Pixels[X, Y];
  End;

Procedure SetColor(NewCol: integer);

  Begin
    iGraph.DrawColor := MapColor(NewCol);
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
  End;

Procedure SetRGBColor(NewCol: Tcolor);

  Begin
    iGraph.DrawColor := NewCol;
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
  End;

Procedure Arc(X, Y, Radius1, Radius2, Color: integer);

  Begin
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.Ellipse(X - Radius1, Y - Radius2, X + Radius1,
      Y + Radius2);
    LastArcData.XStart := X - Radius1;
    LastArcData.YStart := Y - Radius2;
    LastArcData.Xend := X + Radius1;
    LastArcData.YEnd := Y + Radius2;
    iGraph.Changed := true;
  End;

Procedure Ellipse(X, Y, WStart, Wend, Radius, Color: integer);

  Begin
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.Pie(X - Radius, Y - Radius, X + Radius, Y + Radius,
      X + trunc((Radius * sin(WStart * pi / 180))),
      Y + trunc((Radius * sin(WStart * pi / 180))),
      X + trunc((Radius * sin(Wend * pi / 180))),
      Y + trunc((Radius * sin(Wend * pi / 180))));
    iGraph.Changed := true;
  End;

Procedure PieSlice(X, Y, Radius1, Radius2, Color: integer);

  Begin
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.Ellipse(X - Radius1, Y - Radius2, X + Radius1,
      Y + Radius2);
    iGraph.Changed := true;
  End;

Procedure Bar3d(x1, y1, x2, y2, Depth: integer; Topmode: Boolean);

  Begin
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.FrameRect(rect(x1, y1, x2, y2));
    iGraph.bmp.Canvas.MoveTo(x2, y2);
    iGraph.bmp.Canvas.LineTo(x2 + Depth, y2 - Depth);
    iGraph.bmp.Canvas.LineTo(x2 + Depth, y1 - Depth);
    iGraph.bmp.Canvas.LineTo(x2, y1);
    If Topmode Then
      Begin
        iGraph.bmp.Canvas.MoveTo(x2 + Depth, y1 - Depth);
        iGraph.bmp.Canvas.LineTo(x1 + Depth, y1 - Depth);
        iGraph.bmp.Canvas.LineTo(x1, y1);
      End;
    iGraph.Changed := true;
  End;

Procedure GetArcCoords;

  Begin
    ArcKoords := LastArcData;
  End;

Procedure Line(x1, y1, x2, y2: integer);

  Begin
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.MoveTo(x1, y1);
    iGraph.bmp.Canvas.LineTo(x2, y2);
    iGraph.Changed := true;
  End;

Procedure LineTo(x1, y1: integer);

  Begin
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.LineTo(x1, y1);
    iGraph.Changed := true;
  End;

Procedure MoveTo(x1, y1: integer);

  Begin
    iGraph.bmp.Canvas.MoveTo(x1, y1);
  End;

Procedure LineRel(x1, y1: integer);

  Begin
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.LineTo(iGraph.bmp.Canvas.penpos.X + x1,
      iGraph.bmp.Canvas.penpos.Y + y1);
    iGraph.Changed := true;
  End;

Procedure MoveRel(x1, y1: integer);

  Begin
    iGraph.bmp.Canvas.MoveTo(iGraph.bmp.Canvas.penpos.X + x1,
      iGraph.bmp.Canvas.penpos.Y + y1);
  End;

Procedure GetPenPos(Var x1, y1: integer);

  Begin
    x1 := iGraph.bmp.Canvas.penpos.X;
    y1 := iGraph.bmp.Canvas.penpos.Y;
  End;

Function GetX: integer; Inline;
  Begin
    result := iGraph.bmp.Canvas.penpos.X;

  End;

Function GetY: integer; Inline;
  Begin
    result := iGraph.bmp.Canvas.penpos.Y;
  End;

Function GetColor: integer; Inline;
  Begin
    result := iGraph.bmp.Canvas.pen.Color;
  End;

Procedure Getpalette; Inline;
  Begin
    //
  End;

Function detect;

  Begin
    result := 7;
  End;

Function stopmode;

  Begin
    result := ( Not iGraph.visible) Or (iGraph.kkey = #27);
    If iGraph.Changed Then
      Begin
        iGraph.UpdateGraph(Nil);
        Application.ProcessMessages;
        sleep(0);
      End
    Else
      Application.ProcessMessages;
  End;

Procedure Closegraph;

  Begin
    iGraph.hide;
  End;

Function GraphErrorMsg;

  Begin
    result := '';
  End;

Function keypressed;

  Begin
    result := ( Not iGraph.visible) Or (iGraph.kkey <> #0);
    If iGraph.Changed Then
      Begin
        iGraph.UpdateGraph(Nil);
        Application.ProcessMessages;
      End
    Else
      Application.HandleMessage;
    sleep(0);
  End;

Function readkey;

  Begin
    result := #0;
    If Not iGraph.visible Then
      exit;
    While ((iGraph.kkey = #0) And (iGraph.visible)) Do
      Application.HandleMessage;
    result := iGraph.kkey;
    iGraph.kkey := #0;
  End;

Procedure SetFillStyle(FillType: Tbrushstyle; Color: integer);
  Begin
    iGraph.bmp.Canvas.Brush.Color := MapColor(Color);
    iGraph.bmp.Canvas.Brush.Style := FillType;
  End;

Procedure SetFillStyle(FillType, Color: integer);
  Begin
    iGraph.bmp.Canvas.Brush.Color := MapColor(Color);
    iGraph.bmp.Canvas.Brush.Style := Tbrushstyle(FillType);
  End;

Procedure SetLineStyle(LineType, Color, Width: integer);

  Begin
    iGraph.bmp.Canvas.pen.Style := TPenstyle(LineType);
    iGraph.DrawColor := MapColor(Color);
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.pen.Width := Width;
  End;

Procedure GetLineSettings(Var LineInfo: LineSettingsType);
  Begin
    With LineInfo Do
      Begin
        LineStyle := integer(iGraph.bmp.Canvas.pen.Style);
        Thickness := iGraph.bmp.Canvas.pen.Width;
      End;
  End;

Procedure GetFillSettings(Var FillInfo: FillSettingsType);
  Begin
    With FillInfo Do
      Begin
        Pattern := integer(iGraph.bmp.Canvas.Brush.Style);
        Color := iGraph.bmp.Canvas.Brush.Color;
      End;
  End;

Procedure GetTextSettings(Var TextInfo: TextSettingsType);
  Begin
    With TextInfo Do
      Begin
        Font := DefaultFont;
        Direction := iGraph.bmp.Canvas.Font.Orientation;
        CharSize := iGraph.bmp.Canvas.Font.size;
        Horiz := 0;
        Vert := 0;
      End;
  End;

Procedure Bar(x1, y1, x2, y2: integer);

  Var
    r: TRect;
  Begin
    r.Left := x1;
    r.Top := y1;
    r.Right := x2;
    r.Bottom := y2;
    iGraph.bmp.Canvas.FillRect(r);
    iGraph.Changed := true;
  End;

Function TextWidth(Text: String): integer;
  Begin
    result := iGraph.bmp.Canvas.TextWidth(Text);
  End;

Function TextHeight(Text: String): integer;
  Begin
    result := iGraph.bmp.Canvas.TextHeight(Text);
  End;

Procedure OutTextXY(X, Y: integer; Text: String);

  Begin
    iGraph.bmp.Canvas.Font.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.TextOut(X, Y, Text);
    iGraph.Changed := true;
  End;

Procedure OutText(Text: String);

  Begin
    iGraph.bmp.Canvas.Font.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.TextOut(iGraph.bmp.Canvas.penpos.X,
      iGraph.bmp.Canvas.penpos.Y, Text);
    // MoveRel(iGraph.bmp.Canvas.TextWidth(text) ,0);
    iGraph.Changed := true;
  End;

Procedure GetImage(x1, y1, x2, y2: integer; Var Buff); Overload;

  Begin
    //
  End;

Procedure PutImage(x1, y1: integer; Var Buff; PutType: integer);

  Begin
    //
  End;

Procedure GetImage(P1, P2: TPoint; Var Buff: TBitmap); Overload;

  Begin
    Buff := TBitmap.Create;
    Buff.PixelFormat := pf24bit;
    Buff.Width := abs(P2.X - P1.X);
    Buff.Height := abs(P2.Y - P1.Y);
    {$IFNDEF FPC}
    Buff.Canvas.CopyRect(Buff.Canvas.ClipRect, iGraph.bmp.Canvas, rect(P1, P2));
    {$ELSE}
    Buff.Canvas.CopyRect(Buff.Canvas.ClipRect, iGraph.bmp.Canvas, rect(P1.x,P1.y, P2.x,P2.y));
    {$ENDIF}
  End;

Procedure PutImage(p: TPoint; Buff: TBitmap; PutType: integer);

  Begin
    iGraph.bmp.Canvas.CopyMode := PutType;
    iGraph.bmp.Canvas.Draw(p.X, p.Y, Buff);
    iGraph.Changed := true;
  End;

Function ImageSize(x1, y1, x2, y2: integer): integer;

  Var
    PF: TPixelFormat;
  Const
    Bpp: Array [TPixelFormat] Of byte = (24, 1, 4, 8, 15, 16, 24, 32, 24);
    // pfDevice, pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom);
  Begin
    PF := iGraph.bmp.PixelFormat;
    result := (x2 - x1) * (y2 - y1) * Bpp[PF] + sizeof(TImgHeader);
  End;

Procedure setallPalette(Palette: PaletteType);

  Begin
    //
  End;

Type
  ct = Record
    Case Boolean Of
      true:
        (b, g, r, d: byte);
      false:
        (c: Tcolor);
  End;

Function RGB(r, g, b: byte): Tcolor; Inline;

  Var
    cc: ct;

  Begin
    cc.r := r;
    cc.g := g;
    cc.b := b;
    result := cc.c;
  End;

Procedure FillPoly(Count: integer; Pts: Array Of PointType);

  Begin
    iGraph.bmp.Canvas.Polygon(Pts);
    iGraph.Changed := true;
  End;
{$IFnDEF FPC}
  {$R *.dfm}
{$ENDIF}

Procedure DrawPoly(Count: integer; Pts: Array Of PointType);
  Var
    I: integer;
  Begin
    iGraph.bmp.Canvas.MoveTo(Pts[0].X, Pts[0].Y);
    For I := 1 To Count - 1 Do
      iGraph.bmp.Canvas.LineTo(Pts[I].X, Pts[I].Y);
    iGraph.Changed := true;
  End;

Procedure SetViewPort(x1, y1, x2, y2: integer; clip: Boolean);
  Begin
    iGraph.ActiveViewPort := rect(x1, y1, x2, y2);
    iGraph.bmp.Canvas.ClipRect := rect(x1, y1, x2, y2);
    iGraph.bmp.Canvas.Clipping:=true;
  End;

Procedure GetViewSettings(Var ViewPort: ViewPortType);
  Begin
    With ViewPort Do
      Begin
        x1 := iGraph.ActiveViewPort.Left;
        y1 := iGraph.ActiveViewPort.Top;
        x2 := iGraph.ActiveViewPort.Right;
        y2 := iGraph.ActiveViewPort.Bottom;
      End;
  End;

Procedure DetectGraph(Var grk, grm: integer);
  Begin
    grk := VGA;
    grm := VGAhi;
  End;

Procedure SetTextStyle;
  Begin
    Case Fonttype Of
      DefaultFont:
        iGraph.bmp.Canvas.Font.Name := StrDefaultFontName;
      GOTHICFONT:
        iGraph.bmp.Canvas.Font.Name := 'Justice';
      triplexfont:
        iGraph.bmp.Canvas.Font.Name := StrTriplexFontName;
      SansSerifFont:
        iGraph.bmp.Canvas.Font.Name := StrSansSerifFontName;
      SmallFont:
        iGraph.bmp.Canvas.Font.Name := StrSmallFontName;
    Else
      iGraph.bmp.Canvas.Font.Name := StrDefaultFontName;
    End;
    iGraph.bmp.Canvas.Font.Orientation := Direction;
    If size >= 0 Then
      iGraph.bmp.Canvas.Font.size := size * 3 + 6
    Else
      iGraph.bmp.Canvas.Font.size := UserCharDef.size * 3 + 6;
  End;

Procedure SetTextJustify(HAlign, VAlign: integer);
  Begin
    //
  End;

Procedure Rectangle(x1, y1, x2, y2: integer);
  Begin
    iGraph.bmp.Canvas.Brush.Style := bsClear;
    iGraph.bmp.Canvas.Rectangle(x1, y1, x2, y2);
  End;

Function GetModeName(GraphMode: integer): String; Inline;
  Begin
    result := 'User Defined Mode';
  End;

Procedure Draw(x1, y1, x2, y2, Color: integer);

  Begin
    iGraph.bmp.Canvas.pen.Color := MapColor(Color);
    iGraph.bmp.Canvas.MoveTo(x1, y1);
    iGraph.bmp.Canvas.LineTo(x2, y2);
    iGraph.Changed := true;
  End;

Procedure GraphMode;

  Var
    grk, grm: integer;
  Begin
    grk := 0;
    grm := 0;
    InitGraph(grk, grm, bgipath);
    setgraphmode(grm);
  End;

Procedure textmode(mode: integer);
  Begin
    restorecrtmode;
  End;

Procedure FillScreen(Fill: integer);
  Begin
    iGraph.bmp.Canvas.Brush.Style := bsSolid;
    iGraph.bmp.Canvas.Brush.Color := Fill;
    iGraph.bmp.Canvas.FillRect(GraphForm.Fbmp.Canvas.ClipRect);
    iGraph.Changed := true;
  End;

Procedure Circle(X, Y, Radius, Color: integer); Overload;
  Begin
    iGraph.bmp.Canvas.Brush.Style := bsClear;
    iGraph.bmp.Canvas.pen.Color := MapColor(Color);
    iGraph.bmp.Canvas.Ellipse(X - Radius, Y - Radius, X + Radius, Y + Radius);
    iGraph.Changed := true;
  End;

Procedure Circle(X, Y, Radius: integer); Overload;
  Begin
    iGraph.bmp.Canvas.Brush.Style := bsClear;
    iGraph.bmp.Canvas.pen.Color := iGraph.GetDrawColor;
    iGraph.bmp.Canvas.Ellipse(X - Radius, Y - Radius, X + Radius, Y + Radius);
    iGraph.Changed := true;
  End;

Procedure Palette(pal: integer);
  Begin

  End;

Procedure RegisterBGIdriver;
  Begin

  End;

Procedure RegisterBGIFont;
  Begin

  End;


// -----------------------------------------------------------
constructor TGraphForm.Create(TheOwner: TComponent);
begin
  inherited CreateNew(TheOwner);
  {$ifdef FPC}
  if LazarusResources.Find(ClassName)=nil then begin
    SetBounds((Screen.Width-678) div 2,(Screen.Height-480) div 2,678,480);
    Caption:='Graph - Window';
     Color := clNavy;
  Font.Color := clWindowText ;
  Font.Height := -11 ;
  Font.Name := 'MS Sans Serif';
  OnCloseQuery := FormCloseQuery ;
  OnCreate := FormCreate ;
  OnKeyPress := FormKeyPress ;
  OnMouseMove := FormMouseMove;
  OnPaint := FormPaint;
  OnResize := FormResize ;
  OnShow := FormShow;
   PopupMenu1:= TPopupMenu.Create(self);
   with PopupMenu1 do begin
    left := 392;
    top := 392;
    Parent := self;
    Clear1:= TMenuItem.Create(self);
    with Clear1 do begin
      Caption := 'Clear';
      OnClick := Clear1Click;
    end;
    Items.Add(clear1);

    BildSpeichern1:= TMenuItem.Create(self);
    with BildSpeichern1 do begin
      Caption := 'Bild Speichern';
      OnClick := BildSpeichern1Click;
    end;
    Items.Add(BildSpeichern1);

    Aktualisieren1:= TMenuItem.Create(self);
    with Aktualisieren1 do begin
      Caption := 'Aktualisieren';
      OnClick := Aktualisieren1Click;
    end;
    Items.Add(Aktualisieren1);

    N1:= TMenuItem.Create(self);
    with N1 do begin
      Caption := '-';
    end;
    Items.Add(N1);

    Schliessen1:= TMenuItem.Create(self);
    with Schliessen1 do begin
      Caption := 'Schliessen';
      OnClick := Schliessen1Click;
    end;
    Items.Add(Schliessen1);

   Test1:= TMenuItem.Create(self);
   with Test1 do begin
     Caption := 'Test';
     OnClick := Test1Click;
   end;
   Items.Add(Test1);

  end;
   PopupMenu := PopupMenu1;
    SavePictureDialog1:= TSavePictureDialog.Create(self);
    with SavePictureDialog1 do begin
     parent := self;
    DefaultExt := '.bmp';
  end ;
   Timer1:= TTimer.Create(self);
   with Timer1 do begin
    Parent := self;
    OnTimer := Timer1Timer;
  end
  end;
  FormCreate(self);
 {$Endif}
end;

procedure TGraphForm.Aktualisieren1Click(Sender: TObject);
  Begin
    FormPaint(Sender);
  End;

procedure TGraphForm.BildSpeichern1Click(Sender: TObject);
  Begin
    If SavePictureDialog1.execute Then
      Begin
        Fbmp.SaveToFile(SavePictureDialog1.Filename)
      End;
  End;

procedure TGraphForm.Clear1Click(Sender: TObject);
  Begin
    Fbmp.Canvas.Brush.Color := clBlack;
    Fbmp.Canvas.FillRect(Fbmp.Canvas.ClipRect);
    Invalidate;
  End;

procedure TGraphForm.Test1Click(Sender: TObject);
  Begin
    Fbmp.LoadFromResourceName(hInstance, 'TestBMP');
  End;

procedure TGraphForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  Begin
    FkKEY := #27
  End;

procedure TGraphForm.FormCreate(Sender: TObject);

  Begin
    FkKEY := #0;
    df := 1;
    Fbmp := TBitmap.Create;
    Fbmp.Width := ClientWidth;
    Fbmp.Height := ClientHeight;
    Fbmp.Canvas.pen.Width := 1;
    FBkColor := clBlack;
  End;

procedure TGraphForm.FormKeyPress(Sender: TObject; var Key: Char);
  Begin
    FkKEY := Key;
  End;

procedure TGraphForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: integer);
  Begin
    LmousePos := point(X, Y);
    LShift := Shift;
  End;

procedure TGraphForm.FormPaint(Sender: TObject);
  Begin
    Canvas.StretchDraw(rect(0, 0, ClientWidth, ClientHeight), Fbmp);
    FChanged := false;
  End;

procedure TGraphForm.FormShow(Sender: TObject);
  Begin
    FkKEY := #0;
    FActiveViewPort := Fbmp.Canvas.ClipRect;
  End;

procedure TGraphForm.Schliessen1Click(Sender: TObject);
  Begin
    close;
  End;

procedure TGraphForm.Timer1Timer(Sender: TObject);
  Begin
    If FChanged Then
      Aktualisieren1Click(Sender)
  End;

procedure TGraphForm.FormResize(Sender: TObject);
  Begin
    Fbmp.Width := ClientWidth * df;
    Fbmp.Height := ClientHeight * df;
    Fbmp.Canvas.Brush.Color := FBkColor;
    Fbmp.Canvas.FillRect(Fbmp.Canvas.ClipRect);
  End;

procedure TGraphForm.SetVisible(val: Boolean);
  Begin
    If val Then
      show
    Else
      hide;
  End;

function TGraphForm.GetVisible: Boolean;
  Begin
    result := visible;
  End;

procedure TGraphForm.SetBitmap(val: TBitmap);
  Begin
    If Fbmp <> val Then
      Begin
        // FBmp:=val
      End;
  End;

function TGraphForm.GetBitmap: TBitmap;
  Begin
    result := Fbmp;
  End;

function TGraphForm.GetChanged: Boolean;
  Begin
    result := FChanged
  End;

procedure TGraphForm.SetChanged(val: Boolean);
  Begin
    FChanged := val;
  End;

function TGraphForm.GetbkColor: Tcolor;
  Begin
    result := FBkColor;
  End;

procedure TGraphForm.SetbkColor(val: Tcolor);
  Begin
    FBkColor := val;
  End;

function TGraphForm.GetActiveViewPort: TRect;
  Begin
    result := FActiveViewPort;
  End;

procedure TGraphForm.SetActiveViewPort(val: TRect);
  Begin
    FActiveViewPort := val;
  End;

procedure TGraphForm.UpdateGraph(Sender: TObject);
  Begin
    FormPaint(Sender);
  End;

function TGraphForm.GetDrawColor: Tcolor;
  Begin
    result := FDrawColor;
  End;

procedure TGraphForm.SetDrawColor(val: Tcolor);
  Begin
    FDrawColor := val;
  End;

function TGraphForm.Getkkey: Char;
  Begin
    result := FkKEY;
  End;

procedure TGraphForm.Setkkey(val: Char);
  Begin
    FkKEY := val;
  End;

/// <author>Rosewich</author>
Procedure FillEllipse(X, Y, Radius1, Radius2: integer);
  Begin
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.Ellipse(X - Radius1, Y - Radius2, X + Radius1,
      Y + Radius2);
    iGraph.Changed := true;
  End;

/// <author>Rosewich</author>
Procedure Sector(X, Y, Angle1, Angle2, Radius1, Radius2: integer);
  Begin
    iGraph.bmp.Canvas.pen.Color := iGraph.DrawColor;
    iGraph.bmp.Canvas.Ellipse(X - Radius1, Y - Radius2, X + Radius1,
      Y + Radius2);
    iGraph.Changed := true;
  End;

/// <author>Rosewich</author>
Procedure SetWriteMode(NewWritemode: integer);
  Begin
  End;

/// <author>Rosewich</author>
Procedure SetFillPattern(UserFillPattern: FillPatternType; Color: integer);
  Begin
  End;

/// <author>Rosewich</author>
Procedure SetAspectRatio(Xasp, Yasp: word);
  Begin

  End;

/// <author>Rosewich</author>
Procedure SetUserCharSize(size, Top, Bottom, Under: integer);
  Begin
    UserCharDef.size := size;
  End;
initialization
   Application.initialize;
End.
