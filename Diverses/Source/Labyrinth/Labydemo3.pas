unit Labydemo3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
    pngimage, jpeg, Windows,  {UITypes,(?)}
{$ELSE}
  LCLIntf, LCLType, JPEGLib, FileUtil,
{$ENDIF}
    SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
    LabyU3, Fra_WindRose, ExtDlgs, ActnList, StdActns, Menus, Buttons,
    unt_Point2d;

type

    { TForm1 }

    TForm1 = class(TForm)
        actCreateLaby: TAction;
        actFileSave: TAction;
        ActionList1: TActionList;
        BitBtn1: TBitBtn;
        btnRotLeft: TButton;
        btnRotRight: TButton;
        Btn_Back: TButton;
        Btn_GoFwd: TButton;
        chbAuto: TCheckBox;
        chbFast: TCheckBox;
        actFileExit1: TFileExit;
        actFileOpen1: TFileOpen;
        actFileSaveAs1: TFileSaveAs;
        FraWindRose1: TFraWindRose;
        ImgDisplay: TImage;
        Btn_Create: TButton;
        Btn_Test1: TButton;
        Btn_Load: TButton;
        MainMenu1: TMainMenu;
        MenuItem1: TMenuItem;
        MenuItem2: TMenuItem;
        MenuItem3: TMenuItem;
        MenuItem4: TMenuItem;
        MenuItem5: TMenuItem;
        MenuItem6: TMenuItem;
        MenuItem7: TMenuItem;
        MenuItem8: TMenuItem;
        N1: TMenuItem;
        pnlRightTop: TPanel;
        pnlRight: TPanel;
        Panel3: TPanel;
        Timer1: TTimer;
        OpenDialog1: TOpenDialog;
        Label1: TLabel;
        imgPreview: TPaintBox;
        Btn_Test2: TButton;
        Btn_Test3: TButton;
        Btn_Test4: TButton;
        OpenPictureDialog1: TOpenPictureDialog;
        LabeledEdit1: TLabeledEdit;
        LabeledEdit2: TLabeledEdit;
        procedure actFileOpen1BeforeExecute(Sender: TObject);
        procedure actFileOpen1Cancel(Sender: TObject);
        procedure BitBtn1Click(Sender: TObject);
        procedure Btn_Test1Click(Sender: TObject);
        procedure actCreateExecute(Sender: TObject);
        procedure FraWindRose1Resize(Sender: TObject);
        procedure ImgDisplayClick(Sender: TObject);
        procedure Btn_LoadClick(Sender: TObject);
        procedure btnRotRightClick(Sender: TObject);
        procedure btnRotLeftClick(Sender: TObject);
        procedure Btn_GoFwdClick(Sender: TObject);
        procedure Btn_BackClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure chbFastClick(Sender: TObject);
        procedure Btn_Test2Click(Sender: TObject);
        procedure Btn_Test3Click(Sender: TObject);
        procedure Btn_Test4Click(Sender: TObject);
    private
        ActRoom: TLbyRoom;
        FDirection: integer;
        FDirection2: integer;
        // FForeward: Boolean;
        FLdir: integer;
        FVisx0: integer;
        FVisy0: integer;
        FPictFilename: TFileName;
        { Private-Deklarationen }
    private
        procedure DrawLaby(Sender: TObject);
        procedure PutLogo(x, y: integer; path: variant;
            putpixel: TPutObstaclePxl; wfact: integer);
        procedure RandomPoints(x, y, size, Count: integer; putpixel: TPutObstaclePxl);
        procedure RandomQuadr(x, y: integer; ausl, dx, dy: extended;
            putpixel: TPutObstaclePxl);
        procedure PutImage(x, y: integer; filename: string; size: integer;
            putpixel: TPutObstaclePxl);
        { Public-Deklarationen }
    public
        procedure PutLogoUR(putpixel: TPutObstaclePxl);
        procedure DoRandomPoints(putpixel: TPutObstaclePxl);
        procedure DoBigQuadr(putpixel: TPutObstaclePxl);
        procedure DoSmallQuadr(putpixel: TPutObstaclePxl);
        procedure putpixel(dp: T2dpoint; Value: boolean);
        procedure DoPicture(putpixel: TPutObstaclePxl);
    end;

