Unit Labydemo3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
{$IFnDEF FPC}
  pngimage, jpeg,  Windows,  {UITypes,(?)}
{$ELSE}
  LCLIntf, LCLType, JPEGLib, FileUtil,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, LabyU3, Fra_WindRose, ExtDlgs, unt_Point2d;

Type

  { TForm1 }

  TForm1 = Class(TForm)
    Image1: TImage;
    Btn_Create: TButton;
    Btn_Test1: TButton;
    Btn_Load: TButton;
    Button4: TButton;
    Button5: TButton;
    Btn_GoFwd: TButton;
    Btn_Back: TButton;
    FraWindRose1: TFraWindRose;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    CheckBox2: TCheckBox;
    Label1: TLabel;
    Image2: TPaintBox;
    Btn_Test2: TButton;
    Btn_Test3: TButton;
    Btn_Test4: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Procedure Btn_Test1Click(Sender: TObject);
    Procedure Btn_CreateClick(Sender: TObject);
    Procedure Image1Click(Sender: TObject);
    Procedure Btn_LoadClick(Sender: TObject);
    Procedure Button5Click(Sender: TObject);
    Procedure Button4Click(Sender: TObject);
    Procedure Btn_GoFwdClick(Sender: TObject);
    Procedure Btn_BackClick(Sender: TObject);
    Procedure Timer1Timer(Sender: TObject);
    Procedure CheckBox2Click(Sender: TObject);
    Procedure Btn_Test2Click(Sender: TObject);
    Procedure Btn_Test3Click(Sender: TObject);
    Procedure Btn_Test4Click(Sender: TObject);
  Private
    ActRoom: TLbyRoom;
    // FForeward: Boolean;
    FLdir: Integer;
    FVisx0: Integer;
    FVisy0: Integer;
    FPictFilename: TFileName;
    { Private-Deklarationen }
  Private
    Procedure DrawLaby(Sender: TObject);
    Procedure PutLogo(x, y: Integer; path: variant; putpixel: TPutObstaclePxl;wfact:integer);
    Procedure RandomPoints(x, y, size, count: Integer;
      putpixel: TPutObstaclePxl);
    Procedure RandomQuadr(x, y: Integer; ausl, dx, dy: extended;
      putpixel: TPutObstaclePxl);
    Procedure PutImage(x, y: Integer; filename: String; size: Integer;
      putpixel: TPutObstaclePxl);
    { Public-Deklarationen }
  Public
    Procedure PutLogoUR(putpixel: TPutObstaclePxl);
    Procedure DoRandomPoints(putpixel: TPutObstaclePxl);
    Procedure DoBigQuadr(putpixel: TPutObstaclePxl);
    Procedure DoSmallQuadr(putpixel: TPutObstaclePxl);
    Procedure putpixel(dp:T2dpoint; value: Boolean);
    Procedure DoPicture(putpixel: TPutObstaclePxl);
  End;

Var
  Form1: TForm1;

Implementation

Uses ProgressBarU, variants;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

CONST
  GoldCut = 0.61803398874989484820458683436564;

Procedure TForm1.Btn_Test4Click(Sender: TObject);

  Begin
    If OpenPictureDialog1.Execute Then
      Begin
        Image1.Canvas.Brush.Color := clDkGray;
        Image1.Canvas.FillRect(Image1.Canvas.cliprect);

        FPictFilename := OpenPictureDialog1.filename;

        PutImage(0, 0, FPictFilename, 500, putpixel);
        // PutImage(0, 200, FPictFilename, 330, putpixel);
        // Image1.{Picture.bitmap.}Canvas, Image1.{Picture.bitmap.}Canvas.cliprect);
      End;
  End;

Procedure TForm1.Btn_CreateClick(Sender: TObject);

  Begin
    { ProgessForm.Caption := 'Testfortschritt';
      ProgessForm.show;
      for i := 1 to 100 do
      begin
      ProgessForm.SetPercentage(i);
      end;
      ProgessForm.hide;
    }
    Laby.show;
    laby.Laby_width := strtoint(LabeledEdit1.Text);
    laby.Laby_Length := strtoint(LabeledEdit2.text);
    setlength(Laby.fobstacles, 5);
    Laby.fobstacles[0] := PutLogoUR;
    Laby.fobstacles[1] := DoRandomPoints;
    Laby.fobstacles[2] := DoSmallQuadr;
    Laby.fobstacles[3] := DoPicture;
    Laby.fobstacles[4] := DoBigQuadr;

    Laby.CreateLaby;
  End;

