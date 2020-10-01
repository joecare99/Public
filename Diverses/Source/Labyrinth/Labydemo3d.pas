unit Labydemo3d;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

{$IF FPC_FULLVERSION < 030301}
   {$WARN 6058 off}{ : Call to subroutine "$1" marked as inline is not inlined}
{$endif}

uses
{$IFnDEF FPC}
    pngimage, jpeg, Windows,
 {$IFDEF HasUITypes} UITypes, {$ENDIF}
{$ELSE}
  LCLIntf, LCLType, JPEGLib, FileUtil,
{$ENDIF}
    SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ExtCtrls, StdCtrls, LabyU3D, Fra_WindRose, ExtDlgs, unt_Point3d;

type

    { TfrmLabyDemo3d }

    TfrmLabyDemo3d = class(TForm)
        btnShow: TButton;
        imgDisplay: TImage;
        Btn_Create: TButton;
        Btn_Test1: TButton;
        Btn_Load: TButton;
        btnRotLeft: TButton;
        btnRotRight: TButton;
        Btn_GoFwd: TButton;
        Btn_Back: TButton;
        FraWindRose1: TFraWindRose;
        chbAutorun: TCheckBox;
        pnlRightClient: TPanel;
        pnlRight: TPanel;
        pnlRightTop: TPanel;
        Timer1: TTimer;
        OpenDialog1: TOpenDialog;
        chbFast: TCheckBox;
        Label1: TLabel;
        imgPreview: TPaintBox;
        Btn_Test2: TButton;
        Btn_Test3: TButton;
        Btn_Test4: TButton;
        OpenPictureDialog1: TOpenPictureDialog;
        edtXDim: TLabeledEdit;
        edtYDim: TLabeledEdit;
        procedure Btn_Test1Click(Sender: TObject);
        procedure Btn_CreateClick(Sender: TObject);
        procedure btnShowClick(Sender: TObject);
        procedure imgDisplayClick(Sender: TObject);
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
            putpixel: TPut3DObstaclePxl; wfact: integer);
        procedure RandomPoints(x, y, size, Count: integer; putpixel: TPut3DObstaclePxl);
        procedure RandomQuadr(x, y, z: integer; ausl, dx, dy: extended;
            putpixel: TPut3DObstaclePxl);
        procedure PutImage(x, y: integer; filename: string; size: integer;
            putpixel: TPut3DObstaclePxl);
        { Public-Deklarationen }
    public
        procedure PutLogoUR(putpixel: TPut3DObstaclePxl);
        procedure DoRandomPoints(putpixel: TPut3DObstaclePxl);
        procedure DoBigQuadr(putpixel: TPut3DObstaclePxl);
        procedure DoSmallQuadr(putpixel: TPut3DObstaclePxl);
        procedure putpixel(lb: T3dpoint; Value: boolean);
        procedure DoPicture(putpixel: TPut3DObstaclePxl);
    end;

var
    frmLabyDemo3d: TfrmLabyDemo3d;

implementation

uses ProgressBarU, variants;

