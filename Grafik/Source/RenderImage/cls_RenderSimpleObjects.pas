unit cls_RenderSimpleObjects;

{$mode objfpc}{$H+}
{$interfaces CORBA}

interface

uses
  Classes, SysUtils, cls_RenderBase,cls_RenderColor,cls_RenderBoundary, Graphics;

Type

{ TSimpleObject }

 TSimpleObject=Class(TRenderBaseObject,iHasColor)
      protected
        FBaseColor:TRenderColor;
        FBoundary:TRenderBoundary;
        FSurface:TFTriple;
       public
         destructor Destroy; override;
         Function GetColorAt(Point:TRenderPoint):TRenderColor;virtual;
         Function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
           override;
     end;

     { TSphere }

     TSphere=Class(TSimpleObject)

     private
       FRadius: Extended;
     public
       constructor Create(const aPosition: TRenderPoint; aRadius: extended;
         aBaseColor: TRenderColor );overload;
       constructor Create(const aPosition: TRenderPoint; aRadius: extended;
         aBaseColor: TRenderColor;aSurface:TFTriple );overload;
       function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
     end;

     { TPlane }

     TPlane=Class(TSimpleObject)

     private
       FNormal: TRenderVector;
     public
       constructor Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
         aBaseColor: TRenderColor );overload;
       constructor Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
         aBaseColor: TRenderColor;aSurface:TFTriple );overload;
       function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
       Function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
         override;
     end;

     { TBox }

     TBox=Class(TSimpleObject)

     private
       FSize: TRenderVector;
     public
       constructor Create(const aPosition: TRenderPoint; aSize: TRenderVector;
         aBaseColor: TRenderColor );overload;
       constructor Create(const aPosition: TRenderPoint; aSize: TRenderVector;
         aBaseColor: TRenderColor;aSurface:TFTriple );overload;
       function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
     end;

implementation

uses math;

{ TSimpleObject }

destructor TSimpleObject.Destroy;
begin
  FreeandNil(FBoundary);
  inherited Destroy;
end;

function TSimpleObject.GetColorAt(Point: TRenderPoint): TRenderColor;
begin
  Result:= FBaseColor;
end;

function TSimpleObject.BoundaryTest(aRay: TRenderRay; out Distance: extended
  ): boolean;
begin
  If Assigned(FBoundary) then
    result := FBoundary.BoundaryTest(aRay,Distance)
  else
    begin
      Distance:=(aRay.StartPoint-FPosition).GLen;
      result := (FPosition-aRay.StartPoint)*aray.Direction > Distance*0.5;
    end;
end;

{ TSphere }

constructor TSphere.Create(const aPosition: TRenderPoint; aRadius: extended;
  aBaseColor: TRenderColor);
begin
  Create(aPosition,aRadius,aBaseColor,FTriple(0.4,0.6,0.0));
end;

constructor TSphere.Create(const aPosition: TRenderPoint; aRadius: extended;
  aBaseColor: TRenderColor; aSurface: TFTriple);
begin
  FPosition:= aPosition;
  FRadius := aRadius;
  FBaseColor :=  aBaseColor;
  FBoundary:= TBoundarySphere.Create(aPosition,aRadius);
  FSurface:= aSurface;
end;

function TSphere.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;
var
  lFootpLen, lOffset, lFootvLen: Extended;
  lFootVec: TRenderPoint;
  lInside: Boolean;
begin
  result := false;
  HitData.Distance:=-1.0;
  lFootVec:= (FPosition - aRay.StartPoint );
  lFootvLen := lFootVec.GLen;
  lInside := lFootvLen <= FRadius;
  lFootpLen := lFootVec * aRay.Direction;
  if (lFootpLen > 0) or lInside then
    begin
      lOffset:= sqrt( abs(sqr((FPosition - aRay.StartPoint ).GLen)-sqr(lFootpLen))) ;
      result := lOffset <= FRadius;
      if result then
        begin
          if not lInside then
            begin
          HitData.Distance:=lFootpLen-sqrt(sqr(FRadius)-sqr(lOffset));
          HitData.HitPoint := HitData.Distance * aRay.Direction + aRay.StartPoint;
          HitData.Normalvec := (HitData.HitPoint - FPosition) / FRadius;
            end
          else
          begin
        HitData.Distance:=lFootpLen+sqrt(sqr(FRadius)-sqr(lOffset));
        HitData.HitPoint := HitData.Distance * aRay.Direction + aRay.StartPoint;
        HitData.Normalvec := (FPosition-HitData.HitPoint) / FRadius;
          end;
          HitData.AmbientVal:=FSurface.x;
          HitData.ReflectionVal:=FSurface.y;
          HitData.refraction:=FSurface.z;
        end;
    end;
end;

{ TPlane }

constructor TPlane.Create(const aPosition: TRenderPoint;
  aNormal: TRenderVector; aBaseColor: TRenderColor);
begin
  Create(aPosition,aNormal,aBaseColor,FTriple(0.4,0.6,0.0));
end;

constructor TPlane.Create(const aPosition: TRenderPoint;
  aNormal: TRenderVector; aBaseColor: TRenderColor; aSurface: TFTriple);
begin
  FPosition:= aPosition;
  FNormal := aNormal/aNormal.GLen;
  FBaseColor :=  aBaseColor;
  FBoundary:= nil;
  FSurface:= aSurface;
