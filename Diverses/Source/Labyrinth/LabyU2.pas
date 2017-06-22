Unit LabyU2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ExtDlgs, variants;

Type
  TLbyRoomItm = Class

  End;

  TLbyActiveItm = Class(TLbyRoomItm)

  End;

  TLbyPassiveItm = Class(TLbyRoomItm)

  End;

  TLbyRoom = Class(TCollectionItem)
  private
    FOrt: Tpoint;
    FGang: Array Of TLbyRoom;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Property Ort: Tpoint read FOrt;
  End;

  TlbyEingang = Class(TlbyRoom)

  End;

  TLbyAusgang = Class(TlbyRoom)

  End;

  TLbyGang = Class(TlbyRoom)

  End;

  TLbyCreature = Class(TLbyActiveItm)
  End;

  TLbyPlayer = Class(TLbyCreature)
  End;

  TLaby = Class(TForm)
    btnClose: TButton;
    LabImage: TImage;
    Timer1: TTimer;
    btnOK: TButton;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    SavePictureDialog1: TSavePictureDialog;
    Procedure LabImageClick(Sender: TObject);
    Function NewPlayer: TLbyPlayer;
    Function GetRoom({%H-}ZLbyPlayer: TLbyPlayer): TLbyRoomItm;
    Procedure btnCloseClick(Sender: TObject);
    Procedure CreateLaby;
    Procedure Timer1Timer(Sender: TObject);
    Procedure btnOKClick(Sender: TObject);
    Procedure TermML(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    ig: tbitmap;

  public
    { Public-Deklarationen }
    HFont: TFont;
    HText: String;
    Lab: Tbitmap;

  End;

Var
  Laby: TLaby;

Implementation

Uses ProgressBarU, unt_Point2d;

Const
  GoldCut = 0.61803398874989484820458683436564;

Type
  TStack = Class
  private
    FStack: Array Of T2DPoint;
    Stackin, Stackout: integer;
    Function getActPoint: T2DPoint;
  public
    overflow: Boolean;
    Property Point: T2DPoint read getActPoint;
    Constructor Init(count: Integer);
    Destructor done; virtual;
    Procedure Add(newPoint: T2DPoint);
    Function GetNext: boolean;
  End;

  TMakeLaby = Class(TThread)
  public
    test: integer;
    LabyBM: TBitmap;
    LabyDBM: TBitmap;
    FunctnBM: TBitmap;
    dFact: integer;
    Procedure Refr;
    Procedure InitBM(width, Height: integer);
    Procedure SetStartPoint(x, y: integer);
  private

    { Private-Deklarationen }
    FCount: Integer;
    ZStack: TStack;
    {
     FLaby: TLbyRoom;
    }
    FRunnmode: Boolean;
    Function getIpPixel(x, y: integer): Tcolor;
    Function getLBPixel(x, y: integer): boolean;
    Procedure PutLBPixel(x, y: integer; value: boolean);

    {
     Property igpixel[x, y: integer]: Tcolor read getippixel;
    }
    Property LBpixel[x, y: integer]: boolean read getlbpixel write putlbpixel;
    Procedure DrawNewWay(Point: T2DPoint; dir: Shortint; flag2: boolean);
    Procedure InitDBMWay;
    Procedure PutLogo(path: Variant);
    Procedure RandomPoints(dp: T2DPoint);
    Procedure RandomQuadr(dp: T2DPoint; ausl, dx, dy: extended);
    Procedure FindNewWay(Var flag: Boolean; Point: T2DPoint; ddir: Shortint; Var
      dir: Shortint; Var flag2: Boolean; dp: T2DPoint);
  protected
    Property CCount: integer read FCount;
    Procedure Execute; override;
  End;

{$IFnDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

Var
  makelaby: Tmakelaby;

Procedure TLaby.btnCloseClick(Sender: TObject);
Begin
  hide;
  makelaby.FRunnmode := false;
  If assigned(makelaby) Then
    makelaby.DoTerminate
End;

Function TLaby.NewPlayer;

Begin
  NewPlayer := Nil;
End;

Function Tlaby.GetRoom;

Begin
  GetRoom := Nil;
End;

Procedure TLaby.LabImageClick(Sender: TObject);
Begin
  If Not makelaby.Terminated Then
    //    makelaby.Resume;
End;

//---------------------------- Stack ------------------------------------

Constructor TStack.init;

Begin
  setlength(FStack, count);
  Stackin := 0;
  Stackout := 0;
  overflow := false;
End;

Destructor TStack.done;

Begin
  setlength(Fstack, 0);
End;

Procedure TStack.add;
Begin
  stackin := (stackin + 1) Mod (high(FStack) + 1);
  If assigned(FStack[stackin]) Then
    FStack[stackin].copy(newPoint)
  Else
    FStack[stackin] := t2dPoint.init(newPoint);
  If Stackin = stackout Then
    Begin
      stackout := (stackout + 1) Mod (high(FStack) + 1);
      overflow := true;
    End;
End;

Function TStack.getActPoint;
Begin
  result := Fstack[stackout];
End;

Function Tstack.getnext;
Begin
  result := stackin <> stackout;
  If result Then
    stackout := (stackout + 1) Mod (high(FStack) + 1);
End;

//---------------------------------------------------------------------------

Procedure myFloodfill(im: Tcanvas; p: T2dPoint; c: Tcolor; o_r, u_l: T2dPoint;
  mode: byte);

Var
  ZStack: TStack;
  ocol, tc: TColor;
  i, j, k: integer;
  flag: boolean;
  pp: T2dPoint;

Begin
  k := 0;
  ocol := im.pixels[p.x, p.y];
  If ocol <> c Then
    With im Do
      Begin
        zStack := Tstack.init(im.ClipRect.Right * im.ClipRect.Bottom Div 4);
        zstack.Add(p);
        While zstack.GetNext Do
          Begin
            flag := true;
            If pixels[zstack.point.x, zstack.point.y] = ocol Then
              Begin
                If mode > 0 Then
                  Begin
                    j := 1;
                    While (flag) And (j <= mode) Do
                      Begin
                        i := 1;
                        While (flag) And (i <= 12) Do
                          Begin
                            tc := pixels[zstack.point.x + (dir12[i].x * j) Div
                              2, zstack.point.y + (dir12[i].y * j) Div 2];
                            flag := flag And ((tc = c) Or (tc = ocol));
                            inc(i);
                          End;
                        inc(j)
                      End;
                  End;
                If flag Then
                  Begin
                    pixels[zstack.point.x, zstack.point.y] := c;
                    k := k Mod 50 + 1;
                    //        if k = 1 then im.update;
                    For i := 1 To 4 Do
                      Begin
                        If (zstack.point.x + dir4[i].x >= O_R.x) And
                          (zstack.point.x + dir4[i].x <= u_l.x) And
                          (zstack.point.y + dir4[i].y >= O_R.y) And
                          (zstack.point.y + dir4[i].y <= u_l.y) And
                          (pixels[zstack.point.x + dir4[i].x,
                          zstack.point.y + dir4[i].y] = ocol) Then
                          Begin
                            pp := zstack.point;
                            pp.add(dir4[i]);
                            ZStack.add(pp);
                          End;
                      End;
                  End;
              End;
          End;
        ZStack.done;
      End;
End;

{Wichtig: Objektmethoden und -eigenschaften in der VCL können in Methoden
verwendet werden, die mit Synchronize aufgerufen werden, z.B.:

      Synchronize(UpdateCaption);

  wobei UpdateCaption so aussehen könnte:

    procedure MakeLaby.UpdateCaption;
    begin
      Form1.Caption := 'Aktualisiert im Thread';
    end; }

{ MakeLaby }

Const
  Farbtab: Array[0..5] Of Tcolor =
  (clwhite, {Freier Bereich }
    clyellow, {Waarerecht }
    clgreen, {senkrecht}
    clred, {One Way }
    clblue, {eingang zu schwarz}
    clblack); {Innen im weg}

  {
  Uebergtab: Array[0..5, 0..5] Of byte =
  ((1, 1, 1, 4, 4, 9),
    (1, 1, 1, 1, 4, 9),
    (1, 1, 1, 1, 4, 9),
    (9, 1, 1, 1, 4, 9),
    (9, 9, 9, 9, 1, 1),
    (9, 9, 9, 9, 9, 1));
  }

Procedure TLaby.CreateLaby;

Var

  j: integer;
  {   ocol:Tcolor;}

  dir: Shortint;
  Point,
  hp: T2dPoint;

  flag: boolean;

Const
  HFont = {'Arial Rounded MT Bold'} 'Brush Script MT kursiv';
  HFSize = 48;
  HFColor = clYellow;
  HFSColor = clBlack;

Var
  Hiddentext: String;

  Procedure makeSpecialWay;

  Var
    i, j, k: integer;
    tc: tcolor;
    tp, dp, point: T2dpoint;

  Begin
    //exit;
    tp := T2dpoint.init(0, 0);
    dp := T2dpoint.init(0, 0);
    point := T2dpoint.init(0, 0);
    Hiddentext := 'Joe Care';
    With ig.Canvas Do
      Begin
        For i := 0 To ig.Width - 1 Do
          For j := 0 To ig.height - 1 Do
            pixels[i, j] := clwhite;
        font.size := HFSize;
        font.Name := HFont;
        font.Color := HFColor;
        dp.x := TextWidth(hiddentext) + 20;
        dp.y := TextHeight(hiddentext);
        point.x := (ig.width - dp.x) Div 2;
        point.y := (((ig.height - dp.y) Div 2) Or 1) - 1;
        copyMode := cmMergeCopy;
        font.color := HFColor;
        textout(point.x + 10, point.y, Hiddentext);

        tp.init(point);
        tp.add(dp);
        myFloodFill(ig.Canvas, point, clred, point, tp, 0);
        {*Suche und beseitige 'Inseln'}
        {*Parameter: Bereich,Farbe,richtung }
        For j := tp.x Downto point.x Do
          For i := point.y To tp.y Do
            If pixels[j, i] = clwhite Then
              Begin
                hp.x := j;
                hp.y := i;
                flag := true;
                k := 1;
                While (k <= 4) Do
                  Begin
                    tc := pixels[hp.x + dir8[k * 2].x, hp.y + dir8[k * 2].y];
                    If tc = clred Then
                      Begin
                        flag := false;
                        pixels[hp.x + dir4[k].x, hp.y + dir4[k].y] := clwhite;
                        pixels[hp.x, hp.y] := clwhite;
                      End;
                    If tc = clwhite Then
                      pixels[hp.x + dir4[k].x, hp.y + dir4[k].y] := clwhite;
                    inc(k);
                  End;
                If flag Then
                  Begin
                    While pixels[hp.x, hp.y] <> clred Do
                      Begin
                        pixels[hp.x, hp.y] := clwhite;
                        hp.x := hp.x + dir8[1].x;
                        hp.y := hp.y + dir8[1].y;
                      End;
                    hp.x := hp.x - dir8[1].x;
                    hp.y := hp.y - dir8[1].y;
                    myfloodfill(ig.Canvas, hp, clred, point, tp, 0);
                  End
                Else
                  myfloodfill(ig.Canvas, hp, clred, point, tp, 0);

              End;
        tp.y := tp.y - 1;
        myfloodfill(ig.canvas, point, clwhite, point, tp, 0);
        tp.y := tp.y + 1;
        For i := tp.y Downto point.y Do
          For j := point.x To tp.x Do
            If pixels[j, i] = hfcolor Then
              Begin
                hp.x := j;
                hp.y := i;
                flag := true;
                k := 1;
                While flag And (k <= 4) Do
                  Begin
                    If pixels[hp.x + dir8[k * 2].x, hp.y + dir8[k * 2].y] = clred
                      Then
                      Begin
                        flag := false;
                        pixels[hp.x + dir4[k].x, hp.y + dir4[k].y] := clred;
                        pixels[hp.x, hp.y] := clred;
                      End;
                    inc(k);
                  End;
                If flag Then
                  Begin
                    While pixels[hp.x, hp.y] <> clred Do
                      Begin
                        pixels[hp.x, hp.y] := hfcolor;
                        hp.x := hp.x + dir8[3].x;
                        hp.y := hp.y + dir8[3].y;
                      End;
                    hp.x := hp.x + dir8[7].x;
                    hp.y := hp.y + dir8[7].y;
                    myfloodfill(ig.Canvas, hp, clred, point, tp, 0);
                  End;
              End;
        myfloodfill(ig.canvas, tp, hfscolor, point, tp, 0);
        hp.copy(tp);
        tp.x := ig.width;
        tp.y := ig.height;
        myfloodfill(ig.canvas, point, clred, dir4[0], tp, 6);
        For i := 1 To 6 Do
          Begin
            pixels[point.x - i, hp.y] := farbtab[5];
            pixels[hp.x + i, hp.y] := farbtab[5];
          End;
        pixels[point.x, hp.y + 1] := farbtab[4];
        tp.copy(dp);
        For j := 0 To 5 Do
          Begin
            For i := 0 To ig.height Do
              If pixels[j - 2 + ig.width Div 2, i] = clred Then
                pixels[j - 2 + ig.width Div 2, i] := clwhite;
          End;

      End;
    dp.done;
    point.done;
  End;

  Procedure RandomizeWalls(dp: T2dPoint; ddir: shortint);

  Var
    hp: T2dpoint;
    k: integer;
    ocol, tc: TColor;

  Begin
    With labimage.canvas Do
      Begin
        hp := T2dpoint.init(dp);
        k := 0;
        point.copy(dp);
        While (pixels[dp.x, dp.y] <> clBlack)
          And (dp.x > 0)
          And (dp.y > 0)
          And (dp.x < LabImage.Width)
          And (dp.y < LabImage.Height)
          And (k < 2) Do
          Begin
            ocol := clwhite; //ig.canvas.pixels[dp.x,dp.y];
            j := 0;
            Repeat
              If (ig.canvas.pixels[dp.x Div 2, dp.y Div 2] = HFColor) Then
                dir := (dir Or 1) And 3
              Else
                dir := ((dir + 2 + random(3)) Mod 4) + 1;

              If dir = ddir Then
                dir := ((dir + 1) Mod 4) + 1;
              inc(j);
              tc := ig.canvas.pixels[
                (dp.x Div 2) + dir4[dir].x,
                (dp.y Div 2) + dir4[dir].y];
            Until (j > 20) Or ((tc <> HFsColor) And ((tc = clwhite) Or (ocol =
              clred)));
            If j > 20 Then
              Begin
                inc(k);
                dp.copy(hp);
                dir := ddir;
                ddir := ((ddir + 1) Mod 4) + 1;
                If ig.canvas.pixels[
                  (dp.x Div 2) + dir4[dir].x,
                  (dp.y Div 2) + dir4[dir].y] = HFsColor Then
                  inc(k);
              End
            Else
              Begin

                pixels[dp.x, dp.y] := clblue;
                makelaby.ZStack.Add(dp);
                dp.add(dir4[dir]);
                pixels[dp.x, dp.y] := clblue;
                dp.add(dir4[dir]);
              End;
          End;
        dp.x := labimage.Width;
        dp.y := labimage.height;
        If k = 2 Then
          myfloodfill(labimage.canvas, hp, clwhite, dir4[0], dp, 0)
        Else
          myfloodfill(labimage.canvas, hp, clblack, dir4[0], dp, 0);
      End;
  End;

Const
  df = 3;

Begin
  labimage.visible := true;
  labimage.width := labimage.Width Or 1;
  labimage.height := labimage.height Or 1;
  LabImage.Picture := TPicture.Create;
  LabImage.Picture.Bitmap.Create;
  LabImage.Picture.Bitmap.Height := LabImage.Height;
  LabImage.Picture.Bitmap.Width := LabImage.Width;
  randomize;
  {*e Ausgang und Eingang }
  Update;
  MakeLaby := TMakeLaby.Create(true);
  //  makelaby.LabyDBM :=LabImage.Picture.Bitmap;
  makelaby.InitBM(labimage.Width * 2, labimage.Height * 2);
  makelaby.SetStartPoint(0, (makelaby.LabyBM.height Div 2) Or 1);
  makelaby.dfact := df;
  makelaby.Resume;
  //  makelaby.Execute;
    //       point.x:=(LabImage.width-tp.x) div 2 ;
    //       point.y:=(((LabImage.height-tp.y) div 2)or 1)-1;

End;

Function TMakelaby.getIpPixel;

Begin
  getippixel := laby.ig.canvas.pixels[x, y]
End;

Function TMakelaby.getLBPixel;

Begin
  If (x < 0) Or (y < 0) Or (x > LabyBM.Width) Or (y > LabyBM.Height) Then
    result := true
  Else
    result := LabyBM.Canvas.pixels[x, y] <> clblack
End;

Procedure TMakelaby.PutLBPixel;

Begin
  If value Then
    LabyBM.canvas.pixels[x, y] := clwhite
  Else
    LabyBM.canvas.pixels[x, y] := clblack;
End;

Procedure TMakeLaby.Execute;

Var
  flag: boolean;
  Point, dp: T2dPoint;
  odir, dir, ddir: shortint;
  i: TColor;
  path: variant;
  wcount: Integer;
  dir1: Integer;
  dir2: Integer;
  Sdir: Integer;
  flag2: Boolean;

  Function getcolorFkt(c: TColor): byte;

  Var
    i: byte;

  Begin

    i := 5;
    While (i > 0) And (farbtab[i] <> c) Do
      dec(i);
    getColorFkt := i;
  End;

Begin
  { Plazieren Sie den Thread-Quelltext hier }
  FRunnmode := true;
  path := vararrayof([2, 1, 12, 4, 4, 4, 6, 5, 2, 11,
    12, 10, 10, 12, 2, 6, 4, 2, 12, 10, 10, 2,
      12, 2, 5, 7, 4, 1, 1, 12,
      10, 10, 11, 12, 2, 6, 5, 4, 3,
      1, 11, 10, 12, 2, 6, 4, 2, 12, 10, 10, 2, 4, 3,
      1, 11, 10, 12, 4, 4, 2, 10, 10, 12, 2,
      //  12,10,10,2,
    12, 2, 5, 7, 4, 1, 1]);
  PutLogo(path);

  dp := T2DPoint.init(round(goldcut * labybm.width), round(goldcut * goldcut *
    labybm.Height));
  RandomPoints(dp);
  dp.free;
  dp := T2DPoint.init(round(goldcut * goldcut * labybm.width), round(goldcut *
    labybm.Height));
  RandomQuadr(dp, goldcut * goldcut * labybm.height, 4.8, 4.8);
  dp.free;
  dp := T2DPoint.init(round(goldcut * goldcut * labybm.width), round(goldcut *
    goldcut * labybm.Height));
  RandomQuadr(dp, goldcut * goldcut * goldcut * goldcut * labybm.height, 2, 2);

  dp.free;

//  dcount := 1;
  FCount := 0;
  LabyBM.Canvas.Lock;
  InitDBMWay;
  While ZStack.GetNext Do
    Begin
      wcount := 0;
      point := t2dpoint.init(ZStack.point);
      dp := t2dpoint.init(0, 0);
      flag := false;
      odir := 0;
      Sdir := 0;
      dir := 0;
      While Not flag Do
        Begin
          // bestimme eine Richtung und eine Drehung
          If point.x = 0 Then // Startpunkt
            Begin
              dir := 1;
              ddir := random(2) * 2;
            End
          Else If odir = 0 Then // neuer Strang
            Begin
              ddir := random(2) * 2;
              dir := random(12);
            End
          Else
            Begin // Logo
              If (Wcount >= 10) And (fcount < 40000) And (fcount > 10000) Then
                Begin
                  If ((wcount - 10) Div 3) Mod (vararrayhighbound(path, 1) + 1)
                    = 0 Then
                    sdir := (sdir + random(3) + 10) Mod 12 + 1;
                  dir1 := path[((wcount - 10) Div 3) Mod
                    (vararrayhighbound(path, 1) + 1)];
                  dir2 := path[((wcount - 9) Div 3) Mod (vararrayhighbound(path,
                    1) + 1)];
                  If abs(dir1 - dir2) <= 6 Then
                    dir := ((((dir1 + dir2) Div 2) + 11 + sdir) Mod 12) + 1
                  Else
                    dir := (((dir1 + dir2) Div 2 + 4 + sdir) Mod 12) + 1;
                  ddir := random(2) * 2;
                End
              Else
                Begin
                  sdir := odir;
                  dir := (odir + random(3) + 10) Mod 12 + 1;
                  ddir := random(2) * 2;
                End;
            End;
          inc(Wcount);
          dp.copy(point);
          flag := true;

          FindNewWay(flag, Point, ddir, dir, flag2, dp);

          If Not flag Then
            Begin
              // zeichne Linie als weg
              For i := 0 To 3 Do
                lbpixel[point.x + round(dir12[dir].x * i / 3), point.y +
                  round(dir12[dir].y * i / 3)] := true;
              inc(Fcount);

              DrawNewWay(Point, dir, flag2);

              // füge Punkt zum Stack hinzu, für weitere Prüfungen
              ZStack.add(dp);
              ZStack.add(point);

              point.copy(dp);
              odir := dir;
            End;

        End;

      dp.done;
      point.done;
      If Not FRunnmode Then
        break
    End;
  LabyBM.Canvas.Unlock;

  //  Synchronize(refr);
  Terminate;
End;

Procedure TMakeLaby.FindNewWay(Var flag: Boolean; Point: T2DPoint; ddir:
  Shortint; Var dir: Shortint; Var flag2: Boolean; dp: T2DPoint);
Var
  tdir: Integer;
  i: TColor;
  j: TColor;
Begin
  i := 0;
  // suche einen Freien Platz um den Punkt
  While flag And (i < 12) Do
    Begin
      // Berechne zu testenden Punkt
      dp.copy(point);
      dp.add(dir12[dir]);
      j := 0;
      flag := false;
      // Teste ob Punkt und alle 8 umliegenden Punkte frei sind
      While (j < 9) And (Not flag) Do
        Begin
          flag := flag Or (lbpixel[dp.x + dir8[j].x, dp.y + dir8[j].y]);
          inc(j);
        End;
      flag2 := false;
      If (dir12[dir].x <> 0) And (dir12[dir].y <> 0) And (Not flag) Then
        For j := 3 To 3 Do
          Begin
            tdir := (dir + 1) Mod 12 + 1;
            //dir + 2
            flag2 := flag2 Or (lbpixel[point.x + round(dir12[tdir].x * j / 3),
              point.y + round(dir12[tdir].y * j / 3)]);
            tdir := (dir + 9) Mod 12 + 1;
            // dir -2
            flag2 := flag2 Or (lbpixel[point.x + round(dir12[tdir].x * j / 3),
              point.y + round(dir12[tdir].y * j / 3)]);
          End;
      If flag Then
        dir := (dir + ddir + 10) Mod 12 + 1;
      i := i + 1;
    End;
End;

Procedure TMakeLaby.RandomPoints(dp: T2DPoint);
Var
  i: integer;
  dd, ausl, lx, ly, lz: extended;
  cc: Extended;
  ss: Extended;
  lyy: Extended;
  lzz: Extended;

Begin
  cc := cos(pi / 6);
  ss := sin(pi / 6);
  For I := 0 To 7000 - 1 Do
    Begin
      dd := 2 * pi * random;
      ausl := random;
      lx := sin(dd) * ausl;
      ly := cos(dd) * ausl;
      lz := sqrt(1 - ausl);
      lyy := ly * cc - lz * ss;
      lzz := lz * cc + ly * ss;
      If lzz >= 0 Then
        LBpixel[dp.x + round((lx * cc + lyy * ss) * goldcut * goldcut * goldcut
          * labybm.Height), dp.y + round((lyy * cc - lx * ss) * goldcut * goldcut
          * goldcut * labybm.Height)] := true;
    End;
End;

Procedure TMakeLaby.RandomQuadr(dp: T2DPoint; ausl, dx, dy: extended);
Var
  i, j: integer;
  dd, jitter: extended;

Begin
  dd := 2 * pi * random;
  For J := round(-ausl / dy) To round(ausl / dy) Do
    Begin
      Jitter := random * 0.5;
      For I := round(-ausl / dx) To round(ausl / dx) Do
        Begin
          LBpixel[dp.x + round(sin(dd) * J * dy + cos(dd) * (i + Jitter) * dx),
            dp.y + round(cos(dd) * J * dy - sin(dd) * (i + Jitter) * dx)] :=
            true;
        End;
    End;
End;

Procedure TMakeLaby.PutLogo(path: Variant);
Var
  dir, dir1, dir2: Shortint;
  i: TColor;
  dp: T2DPoint;
Begin
  dp := t2dpoint.init(labybm.Width - 10, labybm.height - 10);
  For I := vararrayhighbound(path, 1) * 3 - 1 Downto 0 Do
    Begin
      dir1 := path[i Div 3];
      dir2 := path[(i + 1) Div 3];
      If abs(dir1 - dir2) <= 6 Then
        dir := (dir1 + dir2) Div 2
      Else
        dir := ((dir1 + dir2) Div 2 + 5) Mod 12 + 1;
      lbpixel[dp.x, dp.y] := true;
      //      If dir Mod 3 = 1 Then
      lbpixel[dp.x - dir12[dir].x Div 2, dp.y - dir12[dir].y Div 2] := true;
      //    lbpixel[dp.x - dir12[dir].x , dp.y - dir12[dir].y ] := true;
      //    lbpixel[dp.x - dir12[dir].x*3 div 2, dp.y - dir12[dir].y*3 div 2] := true;
      dp.x := dp.x - dir12[dir].x;
      dp.y := dp.y - dir12[dir].y;
    End;
  lbpixel[dp.x, dp.y] := true;
End;

Procedure TMakeLaby.InitDBMWay;
Begin
  LabyDBM := TBitmap.Create;
  labydbm.PixelFormat := pf4bit;
  LabyDBM.Height := labyBM.Height * dFact;
  LabyDBM.Width := labyBM.Width * dFact;
  LabyDBM.Canvas.pen.Color := clblack;
  LabyDBM.Canvas.pen.Width := (dFact Div 2) + 1;
End;

Procedure TMakeLaby.DrawNewWay(Point: T2DPoint; dir: Shortint; flag2: boolean);
Begin
  labydbm.Canvas.lock;
  labydbm.Canvas.Pen.Color := clGray;
  labydbm.Canvas.Pen.Width := dFact + 1;
  labydbm.Canvas.MoveTo((point.x * dfact + dir12[dir].x), (point.y * dfact +
    dir12[dir].y));
  labydbm.Canvas.LineTo((point.x + dir12[dir].x) * dfact, (point.y +
    dir12[dir].y) * dfact);
  If Not Flag2 Then
    labydbm.Canvas.Pen.Color := clblack;
  labydbm.Canvas.Pen.Width := dFact - 1;
  labydbm.Canvas.MoveTo(point.x * dfact, point.y * dfact);
  labydbm.Canvas.LineTo((point.x + dir12[dir].x) * dfact, (point.y +
    dir12[dir].y) * dfact);
  labydbm.Canvas.unlock;
End;

Procedure TLaby.Timer1Timer(Sender: TObject);
Begin
  If assigned(makelaby) Then
    If assigned(makelaby.LabyDBM) Then
      If Not makelaby.Terminated Then
        If Not makelaby.Suspended Then
          With LabImage.Picture.Bitmap.Canvas Do
            Begin
              makelaby.labydbm.Canvas.lock;
              Label1.Caption := inttostr(makelaby.FCount);
              //            Pixels[makelaby.ZStack.getActPoint.x ,makelaby.ZStack.getActPoint.y]:=clblack;

              CopyRect(ClipRect, makelaby.LabydBM.Canvas,
                makelaby.LabydBM.Canvas.ClipRect);
              makelaby.labydbm.Canvas.unlock;
              //            makelaby.resume;
            End;
End;

Procedure TLaby.TermML(Sender: TObject);
Begin
  btnok.Enabled := true;
End;

Procedure TLaby.btnOKClick(Sender: TObject);
Begin
  hide;
  If Assigned(makelaby) Then
    makelaby.Terminate;
End;

Procedure TMakeLaby.Refr;
Begin
  //  laby.LabImage.Invalidate;
  Laby.Label1.Caption := inttostr(Fcount);
  //  If Suspended Then
  //    resume;
End;

Procedure TLaby.Button1Click(Sender: TObject);
Begin
  {$IFNDEF FPC}
  print
  {$ENDIF}
End;

Procedure TLaby.Button2Click(Sender: TObject);
Begin
  If SavePictureDialog1.Execute Then
    Begin
      Makelaby.LabyDBM.SaveToFile(SavePictureDialog1.FileName);
      Makelaby.LabyBM.SaveToFile('c:\laby_00.bmp');
    End;
End;

Procedure TMakeLaby.InitBM(width, Height: integer);
Begin
  labyBM := TBitmap.Create;
  labyBM.PixelFormat := pf1bit;
  labyBM.Height := Height;
  labyBM.width := Width;
  With labyBM.canvas Do
    Begin
      Brush.Color := clblack;
      FillRect(cliprect);
    End;
End;

Procedure Tmakelaby.SetStartPoint(x: Integer; y: Integer);
Begin
  ZStack := tstack.init(labyBM.Height * labyBM.width Div 4);

  zstack.Add(T2DPoint.init(x, y))

End;

End.

{
\_/| _ _  _  //    _ _  _    _
   |// \\// //    // || ||/\//
   ||| |  | \\   ||  || |||  |
  // \_|  \__\\_/ \_/ \/ ||  \_
  \|

  12,1,2,11,11,11,10,12,3,}