Procedure TForm1.Btn_Test1Click(Sender: TObject);
  Var
    path: variant;
    x, y: Integer;
    // i: Integer;
  Begin
    Image1.Canvas.Brush.Color := clDkGray;
    Image1.Canvas.FillRect(Image1.Canvas.cliprect);

    path := vararrayof([2, 1, 12, 4, 4, 4, 6, 5, 2, 11, 12, 10, 10, 12, 2, 6, 4,
      2, 12, 10, 10, 2, 12, 2, 5, 7, 4, 1, 1, 12, 10, 10, 11, 12, 2, 6, 5, 4, 3,
      1, 11, 10, 12, 2, 6, 4, 2, 12, 10, 10, 2, 4, 3, 1, 11, 10, 12, 4, 4, 2,
      10, 10, 12, 2,
      // 12,10,10,2,
      12, 2, 5, 7, 4, 1, 1]);
    x := Image1.Width - 50;
    y := 50;
    PutLogo(x, y, path, putpixel,1);
    PutLogo(x, y+40, path, putpixel,2);
    PutLogo(x, y+80, path, putpixel,3);
  End;

Procedure TForm1.Btn_LoadClick(Sender: TObject);
  Begin
    Laby.show;
    With Laby Do
      Begin
        labimage.visible := true;
        labimage.Width := labimage.Width Or 1;
        labimage.Height := labimage.Height Or 1;
        If Not assigned(labimage.Picture) Then
          Begin
            labimage.Picture := TPicture.create;
            labimage.Picture.bitmap.create;
          End;
        labimage.Picture.bitmap.Height := labimage.Height;
        labimage.Picture.bitmap.Width := labimage.Width;
        labimage.Picture.bitmap.Canvas.FillRect
          (labimage.Picture.bitmap.Canvas.cliprect);
      End;
    If OpenDialog1.Execute Then
      Begin
        Laby.LoadLaby(OpenDialog1.filename);
        if assigned(Laby.eingang) then
          begin
            ActRoom := Laby.eingang;
            FVisx0 := ActRoom.Ort.x;
            FVisy0 := ActRoom.Ort.y;
            DrawLaby(Sender);
          end
        else
          ActRoom := nil;
      End;
    Laby.Hide;
  End;

Procedure TForm1.Button4Click(Sender: TObject);
  Begin
    FraWindRose1.direction := FraWindRose1.direction - 10;
    DrawLaby(Sender);
  End;

Procedure TForm1.Button5Click(Sender: TObject);
  Begin
    FraWindRose1.direction := FraWindRose1.direction + 10;
    DrawLaby(Sender);
  End;

Procedure TForm1.PutLogo(x, y: Integer; path: variant;
  putpixel: TPutObstaclePxl;wfact:integer);
  Var
    dir, dir1, dir2: Shortint;
    I: Tcolor;
    dp: T2dpoint;
    tr: T2DPoint;
  Begin
    dp := T2dpoint.Init(x, y);
    tr := T2dpoint.Init(nil);
    If assigned(putpixel) Then
      Begin
        For I := Vararrayhighbound(path, 1) * wfact - 1 Downto 0 Do
          Begin
            dir1 := path[I Div wfact];
            if wfact>1 then
              dir2 := path[(I + 1) Div wfact]
            else
              dir2 := dir1;
            If abs(dir1 - dir2) <= 6 Then
              dir := (dir1 + dir2) Div 2
            Else
              dir := ((dir1 + dir2) Div 2 + 5) Mod 12 + 1;

            putpixel(dp, true);
            // If dir Mod 3 = 1 Then
            putpixel(tr.Copy(dp).add(dp).subtr(dir12[dir]).SMult(1,2) , true);
            dp.subtr( dir12[dir]);
          End;
        putpixel(dp, true);
      End;
    dp.free;
    tr.free;
  End;

