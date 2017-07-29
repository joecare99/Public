UNIT frm_Aboutbox;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{ *V 1.2.0 }

{ *H 1.1.0 High-DPI }
{ *H 1.0.0 Animation Variabel }
INTERFACE

USES
{$IFnDEF FPC}
  jpeg, ShellAPI, Windows,
{$ELSE}
{$IFDEF MSWINDOWS}
 Windows,
{$ENDIF}
  LCLIntf, LCLType,LResources,
{$ENDIF}
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  ExtCtrls;

TYPE
  /// <author>Joe Care</author>
  /// <version>1.01.00</version>
  /// <since>02.02.2008</since>
  TAnimationProc = PROCEDURE(Pic: TBitmap; canvas: TCanvas; I, max: integer)
    OF OBJECT;

  /// <author>Joe Care</author>
  /// <since>02.02.2008</since>
  /// <version>1.01.00</version>

  { TAboutBox }

  TAboutBox = CLASS(TComponent)
  Private
    { Private declarations }
    Fcomment, Fcompany: STRING;
    FWebLink: STRING;
    Function FReadLogo: TPicture;
    Procedure FSetLogo(NewVal: TPicture);
    procedure SetWebLink(AValue: STRING);
  Published
    PROPERTY Comment: STRING Read Fcomment Write Fcomment;
    PROPERTY Company: STRING Read Fcompany Write Fcompany;
    PROPERTY WebLink: STRING read FWebLink write SetWebLink;
    PROCEDURE Show;
    FUNCTION ShowModal: Tmodalresult;
  public
    PROPERTY Logo: TPicture Read FReadLogo Write FSetLogo;
  END;

  /// <author>Joe Care</author>
  /// <since>02.02.2008</since>
  /// <version>1.01.00</version>
  TAboutBoxform = CLASS(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    lbl_WebLink: TLabel;
    Lbl_Date: TLabel;
    ScrollBar1: TScrollBar;
    Timer1: TTimer;
    PROCEDURE ScrollBar1Change(Sender: TObject);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
    PROCEDURE ProgramIconClick(Sender: TObject);
    PROCEDURE OKButtonClick(Sender: TObject);
    PROCEDURE lbl_WebLinkClick(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
  Private
    { Private declarations }
    {$IFDEF FPC}
    TransparentColorValue:TColor;
    TransparentColor :boolean;
    {$ENDIF}
    FanimateIcon: TAnimationProc;
    Fcomment, Fcompany: STRING;
    orgBM, orgbm2: TBitmap;
    Anim: Array Of TAnimationProc;

    PROCEDURE anim1_0(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim1_1(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim1_2(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim1(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim2(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim3(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim4(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim5(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim6(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim7(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim8(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim9(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim10(Pic: TBitmap; canvas: TCanvas; I, max: integer);
    PROCEDURE anim11(Pic: TBitmap; canvas: TCanvas; I, max: integer);
  Public
    { Public declarations }
    PROPERTY Comment: STRING Read Fcomment Write Fcomment;
    PROPERTY Company: STRING Read Fcompany Write Fcompany;
  END;

VAR
  AboutBox: TAboutBoxform;

IMPLEMENTATION

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{ $R *.dcr}
{$ENDIF}
// uses Unt_cdate;

PROCEDURE TAboutBoxform.OKButtonClick(Sender: TObject);
BEGIN
  close
END;

VAR
  /// <author>Joe Care</author>
  reent: integer = 0;

PROCEDURE TAboutBoxform.ProgramIconClick(Sender: TObject);
VAR
  I: integer;
BEGIN
  inc(reent);
  IF reent > 1 THEN
  BEGIN
    dec(reent);
    exit;
  END;
  Timer1.Enabled := false;
  FanimateIcon := Anim[Random(high(Anim))];
  IF assigned(FanimateIcon) THEN
  BEGIN
    FOR I := 0 TO 32 DO
    BEGIN
      IF visible THEN
        Try
          FanimateIcon(orgBM, ProgramIcon.canvas, I, 32);
        Except

        End;
      Application.ProcessMessages;
      sleep(20);
    END;
  END;
  Timer1.Enabled := true;
  dec(reent);
END;

PROCEDURE TAboutBoxform.lbl_WebLinkClick(Sender: TObject);
{$IFNDEF FPC}
VAR
  TMP: ARRAY [0 .. 255] OF Char;
  {$ENDIF ~FPC}
BEGIN
  {$IFNDEF FPC}
   StrPCopy(TMP, lbl_WebLink.Caption);
   ShellExecute(0, Nil, TMP, Nil, Nil, SW_NORMAL);
   {$ELSE ~FPC}
   OpenURL(lbl_WebLink.Caption);
   {$ENDIF ~FPC}
END;

var ADate,CName:String;

Function GetCDateVal(Name,Value : AnsiString; {%H-}Hash : Longint; {%H-}arg:pointer) : AnsiString;register;

begin
  if Name='Unt_cdate.adate' then ADate:= Value;
  if Name='Unt_cdate.cname' then CName:= Value;
  result := '';
end;


PROCEDURE TAboutBoxform.FormShow(Sender: TObject);

  FUNCTION GetVersion(filename: STRING): STRING;
  VAR
    VerInfoSize: DWord;
    VerInfo: Pointer;
    VerValueSize: DWord;
     {$IFDEF MSWINDOWS}
    VerValue: PVSFixedFileInfo;
    {$ENDIF}
    Dummy: DWord;
  BEGIN
    Dummy :=0;
    VerValueSize :=0;
    {$IFDEF MSWINDOWS}
    VerValue := nil;
    VerInfoSize := GetFileVersionInfoSize(PChar(filename), Dummy);
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(filename), 0, VerInfoSize, VerInfo);
    if VerInfoSize > 0 then
    begin
      VerQueryValue(VerInfo, '', Pointer(VerValue), VerValueSize);
      WITH VerValue^ DO
      BEGIN
        result := IntTostr(dwFileVersionMS SHR 16);
        result := result + '.' + IntTostr(dwFileVersionMS AND $FFFF);
        result := result + '.' + IntTostr(dwFileVersionLS SHR 16);
        result := result + '.' + IntTostr(dwFileVersionLS AND $FFFF);

      END;
    end
    else
    {$ENDIF}
      result := '1.0.0.0';
    randomize;
    {$IFDEF MSWINDOWS}
    FreeMem(VerInfo, VerInfoSize);
    {$ENDIF}
  END;

BEGIN
  ProductName.Caption := Application.Title;
  FanimateIcon := anim1;
  TRY
    Version.Caption := GetVersion(Application.ExeName);
  EXCEPT
    Version.Caption := '1.0.0.0'
  END;
  {$ifdef FPC}
  SetResourceStrings(GetCDateVal,nil);
  {$else}
 // EnumResourceNames(HInstance,0,list,)
  {$endif}
  if ADate <> '' then
    Lbl_Date.Caption := 'Compiled: '+ADate;
  orgBM := TBitmap.Create;
  orgBM.PixelFormat := pf24bit;
  orgbm2 := TBitmap.Create;
  orgbm2.PixelFormat := pf24bit;
  orgBM.Width := ProgramIcon.Picture.Bitmap.Width;
  orgBM.height := ProgramIcon.Picture.Bitmap.height;
  orgbm2.Width := ProgramIcon.Picture.Bitmap.Width;
  orgbm2.height := ProgramIcon.Picture.Bitmap.height;
  orgBM.canvas.CopyRect(orgBM.canvas.ClipRect,
    ProgramIcon.Picture.Bitmap.canvas, orgBM.canvas.ClipRect);
  TransparentColorValue := orgBM.canvas.Pixels[0, 0];
  TransparentColor := false;
  ProgramIcon.canvas.Brush.Color := TransparentColorValue;
  Copyright.Caption := Fcompany;
  Comments.Caption := Fcomment;
  ScrollBar1.visible := false;

END;

TYPE
  C2RGB = RECORD
    CASE boolean OF
      false:
        (c: Tcolor);
      true:
        (b: ARRAY [0 .. 3] OF byte)
  END;

PROCEDURE TAboutBoxform.anim1_0;
// Wackelzoom
VAR
  x, y, xd, yd, x1, y1, wh: integer;
  s1, c1: extended;
BEGIN
  // canvas.FrameRect(canvas.ClipRect);
  wh := Pic.Width DIV 2;
  s1 := sin(I * pi * 2 / max);
  c1 := cos(I * pi * 2 / max);
  FOR y := 0 TO Pic.height - 1 DO
  BEGIN
    yd := wh + (y - wh) * 2 DIV 3;
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      xd := wh + (x - wh) * 2 DIV 3;
      x1 := xd + trunc((x - xd) * c1 + (y - yd) * s1);
      y1 := yd + trunc(-(x - xd) * s1 + (y - yd) * c1);
      canvas.Pixels[x, y] := Pic.canvas.Pixels[x1, y1];
    END;
  END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim1_1;
// Rotorzoom
VAR
  x, y, xd, yd, x1, y1, wh: integer;
  s1, c1: extended;
BEGIN
  // canvas.FrameRect(canvas.ClipRect);
  wh := Pic.Width DIV 2;
  s1 := sin(I * pi * 2 / max);
  c1 := cos(I * pi * 2 / max);
  FOR y := 0 TO Pic.height - 1 DO
  BEGIN
    yd := wh + (y - wh) DIV 3;
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      xd := wh + (x - wh) DIV 3;
      x1 := xd + trunc((x - xd) * c1 + (y - yd) * s1);
      y1 := yd + trunc(-(x - xd) * s1 + (y - yd) * c1);
      canvas.Pixels[x, y] := Pic.canvas.Pixels[x1, y1];
    END;
  END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim1_2;
// Zerr-Rotor
VAR
  x, y, xd, yd, x1, y1, wh: integer;
  s1, c1: extended;
BEGIN
  wh := Pic.Width DIV 2;
  s1 := sin(I * pi * 2 / max);
  c1 := cos(I * pi * 2 / max);
  FOR y := 0 TO Pic.height - 1 DO
  BEGIN
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      yd := wh + trunc((y - wh) * sin(x * pi / wh) / 3);
      xd := wh + trunc((x - wh) * sin(y * pi / wh) / 3);
      x1 := xd + trunc((x - xd) * c1 + (y - yd) * s1);
      y1 := yd + trunc(-(x - xd) * s1 + (y - yd) * c1);
      canvas.Pixels[x, y] := Pic.canvas.Pixels[x1, y1];
    END;
  END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim1;
// fallout / Drop-in
VAR
  x, y, x1, y1, wh: integer;
  yd, y2, ph: extended;
BEGIN
  wh := Pic.height;
  ph := I * 2 / max;
  IF I < max DIV 2 THEN
  BEGIN
    yd := -1; // in
    y2 := wh * (1 - ph)
  END
  ELSE
  BEGIN
    y2 := wh + 1;
    yd := wh * (2 - ph);
  END;
  FOR y := 0 TO wh - 1 DO
  BEGIN
    y1 := trunc((y / wh) * y2 + (1 - y / wh) * yd);
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      x1 := x;
      canvas.Pixels[x, y] := Pic.canvas.Pixels[x1, y1];
    END;
  END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim2;
VAR
  x, y, x1, y1: integer;
BEGIN
  canvas.FrameRect(canvas.ClipRect);
  FOR y := 0 TO Pic.height - 1 DO
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      x1 := trunc(x + sin(I * pi * 2 / max) *
        (sin(x / 2) * 4 + cos(y / 3) * 4));
      y1 := trunc(y + (cos(I * pi * 2 / max) - 1) *
        (sin(y / 3) * 4 - cos(x / 2) * 4));
      canvas.Pixels[x, y] := Pic.canvas.Pixels[x1 MOD Pic.Width,
        y1 MOD Pic.height];
    END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim3;
VAR
  x, y, x1, y1: integer;
BEGIN
  FOR y := 0 TO Pic.height - 1 DO
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      x1 := trunc(x + sin(I * pi / max) * (sin(x / 2) * 8 + cos(y / 3) * 8));
      y1 := trunc(y + sin(I * pi / max) * (sin(y / 3) * 8 - cos(x / 2) * 8));
      canvas.Pixels[x, y] := Pic.canvas.Pixels[x1, y1];
    END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim4;

VAR
  x, y, x2, y2, z, wh, wd: integer;
  ph, zz, z1, x1, cp2, sp, sp2: extended;
  cc: C2RGB;
BEGIN
  wd := Pic.Width;
  wh := wd DIV 2;
  IF I = 0 THEN
  BEGIN
    x2 := Random(9) + 1;
    y2 := Random(9) + 1;
    z := Random(8);
    FOR y := 0 TO Pic.height - 1 DO
      FOR x := 0 TO Pic.Width - 1 DO
        CASE z OF
          // Zylinder
          0:
            orgbm2.canvas.Pixels[x, y] :=
              rgb(trunc(sin((x) * 2 * pi / Pic.Width) * 127 + 128),
              trunc(y * 256 / Pic.Width),
              trunc(cos((x) * 2 * pi / Pic.Width) * 127 + 128));
          1:
            orgbm2.canvas.Pixels[x, y] :=
              rgb(trunc(sin((x - wh) * 1.5 * pi / wd) *
              sqrt(sqr(wh) - sqr(y - wh) * 0.71) / wh * 127 + 128),
              trunc(y * 256 / wd),
              trunc(-cos((x - wh) * 1.5 * pi / wd) * sqrt(sqr(wh) - sqr(y - wh)
              * 0.71) / wh * 127 + 128));
          2:
            orgbm2.canvas.Pixels[x, y] :=
              rgb(trunc(-cos(x * x2 * pi / Pic.Width) * 127 + 128),
              trunc(-cos(y * y2 * pi / Pic.Width) * 127 + 128),
              trunc(-sin(y * 2 * pi / Pic.Width) * 127 + 128));
          3:
            orgbm2.canvas.Pixels[x, y] := rgb(Random(256), Random(256),
              Random(256));
          4:
            orgbm2.canvas.Pixels[x, y] := rgb(trunc(x * 256 / wd),
              trunc(y * 256 / wd), Random(256));
          5:
            orgbm2.canvas.Pixels[x, y] := rgb(Random(64), trunc(y * 256 / wd),
              trunc(x * 256 / wd));
          6:
            orgbm2.canvas.Pixels[x, y] := rgb(trunc(y * 256 / wd),
              240 + Random(16), trunc(x * 256 / wd));
          7:
            orgbm2.canvas.Pixels[x, y] := rgb(trunc(x * 256 / wd),
              240 + Random(16), trunc(256 - y * 256 / wd));
        END;
  END;
  ph := I * pi / max;
  sp := sin(ph);
  cp2 := cos(ph * 2);
  sp2 := sin(ph * 2);
  canvas.FillRect(canvas.ClipRect);
  FOR y := 0 TO Pic.height - 1 DO
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      cc.c := orgbm2.canvas.Pixels[x, y];
      zz := ((cc.b[0] + cc.b[1] + cc.b[2] + cc.b[3]) * Pic.Width / (4 * 256)
        - wh) * sp;
      x1 := wh + (x - wh) * cp2 + zz * sp2;
      z1 := (wh - x) * sp2 + zz * cp2;
      y2 := trunc(wh + (y - wh) * (1 - (z1 / (2 * wh))));
      x2 := trunc(wh + (x1 - wh) * (1 - (z1 / (2 * wh))));
      canvas.Pixels[x2, y2] := Pic.canvas.Pixels[x, y];
    END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim5;

VAR
  x, y, x1, x2, y2, z, z1, wh: integer;
  cc: C2RGB;
BEGIN
  wh := Pic.Width DIV 2;
  canvas.FillRect(canvas.ClipRect);
  FOR y := 0 TO Pic.height - 1 DO
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      cc.c := Pic.canvas.Pixels[x, y];
      z := -trunc((cc.b[0] + cc.b[1] + cc.b[2] + cc.b[3]) * Pic.Width /
        (4 * 256)) + wh;
      x1 := trunc(wh + (x - wh) * cos(I * pi * 2 / max) + z *
        sin(I * pi * 2 / max));
      z1 := trunc((wh - x) * sin(I * pi * 2 / max) + z * cos(I * pi * 2 / max));
      y2 := trunc(wh + (y - wh) * (1 - (z1 / (2 * wh) * sin(I * pi / max))));
      x2 := trunc(wh + (x1 - wh) * (1 - (z1 / (2 * wh) * sin(I * pi / max))));
      canvas.Pixels[x2, y2] := Pic.canvas.Pixels[x, y];
    END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim6;
// strudel

VAR
  x, y, x1, y1, wh: integer;
  ph, cp, sp, s1: extended;
  // cc: c2rgb;
BEGIN
  wh := Pic.Width DIV 2;
  // canvas.FillRect(canvas.ClipRect);
  s1 := sin(I * pi / max);
  FOR y := 0 TO Pic.height - 1 DO
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      ph := s1 * (pi * 20 / (sqrt(sqr(x - wh) + sqr(y - wh)) + 5));
      cp := cos(ph);
      sp := sin(ph);
      x1 := trunc(wh + (x - wh) * cp + (y - wh) * sp);
      y1 := trunc(wh + (wh - x) * sp + (y - wh) * cp);
      canvas.Pixels[x, y] := Pic.canvas.Pixels[x1, y1];
    END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim7;
// strudel

VAR
  x, y, x1, y1, z, wh, wd: integer;
  cp, sp, s1, c1, x2, y2: extended;
  cc: C2RGB;
BEGIN
  wd := Pic.Width;
  wh := wd DIV 2;
  IF I = 0 THEN
  BEGIN
    x2 := Random(9) + 1;
    y2 := Random(9) + 1;
    z := Random(8);
    FOR y := 0 TO Pic.height - 1 DO
      FOR x := 0 TO Pic.Width - 1 DO
        CASE z OF
          // Zylinder
          0:
            orgbm2.canvas.Pixels[x, y] :=
              rgb(trunc(sin((x) * 2 * pi / Pic.Width) * 127 + 128),
              trunc(y * 256 / Pic.Width),
              trunc(cos((x) * 2 * pi / Pic.Width) * 127 + 128));
          1:
            orgbm2.canvas.Pixels[x, y] :=
              rgb(trunc(sin((x - wh) * 1.5 * pi / wd) *
              sqrt(sqr(wh) - sqr(y - wh) * 0.71) / wh * 127 + 128),
              trunc(y * 256 / wd),
              trunc(-cos((x - wh) * 1.5 * pi / wd) * sqrt(sqr(wh) - sqr(y - wh)
              * 0.71) / wh * 127 + 128));
          2:
            orgbm2.canvas.Pixels[x, y] :=
              rgb(trunc(-cos(x * x2 * pi / Pic.Width) * 127 + 128),
              trunc(-cos(y * y2 * pi / Pic.Width) * 127 + 128),
              trunc(-sin(y * 2 * pi / Pic.Width) * 127 + 128));
          3:
            orgbm2.canvas.Pixels[x, y] := rgb(Random(256), Random(256),
              Random(256));
          4:
            orgbm2.canvas.Pixels[x, y] := rgb(trunc(x * 256 / wd),
              trunc(y * 256 / wd), Random(256));
          5:
            orgbm2.canvas.Pixels[x, y] := rgb(Random(64), trunc(y * 256 / wd),
              trunc(x * 256 / wd));
          6:
            orgbm2.canvas.Pixels[x, y] := rgb(trunc(y * 256 / wd),
              240 + Random(16), trunc(x * 256 / wd));
          7:
            orgbm2.canvas.Pixels[x, y] := rgb(trunc(x * 256 / wd),
              240 + Random(16), trunc(256 - y * 256 / wd));
        END;
  END;
  // canvas.FillRect(canvas.ClipRect);
  s1 := sin(I * pi / max);
  c1 := 1 - s1;
  sp := sin(I * 2 * pi / max);
  cp := cos(I * 2 * pi / max);
  FOR y := 0 TO Pic.height - 1 DO
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      cc.c := orgbm2.canvas.Pixels[x, y];
      x2 := x * c1 + cc.b[0] * Pic.height / 256 * s1;
      y2 := y * c1 + cc.b[1] * Pic.height / 256 * s1;
      x1 := wh + trunc((x2 - wh) * cp + (y2 - wh) * sp);
      y1 := wh + trunc(-(x2 - wh) * sp + (y2 - wh) * cp);
      canvas.Pixels[x, y] := Pic.canvas.Pixels[x1, y1];
    END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim8;

VAR
  x, y, x2, y2, z, wh, wd: integer;
  ph, xx, yy, zz, z1, x1, cp2, sp, sp2, cp: extended;
  cc: C2RGB;
  oc: Tcolor;
BEGIN
  wd := Pic.Width;
  wh := wd DIV 2;
  IF I = 0 THEN
  BEGIN
    x2 := Random(9) + 1;
    y2 := Random(9) + 1;
    z := Random(8);
    FOR y := 0 TO Pic.height - 1 DO
      FOR x := 0 TO Pic.Width - 1 DO
        CASE z OF
          // Zylinder
          0:
            orgbm2.canvas.Pixels[x, y] :=
              rgb(trunc(sin((x) * 2 * pi / Pic.Width) * 127 + 128),
              trunc(y * 256 / Pic.Width),
              trunc(cos((x) * 2 * pi / Pic.Width) * 127 + 128));
          1:
            orgbm2.canvas.Pixels[x, y] :=
              rgb(trunc(sin((x - wh) * 1.5 * pi / wd) *
              sqrt(sqr(wh) - sqr(y - wh) * 0.71) / wh * 127 + 128),
              trunc(y * 256 / wd),
              trunc(-cos((x - wh) * 1.5 * pi / wd) * sqrt(sqr(wh) - sqr(y - wh)
              * 0.71) / wh * 127 + 128));
          2:
            orgbm2.canvas.Pixels[x, y] :=
              rgb(trunc(-cos(x * x2 * pi / Pic.Width) * 127 + 128),
              trunc(-cos(y * y2 * pi / Pic.Width) * 127 + 128),
              trunc(-sin(y * 2 * pi / Pic.Width) * 127 + 128));
          3:
            orgbm2.canvas.Pixels[x, y] := rgb(Random(256), Random(256),
              Random(256));
          4:
            orgbm2.canvas.Pixels[x, y] := rgb(trunc(x * 256 / wd),
              trunc(y * 256 / wd), Random(256));
          5:
            orgbm2.canvas.Pixels[x, y] := rgb(Random(64), trunc(y * 256 / wd),
              trunc(x * 256 / wd));
          6:
            orgbm2.canvas.Pixels[x, y] := rgb(trunc(y * 256 / wd),
              240 + Random(16), trunc(x * 256 / wd));
          7:
            orgbm2.canvas.Pixels[x, y] := rgb(trunc(x * 256 / wd),
              240 + Random(16), trunc(256 - y * 256 / wd));
        END;
  END;
  ph := I * pi / max;
  sp := sin(ph);
  cp := 1 - sp;
  cp2 := cos((1 - cos(ph)) * pi);
  sp2 := sin((1 - cos(ph)) * pi);
  canvas.FillRect(canvas.ClipRect);
  FOR y := 0 TO Pic.height - 1 DO
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      oc := Pic.canvas.Pixels[x, y];
      IF oc <> TransparentColorValue THEN
      BEGIN
        cc.c := orgbm2.canvas.Pixels[x, y];
        // Ktrans
        zz := -wh * cp + (cc.b[2] * wd / 256 - wh) * sp;
        xx := (x - wh) * cp + (cc.b[0] * wd / 256 - wh) * sp;
        yy := (y - wh) * cp + (cc.b[1] * wd / 256 - wh) * sp;
        // rotor
        x1 := xx * cp2 + zz * sp2;
        z1 := -xx * sp2 + zz * cp2;
        // y1 := yy;
        // 3d
        IF z1 / wh > -1.5 THEN
        BEGIN
          y2 := trunc(wh + yy * (3 / (4 + z1 / wh)));
          x2 := trunc(wh + x1 * (3 / (4 + z1 / wh)));
          canvas.Pixels[x2, y2] := oc; // pic.Canvas.Pixels[x2, y2];
          IF z1 < 0 THEN
            canvas.Pixels[x2 + 1, y2] := oc;
          IF z1 < 5 THEN
            canvas.Pixels[x2, y2 + 1] := oc;
          IF z1 < 10 THEN
            canvas.Pixels[x2 - 1, y2] := oc;
        END;
      END
    END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim9;

VAR
  x, y, wh, wd: integer;
  ph, phv, phr, x2, zz, x1, cp2, sp, cp, yr, xr: extended;
  // cc: c2rgb;
  oc: Tcolor;
BEGIN
  wd := Pic.Width;
  wh := wd DIV 2;
  ph := (I MOD max) * pi / max;
  sp := sqrt(sin(ph));
  cp := pi - sp * (pi - 1);
  cp2 := (1 - cos(ph)) * 0.5;
  // sp2 := sin((1 - cos(ph)) * pi);
  canvas.FillRect(canvas.ClipRect);
  FOR y := 0 TO Pic.height - 1 DO
  BEGIN
    yr := sqrt(sqr(wh * cp) - sqr(y - wh));
    // Vorgezoene berechnung
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      xr := sqr(yr) - sqr(x - wh);
      IF xr > 0 THEN
      BEGIN
        zz := sqrt(xr);
        // Kugel
        phv := ArcTan((x - wh) / zz) / pi / 2 + cp2;
        phr := 0.5 - ArcTan((x - wh) / zz) / pi / 2 + cp2;
        phv := phv - int(phv + 0.5);
        phr := phr - int(phr + 0.5);
        // Kugelvorderseite
        x1 := phv * sqr(cp);
        x2 := phr * sqr(cp);
        // Kugelrückseite
        oc := TransparentColorValue;
        IF (x2 > -0.5) AND (x2 < 0.5) THEN
          oc := Pic.canvas.Pixels[trunc((x2 + 0.5) * wd), y];
        IF (oc = TransparentColorValue) AND (x1 > -0.5) AND (x1 < 0.5) THEN
          oc := Pic.canvas.Pixels[trunc((x1 + 0.5) * wd), y];

        // :=
        canvas.Pixels[x, y] := oc;
      END;
    END
  END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim10;

VAR
  x, y, wh, wd: integer;
  ph, ph2, x1, y1, sp2, cp2, sp, cp: extended;
  // cc: c2rgb;
  oc, nc: Tcolor;
BEGIN
  wd := Pic.Width;
  wh := wd DIV 2;
  ph := (I MOD max) * pi / max;
  sp := sqrt(sin(ph));
  cp := 1 - sp;
  sp := sin(ph);
  ph2 := (1 - cos(ph)) * pi * 0.3;
  cp2 := cos(ph2);
  sp2 := sin(ph2);
  canvas.FillRect(canvas.ClipRect);
  FOR y := 0 TO Pic.height - 1 DO
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      oc := Pic.canvas.Pixels[x, y];
      nc := clblack;
      If (byte(abs(x - wh) Mod 10) In [4, 5]) Or
        (byte(abs(y - wh) Mod 10) In [4, 5]) Then
        nc := clBlue;
      x1 := (x - wh) * cp2 + (y - wh) * sp2;
      y1 := (wh - x) * sp2 + (y - wh) * cp2;
      If (byte(abs(trunc(x1)) Mod 9) In [0, 1, 2, 3, 6, 7, 8, 9]) And
        (byte(abs(trunc(y1)) Mod 9) In [0, 1, 2, 3, 6, 7, 8, 9]) Then
        nc := clblack;

      canvas.Pixels[x, y] :=
        rgb(trunc(C2RGB(oc).b[0] * cp + C2RGB(nc).b[0] * sp),
        trunc(C2RGB(oc).b[1] * cp + C2RGB(nc).b[1] * sp),
        trunc(C2RGB(oc).b[2] * cp + C2RGB(nc).b[2] * sp));
    END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.anim11;

VAR
  x, y, wh, wd: integer;
  ph, ph2, ph3, x1, y1, sp2, cp2, sp3, cp3, sp, cp: extended;
  // cc: c2rgb;
  oc, nc: Tcolor;
BEGIN
  wd := Pic.Width;
  wh := wd DIV 2;
  ph := (I MOD max) * pi / max;
  sp := sqrt(sin(ph));
  cp := 1 - sp;
  sp := sin(ph);
  ph2 := (1 - cos(ph)) * pi * 0.25;
  cp2 := cos(ph2);
  sp2 := sin(ph2);
  ph3 := (1 - cos(ph)) * pi * (-0.125);
  cp3 := cos(ph3);
  sp3 := sin(ph3);
  canvas.FillRect(canvas.ClipRect);
  FOR y := 0 TO Pic.height - 1 DO
    FOR x := 0 TO Pic.Width - 1 DO
    BEGIN
      oc := Pic.canvas.Pixels[x, y];
      nc := clblack;
      x1 := (x - wh) * cp3 + (y - wh) * sp3;
      y1 := (wh - x) * sp3 + (y - wh) * cp3;
      If (byte(abs(trunc(x1)) Mod 10) In [4, 5]) Or
        (byte(abs(trunc(y1)) Mod 10) In [4, 5]) Then
        nc := clBlue;
      x1 := (x - wh) * cp2 + (y - wh) * sp2;
      y1 := (wh - x) * sp2 + (y - wh) * cp2;
      If (byte(abs(trunc(x1)) Mod 9) In [0, 1, 2, 3, 6, 7, 8, 9]) And
        (byte(abs(trunc(y1)) Mod 9) In [0, 1, 2, 3, 6, 7, 8, 9]) Then
        nc := clblack;
      canvas.Pixels[x, y] :=
        rgb(trunc(C2RGB(oc).b[0] * cp + C2RGB(nc).b[0] * sp),
        trunc(C2RGB(oc).b[1] * cp + C2RGB(nc).b[1] * sp),
        trunc(C2RGB(oc).b[2] * cp + C2RGB(nc).b[2] * sp));
    END;
  IF I = max THEN
  BEGIN
    canvas.CopyRect(Pic.canvas.ClipRect, Pic.canvas, Pic.canvas.ClipRect);
  END;
END;

PROCEDURE TAboutBoxform.FormClose(Sender: TObject; VAR Action: TCloseAction);
BEGIN
  if action <> caNone then;
  orgBM.Free;
  orgbm2.Free;
END;

procedure ScaleDPI(Control: TControl; FromDPI: Integer);
var
  n: Integer;
  WinControl: TWinControl;

begin
  if Screen.PixelsPerInch = FromDPI then exit;

  {$IFDEF FPC}
  with Control do begin
    Left:=ScaleX(Left,FromDPI);
    Top:=ScaleY(Top,FromDPI);
    Width:=ScaleX(Width,FromDPI);
    Height:=ScaleY(Height,FromDPI);
    {$IFDEF LCL_Qt}
      Font.Size := 0;
    {$ELSE}
      Font.Height := ScaleY(Font.GetTextHeight('Hg'), FromDPI);
    {$ENDIF}
  end;
  {$ENDIF}

  if Control is TWinControl then begin
    WinControl:=TWinControl(Control);
    if WinControl.ControlCount > 0 then begin
      for n:=0 to WinControl.ControlCount-1 do begin
        if WinControl.Controls[n] is TControl then begin
          ScaleDPI(WinControl.Controls[n],FromDPI);
        end;
      end;
    end;
  end;
end;


Procedure TAboutBoxform.FormCreate(Sender: TObject);
Begin
  SetLength(Anim, 14);
  Anim[0] := anim1;
  Anim[1] := anim2;
  Anim[2] := anim3;
  Anim[3] := anim4;
  Anim[4] := anim5;
  Anim[5] := anim6;
  Anim[6] := anim1_0;
  Anim[7] := anim1_1;
  Anim[8] := anim1_2;
  Anim[9] := anim7;
  Anim[10] := anim8;
  Anim[11] := anim9;
  Anim[12] := anim10;
  Anim[13] := anim11;
  {$ifdef FPC}
  scaleDPI(self,DesignTimePPI);
  {$ENDIF}
End;

PROCEDURE TAboutBoxform.ScrollBar1Change(Sender: TObject);
BEGIN
  IF assigned(FanimateIcon) THEN
    IF visible THEN
      FanimateIcon(orgBM, ProgramIcon.canvas, ScrollBar1.Position,
        ScrollBar1.max);

END;

procedure TAboutBox.Show;
BEGIN
  IF NOT assigned(AboutBox) THEN
    Application.CreateForm(TAboutBoxform, AboutBox);
  AboutBox.Comment :=Fcomment;
  AboutBox.Company := Fcompany;
  if FWebLink <> '' then
    AboutBox.lbl_WebLink.Caption := FWebLink;
  AboutBox.Show;
END;

function TAboutBox.ShowModal: Tmodalresult;
BEGIN
  IF NOT assigned(AboutBox) THEN
    Application.CreateForm(TAboutBoxform, AboutBox);
  AboutBox.Comment :=Fcomment;
  AboutBox.Company := Fcompany;
  if FWebLink <> '' then
    AboutBox.lbl_WebLink.Caption := FWebLink;
  result := AboutBox.ShowModal;
END;

function TAboutBox.FReadLogo: TPicture;

begin
  if assigned(AboutBox) then
    result := AboutBox.ProgramIcon.Picture
  else
    result := nil;
end;

procedure TAboutBox.FSetLogo(NewVal: TPicture);
begin
  IF NOT assigned(AboutBox) THEN
    Application.CreateForm(TAboutBoxform, AboutBox);
  AboutBox.ProgramIcon.Picture := NewVal;
end;

procedure TAboutBox.SetWebLink(AValue: STRING);
begin
  if FWebLink=AValue then Exit;
  FWebLink:=AValue;
end;

END.
