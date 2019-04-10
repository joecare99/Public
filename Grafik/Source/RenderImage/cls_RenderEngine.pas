unit cls_RenderEngine;

{$IFDEF FPC} {$mode objfpc}{$H+}       {$ENDIF}

interface

uses
  Classes, SysUtils, cls_RenderBase;

type

{ TRenderEngine }

 TRenderEngine=Class
    FObjects:array of TRenderBaseObject;
    FCamera:TRenderCamera;
    FResult:TBitmap;
    Procedure Render;
  end;

implementation

{ TRenderEngine }

procedure TRenderEngine.Render;
begin
  // Parse
  // Optimize
  // Split into Tasks
  // Per Task do:
  //  - Select a Ray
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

end.

