unit cls_RenderLightSource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_RenderBase, cls_RenderColor;

type

{ TRenderLightsource }

 TRenderLightsource= Class(TRenderBaseObject)
      Constructor Create(aPos:TRenderPoint);
      Function ProjectedColor({%H-}Direction:TRenderVector):TRenderColor;virtual;
      Function FalloffIntensity(Direction:TRenderVector):extended;virtual;
      Function MaxIntensity(Direction:TRenderVector):extended;virtual;
      function BoundaryTest({%H-}aRay: TRenderRay; out Distance: extended): boolean; override;
      function HitTest({%H-}aRay: TRenderRay; out HitData: THitData): boolean; override;
    end;

implementation

uses graphics;
{ TRenderLightsource }

constructor TRenderLightsource.Create(aPos: TRenderPoint);
begin
  FPosition := aPos;
end;

function TRenderLightsource.ProjectedColor(Direction: TRenderVector
  ): TRenderColor;
begin
  result := clWhite;
end;

function TRenderLightsource.FalloffIntensity(Direction: TRenderVector
  ): extended;
begin
  result := 1.0/sqr(Direction.GLen);
end;

function TRenderLightsource.MaxIntensity(Direction: TRenderVector): extended;
begin
  result := 1.0/sqr(Direction.GLen);
end;

function TRenderLightsource.BoundaryTest(aRay: TRenderRay; out
  Distance: extended): boolean;
begin
  Distance:=-1.0;
  result :=false;
end;

function TRenderLightsource.HitTest(aRay: TRenderRay; out HitData: THitData
  ): boolean;
begin
  result := false;
end;

end.