Procedure TForm1.RandomPoints(x, y, size, count: Integer;
  putpixel: TPutObstaclePxl);
  Var
    I: Integer;
    dd, ausl, lx, ly, lz: extended;
    cc: extended;
    ss: extended;
    lyy: extended;
    lzz: extended;
    tr: T2DPoint;

  Begin
    tr:=T2DPoint.init(nil);
    cc := cos(pi / 6);
    ss := sin(pi / 6);
    If assigned(putpixel) Then
      For I := 0 To count Do
        Begin
          dd := 2 * pi * random;
          ausl := random;
          lx := sin(dd) * ausl;
          ly := cos(dd) * ausl;
          lz := sqrt(1 - ausl);
          lyy := ly * cc - lz * ss;
          lzz := lz * cc + ly * ss;
          If lzz >= 0 Then
            putpixel(tr.copy(x + round((lx * cc + lyy * ss) * size),
              y + round((lyy * cc - lx * ss) * size)), true);
        End;
     tr.free;
  End;

Procedure TForm1.RandomQuadr(x, y: Integer; ausl, dx, dy: extended;
  putpixel: TPutObstaclePxl);
  Var
    I, J: Integer;
    dd, jitter: extended;
    tr: T2DPoint;

  Begin
    tr:=T2DPoint.init(nil);
    dd := 2 * pi * random;
    If assigned(putpixel) Then
      For J := round( -ausl / dy) To round(ausl / dy) Do
        Begin
          jitter := random * 0.5;
          For I := round( -ausl / dx) To round(ausl / dx) Do
            Begin
              putpixel(tr.copy(
                x + round(sin(dd) * J * dy + cos(dd) * (I + jitter) * dx),
                y + round(cos(dd) * J * dy - sin(dd) * (I + jitter) * dx))
                , true);
            End;
        End;
    tr.free;
  End;

Procedure TForm1.PutImage(x, y: Integer; filename: String; size: Integer;
  putpixel: TPutObstaclePxl);
    Function min(a1, a2: Integer): Integer; Inline;
      Begin
        If a1 < a2 Then
          result := a1
        Else
          result := a2;
      End;

  Type
    TRGBTripleArray = ARRAY [Word] Of TRGBTriple;
    pRGBTripleArray = ^TRGBTripleArray; // Use a PByteArray for pf8bit color.
  Var
    Lbitmap: Tbitmap;
    LPicture: TPicture;
    LmaxSize, I, f: Integer;
    LP: pRGBTripleArray;
    fv: Array Of Integer;
    tr:T2DPoint;
    J: Integer;
    C, mn, mx, avg, ff: Integer;

  Begin
    If FileExists(filename) { *Converted from FileExists* } Then
      Begin
        tr:=T2DPoint.init(nil);
        LPicture := TPicture.create;
        LPicture.LoadFromFile(filename);
        If LPicture.Height > LPicture.Width Then
          LmaxSize := LPicture.Height
        Else
          LmaxSize := LPicture.Width;

        Lbitmap := Tbitmap.create;
        Lbitmap.SetSize(trunc(LPicture.Width * size Div (LmaxSize * 3)),
          trunc(LPicture.Height * size Div (LmaxSize * 3)));
        Lbitmap.PixelFormat := pf24bit;
        Lbitmap.Canvas.StretchDraw(Lbitmap.Canvas.cliprect, LPicture.Graphic);
        setlength(fv, Lbitmap.Width);
        For J := 0 To Lbitmap.Width - 1 Do
          fv[J] := 0;
        mx := 0;
        mn := 255;
        avg := 0;
        For I := 0 To Lbitmap.Height - 1 Do
          Begin
            LP := Lbitmap.ScanLine[I];
            For J := 0 To Lbitmap.Width - 1 Do
              Begin
                C := (LP[J].rgbtRed + LP[J].rgbtGreen + LP[J].rgbtBlue) Div 3;
                avg := avg + C;
                If C > mx Then
                  mx := C;
                If C < mn Then
                  mn := C;

              End;
          End;
        avg := avg Div (Lbitmap.Height * Lbitmap.Width);
        For I := 0 To Lbitmap.Height - 1 Do
          Begin
            LP := Lbitmap.ScanLine[I];
            f := 0;
            For J := 0 To Lbitmap.Width - 1 Do
              Begin

                ff := min(min(min(I, Lbitmap.Height - 1 - I),
                  min(J, Lbitmap.Width - 1 - J)), 10);

                C := (((LP[J].rgbtRed + LP[J].rgbtGreen + LP[J].rgbtBlue) {%H-}* ff)
                  Div 10 + (f * 3 + fv[J] * 3) Div 2) Div 3;

                If C > avg Then
                  Begin
                    f := -mx + C;
                    //C := 255;
                    putpixel(tr.copy(
                      x + size - Lbitmap.Width * 3 + J * 3,
                      y + I * 3),
                      true);
                  End
                Else
                  Begin
                    f := -mn + C;
                    //C := 0;
                  End;
                fv[J] := f;

              End;

          End;

        LPicture.free;
        Lbitmap.free;
        tr.free;
      End;
  End;