{$IFnDEF FPC}
  {$R *.dfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
    GoldCut = 0.61803398874989484820458683436564;

procedure TfrmLabyDemo3d.Btn_Test4Click(Sender: TObject);

begin
    if OpenPictureDialog1.Execute then
      begin
        imgDisplay.Canvas.Brush.Color := clDkGray;
        imgDisplay.Canvas.FillRect(imgDisplay.Canvas.cliprect);

        FPictFilename := OpenPictureDialog1.filename;

        PutImage(0, 0, FPictFilename, 500, putpixel);
        // PutImage(0, 200, FPictFilename, 330, putpixel);
        // imgDisplay.{Picture.bitmap.}Canvas, imgDisplay.{Picture.bitmap.}Canvas.cliprect);
      end;
end;

procedure TfrmLabyDemo3d.Btn_CreateClick(Sender: TObject);

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
    laby.Laby_width := StrToInt(edtXDim.Text);
    laby.Laby_Length := StrToInt(edtYDim.Text);
    laby.Laby_Height_ := 5;

    setlength(Laby.fobstacles, 5);
    Laby.fobstacles[0] := PutLogoUR;
    Laby.fobstacles[1] := DoRandomPoints;
    Laby.fobstacles[2] := DoSmallQuadr;
    Laby.fobstacles[3] := DoPicture;
    Laby.fobstacles[4] := DoBigQuadr;

    Laby.CreateLaby;
end;

procedure TfrmLabyDemo3d.btnShowClick(Sender: TObject);
begin
    Laby.Show;
end;

procedure TfrmLabyDemo3d.Btn_Test1Click(Sender: TObject);
var
    path: variant;
    x, y: integer;
    // i: Integer;
begin
    imgDisplay.Canvas.Brush.Color := clDkGray;
    imgDisplay.Canvas.FillRect(imgDisplay.Canvas.cliprect);

    path := vararrayof([2, 1, 12, 4, 4, 4, 6, 5, 2, 11, 12, 10, 10,
        12, 2, 6, 4, 2, 12, 10, 10, 2, 12, 2, 5, 7, 4, 1, 1, 12, 10,
        10, 11, 12, 2, 6, 5, 4, 3, 1, 11, 10, 12, 2, 6, 4, 2, 12, 10,
        10, 2, 4, 3, 1, 11, 10, 12, 4, 4, 2, 10, 10, 12, 2,
        // 12,10,10,2,
        12, 2, 5, 7, 4, 1, 1]);
    x := imgDisplay.Width - 50;
    y := 50;
    PutLogo(x, y, path, putpixel, 1);
    PutLogo(x, y + 40, path, putpixel, 2);
    PutLogo(x, y + 80, path, putpixel, 3);
end;

procedure TfrmLabyDemo3d.Btn_LoadClick(Sender: TObject);
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
    if OpenDialog1.Execute then
      begin
        Laby.LoadLaby(OpenDialog1.filename);
        ActRoom := Laby.eingang;
        FVisx0 := ActRoom.Ort.x;
        FVisy0 := ActRoom.Ort.y;
        DrawLaby(Sender);
      end;
    Laby.Hide;
end;

procedure TfrmLabyDemo3d.btnRotLeftClick(Sender: TObject);
begin
    FraWindRose1.direction := FraWindRose1.direction - 10;
    DrawLaby(Sender);
end;

procedure TfrmLabyDemo3d.btnRotRightClick(Sender: TObject);
begin
    FraWindRose1.direction := FraWindRose1.direction + 10;
    DrawLaby(Sender);
end;

procedure TfrmLabyDemo3d.PutLogo(x, y: integer; path: variant; putpixel: TPut3DObstaclePxl;
    wfact: integer);
var
    dir, dir1, dir2: shortint;
    I,j: integer;
    dp: T3DPoint;
    tr: T3DPoint;
begin
    dp := T3DPoint.Init(x, y, 4);
    tr := T3DPoint.Init(nil);
    if assigned(putpixel) then
      begin
        if wfact=1 then
          for I := Vararrayhighbound(path, 1) - 1 downto 1 do
            begin
              dir := path[I div wfact];
              if i < Vararrayhighbound(path, 1) - 1 then
              for J in [1..12] do
                putpixel(tr.copy(dp).add(Dir3D22[J]), True);
              dp.subst(Dir3D22[dir]);
            end;
        dp.copy(x, y, 4);
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
            if wfact>1 then
            begin
              putpixel(dp, True);
              putpixel(tr.copy(dp).add(Dir3D1[3]), True);
              putpixel(tr.copy(dp).Subst(dir3d1[3]), True);
            end
            else
              begin
                for J in [1..8] do
                  putpixel(tr.copy(dp).add(Dir3D15[J]), True);
                putpixel(dp, false);
              end;
            // If dir Mod 3 = 1 Then
            if wfact>1 then
            begin
              putpixel(tr.copy(dp).add(dp).subst(Dir3D22[dir]).Smult(1, 2), True);
            putpixel(tr.copy(dp).add(dp).subst(Dir3D22[dir]).Smult(
                1, 2).add(dir3d1[3]), True);
            putpixel(tr.copy(dp).add(dp).subst(Dir3D22[dir]).Smult(
                1, 2).Subst(dir3d1[3]), True);
            end;
            dp.subst(Dir3D22[dir]);
          end;
        putpixel(dp, True);
      end;
    dp.Free;
    tr.Free;
end;

procedure TfrmLabyDemo3d.RandomPoints(x, y, size, Count: integer; putpixel: TPut3DObstaclePxl);
var
    I: integer;
    dd, ausl, lx, ly, lz: extended;
    cc: extended;
    ss: extended;
    lyy: extended;
    lzz: extended;
    tr: T3DPoint;

begin
    tr := T3DPoint.init(nil);
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
                    y + round((lyy * cc - lx * ss) * size), 1 + random(3)), True);
          end;
    tr.Free;
