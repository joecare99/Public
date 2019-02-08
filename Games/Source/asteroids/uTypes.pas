unit uTypes;

{$mode delphi}

interface

uses
  Classes, SysUtils;

Const RadCon = Pi / 180;
  r045: Single = RadCon * 045;
  r360: Single = RadCon * 360;
  RockAnomaly: Single = 0.25; {zero = spheres}

Type

{ TFloatPoint }

 TFloatPoint = Record
    x, y: Single;
    function pLength:single;
    Function Add(p:TFloatPoint):TFloatPoint;
    Function Sub(p:TFloatPoint):TFloatPoint;
    Function Summ(p:TFloatPoint):TFloatPoint;
    Function Diff(p:TFloatPoint):TFloatPoint;
    Function sMult(p:single):TFloatPoint;
    Function vMult(p:TFloatPoint):single;
    Function xMult(p:TFloatPoint):TFloatPoint;
    Function Angle:single;
  End;

  { TVector }

  TVector = Record
    Direction, Distance: Single;
    function ToPoint:TFloatPoint;
  End;

  Function PointSingle(x,y:single):TFloatPoint;inline;
  Function Vector(aDir,aDist:single):TVector;inline;

const
  ZeroPnt:TFloatPoint=(x:0.0;y:0.0);

implementation

Function PointSingle(x,y:single):TFloatPoint;inline;
begin
  result.x:=x;
  result.y:=y;
end;

function Vector(aDir, aDist: single): TVector;
begin
  result.Direction:=aDir;
  result.Distance:=aDist;
end;

{ TVector }

function TVector.ToPoint: TFloatPoint;
begin
  result.x := cos(Direction)*Distance;
  result.y := sin(Direction)*Distance;
end;

{ TFloatPoint }

function TFloatPoint.pLength: single;
begin
  result:=sqrt(sqr(x)+sqr(y));
end;

function TFloatPoint.Add(p: TFloatPoint): TFloatPoint;
begin
  x:=x+p.x;
  y:=y+p.y;
  result:=self;
end;

function TFloatPoint.Sub(p: TFloatPoint): TFloatPoint;
begin
  x:=x-p.x;
  y:=y-p.y;
  result:=self;
end;

function TFloatPoint.Summ(p: TFloatPoint): TFloatPoint; inline;
begin
  result.x:=x+p.x;
  result.y:=y+p.y;
end;

function TFloatPoint.Diff(p: TFloatPoint): TFloatPoint; inline;
begin
  result.x:=x-p.x;
  result.y:=y-p.y;
end;

function TFloatPoint.sMult(p: single): TFloatPoint;
begin
  result.x:=x*p;
  result.y:=y*p;
end;

function TFloatPoint.vMult(p: TFloatPoint): single; inline;
begin
  result:= x*p.x+y*p.y;
end;

function TFloatPoint.xMult(p: TFloatPoint): TFloatPoint; inline;
begin
  result.x := x*p.x - y*p.y;
  result.y := x*p.y + y*p.x;
end;

function TFloatPoint.Angle: single;
const eps  = 1e-20;
var
  lQuot: Single;
begin
  if abs(x) < eps then
    if abs(y) <eps then
       result := 0.0
    else  if y<0 then
       result := -0.5*pi
    else
      result := 0.5*pi
  else if abs(y) <eps then
     if x<0 then
       result :=  pi
     else
       result := 0.0
  else if abs(x)>abs(y) then
    begin
      lQuot := y/x;
      if x >0 then
         result := arctan(lQuot)
      else if y>0 then
        result := pi+arctan(lQuot)
      else
        result := -pi+arctan(lQuot)
    end
  else
  begin
    lQuot := x/y;
    if y >0 then
       result := 0.5*pi-arctan(lQuot)
    else
      result := -0.5*pi-arctan(lQuot)
  end

end;

end.