Procedure TForm1.PutLogoUR(putpixel: TPutObstaclePxl);
  Var
    path: variant;
  ww: Integer;
  Begin

    path := vararrayof([2, 1, 12, 4, 4, 4, 6, 5, 2, 11, 12, 10, 10, 12, 2, 6, 4,
      2, 12, 10, 10, 2, 12, 2, 5, 7, 4, 1, 1, 12, 10, 10, 11, 12, 2, 6, 5, 4, 3,
      1, 11, 10, 12, 2, 6, 4, 2, 12, 10, 10, 2, 4, 3, 1, 11, 10, 12, 4, 4, 2,
      10, 10, 12, 2,
      // 12,10,10,2,
      12, 2, 5, 7, 4, 1, 1]);

    if Laby.Laby_Width < 300 then
       ww:= 1
    else if Laby.Laby_Width < 500 then
       ww:= 2
    else
       ww := 3 ;
    PutLogo(Laby.Laby_Width - 10, Laby.Laby_Length - 10, path, putpixel,ww);
  End;

Procedure TForm1.putpixel(dp:T2dpoint; value: Boolean);
  Begin
    If value Then
      with dp do
       Image1.Canvas.Pixels[x, y] := clWhite;
  End;

Procedure TForm1.DoRandomPoints(putpixel: TPutObstaclePxl);

  Var
    count, size: Integer;
  Begin
    count := round(Laby.Laby_Width * Laby.Laby_Length * 0.005) - 1;
    size := round(GoldCut * GoldCut * GoldCut * Laby.Laby_Length);
    RandomPoints(round(GoldCut * Laby.Laby_Width),
      round(GoldCut * GoldCut * Laby.Laby_Length), size, count, putpixel);
  End;

Procedure TForm1.DoBigQuadr(putpixel: TPutObstaclePxl);

  Begin

    RandomQuadr(round(GoldCut * GoldCut * Laby.Laby_Width),
      round(GoldCut * Laby.Laby_Length), GoldCut * GoldCut * Laby.Laby_Length,
      4.5, 4.5, putpixel);

  End;

Procedure TForm1.DoPicture(putpixel: TPutObstaclePxl);
  Begin
    PutImage(((Laby.Laby_Width * 4) Div 5) - 20, 20, FPictFilename,
      Laby.Laby_Width Div 5, putpixel);
  End;

Procedure TForm1.DoSmallQuadr(putpixel: TPutObstaclePxl);

  Begin
    RandomQuadr(round(GoldCut * GoldCut * Laby.Laby_Width),
      round(GoldCut * GoldCut * Laby.Laby_Length), GoldCut * GoldCut * GoldCut *
      GoldCut * Laby.Laby_Length, 2, 2, putpixel);

  End;

Procedure TForm1.Btn_GoFwdClick(Sender: TObject);
  Var
    LDir: Integer;
  Begin
    If assigned(ActRoom) Then
      Begin
        LDir := (FraWindRose1.direction + 375) Div 30 Mod 12 + 1;
        If assigned(ActRoom.gang[LDir]) Then
          ActRoom := ActRoom.gang[LDir];

      End;
    DrawLaby(Sender);
  End;

Procedure TForm1.Btn_BackClick(Sender: TObject);
  Var
    LDir: Integer;
  Begin
    If assigned(ActRoom) Then
      Begin
        LDir := ActRoom.EDir;
        If assigned(ActRoom.gang[LDir]) Then
          ActRoom := ActRoom.gang[LDir];
      End;
    DrawLaby(Sender);

  End;

