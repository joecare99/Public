unit cls_RenderEngine;

{$IFDEF FPC} {$mode objfpc}{$H+}       {$ENDIF}

interface

uses
  Classes, SysUtils, cls_RenderBase,cls_RenderColor, cls_RenderLightSource ,cls_RenderSimpleObjects, cls_RenderCamera,graphics;

type

{ TRenderEngine }

 TRenderEngine=Class
   private
    FObjects:array of TRenderBaseObject;
    FLightSources:array of TRenderLightsource;
    FCamera:TRenderCamera;
    FResult:TBitmap;
    FMaxDepth: integer;
    FMinShare:extended;
    procedure SetMaxDepth(AValue: integer);
   protected
     function TestRayIntersection(const Ray: TRenderRay; out HitObj: TRenderBaseObject ): THitData;
  public
    Constructor Create;
    destructor Destroy; override;
    Function Trace(Ray:TRenderRay;Share:extended;Depth:integer):TRenderColor;
    Procedure Render;
    Procedure Append(aObj:TRenderBaseObject);
    Property MaxDepth:integer read FMaxDepth write SetMaxDepth;
  end;

implementation

{ TRenderEngine }

procedure TRenderEngine.SetMaxDepth(AValue: integer);
begin
  if FMaxDepth=AValue then Exit;
  FMaxDepth:=AValue;
end;

function TRenderEngine.TestRayIntersection(const Ray: TRenderRay; out
  HitObj: TRenderBaseObject): THitData;
var
  i:Integer;
  bHitdata: THitData;
  bDistance: extended;
begin
  //  - Follow the ray until it hits an Object.
  result.Distance :=-1.0;
  HitObj := nil;
  for I :=  0 to high(FObjects) do
    if FObjects[i].BoundaryTest(Ray, bDistance) then
      begin
  //  - Calculete The Hitpoint of the Object
        if FObjects[i].HitTest(Ray, bHitData) and ((result.Distance =-1.0)
          or  (bHitData.Distance<result.Distance)) then
          begin
            result:=bHitData;
            HitObj:=FObjects[i];
          end
      end;
end;

constructor TRenderEngine.Create;
begin
  // Todo: ?
  FMaxDepth:=100;
  FMinShare:=1e-4;
end;

destructor TRenderEngine.Destroy;
var
  i: integer;
begin
  SetLength(FLightSources,0);
  for i := 0 to high(FObjects) do
    FreeAndNil(FObjects[i]);
  SetLength(FObjects,0);
  inherited Destroy;
end;

function TRenderEngine.Trace(Ray: TRenderRay; Share: extended; Depth: integer
  ): TRenderColor;
var
  hHitData, lHit: THitData;
  HitObj, lBlockObj: TRenderBaseObject;
  lAmbient, lColorAtHP, lDirect, lReflect, lPhong, lRefract:TRenderColor;
  I: Integer;
  lHpRay: TRenderRay;
  lLightSVec: TRenderVector;
  lVecLen, lIntensity, lMaxLight: Extended;
