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
  lFootpLen, lOffset: Extended;
begin
  result := false;
  HitData.Distance:=-1.0;
  lFootpLen := (FPosition - aRay.StartPoint ) * aRay.Direction;
  if lFootpLen > 0 then
    begin
      lOffset:= sqrt( abs(sqr((FPosition - aRay.StartPoint ).GLen)-sqr(lFootpLen))) ;
      result := lOffset <= FRadius;
      if result then
        begin
          HitData.Distance:=lFootpLen-sqrt(sqr(FRadius)-sqr(lOffset));
          HitData.HitPoint := HitData.Distance * aRay.Direction + aRay.StartPoint;
          HitData.Normalvec := (HitData.HitPoint - FPosition) / FRadius;
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
begin
  lFootpVec := (FPosition - aRay.StartPoint ) ;
  HitData.Distance:=-1.0;
  Result:=sign(lFootpVec*FNormal) = sign(FNormal*aRay.Direction) ;
  if result then
    begin
      HitData.Distance := lFootpVec*FNormal / (FNormal*aRay.Direction);
      HitData.HitPoint := aRay.StartPoint + HitData.Distance* aRay.Direction;
      HitData.Normalvec := FNormal;
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

end.

