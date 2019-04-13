unit frm_plasmamain;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, {$IFDEF FPC} FileUtil,  {$ENDIF}Forms, Controls,
  Graphics, Dialogs, ExtCtrls, unt_2dPlasmaFktn,
  Buttons, StdCtrls, ComCtrls;

type
  { TForm1 }

  TForm1 = class(TForm)
    btnPerlin: TBitBtn;
    btnyGrad: TBitBtn;
    btnHexGrad: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    IdleTimer1: TIdleTimer;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure btnPerlinClick(Sender: TObject);
    procedure btnyGradClick(Sender: TObject);
    procedure btnHexGradClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    Fw: double;
    FGradient: TGradient;
    FBitmap: TBitmap;
    FNoiseFkt: TNoiseFktn;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  cc, rr, gg: byte;
  ix: integer;
  iy: integer;
  x0: integer;
  y0: integer;
  lZoom, lOffsetx, lOffsety, lRadius: Extended;
  lPhase: Double;
begin
  // Debug
  FGradient[12, 22].x := sin(fw);
  FGradient[12, 22].y := cos(fw);
  FGradient[13, 25].x := cos(fw);
  FGradient[13, 25].y := sin(fw);

  if assigned(FNoiseFkt) then
  begin
    case trunc(fw * 10) mod 4 of
      0:
      begin
        x0 := 0;
        y0 := 0;
      end;
      1:
      begin
        x0 := 1;
        y0 := 0;
      end;
      2:
      begin
        x0 := 1;
        y0 := 1;
      end;
      3:
      begin
        x0 := 0;
        y0 := 1;
      end;
    end;
    lZoom := 1.25 / TrackBar1.Position;
    lRadius := ((high(FGradient)-1)-PaintBox1.Width*lZoom*0.5)*0.45;
    lOffsetx := sin(Fw * 0.01) * lRadius +
          lRadius;
    lOffsety := cos(Fw * 0.01) * lRadius +
                lRadius;
    lPhase := 8 * pi ;
    for ix := 0 to PaintBox1.Width div 2 do
      for iy := 0 to PaintBox1.Height div 2 do
      begin
        cc := trunc(sin(FNoiseFkt(ix * lZoom + lOffsetx, iy * lZoom + lOffsety, FGradient) *
          lPhase+ Fw * 1) * 127) + 128;
        FBitmap.Canvas.Pixels[ix * 2 + x0, iy * 2 + y0] := RGBToColor(cc, cc, cc);
      end;
  end;
  PaintBox1.canvas.Draw(0, 0, FBitmap);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Fw := fw + 0.1;
  PaintBox1.Invalidate;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  x: integer;
  y: integer;
  ww: extended;
begin
  RandSeed := 0;
  FBitmap := TBitmap.Create;
  FBitmap.Width := PaintBox1.Width;
  FBitmap.Height := PaintBox1.Height;
  setlength(FGradient, 32, 32);
  ww := 0.0;
  FNoiseFkt := perlin;
  for x := 0 to 31 do
    for y := 0 to 31 do
    begin
      //        ww:=x*pi-y*pi;
      //        ww:= random*2*pi;
      //        FGradient[x,y].x := sin(ww);
      //        FGradient[x,y].y := cos(ww);
      FGradient[x, y].x := random * 2 - 1;
      FGradient[x, y].y := random * 2 - 1;
    end;
end;

procedure TForm1.btnPerlinClick(Sender: TObject);
begin
  FNoiseFkt := perlin;
end;

procedure TForm1.btnyGradClick(Sender: TObject);
begin
  FNoiseFkt := yGrad;
end;

procedure TForm1.btnHexGradClick(Sender: TObject);
begin
  FNoiseFkt := HexGrad;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  FNoiseFkt := HexGrad0;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  FNoiseFkt := HexGrad2;
end;


end.