begin
  // Bailout-Test
  if (Depth > FMaxDepth) or (share < FMinShare) then
    exit(RenderColor(0,0,0));

  hHitData:=TestRayIntersection(Ray, HitObj);

  if hHitData.Distance>=0 then
    begin
  //  - Calculate the Light&Color of the Hitpoint by:
  //  - - SelfLightness
      if HitObj.InheritsFrom(TSimpleObject) then
        lColorAtHP := TSimpleObject(HitObj).GetColorAt(hHitData.HitPoint)
      else
        if HitObj is iHasColor then
          lColorAtHP := (HitObj as iHasColor).GetColorAt(hHitData.HitPoint)
        else
          lColorAtHP :=RenderColor(0,0,0);
      lAmbient := lColorAtHP * 0.1*hHitData.AmbientVal;
  //  - - Calculate the Light-Rays from the Hitpoint to the Light-Sources
      lHpRay := TRenderRay.Create(hHitData.HitPoint,hHitData.Normalvec);
      try
      lDirect:=RenderColor(0,0,0);
      lMaxLight :=0.0;
      for i := 0 to high(FLightSources) do
        begin
          lLightSVec:=(FLightSources[i].Position-hHitData.HitPoint);
          lMaxLight += FLightSources[i].MaxIntensity(lLightSVec*-1);
        if  lLightSVec*hHitData.Normalvec >0 then
          begin
            lhpRay.Direction := lLightSVec;
            if HitObj.HitTest(lHpRay,lHit) and (lHit.Distance < 1e-6) then
              lHpRay.StartPoint := hHitData.HitPoint + hHitData.Normalvec*1e-4;
            lHit := TestRayIntersection(lHpRay,lBlockObj);
            lVecLen:= lLightSVec.GLen;
            if (lHit.Distance <0)  or (lBlockObj=FLightSources[i]) or (lHit.Distance>=lVecLen) then
              begin
                lIntensity:=  FLightSources[i].FalloffIntensity(lLightSVec*-1) * (lHpRay.Direction*hHitData.Normalvec);
                lDirect += lIntensity * lColorAtHP.Filter( FLightSources[i].ProjectedColor(lLightSVec*-1));
              end;
          end
        end;
      if lMaxLight=0.0 then
        lDirect := lColorAtHP * 0.9 * hHitData.AmbientVal
      else
      lDirect := lDirect *(1/ lMaxLight)*0.9*hHitData.AmbientVal;
  //  - - In case of reflection Split the Ray into a new Ray from the Hitpoint according to the Reflection-Propety of the Hitpoint.

      if hHitData.ReflectionVal <1e-4 then
        lReflect :=RenderColor(0,0,0)
      else
        begin
      lHpRay.Direction := Ray.Direction + (ray.Direction * hHitData.Normalvec)*(-2.0)*hHitData.Normalvec;
      lHpRay.StartPoint := hHitData.HitPoint+lHpRay.Direction*1e-4;
      lReflect := trace(lHpRay,hHitData.ReflectionVal,Depth+1) *hHitData.ReflectionVal;
        end;
  //  - - In Case of Refraction Split the Ray into a New Ray from the Hitpoint according to the Refraction-Property.
      lPhong := RenderColor(0,0,0);
  //  - - Calculate a Phong - Point when the Reflection-Vector hits a Light-Source

      lRefract := RenderColor(0,0,0);
  //  - - Both split rays are Followed until a maximum of splits is reached or the relevance is canceled by a bail-out-Value.
  //  - All three Rays add up to the Color of the Original Ray.
        result := lAmbient + lDirect+ lReflect;
      finally
        freeandnil(lHpRay);
      end;
      end
   else      // Todo: SkyObject
     result :=clBlack;
//     RenderColor(Ray.Direction.x*0.5+0.5,Ray.Direction.y*0.5+0.5,Ray.Direction.z*0.5+0.5);
end;

procedure TRenderEngine.Render;

var lRay:TRenderRay;
  y, x: Integer;
begin
  // Create Result-Bitmap
  FResult:=TBitmap.Create;
  FResult.Width:= trunc(FCamera.Resolution.x);
  FResult.Height := trunc(FCamera.Resolution.y);
  FResult.PixelFormat:=pf24bit;
  // Parse
  // Optimize
  // Split into Tasks
  // Per Task do:
  //  - Select a Ray
  lRay := TRenderRay.Create(FCamera.Position,FCamera.DefaultDirection);
  for y := 0 to FResult.Height-1 do
    for x := 0 to FResult.Width-1 do
      begin
        lRay.direction := FCamera.RayDirection[Point(x,y)];
        FResult.Canvas.Pixels[x,y]:= Trace(lRay, 1.0, 1).Color;
      end;
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
  // Done: Lightsource
  if aObj.InheritsFrom(TRenderLightsource) then
    begin
      setlength(FLightSources,length(FLightSources)+1);
      FLightSources[high(FLightSources)] := TRenderLightsource(aObj);
    end;
  // Todo: Sky/Default-Object
{  if aObj.InheritsFrom(TSkyObject) then
    begin
      Freeandnil(FSkyObject);
      FSkyObject := TSkyObject(aObj);
    end;  }
end;

end.

