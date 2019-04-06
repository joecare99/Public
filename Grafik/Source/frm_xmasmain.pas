unit frm_XmasMain;

{$mode objfpc}{$H+}
interface

uses
    Classes, Forms, Graphics, ExtCtrls;

type
    { TfrmXmasMain }
    TfrmXmasMain = class(TForm)
        Image1: TImage;
        procedure FormCreate(Sender: TObject);
        procedure FormPaint(Sender: TObject);
    end;

var
    frmXmasMain: TfrmXmasMain;

implementation

{$R *.lfm}

{ TfrmXmasMain }
const
    SquareW = 64;
    gc: extended = sqrt(1.25) - 0.5;
    o: extended = sqrt(2);

function CalcCol(const J,i: extended): TColor;
var
  cc: TColor;
  s: integer;
  a: extended;
  c: extended;
  fh: extended;
  fl: extended;
  f: extended;
  R: extended;
begin
  // Tree-radius
  r := 0.1 + (i - int(i / 10) * 7) - int(i / 40) * (i - 31);
  // flame-data
  f := gc * 80 - j - sin(int(i / 4) * gc * pi + o) * int(i / 4) * 2;
  fh := 0.2 - sin(i * 0.5 * pi) * 1.1;
  fl := -0.2 - abs(sin(i * 0.25 * pi) * 2.3);
  s := 1;
  if sin(int(i / 4) * 4.9) < 0 then
      s := -1;
  // candle-data
  c := gc * 80 - j - sin(int(i / 4) * gc * pi - gc * pi + o) * (int(i / 4) * 2 - 2);
  // apple-data
  a := gc * 80 - j - cos(int(i / 5) * gc * pi + o) * int(i / 5) * 2.5;
  // Compute color-data
  if (I >= 8) and (i < 36) and (f * s < fh) and (f * s > fl) then
      cc := RGBToColor(255, trunc((1 - (fh * 0.2 - fl * 0.2 - abs(f * s * 2 - fl - fh) * 0.2)) * 255), 0)
  else if (I >= 12) and (i < 40) and (abs(c) <= 1) then
      cc := RGBToColor(trunc((c + 1) * 100), trunc((c + 1) * 100), 0)
  else if (I >= 5) and (i < 45) and (abs(a) <= 0.1 +
      sqrt(1 - sqr(i / 2.5 - int(i / 5) * 2 - 1)) * 2.5) then
      cc := RGBToColor(trunc((a - i + int(i / 5) * 5 + 6.2) * 35), 0, 0)
  else if abs(gc * 80 - j) > r then
      cc := RGBToColor(trunc((1 - int(i / (gc * 50))) * abs(i - gc * 50) * 3),
          trunc(int(i / (gc * 50)) * (128 + abs(i - gc * 50) * 5)),
          trunc((1 - int(i / (gc * 50))) * 160 + abs(i - gc * 50) * 3))
  else
      cc := RGBToColor(trunc(int(i / 40) * 128), trunc(
          ((gc * 80 + r - j) / r) * 127), 0);
  Result:=cc;
end;

procedure TfrmXmasMain.FormPaint(Sender: TObject);
var
    I,  yf, xf: extended;
    xMax, iMax, ii, x0, y0, xx, yy: integer;
    bm: TBitmap;
begin
    // Create display-image
    if not assigned(image1) then
      begin
        image1 := TImage.Create(self);
        image1.Parent := self;
        image1.Height := Height;
        image1.Width := Width;
      //  image1.OnPaint := @FormPaint;
       // exit;
      end;
    // Render grafics
    bm:= TBitmap.Create;
    bm.Width:=SquareW;
    bm.Height:=SquareW;
    bm.PixelFormat := pf32bit;
    yf :=   50 / image1.Height;
    xf := 80 / Image1.Width;
    xMax := (image1.Width div SquareW) + 1;
    iMax := xMAx * ((image1.Height div SquareW) + 1);
    for ii := 0 to iMax - 1 do
      begin
        x0 := ii mod xMax;
        y0 := ii div xMax;

        for xx := 0 to SquareW - 1 do
          begin
          i:=(x0 * SquareW + xx)*xf;
            for yy := 0 to SquareW - 1 do
              begin
               // draw pixel
                bm.Canvas.Pixels[xx, yy] := CalcCol(i,(y0 * SquareW + yy)*yf);
              end;

          end;
        Image1.Canvas.Draw(x0*SquareW,y0*SquareW,bm);
   //     Application.ProcessMessages;
      end;
    // Write Merry Xmas
    image1.canvas.Font.Size := image1.Height div 8;
    image1.Canvas.Brush.Style := bsClear;
    image1.canvas.TextOut(image1.Height div 25, trunc(image1.Height * gc), 'Merry');
    image1.canvas.TextOut(image1.Height div 3, (image1.Height * 7) div 9, 'Xmas');
end;

procedure TfrmXmasMain.FormCreate(Sender: TObject);
begin
    // Set Form Size ...
    Height := Screen.Height *9 div 10;
    Width := screen.width*9 div 10;
    Position:=poScreenCenter;
end;

end.