end;

procedure TfrmLabyDemo3d.RandomQuadr(x, y, z: integer; ausl, dx, dy: extended;
  putpixel: TPut3DObstaclePxl);
var
    I, J: integer;
    dd, jitter: extended;
    dp: T3DPoint;
    tp: T3DPoint;

begin
    dp := T3DPoint.init(x, y, z);
    tp := T3DPoint.init(nil);
    dd := 2 * pi * random;
    if assigned(putpixel) then
        for J := round(-ausl / dy) to round(ausl / dy) do
          begin
            jitter := random * 0.5;
            for I := round(-ausl / dx) to round(ausl / dx) do
              begin
                putpixel(tp.copy(
                    round(sin(dd) * J * dy + cos(dd) * (I + jitter) * dx),
                    round(cos(dd) * J * dy - sin(dd) * (I + jitter) * dx), 0).add(dp), True);
              end;
          end;
    tp.Free;
    dp.Free;
end;

procedure TfrmLabyDemo3d.PutImage(x, y: integer; filename: string; size: integer;
    putpixel: TPut3DObstaclePxl);

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

    J: integer;
    C, mn, mx, avg, ff: integer;
    zz: integer;
    tp: T3DPoint;

begin
    if FileExists(filename) then
      begin
        tp := T3dpoint.init(nil);
        LPicture := TPicture.Create;
        LPicture.LoadFromFile(filename);
        if LPicture.Height > LPicture.Width then
            LmaxSize := LPicture.Height
        else
            LmaxSize := LPicture.Width;

        Lbitmap := Tbitmap.Create;
        Lbitmap.SetSize(
            trunc(LPicture.Width * size div (LmaxSize)),
            trunc(LPicture.Height * size div (LmaxSize)));
        Lbitmap.PixelFormat := pf24bit;
        Lbitmap.Canvas.StretchDraw(rect(0, 0, Lbitmap.Width, Lbitmap.Height),
            LPicture.Graphic);
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
        mx := mx - 10;
        mn := mn + 10;
        avg := avg div (Lbitmap.Height * Lbitmap.Width);
        for I := 0 to Lbitmap.Height - 1 do
          begin
            LP := Lbitmap.ScanLine[I];
            f := 0;
            for J := 0 to Lbitmap.Width - 1 do
              begin

                ff := min(min(min(I, Lbitmap.Height - 1 - I),
                    min(J, Lbitmap.Width - 1 - J)), 10);

                C := (((LP[J].rgbtRed + LP[J].rgbtGreen + LP[J].rgbtBlue) *
                    ff) div 10 + (f * 3 + fv[J] * 3) div 2) div 3;

                if C > avg then
                  begin
                    f := -mx + C;
                    //C := 255;
                    zz := 4;
                    putpixel(tp.copy(x + size - Lbitmap.Width + J,
                        y + I, zz), True);
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
        tp.Free;
      end;
end;

procedure TfrmLabyDemo3d.PutLogoUR(putpixel: TPut3DObstaclePxl);
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

    if Laby.Laby_Width < 200 then
        ww := 1
    else if Laby.Laby_Width < 300 then
        ww := 2
    else
        ww := 3;
    PutLogo(Laby.Laby_Width - 10, Laby.Laby_length - 10, path, putpixel, ww);
end;

procedure TfrmLabyDemo3d.putpixel(lb: T3dpoint; Value: boolean);
begin
    if assigned(lb) and Value then
        imgDisplay.Canvas.Pixels[lb.x, lb.y] := clWhite;