end;

function TPlane.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;
var
  lFootpVec: TRenderPoint;
  lSgn: TValueSign;
begin
  lFootpVec := (FPosition - aRay.StartPoint ) ;
  HitData.Distance:=-1.0;
  lSgn:=sign(FNormal*aRay.Direction);
  Result:=sign(lFootpVec*FNormal) = lsgn ;
  if result then
    begin
      HitData.Distance := lFootpVec*FNormal / (FNormal*aRay.Direction);
      HitData.HitPoint := aRay.StartPoint + HitData.Distance* aRay.Direction;
      HitData.Normalvec := FNormal *-lsgn;
      HitData.AmbientVal:=FSurface.x;
      HitData.ReflectionVal:=FSurface.y;
      HitData.refraction:=FSurface.z;
    end;
end;

function TPlane.BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
var
  lFootpVec: TRenderPoint;
begin
  lFootpVec := (FPosition - aRay.StartPoint ) ;
  Distance := -1.0;
  Result:=sign(lFootpVec*FNormal) = sign(FNormal*aRay.Direction) ;
  if result then
    Distance := lFootpVec*FNormal / (FNormal*aRay.Direction);
end;

{ TBox }

constructor TBox.Create(const aPosition: TRenderPoint; aSize: TRenderVector;
  aBaseColor: TRenderColor);
begin
  create(aPosition,aSize,aBaseColor,FTriple(0.6,0.4,0));
end;

constructor TBox.Create(const aPosition: TRenderPoint; aSize: TRenderVector;
  aBaseColor: TRenderColor; aSurface: TFTriple);
begin
  FPosition:= aPosition;
  FSize := aSize;
  FBaseColor :=  aBaseColor;
  FBoundary:= TBoundaryBox.Create(aPosition,aSize);
  FSurface:= aSurface;
end;

function TBox.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;

var
  lDist: TRenderPoint;
  lTstPoint: TRenderVector;
  lInside: Boolean;

begin
lDist := FPosition-aray.StartPoint;
lInside:= (abs(ldist.X) < FSize.x*0.5) and
      (abs(ldist.y) < FSize.y*0.5) and
      (abs(ldist.Z) < FSize.z*0.5);

HitData.Distance := -1.0;
if ((ldist.x-FSize.x*0.5>0) and (aray.Direction.x<=0)) or
   ((ldist.x+FSize.x*0.5<0) and (aray.Direction.x>=0)) or
   ((ldist.y-FSize.y*0.5>0) and (aray.Direction.y<=0)) or
   ((ldist.y+FSize.y*0.5<0) and (aray.Direction.y>=0)) or
   ((ldist.z-FSize.z*0.5>0) and (aray.Direction.z<=0)) or
   ((ldist.z+FSize.z*0.5<0) and (aray.Direction.z>=0)) then
     exit(False);

HitData.AmbientVal:=FSurface.x;
HitData.ReflectionVal:=FSurface.y;
HitData.refraction:=FSurface.z;
// Teste XY-Ebene
if abs(aray.Direction.z) > 1e-12 then
  begin
    HitData.Normalvec := FTriple(0,0,-sign(ldist.Z));
    if lInside then
      HitData.Distance := (ldist.Z-HitData.Normalvec.z*0.5*FSize.z)/aRay.Direction.z
    else
      HitData.Distance := (ldist.Z+HitData.Normalvec.z*0.5*FSize.z)/aRay.Direction.z;
    HitData.HitPoint := aray.StartPoint+aRay.Direction*HitData.Distance;
    lTstPoint := HitData.HitPoint-FPosition;
    if (abs(lTstPoint.x) < FSize.x*0.5) and (abs(lTstPoint.y) < FSize.y*0.5) then
      exit(true);
  end;
// Teste XZ-Ebene
if abs(aray.Direction.y) > 1e-12 then
  begin
    HitData.Normalvec := FTriple(0,-sign(ldist.y),0);
    if lInside then
      HitData.Distance := (ldist.y-HitData.Normalvec.y*0.5*FSize.y)/aRay.Direction.y
    else
      HitData.Distance := (ldist.y+HitData.Normalvec.y*0.5*FSize.y)/aRay.Direction.y;
    HitData.HitPoint := aray.StartPoint+aRay.Direction*HitData.Distance;
    lTstPoint := HitData.HitPoint-FPosition;
    if (abs(lTstPoint.x) < FSize.x*0.5) and (abs(lTstPoint.z) < FSize.z*0.5) then
      exit(true);
  end;
// Teste YZ-Ebene
if abs(aray.Direction.x) > 1e-12 then
  begin
    HitData.Normalvec := FTriple(-sign(ldist.x),0,0);
    if lInside then
      HitData.Distance := (ldist.x-HitData.Normalvec.x*0.5*FSize.x)/aRay.Direction.x
    else
      HitData.Distance := (ldist.x+HitData.Normalvec.x*0.5*FSize.x)/aRay.Direction.x;
    HitData.HitPoint := aray.StartPoint+aRay.Direction*HitData.Distance;
    lTstPoint := HitData.HitPoint-FPosition;
    if (abs(lTstPoint.y) < FSize.y*0.5) and (abs(lTstPoint.z) < FSize.z*0.5) then
      exit(true);
  end;
HitData.Distance := -1.0;
result :=false;
end;

end.

