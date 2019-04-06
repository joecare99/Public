unit frm_DrawLinkMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ButtonPanel,
  ComCtrls, ExtCtrls, unt_DrawLink;

type

  { TfrmDrawLinkMain }

  TfrmDrawLinkMain = class(TForm)
    ButtonPanel1: TButtonPanel;
    PaintBox1: TPaintBox;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    FDrawPoints: TLinksWorker;
    FFontIdx:integer;
  public
    { public declarations }
  end;

var
  frmDrawLinkMain: TfrmDrawLinkMain;

implementation

{$R *.lfm}

uses Math, GraphMath;

function Betr(aFP: TFloatPoint): extended; inline;

begin
  Result := sqrt(sqr(aFP.x) + sqr(aFP.y));
end;

{ TfrmDrawLinkMain }

procedure TfrmDrawLinkMain.Timer1Timer(Sender: TObject);
var
  tPlace, testpl, tPl2, tPl3: TFloatPoint;
  i, ia, i2, ix2, ix3: integer;
  tBtr, tBtr2, tBtr3, TestBtr: extended;
  idx: TArrayOfInteger;

  function WechselWrk(aDist: extended): extended; inline;

  begin
    if adist = 0.0 then
      result := 0.0
    else if aDist < 2.0 then
      Result := -1/ sqr(aDist/2)  + 2.0
    else if aDist < 3.0 then
      Result := aDist * -1 + 3
    else
      Result := 0.0;
  end;

begin
   FFontIdx := (FFontIdx+1) mod FDrawPoints.PointCount ;
   FDrawPoints.SetPoint(FFontIdx, FloatPoint(0, 0.5),
      FloatPoint(3, 0));
   FDrawPoints.AnimationStep(2);
  for i := 0 to FDrawPoints.PointCount - 1 do
  begin
    with FDrawPoints.GetPoint(i) do
    begin
      tPlace := Actual;
      ix2 := -1;
      ix3 := -1;
      FDrawPoints.setVelocity(i,Velocity*0.99);
    end;
    tPl2 := FloatPoint(-1, -1);
    tBtr2 := Betr(tPlace - tPl2);
    tPl3 := FloatPoint(-1, -1);
    tBtr3 := Betr(tPlace - tPl3);
    for ia := 0 to 3 do
      if (ia = 0) or (not FDrawPoints.SameIndex(
        tplace + FloatPoint(-0.015, -0.015), tplace +
        FloatPoint(((ia mod 2) - 0.5) * 0.03, ((ia div 2) - 0.5) * 0.03))) then
      begin
        idx := FDrawPoints.GetIndex(tplace + FloatPoint(
          ((ia mod 2) - 0.5) * 0.02, ((ia div 2) - 0.5) * 0.02));
        for i2 := 0 to high(idx) do
        begin

          testpl := FDrawPoints.GetPoint(idx[i2]).Actual;
          TestBtr := Betr(tPlace - testpl);
          with FDrawPoints.GetPoint(i) do
            FDrawPoints.setVelocity(i, Velocity + (testpl - tPlace) * WechselWrk(
              testBtr * 50.0) * 0.1);
          if (tBtr2 >= TestBtr) and (TestBtr < 0.03) and (idx[i2] <> i)
            then
          begin
            tpl3 := tpl2;
            tBtr3 := tBtr2;
            tpl2 := testpl;
            tBtr2 := TestBtr;
            ix2 := idx[i2];
          end
          else if (tBtr3 > TestBtr) and (TestBtr < 0.03) and (idx[i2] <> i)
          then
          begin
            tpl3 := testpl;
            tBtr3 := TestBtr;
            ix3 := idx[i2];
          end;
        end;
      end;
    FDrawPoints.SetLinks(i,0,ix2);
    FDrawPoints.SetLinks(i,1,ix3);
  end;

  PaintBox1.Invalidate;
end;

procedure TfrmDrawLinkMain.FormCreate(Sender: TObject);
var
  i: integer;
begin
  FDrawPoints := TLinksWorker.Create(1000);
  for i := 0 to FDrawPoints.PointCount - 1 do
    FDrawPoints.SetPoint(i, FloatPoint(sqr(random), sqr(random)),
      FloatPoint(random - 0.5, random - 0.5));
end;

procedure TfrmDrawLinkMain.PaintBox1Paint(Sender: TObject);
var
  tPlace, tPl2, tPl3: TFloatPoint;
  i, ix2, ix3, cc: integer;

begin
  for i := 0 to FDrawPoints.PointCount - 1 do
  begin
    with FDrawPoints.GetPoint(i) do
    begin
      tPlace := Actual;
      ix2 := Links[0];
      ix3 := Links[1];
    end;
    if ix2 < 0 then
      PaintBox1.Canvas.Pixels[trunc(tplace.x * PaintBox1.Width),
        trunc(tPlace.Y * PaintBox1.Height)] := clBlack
    else
    begin
      tpl2 := FDrawPoints.GetPoint(ix2).Actual;
      cc := min(trunc(Betr(tPlace - tPl2) * 12500), 255);
      PaintBox1.Canvas.pen.Color := RGBToColor(cc, cc, cc);
      PaintBox1.Canvas.Line(trunc(tplace.x * PaintBox1.Width), trunc(
        tPlace.Y * PaintBox1.Height),
        trunc(tPl2.x * PaintBox1.Width), trunc(tPl2.Y * PaintBox1.Height));
      if ix3 >= 0 then
      begin
        tpl3 := FDrawPoints.GetPoint(ix3).Actual;
        cc := min(trunc(Betr(tPlace - tpl3) * 12500), 255);
        PaintBox1.Canvas.pen.Color := RGBToColor(cc, cc, cc);
        PaintBox1.Canvas.Line(trunc(tplace.x * PaintBox1.Width),
          trunc(tPlace.Y * PaintBox1.Height),
          trunc(tPl3.x * PaintBox1.Width), trunc(tPl3.Y * PaintBox1.Height));
      end;
    end;
  end;
end;

end.