end;

procedure TfrmLabyDemo3d.DoRandomPoints(putpixel: TPut3DObstaclePxl);

var
    Count, size: integer;
begin
    Count := round(Laby.Laby_Width * Laby.Laby_Length * 0.01) - 1;
    size := round(GoldCut * GoldCut * GoldCut * Laby.Laby_Length);
    RandomPoints(round(GoldCut * Laby.Laby_Width),
        round(GoldCut * GoldCut * Laby.Laby_Length), size, Count, putpixel);
end;

procedure TfrmLabyDemo3d.DoBigQuadr(putpixel: TPut3DObstaclePxl);

begin

    RandomQuadr(round(GoldCut * GoldCut * Laby.Laby_Width),
        round(GoldCut * Laby.Laby_Length),2, GoldCut * GoldCut * Laby.Laby_Length,
        3.0, 3.0, putpixel);

end;

procedure TfrmLabyDemo3d.DoPicture(putpixel: TPut3DObstaclePxl);
begin
    PutImage(((Laby.Laby_Width * 4) div 5) - 20, 20, FPictFilename,
        Laby.Laby_Width div 5, putpixel);
end;

procedure TfrmLabyDemo3d.DoSmallQuadr(putpixel: TPut3DObstaclePxl);

begin
    RandomQuadr(round(GoldCut * GoldCut * Laby.Laby_Width),
        round(GoldCut * GoldCut * Laby.Laby_Length),3, GoldCut * GoldCut *
        GoldCut * GoldCut * Laby.Laby_Length, 2, 2, putpixel);

end;

procedure TfrmLabyDemo3d.Btn_GoFwdClick(Sender: TObject);
var
    LDir: integer;
begin
    if assigned(ActRoom) then
      begin
        LDir := (FraWindRose1.direction + 375) div 30 mod 12 + 1;
        if assigned(ActRoom.gang[LDir]) then
            ActRoom := ActRoom.gang[LDir];

      end;
    DrawLaby(Sender);
end;

procedure TfrmLabyDemo3d.Btn_BackClick(Sender: TObject);
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

procedure TfrmLabyDemo3d.Btn_Test2Click(Sender: TObject);
begin
    imgDisplay.Canvas.Brush.Color := Color;
    imgDisplay.Canvas.FillRect(imgDisplay.Canvas.cliprect);

    RandomPoints(imgDisplay.Width div 2, imgDisplay.Height div 2, imgDisplay.Width div 2,
        10000, putpixel);
end;

procedure TfrmLabyDemo3d.Btn_Test3Click(Sender: TObject);
begin
    imgDisplay.Canvas.Brush.Color := clDkGray;
    imgDisplay.Canvas.FillRect(imgDisplay.Canvas.cliprect);

    RandomQuadr(imgDisplay.Width div 2, imgDisplay.Height div 2,3,
        imgDisplay.Height div 3, 2,
        2, putpixel);
end;

procedure TfrmLabyDemo3d.chbFastClick(Sender: TObject);
begin
    if chbFast.Checked then
        Timer1.Interval := 25
    else
        Timer1.Interval := 100;

end;

procedure TfrmLabyDemo3d.imgDisplayClick(Sender: TObject);

var
    I, J, imax: integer;
    hp: T3DPoint;

begin

    // hp.init(0,0);
    for I := 30 to 80 do
      begin
        imax := round(I * 2 * pi);
        for J := 1 to imax do
          begin
            hp := Unt_point3d.getdir(I, J);
            imgDisplay.Canvas.Pixels[hp.x + 40, hp.y + 40] :=
                rgb(I * 3, I * 2 + round(J / imax * 90), round(J / imax * 250));
            imgDisplay.Canvas.Pixels[J, hp.x + 120] :=
                rgb(I * 3, I * 2 + round(J / imax * 90), round(J / imax * 250));
            imgDisplay.Canvas.Pixels[J, hp.y + 200] :=
                rgb(I * 3, I * 2 + round(J / imax * 90), round(J / imax * 250));
            hp.Free;

          end;
        imgDisplay.Update;
      end;