Procedure TForm1.Btn_Test2Click(Sender: TObject);
  Begin
    Image1.Canvas.Brush.Color := Color;
    Image1.Canvas.FillRect(Image1.Canvas.cliprect);

    RandomPoints(Image1.Width Div 2, Image1.Height Div 2, Image1.Width Div 2,
      10000, putpixel);
  End;

Procedure TForm1.Btn_Test3Click(Sender: TObject);
  Begin
    Image1.Canvas.Brush.Color := clDkGray;
    Image1.Canvas.FillRect(Image1.Canvas.cliprect);

    RandomQuadr(Image1.Width Div 2, Image1.Height Div 2, Image1.Height Div 3, 2,
      2, putpixel);
  End;

Procedure TForm1.CheckBox2Click(Sender: TObject);
  Begin
    If CheckBox2.Checked Then
      Timer1.Interval := 25
    Else
      Timer1.Interval := 100;

  End;

Procedure TForm1.Image1Click(Sender: TObject);

  Var
    I, J, imax: Integer;
    hp: T2dpoint;

  Begin

    // hp.init(0,0);
    For I := 30 To 80 Do
      Begin
        imax := round(I * 2 * pi);
        For J := 1 To imax Do
          Begin
            hp := Unt_point2d.getdir(I, J);
            Image1.Canvas.Pixels[hp.x + 40, hp.y + 40] :=
              rgb(I * 3, I * 2 {%H-}+ round(J / imax * 90), round(J / imax * 250));
            Image1.Canvas.Pixels[J, hp.x + 120] :=
              rgb(I * 3, I * 2 {%H-}+ round(J / imax * 90), round(J / imax * 250));
            Image1.Canvas.Pixels[J, hp.y + 200] :=
              rgb(I * 3, I * 2 {%H-}+ round(J / imax * 90), round(J / imax * 250));
            hp.free;

          End;
        Image1.Update;
      End;
  End;

Procedure TForm1.Timer1Timer(Sender: TObject);
  Var
    LDir: Integer;
    I: Integer;
  Begin
    If CheckBox1.Checked Then
      If assigned(ActRoom) Then
        Begin
          LDir := FLdir; // random(12) + 1;
          Begin
            For I := LDir To LDir + high(dir12) -1 Do
              If assigned(ActRoom.gang[I Mod high(dir12) + 1]) And
                (FLdir <> I Mod high(dir12) + 1) Then
                LDir := I Mod high(dir12) + 1;
            If Not assigned(ActRoom.gang[LDir]) Then
              LDir := ActRoom.EDir;
          End;

          If assigned(ActRoom.gang[LDir]) Then
            Begin
              ActRoom := ActRoom.gang[LDir];
              FLdir := getinvdir(LDir,22);
              // FraWindRose1.Direction2 := (FLdir + 5) * 30;
              For I := 1 To 10 Do

                If ((FLdir + 5) * 30 - FraWindRose1.direction2 + 360)
                  Mod 180 > 90 Then
                  FraWindRose1.direction2 :=
                    (FraWindRose1.direction2 + 359) Mod 360
                Else
                  FraWindRose1.direction2 :=
                    (FraWindRose1.direction2 + 1) Mod 360;

              If (FraWindRose1.direction2 - FraWindRose1.direction + 360)
                Mod 180 > 90 Then
                FraWindRose1.direction := (FraWindRose1.direction + 359) Mod 360
              Else
                FraWindRose1.direction := (FraWindRose1.direction + 1) Mod 360

            End;

          DrawLaby(Sender);
        End;

  End;