var
    Form1: TForm1;

implementation

uses ProgressBarU, variants;

{$IFnDEF FPC}
  {$R *.dfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
    GoldCut = 0.61803398874989484820458683436564;

procedure TForm1.Btn_Test4Click(Sender: TObject);

begin
    if OpenPictureDialog1.Execute then
      begin
        ImgDisplay.Canvas.Brush.Color := clDkGray;
        ImgDisplay.Canvas.FillRect(ImgDisplay.Canvas.cliprect);

        FPictFilename := OpenPictureDialog1.filename;

        PutImage(0, 0, FPictFilename, 500, putpixel);
        // PutImage(0, 200, FPictFilename, 330, putpixel);
        // ImgDisplay.{Picture.bitmap.}Canvas, ImgDisplay.{Picture.bitmap.}Canvas.cliprect);
      end;
end;

procedure TForm1.actCreateExecute(Sender: TObject);

begin
    { ProgessForm.Caption := 'Testfortschritt';
      ProgessForm.show;
      for i := 1 to 100 do
      begin
      ProgessForm.SetPercentage(i);
      end;
      ProgessForm.hide;
    }
    Laby.Show;
    laby.Laby_width := StrToInt(LabeledEdit1.Text);
    laby.Laby_Length := StrToInt(LabeledEdit2.Text);
    setlength(Laby.fobstacles, 5);
    Laby.fobstacles[0] := PutLogoUR;
    Laby.fobstacles[1] := DoRandomPoints;
    Laby.fobstacles[2] := DoSmallQuadr;
    Laby.fobstacles[3] := DoPicture;
    Laby.fobstacles[4] := DoBigQuadr;

    Laby.CreateLaby;
end;

procedure TForm1.FraWindRose1Resize(Sender: TObject);
begin

end;

procedure TForm1.Btn_Test1Click(Sender: TObject);
var
    path: variant;
    x, y: integer;
    // i: Integer;
begin
    ImgDisplay.Canvas.Brush.Color := clDkGray;
    ImgDisplay.Canvas.FillRect(ImgDisplay.Canvas.cliprect);

    path := vararrayof([2, 1, 12, 4, 4, 4, 6, 5, 2, 11, 12, 10, 10,
        12, 2, 6, 4, 2, 12, 10, 10, 2, 12, 2, 5, 7, 4, 1, 1, 12, 10,
        10, 11, 12, 2, 6, 5, 4, 3, 1, 11, 10, 12, 2, 6, 4, 2, 12, 10,
        10, 2, 4, 3, 1, 11, 10, 12, 4, 4, 2, 10, 10, 12, 2,
        // 12,10,10,2,
        12, 2, 5, 7, 4, 1, 1]);
    x := ImgDisplay.Width - 50;
    y := 50;
    PutLogo(x, y, path, putpixel, 1);
    PutLogo(x, y + 40, path, putpixel, 2);
    PutLogo(x, y + 80, path, putpixel, 3);
end;

procedure TForm1.actFileOpen1BeforeExecute(Sender: TObject);
begin
    Laby.Show;
    with Laby do
      begin
        labimage.Visible := True;
        labimage.Width := labimage.Width or 1;
        labimage.Height := labimage.Height or 1;
        if not assigned(labimage.Picture) then
          begin
            labimage.Picture := TPicture.Create;
            labimage.Picture.bitmap.Create;
          end;
        labimage.Picture.bitmap.Height := labimage.Height;
        labimage.Picture.bitmap.Width := labimage.Width;
        labimage.Picture.bitmap.Canvas.FillRect
        (labimage.Picture.bitmap.Canvas.cliprect);
      end;
end;

procedure TForm1.actFileOpen1Cancel(Sender: TObject);
begin
    Laby.Hide;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  laby.Show;
end;

procedure TForm1.Btn_LoadClick(Sender: TObject);
begin
    Laby.LoadLaby(actFileOpen1.Dialog.filename);
    if assigned(Laby.eingang) then
      begin
        ActRoom := Laby.eingang;
        FVisx0 := ActRoom.Ort.x;
        FVisy0 := ActRoom.Ort.y;
        DrawLaby(Sender);
      end
    else
        ActRoom := nil;
    Laby.Hide;
end;

procedure TForm1.btnRotLeftClick(Sender: TObject);
begin
    FDirection := (FDirection + 350) mod 360;
    FraWindRose1.direction := FDirection;
    DrawLaby(Sender);
end;

procedure TForm1.btnRotRightClick(Sender: TObject);
begin
    FDirection := (FDirection + 10) mod 360;
    FraWindRose1.direction := FDirection;
    DrawLaby(Sender);
end;

procedure TForm1.PutLogo(x, y: integer; path: variant;
    putpixel: TPutObstaclePxl; wfact: integer);
var
    dir, dir1, dir2: shortint;
    I: Tcolor;
    dp: T2dpoint;
    tr: T2DPoint;
begin
    dp := T2dpoint.Init(x, y);
    tr := T2dpoint.Init(nil);
    if assigned(putpixel) then
      begin
        for I := Vararrayhighbound(path, 1) * wfact - 1 downto 0 do
          begin
            dir1 := path[I div wfact];
            if wfact > 1 then
                dir2 := path[(I + 1) div wfact]
            else
                dir2 := dir1;
            if abs(dir1 - dir2) <= 6 then
                dir := (dir1 + dir2) div 2
            else
                dir := ((dir1 + dir2) div 2 + 5) mod 12 + 1;

            putpixel(dp, True);
            // If dir Mod 3 = 1 Then
            putpixel(tr.Copy(dp).add(dp).subtr(dir12[dir]).SMult(1, 2), True);
            dp.subtr(dir12[dir]);
          end;
        putpixel(dp, True);
      end;
    dp.Free;
    tr.Free;
end;

procedure TForm1.RandomPoints(x, y, size, Count: integer; putpixel: TPutObstaclePxl);
var
    I: integer;
    dd, ausl, lx, ly, lz: extended;
    cc: extended;
    ss: extended;
    lyy: extended;
    lzz: extended;
    tr: T2DPoint;

begin
    tr := T2DPoint.init(nil);
    cc := cos(pi / 6);
    ss := sin(pi / 6);
    if assigned(putpixel) then
        for I := 0 to Count do
          begin
            dd := 2 * pi * random;
            ausl := random;
            lx := sin(dd) * ausl;
            ly := cos(dd) * ausl;
            lz := sqrt(1 - ausl);
            lyy := ly * cc - lz * ss;
            lzz := lz * cc + ly * ss;
            if lzz >= 0 then
                putpixel(tr.copy(x + round((lx * cc + lyy * ss) * size),
                    y + round((lyy * cc - lx * ss) * size)), True);
          end;
    tr.Free;
end;

procedure TForm1.RandomQuadr(x, y: integer; ausl, dx, dy: extended;
    putpixel: TPutObstaclePxl);
var
    I, J: integer;
    dd, jitter: extended;
    tr: T2DPoint;

begin
    tr := T2DPoint.init(nil);
    dd := 2 * pi * random;
    if assigned(putpixel) then
        for J := round(-ausl / dy) to round(ausl / dy) do
          begin
            jitter := random * 0.5;
            for I := round(-ausl / dx) to round(ausl / dx) do
              begin
                putpixel(tr.copy(x + round(sin(dd) *
                    J * dy + cos(dd) * (I + jitter) * dx), y +
                    round(cos(dd) * J * dy - sin(dd) * (I + jitter) * dx))
                    , True);
              end;
          end;
    tr.Free;
end;

procedure TForm1.PutImage(x, y: integer; filename: string; size: integer;
    putpixel: TPutObstaclePxl);

    function min(a1, a2: integer): integer; inline;
    begin
        if a1 < a2 then
            Result := a1
        else
            Result := a2;
    end;

type
    TRGBTripleArray = array [word] of TRGBTriple;
    pRGBTripleArray = ^TRGBTripleArray; // Use a PByteArray for pf8bit color.
var
    Lbitmap: Tbitmap;
    LPicture: TPicture;
    LmaxSize, I, f: integer;
    LP: pRGBTripleArray;
    fv: array of integer;
    tr: T2DPoint;
    J: integer;
    C, mn, mx, avg, ff: integer;

begin
    if FileExists(filename) then
      begin
        tr := T2DPoint.init(nil);
        LPicture := TPicture.Create;
        LPicture.LoadFromFile(filename);
        if LPicture.Height > LPicture.Width then
            LmaxSize := LPicture.Height
        else
            LmaxSize := LPicture.Width;

        Lbitmap := Tbitmap.Create;
        Lbitmap.SetSize(trunc(LPicture.Width * size div (LmaxSize * 3)),
            trunc(LPicture.Height * size div (LmaxSize * 3)));
        Lbitmap.PixelFormat := pf24bit;
        Lbitmap.Canvas.StretchDraw(Lbitmap.Canvas.cliprect, LPicture.Graphic);
        setlength(fv, Lbitmap.Width);
        for J := 0 to Lbitmap.Width - 1 do
            fv[J] := 0;
        mx := 0;
        mn := 255;
        avg := 0;
        for I := 0 to Lbitmap.Height - 1 do
          begin
            LP := Lbitmap.ScanLine[I];
            for J := 0 to Lbitmap.Width - 1 do
              begin
                C := (LP[J].rgbtRed + LP[J].rgbtGreen + LP[J].rgbtBlue) div 3;
                avg := avg + C;
                if C > mx then
                    mx := C;
                if C < mn then
                    mn := C;
              end;
          end;
        avg := avg div (Lbitmap.Height * Lbitmap.Width);
        for I := 0 to Lbitmap.Height - 1 do
          begin
            LP := Lbitmap.ScanLine[I];
            f := 0;
            for J := 0 to Lbitmap.Width - 1 do
              begin

                ff := min(min(min(I, Lbitmap.Height - 1 - I),
                    min(J, Lbitmap.Width - 1 - J)), 10);

                C := (((LP[J].rgbtRed + LP[J].rgbtGreen + LP[J].rgbtBlue) {%H-} *
                    ff) div 10 + (f * 3 + fv[J] * 3) div 2) div 3;

                if C > avg then
                  begin
                    f := -mx + C;
                    //C := 255;
                    putpixel(tr.copy(x + size -
                        Lbitmap.Width * 3 + J * 3, y + I * 3),
                        True);
                  end
                else
                  begin
                    f := -mn + C;
                    //C := 0;
                  end;
                fv[J] := f;

              end;

          end;

        LPicture.Free;
        Lbitmap.Free;
        tr.Free;
      end;
end;

procedure TForm1.PutLogoUR(putpixel: TPutObstaclePxl);
var
    path: variant;
    ww: integer;
begin

    path := vararrayof([2, 1, 12, 4, 4, 4, 6, 5, 2, 11, 12, 10, 10,
        12, 2, 6, 4, 2, 12, 10, 10, 2, 12, 2, 5, 7, 4, 1, 1, 12, 10,
        10, 11, 12, 2, 6, 5, 4, 3, 1, 11, 10, 12, 2, 6, 4, 2, 12, 10,
        10, 2, 4, 3, 1, 11, 10, 12, 4, 4, 2, 10, 10, 12, 2,
        // 12,10,10,2,
        12, 2, 5, 7, 4, 1, 1]);

    if Laby.Laby_Width < 300 then
        ww := 1
    else if Laby.Laby_Width < 500 then
        ww := 2
    else
        ww := 3;
    PutLogo(Laby.Laby_Width - 10, Laby.Laby_Length - 10, path, putpixel, ww);
end;

procedure TForm1.putpixel(dp: T2dpoint; Value: boolean);
begin
    if Value then
        with dp do
            ImgDisplay.Canvas.Pixels[x, y] := clWhite;
end;

procedure TForm1.DoRandomPoints(putpixel: TPutObstaclePxl);

var
    Count, size: integer;
begin
    Count := round(Laby.Laby_Width * Laby.Laby_Length * 0.005) - 1;
    size := round(GoldCut * GoldCut * GoldCut * Laby.Laby_Length);
    RandomPoints(round(GoldCut * Laby.Laby_Width),
        round(GoldCut * GoldCut * Laby.Laby_Length), size, Count, putpixel);
end;

procedure TForm1.DoBigQuadr(putpixel: TPutObstaclePxl);

begin

    RandomQuadr(round(GoldCut * GoldCut * Laby.Laby_Width),
        round(GoldCut * Laby.Laby_Length), GoldCut * GoldCut * Laby.Laby_Length,
        4.5, 4.5, putpixel);

end;

procedure TForm1.DoPicture(putpixel: TPutObstaclePxl);
begin
    PutImage(((Laby.Laby_Width * 4) div 5) - 20, 20, FPictFilename,
        Laby.Laby_Width div 5, putpixel);
end;

procedure TForm1.DoSmallQuadr(putpixel: TPutObstaclePxl);

begin
    RandomQuadr(round(GoldCut * GoldCut * Laby.Laby_Width),
        round(GoldCut * GoldCut * Laby.Laby_Length), GoldCut * GoldCut *
        GoldCut * GoldCut * Laby.Laby_Length, 2, 2, putpixel);

end;

procedure TForm1.Btn_GoFwdClick(Sender: TObject);
var
    LDir: integer;
begin
    if assigned(ActRoom) then
      begin
        LDir := (FDirection + 375) div 30 mod 12 + 1;
        if assigned(ActRoom.gang[LDir]) then
            ActRoom := ActRoom.gang[LDir];

      end;
    DrawLaby(Sender);
end;

procedure TForm1.Btn_BackClick(Sender: TObject);
var
    LDir: integer;
begin
    if assigned(ActRoom) then
      begin
        LDir := ActRoom.EDir;
        if assigned(ActRoom.gang[LDir]) then
            ActRoom := ActRoom.gang[LDir];
      end;
    DrawLaby(Sender);

end;

procedure TForm1.Btn_Test2Click(Sender: TObject);
begin
    ImgDisplay.Canvas.Brush.Color := Color;
    ImgDisplay.Canvas.FillRect(ImgDisplay.Canvas.cliprect);

    RandomPoints(ImgDisplay.Width div 2, ImgDisplay.Height div 2, ImgDisplay.Width div 2,
        10000, putpixel);
end;

procedure TForm1.Btn_Test3Click(Sender: TObject);
begin
    ImgDisplay.Canvas.Brush.Color := clDkGray;
    ImgDisplay.Canvas.FillRect(ImgDisplay.Canvas.cliprect);

    RandomQuadr(ImgDisplay.Width div 2, ImgDisplay.Height div 2,
        ImgDisplay.Height div 3, 2,
        2, putpixel);
end;

procedure TForm1.chbFastClick(Sender: TObject);
begin
    if chbFast.Checked then
        Timer1.Interval := 25
    else
        Timer1.Interval := 100;

end;

procedure TForm1.ImgDisplayClick(Sender: TObject);

var
    I, J, imax: integer;
    hp: T2dpoint;

begin

    // hp.init(0,0);
    for I := 30 to 80 do
      begin
        imax := round(I * 2 * pi);
        for J := 1 to imax do
          begin
            hp := Unt_point2d.getdir(I, J);
            ImgDisplay.Canvas.Pixels[hp.x + 40, hp.y + 40] :=
                rgb(I * 3, I * 2 {%H-} + round(J / imax * 90), round(J / imax * 250));
            ImgDisplay.Canvas.Pixels[J, hp.x + 120] :=
                rgb(I * 3, I * 2 {%H-} + round(J / imax * 90), round(J / imax * 250));
            ImgDisplay.Canvas.Pixels[J, hp.y + 200] :=
                rgb(I * 3, I * 2 {%H-} + round(J / imax * 90), round(J / imax * 250));
            hp.Free;

          end;
        ImgDisplay.Update;
      end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
    LDir: integer;
    I: integer;
begin
    if chbAuto.Checked then
        if assigned(ActRoom) then
          begin
            LDir := FLdir; // random(12) + 1;
              begin
                for I := LDir to LDir + high(dir12) - 1 do
                    if assigned(ActRoom.gang[I mod high(dir12) + 1]) and
                        (FLdir <> I mod high(dir12) + 1) then
                        LDir := I mod high(dir12) + 1;
                if not assigned(ActRoom.gang[LDir]) then
                    LDir := ActRoom.EDir;
              end;

            if assigned(ActRoom.gang[LDir]) then
              begin
                ActRoom := ActRoom.gang[LDir];
                FLdir := getinvdir(LDir, 22);
                // FraWindRose1.Direction2 := (FLdir + 5) * 30;

                //              For I := 1 To 10 Do

                if ((FLdir + 5) * 30 - Fdirection2 + 360) mod
                    180 > 90 then
                    FDirection2 :=
                        (FDirection2 + 350) mod 360
                else
                    FDirection2 :=
                        (FDirection2 + 10) mod 360;


                if (FDirection2 - FDirection + 360) mod 180 > 90 then
                    FDirection := (FDirection + 359) mod 360
                else
                    FDirection := (FDirection + 1) mod 360;

                FraWindRose1.Direction2 := FDirection2;
                FraWindRose1.Direction := FDirection;

              end;


            DrawLaby(Sender);
          end;

end;

procedure TForm1.DrawLaby(Sender: TObject);

    procedure VTransform(xx0, yy0, s, C: extended; Out rx0: integer;
        Out ry0: integer); inline;

    var
        ly: extended;
        lz: extended;

    const
        ZFAkt = 900;
        ZFaktinv = 1 / ZFAkt;
        yFakt = 0.5;

    begin
        ly := (yy0 * C - s * xx0);
        lz := (ZFAkt + ly) * ZFaktinv;
        rx0 := trunc((xx0 * C + s * yy0) * lz);
        ry0 := trunc(ly * yFakt * lz);
    end;

var
    lx: integer;
    ly: integer;
    LBreaks: integer;
    s, C: extended;
    LMAxLEvel: integer;

const
    df = 6;

    procedure DrawSubPath(Level: integer; iDir: integer; Lroom: TLbyRoom;
        x0, y0: integer);

    var
        I,K: integer;
        xx0, xx1, yy0, yy1: extended;
        rx0, rx1, ry0, ry1: integer;
        G:array[0..5] of integer;

    begin
        for I := 1 to high(dir12) do
            if assigned(Lroom.gang[I]) and ((I <> getinvdir(iDir, 22)) or
                (iDir = -1)) then
              begin
                if Level > LMAxLEvel - 15 then
                    ImgDisplay.Canvas.pen.Width := (Level - LMAxLEvel + 20) div 3
                else
                    ImgDisplay.Canvas.pen.Width := 2;
                if iDir = -1 then

                  begin
                    ImgDisplay.Canvas.pen.Color := clLime;
                  end
                else if Lroom.gang[I].token = 'R' then
                  begin
                    ImgDisplay.Canvas.pen.Color := clBlue;
                  end
                else if Lroom.gang[I].token = 'E' then
                  begin
                    ImgDisplay.Canvas.pen.Color := clRed;

                  end
                else
                    ImgDisplay.Canvas.pen.Color := clblack;
                xx0 := +(Lroom.Ort.y - y0) * df;
                yy0 := -(Lroom.Ort.x - x0) * df;
                xx1 := +(Lroom.gang[I].Ort.y - y0) * df;
                yy1 := -(Lroom.gang[I].Ort.x - x0) * df;
                VTransform(xx0, yy0, s, C, rx0, ry0);
                VTransform(xx1, yy1, s, C, rx1, ry1);

                ImgDisplay.Canvas.moveto(lx + rx0, ly + ry0);
                ImgDisplay.Canvas.lineto(lx + rx1, ly + ry1);

                if (Level > 0) then
                    DrawSubPath(Level - 1, I, Lroom.gang[I], x0, y0)
                else
                    Inc(LBreaks);
                if Color <> clblack then
                    imgPreview.Canvas.Pixels
                        [trunc(Lroom.gang[I].Ort.x / Laby.Laby_Width *
                        (imgPreview.Width - 2)) + 1,
                        trunc(Lroom.gang[I].Ort.y / Laby.Laby_Length *
                        (imgPreview.Height - 2)) + 1] := ImgDisplay.Canvas.pen.Color;

              end;
    end;

    procedure DrawMap(Level: integer; x0, y0: integer);

    var
        LAoRooms: TArrayOfRooms;
        I, J: integer;
        xx0, xx1,xx2,xx3, yy0, yy1,yy2,yy3: extended;
        ix, iy, rx0, rx1, ry0, ry1, dist, GCount, K, rx2, ry2, ry3,
          rx3: integer;
        Color, Color2: Tcolor;
        Dp, O: T2DPoint;
        G:array[0..5] of integer;

        function sgn(i: integer): integer; inline;
        begin
            if i > 0 then
                Result := 1
            else if i < 0 then
                Result := -1
            else
                Result := 0;
        end;


    begin
        Dp := T2DPoint.init(nil);
        for ix := (x0 - Level) div 4 to (x0 + Level) div 4 do
            for iy := (y0 - Level) div 4 to (y0 + Level) div 4 do
              begin
                LAoRooms := Laby.RoomIndex[dp.Copy(ix * 4, iy * 4)];

                for J := 0 to High(LAoRooms) do
                  begin
                    dp.Copy(LAoRooms[J].ort);
                    dist :=
                        trunc(sqrt(sqr(dp.x - x0) +
                        sqr(dp.y - y0)));


                    ImgDisplay.Canvas.pen.Width := 1;
                    if LAoRooms[J].token = 'R' then
                      begin
                        Color := clBlue;
                        Color2 := rgb(128, 128, 255);

                      end
                    else if LAoRooms[J].token = 'E' then
                      begin
                        Color := clRed;
                        Color2 := rgb(255, 128, 128);

                      end
                    else
                      begin
                        Color := clblack;
                        Color2 := rgb(128, 128, 128);
                      end;

                    if dist < Level then
                        imgPreview.Canvas.Pixels
                            [trunc(dp.x / Laby.Laby_Width *
                            (imgPreview.Width - 2)) + 1,
                            trunc(dp.y / Laby.Laby_Length *
                            (imgPreview.Height - 2)) + 1] := Color2
                    else
                        imgPreview.Canvas.Pixels
                            [trunc(dp.x / Laby.Laby_Width *
                            (imgPreview.Width - 2)) + 1,
                            trunc(dp.y / Laby.Laby_Length *
                            (imgPreview.Height - 2)) + 1] := clWhite;

                    if dist < Level - 1 then
                        begin
                          O := LAoRooms[J].Ort;
                          GCount :=0;
                          for I := 1 to high(dir12) do
                            if assigned(LAoRooms[J].gang[I]) then
                               begin
                                 G[GCount]:=I;
                                 inc(GCount);
                               end;

                          for K := 0 to GCount-1 do
                              begin
                                if (K = 1) and (GCount=2) then break;
                                I := G[K];
                                dp.Copy(LAoRooms[J].ort).add(LAoRooms[J].gang[I].Ort);
                                dist :=
                                    trunc(sqrt(sqr(dp.x div 2 - x0) +
                                    sqr(dp.y div 2 - y0)));

                                if dist < Level then
                                    imgPreview.Canvas.Pixels
                                        [trunc(dp.x div 2 / Laby.Laby_Width *
                                        (imgPreview.Width - 2)) + 1,
                                        trunc(dp.y div 2 / Laby.Laby_Length *
                                        (imgPreview.Height - 2)) + 1] := Color2
                                else
                                    imgPreview.Canvas.Pixels
                                        [trunc(dp.x div 2 / Laby.Laby_Width *
                                        (imgPreview.Width - 2)) + 1,
                                        trunc(dp.y div 2 / Laby.Laby_Length *
                                        (imgPreview.Height - 2)) + 1] := clWhite;


                                xx0 := +(O.y +0.5*dir12[I].y  - y0) * df;
                                yy0 := -(O.x +0.5*dir12[I].x  - x0) * df;
                                xx1 := +(O.y +0.25*dir12[I].y  - y0) * df;
                                yy1 := -(O.x +0.25*dir12[I].x  - x0) * df;
                                I := G[(k+1) mod GCount];
                                xx2 := +(O.y +0.25*dir12[I].y  - y0) * df;
                                yy2 := -(O.x +0.25*dir12[I].x  - x0) * df;
                                xx3 := +(O.y +0.5*dir12[I].y  - y0) * df;
                                yy3 := -(O.x +0.5*dir12[I].x  - x0) * df;

                                VTransform(xx0, yy0, s, C, rx0, ry0);
                                VTransform(xx1, yy1, s, C, rx1, ry1);
                                VTransform(xx2, yy2, s, C, rx2, ry2);
                                VTransform(xx3, yy3, s, C, rx3, ry3);

                                if dist < Level then
                                  begin
                                    ImgDisplay.Canvas.pen.Width := 3;
                                    ImgDisplay.Canvas.pen.Color := Color;
                                    ImgDisplay.Canvas.moveto(lx + rx0, ly + ry0);
                                    ImgDisplay.Canvas.Lineto(lx + rx1, ly + ry1);
                                    ImgDisplay.Canvas.Lineto(lx + rx2, ly + ry2);
                                    ImgDisplay.Canvas.lineto(lx + rx3, ly + ry3);
                                  end;
                              end;
                        end;
                  end;
              end;
        dp.Free;
    end;

var
    // i: Integer;
    lx0: integer;
    ly0: integer;
    // ax, ay: extended;

begin
    lx := ImgDisplay.Width div 2;
    ly := ImgDisplay.Height div 2;
    s := sin(FDirection * pi / 180);
    C := cos(FDirection * pi / 180);
    ImgDisplay.Canvas.Brush.Color := Color;
    ImgDisplay.Canvas.FillRect(ImgDisplay.Canvas.cliprect);
    if assigned(ActRoom) then
      begin
        lx0 := ActRoom.Ort.x;
        ly0 := ActRoom.Ort.y;
        if abs(lx0 - FVisx0) > 50 then

            FVisx0 := FVisx0 + (lx0 - FVisx0) div 2
        else if abs(lx0 - FVisx0) > 25 then
            FVisx0 := FVisx0 + (lx0 - FVisx0) div 4
        else if abs(lx0 - FVisx0) > 10 then
            FVisx0 := FVisx0 + (lx0 - FVisx0) div 8;

        if abs(ly0 - FVisy0) > 50 then
            FVisy0 := FVisy0 + (ly0 - FVisy0) div 2
        else if abs(ly0 - FVisy0) > 25 then
            FVisy0 := FVisy0 + (ly0 - FVisy0) div 4
        else if abs(ly0 - FVisy0) > 10 then
            FVisy0 := FVisy0 + (ly0 - FVisy0) div 8;

        DrawMap(50, FVisx0, FVisy0);

        LBreaks := 0;

        LMAxLEvel := 20;
        DrawSubPath(LMAxLEvel, -1, ActRoom, FVisx0, FVisy0);

        Label1.Caption := IntToStr(LBreaks);
      end;
end;

end.
