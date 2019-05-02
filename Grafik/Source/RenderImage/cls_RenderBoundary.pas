unit cls_RenderBoundary;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_RenderBase;

Type

{ TRenderBoundary }

 TRenderBoundary= Class(TRenderBaseObject)
    function HitTest(aRay: TRenderRay; out {%H-}HitData: THitData): boolean; override;
    Constructor Create(aPosition:TRenderPoint);
  end;

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

  { TBoundaryCylinder }

  TBoundaryCylinder = class(TRenderBoundary)
    Protected
      FBoxSize:TRenderPoint;
      FNormal:TRenderVector;
      FHHeight,
      FRadius:extended;
    public
      Constructor Create(aPosition:TRenderPoint;aNormal:TRenderPoint;Height,Radius:extended);
      Function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean; override;
  end;

  { TBoundaryHollowCylinder }

  TBoundaryHollowCylinder = class(TBoundaryCylinder)
    Protected
      FRadiusInner:extended;
    public
      Constructor Create(aPosition:TRenderPoint;aNormal:TRenderPoint;Height,Radius1,Radius2:extended);
      Function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean; override;
  end;



implementation

uses math;

{ TRenderBoundary }

function TRenderBoundary.{%H-}HitTest(aRay: TRenderRay; out HitData: THitData
  ): boolean;
begin
  raise(EAbstractError.Create('HitTest should not be called in a Boundary-Object'));
end;

constructor TRenderBoundary.Create(aPosition: TRenderPoint);
begin
  FPosition := aPosition;
end;

{ TBoundaryBox }

constructor TBoundaryBox.Create(aPosition: TRenderPoint; aSize: TRenderPoint);
begin
  inherited Create(aPosition);
  FBoxSize := aSize;
end;

function TBoundaryBox.BoundaryTest(aRay: TRenderRay; out Distance: extended
  ): boolean;
var
  lDist,lTstPoint: TRenderPoint;
begin
  lDist := FPosition-aray.StartPoint;
  if (abs(ldist.X) < FBoxSize.x*0.5) and
     (abs(ldist.y) < FBoxSize.y*0.5) and
     (abs(ldist.Z) < FBoxSize.z*0.5) then
     begin
       // Startpoint is Inside
       Distance := 0.0;
       exit(true);
     end;
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
      lTstPoint:=aray.RayPoint(Distance)-FPosition;
      if (abs(lTstPoint.x) <= FBoxSize.x*0.5) and (abs(lTstPoint.y) <= FBoxSize.y*0.5) then
        exit(true);
    end;
  // Teste XZ-Ebene
  if abs(aray.Direction.y) > 1e-12 then
    begin
      Distance := (ldist.y-sign(ldist.y)*0.5*FBoxSize.y)/aRay.Direction.y;
      lTstPoint:=aray.RayPoint(Distance) -FPosition;
      if (abs(lTstPoint.x) <= FBoxSize.x*0.5) and (abs(lTstPoint.z) <= FBoxSize.z*0.5) then
        exit(true);
    end;
  // Teste YZ-Ebene
  if abs(aray.Direction.x) > 1e-12 then
    begin
      Distance := (ldist.x-sign(ldist.x)*0.5*FBoxSize.x)/aRay.Direction.x;
      lTstPoint:=aray.RayPoint(Distance)-FPosition;
      if (abs(lTstPoint.y) <= FBoxSize.y*0.5) and (abs(lTstPoint.z) <= FBoxSize.z*0.5) then
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
  if (lVecToPos.glen<=FBoundingRadius) then
    begin
      Distance:=0.0;
      exit (true);
    end
  else
    Distance:=-1.0;
  llDist := lVecToPos*aRay.Direction;
  if llDist < 0 then
    exit(false);
  lqDistq := lVecToPos*lVecToPos - sqr(llDist);
  Result := lqdistq <= sqr(FBoundingRadius);
  if result then
    Distance:=llDist-Sqrt(sqr(FBoundingRadius)-lqDistq)
end;

{ TBoundaryCylinder }

constructor TBoundaryCylinder.Create(aPosition: TRenderPoint;
  aNormal: TRenderPoint; Height, Radius: extended);
begin
  inherited Create(aPosition);
  FNormal := aNormal / aNormal.GLen;
  FHHeight:=Height;
  FRadius:=Radius;

end;

