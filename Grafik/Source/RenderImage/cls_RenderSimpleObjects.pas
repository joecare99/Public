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
begin
  if  (aRay.StartPoint - FPosition) * aRay.Direction < FRadius then

end;

end.

