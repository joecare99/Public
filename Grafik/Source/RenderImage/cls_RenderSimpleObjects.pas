unit cls_RenderSimpleObjects;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_RenderBase, Graphics;

Type TSimpleObject=Class(TRenderBaseObject)
      protected
        FBaseColor:TColor;
     end;

     { TSphere }

     TSphere=Class(TSimpleObject)

     private
       FRadius: Extended;
     public
       constructor Create(const aPosition: TRenderPoint; aRadius: extended;
         aBaseColor: TColor);
       function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
     end;

implementation

{ TSphere }

constructor TSphere.Create(const aPosition: TRenderPoint; aRadius: extended;
  aBaseColor: TColor);
begin
  FPosition:= aPosition;
  FRadius := aRadius;
  FBaseColor :=  aBaseColor;
end;

function TSphere.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;
var
  lFootpLen, lOffset: Extended;
begin
  result := false;
  lFootpLen := (FPosition - aRay.StartPoint ) * aRay.Direction;
  if lFootpLen > 0 then
    begin
      lOffset:= sqrt( sqr((FPosition - aRay.StartPoint ).GLen)-sqr(lFootpLen)) ;
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

