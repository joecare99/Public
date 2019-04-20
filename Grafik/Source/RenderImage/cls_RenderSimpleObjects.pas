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
         aBaseColor: TRenderColor);
       function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
     end;

implementation


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
  FPosition:= aPosition;
  FRadius := aRadius;
  FBaseColor :=  aBaseColor;
  FBoundary:= TBoundarySphere.Create(aPosition,aRadius);
end;

function TSphere.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;
var
  lFootpLen, lOffset: Extended;
begin
  result := false;
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
        end;
    end;
end;

end.

