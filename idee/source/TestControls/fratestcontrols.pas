unit fraTestControls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls;

type

  { TFrame1 }

  TFrame1 = class(TFrame)
    StaticText2: TStaticText;
    procedure FrameResize(Sender: TObject);
  private
    FFrequency: integer;
    { private declarations }
    Funderlaying: TGraphicControl;
    FValue,FMin,FMax: integer;
    procedure SetFrequency(AValue: integer);
    procedure SetMax(AValue: integer);
    procedure SetMin(AValue: integer);
    procedure SetValue(AValue: integer);
  protected
     procedure Paint; override;
  public
    { public declarations }
    Property Value:integer read FValue write SetValue;
    Property Min:integer read FMin write SetMin;
    Property Max:integer read FMax write SetMax;
    Property Frequency:integer read FFrequency write SetFrequency;
  end;

implementation

{$R *.lfm}

uses graphics;
{ TFrame1 }

procedure TFrame1.FrameResize(Sender: TObject);
begin
  if not assigned(Funderlaying) then
    begin
      Funderlaying := Tshape.Create(self);
      with TShape(Funderlaying) do
        begin
          Parent := self.Parent;
          top := self.top-5;
          left := self.Left-5;
          width := self.Width+10;
          height := self.Height+10;
          shape := stEllipse;
          pen.Color:=clGray;
          brush.Color:=clDkGray;
        end;
    end;
end;

procedure TFrame1.SetValue(AValue: integer);
begin
  if FValue=AValue then Exit;
  FValue:=AValue;
  StaticText2.Caption:=inttostr(FValue);
  Invalidate;
end;

procedure TFrame1.SetMin(AValue: integer);
begin
  if FMin=AValue then Exit;
  FMin:=AValue;
end;

procedure TFrame1.SetMax(AValue: integer);
begin
  if FMax=AValue then Exit;
  FMax:=AValue;
end;

procedure TFrame1.SetFrequency(AValue: integer);
begin
  if FFrequency=AValue then Exit;
  FFrequency:=AValue;
end;

procedure TFrame1.Paint;
var
  i: Integer;
  Grayv: byte;
  Wh: Integer;
  Hh: Integer;

  procedure DrawArc(i:integer;S1,s2:integer);
  var
    cc: ValReal;
    Grayv2: Int64;
    ssh :integer;
    cy: ValReal;
    cx: ValReal;
  begin
    ssh:=(s1+s2) div 2;
    cx:= cos((i+37)/wh);
    cy:= sin((i+37)/wh);
    cc := cos((i)/wh)*0.5;
    Grayv:=trunc((1-sqr(sqr(0.5+cc)))*250);
    Grayv2:=trunc((sqr(sqr(0.5-cc)))*250);
    canvas.pen.color := RGBToColor(Grayv,Grayv2,Grayv2);
    canvas.Line(wh+trunc(cx*s1),wh+trunc(cy*s1),wh+trunc(cx*ssh),wh+trunc(cy*ssh));
    canvas.Line(wh-trunc(cx*s2),wh-trunc(cy*s2),wh-trunc(cx*ssh),wh-trunc(cy*ssh));
//   canvas.Arc(12+cx,12+cy,width-12+cx,height-20+cy, wh+20+cy div 2,height-15,wh-20-cy div 2,height-15);
  end;

  procedure DrawScale(i,mxi:integer;S1,s2:integer);
  var
    cy: ValReal;
    cx: ValReal;
  begin
    cx:= -sin((i/mxi-0.5)*pi*1.4);
    cy:= cos((i/mxi-0.5)*pi*1.4);
    canvas.Line(wh-trunc(cx*s2),wh-trunc(cy*s2),wh-trunc(cx*s1),wh-trunc(cy*s1));
  end;

  procedure DrawInd(i,mxi:integer;S1,s2:integer);
  var
    cy: ValReal;
    cx: ValReal;
    points:array of TPoint;
    oc : TColor;
  begin
    cx:= -sin((i/mxi-0.5)*pi*1.4);
    cy:= cos((i/mxi-0.5)*pi*1.4);
    SetLength(points,4);
    oc:= canvas.Brush.color;
    canvas.Brush.Style := bsSolid;
    canvas.Brush.color := clblack;
    canvas.pen.color:= clDkGray;
    points[0] := point(1+wh-trunc(cx*s1),1+wh-trunc(cy*s1));
    points[2] := point(2+wh+trunc(cx*s2*0.5),2+wh+trunc(cy*s2*0.5));
    points[1] := point(2+wh+trunc((cx+cy*0.2)*s2),2+wh+trunc((cy-cx*0.2)*s2));
    points[3] := point(2+wh+trunc((cx-cy*0.2)*s2),2+wh+trunc((cy+cx*0.2)*s2));
    canvas.Polygon(points);
    canvas.Brush.color := oc;
    canvas.pen.color:= oc;
    points[0] := point(wh-trunc(cx*s1),wh-trunc(cy*s1));
    points[2] := point(wh+trunc(cx*s2*0.5),wh+trunc(cy*s2*0.5));
    points[1] := point(wh+trunc((cx+cy*0.2)*s2),wh+trunc((cy-cx*0.2)*s2));
    points[3] := point(wh+trunc((cx-cy*0.2)*s2),wh+trunc((cy+cx*0.2)*s2));
    canvas.Polygon(points);
    canvas.Brush.color := clblack;
    canvas.pen.color:= clDkGray;
    canvas.Ellipse(wh-4,wh-4,wh+4,wh+4);
  end;


begin
  inherited;
  Wh := width div 2;
  Hh := height div 2;
  Funderlaying.Canvas.Brush.Style:=bsClear;
  Canvas.Brush.Style:=bsClear;
  Funderlaying.canvas.pen.width := 2;
  canvas.pen.width := 2;
  for i := 0 to (width+10) div 2 do
    begin
      Grayv:=trunc(cos(i/4)*30+210);
      Funderlaying.canvas.pen.color := RGBToColor(Grayv,Grayv,grayv);
      canvas.pen.color := RGBToColor(Grayv,Grayv,grayv);
      Funderlaying.Canvas.Ellipse(5+wh-i,5+hh-i,5+wh+i,5+hh+i);
      Canvas.Ellipse(wh-i,hh-i,wh+i,hh+i);
    end;
//
  canvas.pen.width := 2;
  for i := 0 to wh*7 do
    begin
      DrawArc(i,wh-3,wh-12);
//      canvas.Arc(12+cx+cy div 3,12+cy-cx div 3,width-12+cx+cy div 3,height-20+cy-cx div 3,wh+cx *4,hh+cy*4,wh-cx *4,hh-cy*4);
//      canvas.Arc(12+cx,12+cy,width-12+cx,height-20+cy,wh+cx *4,hh+cy*4,wh-cx *4,hh-cy*4);
//      canvas.Arc(12+cx+cy div 3,12+cy-cx div 3,width-12+cx+cy div 3,height-20+cy-cx div 3,wh+cx *4,hh+cy*4,wh-cx *4,hh-cy*4);
    end;
  canvas.pen.width := 4;
  canvas.pen.color := clRed;
  Canvas.Ellipse(8,8,width-8,width-8);
// Scala

  canvas.pen.width := 1;
  canvas.pen.color := clblack;
  For i := 0 to (fMax -Fmin) div FFrequency do
    drawscale(i,(fMax -Fmin) div FFrequency,wh-11,wh-13);
// Zeiger
  canvas.Brush.color := clred;
  DrawInd(FValue-Fmin,(fMax -Fmin),wh-14,wh div 2);
end;

end.