Procedure TForm1.DrawLaby(Sender: TObject);

    Procedure VTransform(xx0, yy0, s, C: extended; Out rx0: Integer;
      Out ry0: Integer); Inline;

      Var
        ly: extended;
        lz: extended;

      Const
        ZFAkt = 900;
        ZFaktinv = 1 / ZFAkt;
        yFakt = 0.5;

      Begin
        ly := (yy0 * C - s * xx0);
        lz := (ZFAkt + ly) * ZFaktinv;
        rx0 := trunc((xx0 * C + s * yy0) * lz);
        ry0 := trunc(ly * yFakt * lz);
      End;

  Var
    lx: Integer;
    ly: Integer;
    LBreaks: Integer;
    s, C: extended;
    LMAxLEvel: Integer;

  Const
    df = 6;

    Procedure DrawSubPath(Level: Integer; iDir: Integer; Lroom: TLbyRoom;
      x0, y0: Integer);

      Var
        I: Integer;
        xx0, xx1, yy0, yy1: extended;
        rx0, rx1, ry0, ry1: Integer;
      Begin
        For I := 1 To high(dir12) Do
          If assigned(Lroom.gang[I]) And
            ((I <> getinvdir(iDir,22)) Or (iDir = -1)) Then
            Begin
              If Level > LMAxLEvel - 15 Then
                Image1.Canvas.pen.Width := (Level - LMAxLEvel + 20) Div 3
              Else
                Image1.Canvas.pen.Width := 2;
              If iDir = -1 Then

                Begin
                  Image1.Canvas.pen.Color := clLime;
                End
              Else If Lroom.gang[I].token = 'R' Then
                Begin
                  Image1.Canvas.pen.Color := clBlue;
                End
              Else If Lroom.gang[I].token = 'E' Then
                Begin
                  Image1.Canvas.pen.Color := clRed;

                End
              Else
                Image1.Canvas.pen.Color := clblack;
              xx0 := +(Lroom.Ort.y - y0) * df;
              yy0 := -(Lroom.Ort.x - x0) * df;
              xx1 := +(Lroom.gang[I].Ort.y - y0) * df;
              yy1 := -(Lroom.gang[I].Ort.x - x0) * df;
              VTransform(xx0, yy0, s, C, rx0, ry0);
              VTransform(xx1, yy1, s, C, rx1, ry1);

              Image1.Canvas.moveto(lx + rx0, ly + ry0);
              Image1.Canvas.lineto(lx + rx1, ly + ry1);

              If (Level > 0) Then
                DrawSubPath(Level - 1, I, Lroom.gang[I], x0, y0)
              Else
                inc(LBreaks);
              If Color <> clblack Then
                Image2.Canvas.Pixels
                  [trunc(Lroom.gang[I].Ort.x / Laby.Laby_Width *
                  (Image2.Width - 2)) + 1,
                  trunc(Lroom.gang[I].Ort.y / Laby.Laby_Length *
                  (Image2.Height - 2)) + 1] := Image1.Canvas.pen.Color;

            End;
      End;

    Procedure DrawMap(Level: Integer; x0, y0: Integer);

      Var
        LAoRooms: TArrayOfRooms;
        I, J: Integer;
        xx0, xx1, yy0, yy1: extended;
        ix, iy, rx0, rx1, ry0, ry1, dist: Integer;
        Color, Color2: Tcolor;
        Dp: T2DPoint;
   
      Function sgn(i: integer): integer; Inline;
        Begin
          If i > 0 Then
            result := 1
          Else If i < 0 Then
            result := -1
          Else
            result := 0;
        End;

      Begin
        Dp:= T2DPoint.init(nil);
        For ix := (x0 - Level) Div 4 To (x0 + Level) Div 4 Do
          For iy := (y0 - Level) Div 4 To (y0 + Level) Div 4 Do
            Begin
              LAoRooms := Laby.RoomIndex[dp.Copy(ix * 4, iy * 4)];

              For J := 0 To High(LAoRooms) Do
                begin
                dp.Copy(LAoRooms[J].ort);
                      dist := trunc(sqrt(
                        sqr(dp.x - x0) +
                        sqr(dp.y - y0) 
                        ));


                      Image1.Canvas.pen.Width := 1;
                      If LAoRooms[J].token = 'R' Then
                        Begin
                          Color := clBlue;
                          Color2 := rgb(128, 128, 255);

                        End
                      Else If LAoRooms[J].token = 'E' Then
                        Begin
                          Color := clRed;
                          Color2 := rgb(255, 128, 128);

                        End
                      Else
                        Begin
                          Color := clblack;
                          Color2 := rgb(128, 128, 128);
                        End;

                if dist <Level then
                  Image2.Canvas.Pixels
                            [trunc(dp.x  / Laby.Laby_Width *
                            (Image2.Width - 2)) + 1,
                            trunc(dp.y  / Laby.Laby_Length *
                            (Image2.Height - 2)) + 1] := Color2
                      Else
                        Image2.Canvas.Pixels
                          [trunc(dp.x  / Laby.Laby_Width *
                          (Image2.Width - 2)) + 1,
                          trunc(dp.y  / Laby.Laby_Length *
                          (Image2.Height - 2)) + 1] := clWhite;

                if dist <Level-1 then
                  For I := 1 To high(dir12) Do
                  If assigned(LAoRooms[J].gang[I]) Then
                    Begin
                      dp.Copy(LAoRooms[J].ort).add(LAoRooms[J].gang[I].Ort);
                      dist := trunc(sqrt(
                        sqr(dp.x div 2 - x0) +
                        sqr(dp.y div 2 - y0)
                        ));

                      if dist <Level then
                           Image2.Canvas.Pixels
                            [trunc(dp.x div 2 / Laby.Laby_Width *
                            (Image2.Width - 2)) + 1,
                            trunc(dp.y div 2 / Laby.Laby_Length *
                            (Image2.Height - 2)) + 1] := Color2
                      Else
                        Image2.Canvas.Pixels
                          [trunc(dp.x div 2 / Laby.Laby_Width *
                          (Image2.Width - 2)) + 1,
                          trunc(dp.y div 2 / Laby.Laby_Length *
                          (Image2.Height - 2)) + 1] := clWhite;


                      xx0 := +(LAoRooms[J].Ort.y - y0) * df;
                      yy0 := -(LAoRooms[J].Ort.x - x0) * df;
                      xx1 := +(dp.y*0.5 - y0) * df;
                      yy1 := -(dp.x*0.5 - x0) * df;

                      VTransform(xx0, yy0, s, C, rx0, ry0);
                      VTransform(xx1, yy1, s, C, rx1, ry1);

                      If dist < Level Then
                        Begin
                          Image1.Canvas.pen.Width := 3;
                          Image1.Canvas.pen.Color := clwhite;
                          Image1.Canvas.moveto(lx + rx0+sgn(rx1-rx0), ly + ry0+sgn(ry1-ry0));
                          Image1.Canvas.lineto(lx + rx1, ly + ry1);
                          Image1.Canvas.pen.Width := 3;
                          Image1.Canvas.pen.Color := Color;
                          Image1.Canvas.moveto(lx + rx0, ly + ry0);
                          Image1.Canvas.lineto(lx + rx1+sgn(rx1-rx0), ly + ry1+sgn(ry1-ry0));
                        End
                    End;
                End;
            End;
        dp.free;
      End;

  Var
    // i: Integer;
    lx0: Integer;
    ly0: Integer;
    // ax, ay: extended;

  Begin
    lx := Image1.Width Div 2;
    ly := Image1.Height Div 2;
    s := sin(FraWindRose1.direction * pi / 180);
    C := cos(FraWindRose1.direction * pi / 180);
    Image1.Canvas.Brush.Color := Color;
    Image1.Canvas.FillRect(Image1.Canvas.cliprect);
    If assigned(ActRoom) Then
      Begin
        lx0 := ActRoom.Ort.x;
        ly0 := ActRoom.Ort.y;
        If abs(lx0 - FVisx0) > 50 Then

          FVisx0 := FVisx0 + (lx0 - FVisx0) Div 2
        Else If abs(lx0 - FVisx0) > 25 Then
          FVisx0 := FVisx0 + (lx0 - FVisx0) Div 4
        Else If abs(lx0 - FVisx0) > 10 Then
          FVisx0 := FVisx0 + (lx0 - FVisx0) Div 8;

        If abs(ly0 - FVisy0) > 50 Then
          FVisy0 := FVisy0 + (ly0 - FVisy0) Div 2
        Else If abs(ly0 - FVisy0) > 25 Then
          FVisy0 := FVisy0 + (ly0 - FVisy0) Div 4
        Else If abs(ly0 - FVisy0) > 10 Then
          FVisy0 := FVisy0 + (ly0 - FVisy0) Div 8;

        DrawMap(50, FVisx0, FVisy0);

        LBreaks := 0;

        LMAxLEvel := 20;
        DrawSubPath(LMAxLEvel, -1, ActRoom, FVisx0, FVisy0);

        Label1.Caption := Inttostr(LBreaks);
      End;
  End;

End.
