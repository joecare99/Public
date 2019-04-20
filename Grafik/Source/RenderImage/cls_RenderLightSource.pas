unit cls_RenderLightSource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_RenderBase, cls_RenderColor;

type

{ TRenderLightsource }

 TRenderLightsource= Class(TRenderBaseObject)
      Function ProjectedColor(Direction:TRenderVector):TRenderColor;virtual;
      Function FalloffIntensity(Direction:TRenderVector):extended;virtual;
      Function MaxIntensity(Direction:TRenderVector):extended;virtual;
    end;

implementation

uses graphics;
{ TRenderLightsource }

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

end.

