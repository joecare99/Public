Unit Frm_Plasmatest;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

Type
  TForm8 = Class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Image1: TImage;
    Procedure Timer1Timer(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
    fBitmap: Tbitmap;
    FK: integer;
    Fmatrix: Array Of extended;
    Function Finterp(x, y, z: extended): extended;
    Function plasma(x, y, z: extended): extended;

  public
    { Public-Deklarationen }
  End;

Var
  Form8: TForm8;


Implementation

{$R *.dfm}

Function TForm8.Finterp(x, y, z: extended): extended;
Var
  ix, iy, iz, ix1, iy1, iz1: integer;
  mx, my, mz: extended;
Begin
   ix := trunc(x) Mod 8;
  ix1 := (ix + 1) Mod 8;
  iy := (trunc(y) Mod 8) * 8;
  iy1 := ((trunc(y) + 1) Mod 8) * 8;
  iz := (trunc(z) Mod 8) * 64;
  iz1 := (trunc(z + 1) Mod 8) * 64;
  mx := 0.5 - cos((x - int(x)) * pi) * 0.5;
  my := 0.5 - cos((y - int(y)) * pi) * 0.5;
  mz := 0.5 - cos((z - int(z)) * pi) * 0.5;
  result := Fmatrix[(ix + iy + iz)] * ((1 - mx) * (1 - my) * (1 - mz))
    + Fmatrix[(ix1 + iy + iz)] * ((mx) * (1 - my) * (1 - mz))
    + Fmatrix[(ix + iy1 + iz)] * ((1 - mx) * (my) * (1 - mz))
    + Fmatrix[(ix + iy + iz1)] * ((1 - mx) * (1 - my) * (mz))
    + Fmatrix[(ix1 + iy1 + iz1)] * ((mx) * (my) * (mz))
    + Fmatrix[(ix1 + iy1 + iz)] * ((mx) * (my) * (1 - mz))
     + Fmatrix[(ix + iy1 + iz1)] * ((1 - mx) * (my) * (mz))
    + Fmatrix[(ix1 + iy + iz1)] * ((mx) * (1 - my) * (mz));
End;

Function Finterp2(x, y, z: extended): extended; inline;
Var
  ix, iy, iz, ix1, iy1, iz1: integer;
  mx, my, mz: extended;

Begin
  ix := trunc(x) Mod 8;
  ix1 := (ix + 1) Mod 8;
  iy := (trunc(y) Mod 8) * 8;
  iy1 := ((trunc(y) + 1) Mod 8) * 8;
  iz := (trunc(z) Mod 8) * 64;
  iz1 := (trunc(z + 1) Mod 8) * 64;
  mx := 0.5 - cos((x - int(x)) * pi) * 0.5;
  my := 0.5 - cos((y - int(y)) * pi) * 0.5;
  mz := 0.5 - cos((z - int(z)) * pi) * 0.5;
  result := Form8.Fmatrix[(ix + iy + iz)] * ((1 - mx) * (1 - my) * (1 - mz))
    + Form8.Fmatrix[(ix1 + iy + iz)] * ((mx) * (1 - my) * (1 - mz))
    + Form8.Fmatrix[(ix + iy1 + iz)] * ((1 - mx) * (my) * (1 - mz))
    + Form8.Fmatrix[(ix + iy + iz1)] * ((1 - mx) * (1 - my) * (mz))
    + Form8.Fmatrix[(ix1 + iy1 + iz1)] * ((mx) * (my) * (mz))
    + Form8.Fmatrix[(ix1 + iy1 + iz)] * ((mx) * (my) * (1 - mz))
     + Form8.Fmatrix[(ix + iy1 + iz1)] * ((1 - mx) * (my) * (mz))
    + Form8.Fmatrix[(ix1 + iy + iz1)] * ((mx) * (1 - my) * (mz));
End;

Function TForm8.plasma(x, y, z: extended): extended;
var
  Fi0,xx,yy: Extended;

Begin
  xx:=x*0.25+cos(z*pi*0.5)*4-2;
  yy:=y*0.25+sin(z*pi*0.6)*4-2;
  Fi0:=Finterp(z*2,xx*sin(z*pi)+yy*cos(z*pi)+16+z,-yy*sin(z*pi)+xx*cos(z*pi)+16)*pi*4;
//  result := 0.5 + 0.5 * cos((z * 4 + Finterp2(x +sin(Fi0), y
//    +Cos(Fi0), z {+Finterp2(x,y,z+0.5)})) * 4 * pi);
 result:=Fi0-z*2;
 result:=-Z*6+ (x*0.2 *(Cos(result)))+(y*0.2 *(-sin(Result)));
 result:= 0.9 + 0.091 * sin(sin(cos(result*pi*3)*pi*0.6)*pi*0.6) ;
End;

Function plasma2(x, y, z: extended): extended;
var
  Fi0,xx,yy: Extended;

Begin
  xx:=x*0.25+cos(z*pi*0.25)*4-2;
  yy:=y*0.25+sin(z*pi*0.3)*4-2;
  Fi0:=Finterp2(z*2,xx*sin(z*pi)+yy*cos(z*pi)+16+z,-yy*sin(z*pi)+xx*cos(z*pi)+16)*pi*4;
  result := Z*3 + pi * cos((z  + Finterp2(16+yy +sin(Fi0), 16+xx
    +Cos(Fi0), z {+Finterp2(x,y,z+0.5)})) * 4 * pi);
// result:=Fi0-z*2;
// result:=-Z*12+ (x*0.5 *(Cos(result)))+(y*0.5 *(-sin(Result)));
 result:= 0.9 + 0.091 * sin(sin(cos(result)*pi*0.6)*pi*0.6) ;
End;

Procedure TForm8.FormCreate(Sender: TObject);
Var
  I: Integer;
Begin
  fBitmap := TBitmap.create;
  fBitmap.PixelFormat := pf24bit;
  FBitmap.Width := 256;
  Fbitmap.Height := 256;
  setlength(Fmatrix, 512);
  For I := 0 To 512 - 1 Do
    Fmatrix[i] := random;
End;

procedure TForm8.FormResize(Sender: TObject);
begin
  FBitmap.Width := Image1.Width ;//div 2 ;
  Fbitmap.Height := Image1.height;// div 2;
end;

Procedure TForm8.Timer1Timer(Sender: TObject);
Type
  Tarr = Packed Array[0..512] Of byte;
  PArr = ^TArr;
Var
  pp,qq: PArr;
  I: Integer;
  J: Integer;
  tt: Cardinal;
  lz: extended;
  ly: extended;
  LJ: Integer;
  LI: Integer;
  jj: Integer;
  ii: Integer;
  LDx: extended;
  LDy: extended;
Begin
  tt := GetTickCount;
  FK := (fk +1) mod 4;
  lz := tt / 64000;
  jj:=3- (fk Mod 2)*6;
ii:=1-((fk Mod 4) Div 2) *2;
LDx:=8/fBitmap.Width;
LDy:=8/fBitmap.height;
  For LI := 0 To fBitmap.Height Div 2 - 1 Do
    Begin
      I := LI * 2 + (fk Mod 4) Div 2;

      ly := I * ldy;
      pp := FBitmap.ScanLine[i];
      qq := FBitmap.ScanLine[i+ii];
      For LJ := 0 To fBitmap.Width div 2 - 1 Do
        Begin
          J := (LJ * 2 + (fk Mod 2))*3;
          pp^[J ] := trunc(plasma2(J * ldx, ly, lz) * 256);
          pp^[J  + 1] := pp^[J ];
          pp^[J  + 2] := pp^[J ];

          pp^[J  + jj] := (pp^[J  + jj]+pp^[J]) div 2;
          pp^[J  + jj+1] := pp^[J +jj];
          pp^[J  + jj+1] := pp^[J +jj];
          qq^[j]:=(qq^[j]+qq^[j+jj]) div 2;
          qq^[j+1]:=qq^[j];
          qq^[j+2]:=qq^[j];
          qq^[j+jj]:=qq^[j];
          qq^[j+jj+1]:=qq^[j];
          qq^[j+jj+2]:=qq^[j];
        End;
    End;
  Form8.Caption := inttostr(GetTickCount - tt) + ' ms';
  Image1.Canvas.StretchDraw(rect(0,0,Image1.width,image1.Height), fBitmap);
End;

End.