function TBoundaryCylinder.BoundaryTest(aRay: TRenderRay; out Distance: extended
  ): boolean;
var
    lFootVec, lOrthVec, lOrtoDirVec, lStartVec: TRenderVector;
    lDist, lFootvInnerVProd: extended;
    lSPDist: ValReal;
    lSgn: TValueSign;
begin
    lSgn := sign(FNormal * aray.Direction);
    lStartVec := aray.StartPoint-FPosition;
    lFootVec := FNormal * -lSgn*FHHeight - lStartVec;
    lSPDist := -lStartVec * FNormal ;
    if (abs(lSPDist) < FHHeight) and ((lStartVec + lSPDist *
        FNormal).glen < Fradius) then
      begin
        Distance := 0.0;
        exit(True);
      end;
    // Definitive outside
    lOrthVec := aray.Direction.XMul(FNormal);
    if (lOrthVec.MLen <> 0) then
      begin
        lDist := (lOrthVec * lFootVec) / lOrthVec.GLen;
        Distance := -1.0;
        if abs(lDist) > FRadius then
            exit(False);
      end;
    lFootvInnerVProd := lFootVec * FNormal;
    if (sign(lFootvInnerVProd) = lsgn) and (lsgn <> 0) then
      begin
        Distance := lFootvInnerVProd / (FNormal * aRay.Direction);
        if (aRay.Direction* Distance - lFootVec).Glen <= FRadius then
            exit(True);
      end;
    Distance := -1;
    if (lOrthVec.MLen = 0) then
        exit(False);
    lOrtoDirVec := aray.Direction - (aray.Direction * FNormal) * FNormal;
    Distance := lOrtoDirVec * lFootVec / sqr(lOrtoDirVec) - sqrt(
        sqr(FRadius) - sqr(lDist)) / lOrtoDirVec.glen;
    if (Distance >= 0) and (abs(
        ( aray.Direction*Distance + lStartVec) * FNormal) <= FHHeight) then
        exit(True);
    Distance := -1;
    Result := False;
end;

{ TBoundaryHollowCylinder }

constructor TBoundaryHollowCylinder.Create(aPosition: TRenderPoint;
  aNormal: TRenderPoint; Height, Radius1, Radius2: extended);
begin
  inherited Create(aPosition,aNormal,Height,Radius1);
  FRadiusInner:=Radius2;
end;

function TBoundaryHollowCylinder.BoundaryTest(aRay: TRenderRay; out
  Distance: extended): boolean;
var
  lSgn: TValueSign;
  lStartVec,lFootVec,lOrtoDirVec: TRenderVector;
  lSPDist, lFootvInnerVProd: Extended;
  lDist: ValReal;
begin
  Result := inherited BoundaryTest(aRay,Distance);
  if Distance = 0.0 then
    begin;
      // Inside Outer Cylinder
      lSgn := sign(FNormal * aray.Direction);
      lStartVec := aray.StartPoint-FPosition;
      lFootVec := FNormal * (-lSgn)*FHHeight - lStartVec;
      lSPDist := -lStartVec * FNormal * FHHeight;
      if (abs(lSPDist) < FHHeight) and ((lFootVec - lSPDist *
          FNormal).glen > FRadiusInner) then
        begin
          Distance := 0.0;
          exit(True);
        end;
      lFootvInnerVProd := lFootVec * FNormal;
      if (sign(lFootvInnerVProd) = lsgn) and (lsgn <> 0) then
        begin
          // Test: Hit the Top/Floor
          Distance := lFootvInnerVProd / (FNormal * aRay.Direction);
          if (aRay.Direction*Distance - lFootVec).Glen <= FRadius then
              exit(True);
        end;

      lOrtoDirVec := aray.Direction - (aray.Direction * FNormal) * FNormal;
      lDist := sqrt(sqr(lStartVec + lSPDist * FNormal)-sqr(lOrtoDirVec*lStartVec/lOrtoDirVec.glen )) ;
      Distance := lOrtoDirVec * lFootVec / sqr(lOrtoDirVec.glen) - sqrt(
          sqr(FRadius) - sqr(lDist)) / lOrtoDirVec.glen;
      if (Distance >= 0) and (abs(
          ( aray.Direction*Distance + lStartVec) * FNormal) <= FHHeight) then
          exit(True);

    end;
end;


end.

