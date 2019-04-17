unit cls_RenderBoundary;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_RenderBase;

Type TRenderBoundary= Class(TRenderBaseObject);

  { TBoundarySphere }

  TBoundarySphere = class(TRenderBoundary)
    Protected
      FBoundingRadius:Extended;
    public
      Constructor Create(aPosition:TRenderPoint;aRAdius:extended);
      Function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean; override;
  end;

  { TBoundaryBox }

  TBoundaryBox = class(TRenderBoundary)
    Protected
      FBoxSize:TRenderPoint;
    public
      Constructor Create(aPosition:TRenderPoint;aSize:TRenderPoint);
      Function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean; override;
  end;


implementation

uses math;
{ TBoundaryBox }

constructor TBoundaryBox.Create(aPosition: TRenderPoint; aSize: TRenderPoint);
begin
  FPosition := aPosition;
  FBoxSize := aSize;
end;

function TBoundaryBox.BoundaryTest(aRay: TRenderRay; out Distance: extended
  ): boolean;
var
  lDist,lTstPoint: TRenderPoint;
begin
  lDist := FPosition-aray.StartPoint;
  Distance := -1.0;
  if ((ldist.x-FBoxSize.x*0.5>0) and (aray.Direction.x<=0)) or
     ((ldist.x+FBoxSize.x*0.5<0) and (aray.Direction.x>=0)) or
     ((ldist.y-FBoxSize.y*0.5>0) and (aray.Direction.y<=0)) or
     ((ldist.y+FBoxSize.y*0.5<0) and (aray.Direction.y>=0)) or
     ((ldist.z-FBoxSize.z*0.5>0) and (aray.Direction.z<=0)) or
     ((ldist.z+FBoxSize.z*0.5<0) and (aray.Direction.z>=0)) then
       exit(False);
  // Teste XY-Ebene
  if abs(aray.Direction.z) > 1e-12 then
    begin
      Distance := (ldist.Z-sign(ldist.Z)*0.5*FBoxSize.z)/aRay.Direction.z;
      lTstPoint:=aray.StartPoint-FPosition+aRay.Direction*Distance;
      if (abs(lTstPoint.x) > FBoxSize.x*0.5) and (abs(lTstPoint.y) < FBoxSize.y*0.5) then
        exit(true);
    end;
  // Teste XZ-Ebene
  if abs(aray.Direction.y) > 1e-12 then
    begin
      Distance := (ldist.y-sign(ldist.y)*0.5*FBoxSize.y)/aRay.Direction.y;
      lTstPoint:=aray.StartPoint-FPosition+aRay.Direction*Distance;
      if (abs(lTstPoint.x) > FBoxSize.x*0.5) and (abs(lTstPoint.z) < FBoxSize.z*0.5) then
        exit(true);
    end;
  // Teste YZ-Ebene
  if abs(aray.Direction.x) > 1e-12 then
    begin
      Distance := (ldist.x-sign(ldist.x)*0.5*FBoxSize.x)/aRay.Direction.x;
      lTstPoint:=aray.StartPoint-FPosition+aRay.Direction*Distance;
      if (abs(lTstPoint.y) > FBoxSize.y*0.5) and (abs(lTstPoint.z) < FBoxSize.z*0.5) then
        exit(true);
    end;
  Distance := -1.0;
  result :=false;
end;

{ TBoundarySphere }

constructor TBoundarySphere.Create(aPosition: TRenderPoint; aRAdius: extended);
begin
  FPosition:=aPosition;
  FBoundingRadius:=aRadius;
end;

function TBoundarySphere.BoundaryTest(aRay: TRenderRay; out Distance: extended
  ): boolean;
var
  lVecToPos: TRenderPoint;
  llDist,lqDistq: Extended;
begin
  lVecToPos := (FPosition-aray.StartPoint);
  llDist := lVecToPos*aRay.Direction;
  lqDistq := lVecToPos*lVecToPos - sqr(llDist);
  Result := lqdistq <= sqr(FBoundingRadius);
  if result then
    Distance:=llDist-Sqrt(sqr(FBoundingRadius)-lqDistq)
  else
    Distance:=-1.0;
end;

end.

