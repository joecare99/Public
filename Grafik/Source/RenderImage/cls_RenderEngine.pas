unit cls_RenderEngine;

{$IFDEF FPC} {$mode objfpc}{$H+}       {$ENDIF}

interface

uses
  Classes, SysUtils, cls_RenderBase,cls_RenderColor, cls_RenderSimpleObjects, cls_RenderCamera,graphics;

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
    Function Trace(Ray:TRenderRay;Share:extended;Death:integer):TRenderColor;
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
  ): TRenderColor;
var
  bDistance: extended;
  hHitData,bHitdata: THitData;
  HitObj: TRenderBaseObject;
  lAmbient:TRenderColor;
  I: Integer;
begin
  //  - Follow the ray until it hits an Object.
  hHitdata.Distance :=-1.0;
  for I :=  0 to high(FObjects) do
    if FObjects[i].BoundaryTest(Ray,bDistance) then
      begin
  //  - Calculete The Hitpoint of the Object
        if FObjects[i].HitTest(Ray,bHitData) and ((hHitdata.Distance =-1.0) or  (bHitData.Distance<hHitData.Distance)) then
          begin
            hHitData:=bHitData;
            HitObj:=FObjects[i];
          end
      end;
  if hHitData.Distance>=0 then
    begin
  //  - Calculate the Light&Color of the Hitpoint by:
  //  - - SelfLightness
      if HitObj.InheritsFrom(TSimpleObject) then
        lColorAtHP := TSimpleObject(HitObj).GetColorAt(hHitData.HitPoint)
      else
        if HitObj.(iGetColor) then
      lAmbient := lColorAtHP * 0.1;
  //  - - Calculate the Light-Rays from the Hitpoint to the Light-Sources
      lDirect := lColorAtHP * 0.9;

  //  - - In case of reflection Split the Ray into a new Ray from the Hitpoint according to the Reflection-Propety of the Hitpoint.

      lReflect := RenderColor(0,0,0);
  //  - - In Case of Refraction Split the Ray into a New Ray from the Hitpoint according to the Refraction-Property.
      lPhong := RenderColor(0,0,0);
  //  - - Calculate a Phong - Point when the Reflection-Vector hits a Light-Source

      lRefract := RenderColor(0,0,0);
  //  - - Both split rays are Followed until a maximum of splits is reached or the relevance is canceled by a bail-out-Value.
  //  - All three Rays add up to the Color of the Original Ray.
        result := lAmbient + lDirect;
      end;
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

