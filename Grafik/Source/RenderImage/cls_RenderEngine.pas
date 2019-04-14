unit cls_RenderEngine;

{$IFDEF FPC} {$mode objfpc}{$H+}       {$ENDIF}

interface

uses
  Classes, SysUtils, cls_RenderBase,cls_RenderCamera,graphics;

type

{ TRenderEngine }

 TRenderEngine=Class
   private
    FObjects:array of TRenderBaseObject;
    FLightSources:array of TRenderBaseObject;
    FCamera:TRenderCamera;
    FResult:TBitmap;
  public
    Constructor Create;
    Function Trace(Ray:TRenderRay;Share:extended;Death:integer):TColor;
    Procedure Render;
    Procedure Append(aObj:TRenderBaseObject);
  end;

implementation

{ TRenderEngine }

constructor TRenderEngine.Create;
begin
  // Todo: ?
end;

function TRenderEngine.Trace(Ray: TRenderRay; Share: extended; Death: integer
  ): TColor;
begin
  //  - Follow the ray until it hits an Object.

  //  - Calculete The Hitpoint of the Object

  //  - Calculate the Light&Color of the Hitpoint by:
  //  - - SelfLightness

  //  - - Calculate the Light-Rays from the Hitpoint to the Light-Sources

  //  - - In case of reflection Split the Ray into a new Ray from the Hitpoint according to the Reflection-Propety of the Hitpoint.

  //  - - In Case of Refraction Split the Ray into a New Ray from the Hitpoint according to the Refraction-Property.
  //  - - Both split rays are Followed until a maximum of splits is reached or the relevance is canceled by a bail-out-Value.
  //  - All three Rays add up to the Color of the Original Ray.
end;

procedure TRenderEngine.Render;

var Ray:TRenderRay;
begin
  // Create Result-Bitmap
  // Parse
  // Optimize
  // Split into Tasks
  // Per Task do:
  //  - Select a Ray
  //call Trace(Ray, 1.0, 1)
end;

procedure TRenderEngine.Append(aObj: TRenderBaseObject);
begin
  setlength(FObjects,length(FObjects)+1);
  FObjects[high(FObjects)] := aObj;
  // test if Object is special
  if aObj.InheritsFrom(TRenderCamera) then
    begin
      Freeandnil(FCamera);
      FCamera := TRenderCamera(aObj);
    end;
  // Todo: Lightsource
  {
  if aObj.InheritsFrom(TRenderLightsource) then
    begin
      setlength(FLightSources,length(FLightSources)+1);
      FLightSources[high(FLightSources)] := aObj;
    end; }
end;

end.