end;

procedure TfrmLabyDemo3d.Timer1Timer(Sender: TObject);
var
    LDir: integer;
    I: integer;
begin
    if chbAutorun.Checked then
        if assigned(ActRoom) then
          begin
            LDir := FLdir; // random(12) + 1;
              begin
                for I := LDir to LDir + high(dir3d22) - 1 do
                    if assigned(ActRoom.gang[I mod high(dir3d22) + 1]) and
                        (FLdir <> I mod high(dir3d22) + 1) then
                        LDir := I mod high(dir3d22) + 1;
                if not assigned(ActRoom.gang[LDir]) then
                    LDir := ActRoom.EDir;
              end;

            if assigned(ActRoom.gang[LDir]) then
              begin
                ActRoom := ActRoom.gang[LDir];
                FLdir := getinvdir(LDir, 22);
                // FraWindRose1.Direction2 := (FLdir + 5) * 30;
                for I := 1 to 10 do

                    if ((FLdir + 5) * 30 - FraWindRose1.direction2 +
                        360) mod 180 > 90 then
                        FraWindRose1.direction2 :=
                            (FraWindRose1.direction2 + 359) mod 360
                    else
                        FraWindRose1.direction2 :=
                            (FraWindRose1.direction2 + 1) mod 360;

                if (FraWindRose1.direction2 - FraWindRose1.direction +
                    360) mod 180 > 90 then
                    FraWindRose1.direction := (FraWindRose1.direction + 359) mod 360
                else
                    FraWindRose1.direction := (FraWindRose1.direction + 1) mod 360;

              end;

            DrawLaby(Sender);
          end;

end;

