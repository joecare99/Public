unit frm_laby4;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
    Windows,
{$ELSE}
    LCLIntf, LCLType,
{$ENDIF}
    SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, Buttons, StdCtrls;

type

    { TForm2 }

    TForm2 = class(TForm)
      BitBtn1: TBitBtn;
      BitBtn2: TBitBtn;
        PaintBox1: TPaintBox;
        PaintBox2: TPaintBox;
        Panel1: TPanel;
        procedure BitBtn1Click(Sender: TObject);
        procedure BitBtn2Click(Sender: TObject);
    private
        FZValues: array of array of integer;
        { Private-Deklarationen }
    public
        { Public-Deklarationen }
    end;

var
    Form2: TForm2;


const     Clen = 30;

implementation

{$IFnDEF FPC}
  {$R *.dfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TForm2.BitBtn1Click(Sender: TObject);
var
    x, y, rr: integer;
begin
    rr := random(3) + 2;
    Randomize;
    setlength(FZValues, Clen, Clen);
    // rohdaten
    for x := 0 to Clen - 1 do
        for y := 0 to Clen - 1 do
          begin
            FZValues[x, y] := x + y + random(rr);
            if (x >= 1) and (FZValues[x, y] < FZValues[x - 1, y] - 1) then
                FZValues[x, y] := FZValues[x - 1, y] - 1;
            if (y >= 1) and (FZValues[x, y] < FZValues[x, y - 1] - 1) then
                FZValues[x, y] := FZValues[x, y - 1];
            if (y >= 1) and (x >= 1) and (FZValues[x, y] <
                FZValues[x - 1, y - 1] - 1) then
                FZValues[x, y] := FZValues[x - 1, y - 1] - 1;
          end;
    // nicht verbundene zellen
    for x := 0 to Clen - 1 do
        for y := 0 to Clen - 1 do
          begin
            //    c := 0;
            if (x >= 1) and (abs(FZValues[x, y] - FZValues[x - 1, y]) < 2) and
                (x < Clen - 1) and (abs(FZValues[x, y] - FZValues[x + 1, y]) <
                2) and (y >= 1) and (abs(FZValues[x, y] - FZValues[x, y - 1]) < 2) and
                (y < Clen - 1) and (abs(FZValues[x, y] - FZValues[x, y]) < 2) then
              begin
                if abs(x - (Clen div 2)) > abs(y - (Clen div 2)) then
                    if x > Clen div 2 then
                        FZValues[x, y] := FZValues[x - 1, y] + 1
                    else
                        FZValues[x, y] := FZValues[x + 1, y] - 1
                else if y > Clen div 2 then
                    FZValues[x, y] := FZValues[x, y - 1] + 1
                else
                    FZValues[x, y] := FZValues[x, y + 1] - 1;

              end;

          end;

    PaintBox2.Width:=CLen*10;
    PaintBox2.Height:=CLen*10;
    for x := 0 to Clen - 1 do
        for y := 0 to Clen - 1 do
          begin
            PaintBox2.Canvas.Brush.Color :=
                rgb(FZValues[x, y] * 3, FZValues[x, y] * 3, FZValues[x, y] * 4);
            PaintBox2.Canvas.FillRect(Rect(x * 10, y * 10, (x + 1) *
                10, (y + 1) * 10));
            if (x >= 1) and (abs(FZValues[x, y] - FZValues[x - 1, y]) < 2) then
              begin
                PaintBox2.Canvas.pen.Color := clwhite;
                PaintBox2.Canvas.moveto(x * 10 + 5, y * 10 + 5);
                PaintBox2.Canvas.Lineto(x * 10 - 5, y * 10 + 5);

              end;
            if (y >= 1) and (abs(FZValues[x, y] - FZValues[x, y - 1]) < 2) then
              begin
                PaintBox2.Canvas.pen.Color := clwhite;
                PaintBox2.Canvas.moveto(x * 10 + 5, y * 10 + 5);
                PaintBox2.Canvas.Lineto(x * 10 + 5, y * 10 - 5);

              end;

          end;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);

    procedure Drawbox(x, y, z: integer; DrawHead: boolean);
    var
        x2, y2, L: integer;
        pts: array of TPoint;
    begin
        L := PaintBox1.Canvas.ClipRect.Right div (Clen*4);
        x2 := (Clen - x + y) * L * 2;
        y2 := PaintBox1.Canvas.ClipRect.bottom - (x + y + z + 2) * L;
        setlength(pts, 4);
        pts[0] := point(x2, y2);
        PaintBox1.Canvas.Brush.Color := clLtGray;
        PaintBox1.Canvas.pen.Color := clLtGray;
        pts[1] := point(x2 - L * 2, y2 - L);
        pts[2] := point(x2 - L * 2, y2);
        pts[3] := point(x2, y2 + L);
        PaintBox1.Canvas.Polygon(pts);
        // PaintBox1.Canvas.PolyLine(pts);
        PaintBox1.Canvas.Brush.Color := clDkGray;
        // PaintBox1.Canvas.pen.Color := PaintBox1.Canvas.Brush.Color;
        pts[1] := point(x2 + L * 2, y2 - L);
        pts[2] := point(x2 + L * 2, y2);
        pts[3] := point(x2, y2 + L);
        PaintBox1.Canvas.Polygon(pts);
        PaintBox1.Canvas.Brush.Color := clwhite;
        // PaintBox1.Canvas.pen.Color := PaintBox1.Canvas.Brush.Color;
        if DrawHead then
          begin
            pts[1] := point(x2 + L * 2, y2 - L);
            pts[2] := point(x2, y2 - L * 2);
            pts[3] := point(x2 - L * 2, y2 - L);
            PaintBox1.Canvas.Polygon(pts);
            // PaintBox1.Canvas.PolyLine(pts);
          end;
    end;

var
    x, y, z: integer;

begin
    PaintBox1.Canvas.Brush.Color := Color;
    PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
    for z := 0 to (Clen*2+4) do
        for x := Clen - 1 downto 0 do
            for y := Clen - 1 downto 0 do
                if (FZValues[x, y] >= z) and ((x = 0) or (y = 0) or
                    (z > x + y - 2)) then
                    Drawbox(x, y, z,FZValues[x, y] = z);

end;

end.