procedure TfrmLabyDemo3d.DrawLaby(Sender: TObject);

    procedure VTransform(xx0, yy0, zz0, s, C: extended; Out rx0: integer;
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
        ry0 := trunc((ly * yFakt + zz0) * lz);
    end;

var
    lx: integer;
    ly: integer;
    LBreaks: integer;
    s, C: extended;
    LMAxLEvel: integer;

const
    df = 10;

    procedure DrawSubPath(Level: integer; iDir: integer; Lroom: TLbyRoom;
        x0, y0: integer);

    var
        I: integer;
        xx0, xx1, yy0, yy1: extended;
        rx0, rx1, ry0, ry1: integer;
        zz0: integer;
        zz1: integer;
    begin
        for I := 1 to high(dir3d22) do
            if assigned(Lroom.gang[I]) and ((I <> getinvdir(iDir, 22)) or
                (iDir = -1)) then
              begin
                if Level > LMAxLEvel - 15 then
                    imgDisplay.Canvas.pen.Width := (Level - LMAxLEvel + 20) div 3
                else
                    imgDisplay.Canvas.pen.Width := 2;
                if iDir = -1 then

                  begin
                    imgDisplay.Canvas.pen.Color := clLime;
                  end
                else if Lroom.gang[I].token = 'R' then
                  begin
                    imgDisplay.Canvas.pen.Color := clBlue;
                  end
                else if Lroom.gang[I].token = 'E' then
                  begin
                    imgDisplay.Canvas.pen.Color := clRed;

                  end
                else
                    imgDisplay.Canvas.pen.Color := clblack;
                xx0 := +(Lroom.Ort.y - y0) * df;
                yy0 := -(Lroom.Ort.x - x0) * df;
                zz0 := -(Lroom.Ort.z - 3) * df;
                xx1 := +(Lroom.gang[I].Ort.y - y0) * df;
                yy1 := -(Lroom.gang[I].Ort.x - x0) * df;
                zz1 := -(Lroom.gang[I].Ort.z - 3) * df;
                VTransform(xx0, yy0, zz0, s, C, rx0, ry0);
                VTransform(xx1, yy1, zz1, s, C, rx1, ry1);

                imgDisplay.Canvas.moveto(lx + rx0, ly + ry0);
                imgDisplay.Canvas.lineto(lx + rx1, ly + ry1);

                if (Level > 0) then
                    DrawSubPath(Level - 1, I, Lroom.gang[I], x0, y0)
                else
                    Inc(LBreaks);
                if Color <> clblack then
                    imgPreview.Canvas.Pixels
                        [trunc(Lroom.gang[I].Ort.x / Laby.Laby_Width *
                        (imgPreview.Width - 2)) + 1,
                        trunc(Lroom.gang[I].Ort.y / Laby.Laby_Length *
                        (imgPreview.Height - 2)) + 1] := imgDisplay.Canvas.pen.Color;

              end;
    end;

    procedure DrawMap(Level: integer; x0, y0, z0: integer);

    var
        LAoRooms: TArrayOfRooms;
        I, J: integer;
        xx0, xx1, yy0, yy1, zz0, zz1: extended;
        ix, iy, iz, rx0, rx1, ry0, ry1, dist: integer;
        Color, Color2: Tcolor;
        Dp: T3DPoint;

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
        Dp := T3DPoint.init(nil);
        for iz := 0 to Laby.Laby_Height_ div 4 do
            for ix := (x0 - Level) div 4 to (x0 + Level) div 4 do
                for iy := (y0 - Level) div 4 to (y0 + Level) div 4 do
                  begin
                    LAoRooms := Laby.RoomIndex[dp.copy(ix * 4, iy * 4, iz * 4)];

                    for J := 0 to High(LAoRooms) do
                      begin
                        dp.Copy(LAoRooms[J].ort);
                        dist := trunc(sqrt(sqr(dp.x - x0) +
                            sqr(dp.y - y0) + sqr(dp.z - 3)));


                        imgDisplay.Canvas.pen.Width := 1;
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
                            for I := 1 to high(Dir3D22) do
                                if assigned(LAoRooms[J].gang[I]) then
                                  begin
                                    dp.Copy(LAoRooms[J].ort).add(LAoRooms[J].gang[I].Ort);
                                    dist :=
                                        trunc(sqrt(sqr(dp.x div 2 - x0) +
                                        sqr(dp.y div 2 - y0) +
                                        sqr(dp.z div 2 - 3)));

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


                                    xx0 := +(LAoRooms[J].Ort.y - y0) * df;
                                    yy0 := -(LAoRooms[J].Ort.x - x0) * df;
                                    ZZ0 := -(LAoRooms[J].Ort.z - 3) * df;
                                    xx1 := +(dp.y * 0.5 - y0) * df;
                                    yy1 := -(dp.x * 0.5 - x0) * df;
                                    zz1 := -(dp.z * 0.5 - 3) * df;

                                    VTransform(xx0, yy0, zz0, s, C, rx0, ry0);
                                    VTransform(xx1, yy1, zz1, s, C, rx1, ry1);

                                    if dist < Level then
                                      begin
                                        imgDisplay.Canvas.pen.Width := 5;
                                        imgDisplay.Canvas.pen.Color := clwhite;
                                        imgDisplay.Canvas.moveto(lx + rx0 + sgn(rx1 - rx0),
                                            ly + ry0 + sgn(ry1 - ry0));
                                        imgDisplay.Canvas.lineto(lx + rx1, ly + ry1);
                                        imgDisplay.Canvas.pen.Width := 5;
                                        imgDisplay.Canvas.pen.Color := Color;
                                        imgDisplay.Canvas.moveto(lx + rx0, ly + ry0);
                                        imgDisplay.Canvas.lineto(lx + rx1 + sgn(rx1 - rx0),
                                            ly + ry1 + sgn(ry1 - ry0));

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
    lx := imgDisplay.Width div 2;
    ly := imgDisplay.Height div 2;
    s := sin(FraWindRose1.direction * pi / 180);
    C := cos(FraWindRose1.direction * pi / 180);
    imgDisplay.Canvas.Brush.Color := Color;
    imgDisplay.Canvas.FillRect(imgDisplay.Canvas.cliprect);
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

        DrawMap(30, FVisx0, FVisy0, 3);

        LBreaks := 0;

        LMAxLEvel := 15;
        DrawSubPath(LMAxLEvel, -1, ActRoom, FVisx0, FVisy0);

        Label1.Caption := IntToStr(LBreaks);
      end;
end;

end.
