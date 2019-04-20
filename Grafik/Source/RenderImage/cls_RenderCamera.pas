unit cls_RenderCamera;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_RenderBase;

type

{ TRenderCamera }

 TRenderCamera=Class(TRenderBaseObject)
private
  FLookAt: TRenderPoint;
  FRight:TRenderVector;
  FUp:TRenderVector;
  FResolution: TFTuple;
  function GetDefaultDirection: TRenderVector;
  procedure SetDefaultDirection(AValue: TRenderVector);
  procedure SetLookAt(AValue: TRenderPoint);
  procedure SetResolution(AValue: TFTuple);
protected
    function GetRayDirection(pnt: TPoint): TRenderVector;virtual;
public
    // Abstract Camera definition
      property Position:TRenderPoint read FPosition write SetPosition;
      property LookAt:TRenderPoint read FLookAt write SetLookAt;
      property Resolution:TFTuple read FResolution write SetResolution;
      property DefaultDirection:TRenderVector read GetDefaultDirection write SetDefaultDirection;
      property RayDirection[pnt:TPoint]:TRenderVector read GetRayDirection;
    end;

    { TRenderSimpleCamera }

    TRenderSimpleCamera=Class(TRenderCamera)
      private
      FAngle: extended;
      procedure SetAngle(AValue: extended);
      public
      Property Angle:extended read FAngle write SetAngle;
    end;

implementation

{ TRenderCamera }

procedure TRenderCamera.SetLookAt(AValue: TRenderPoint);
begin
  if FLookAt=AValue then Exit;
  FLookAt:=AValue;
  FRight := (FLookAt-FPosition).Normalize.XMul(FTriple(0,0,1));
  FUp := (FLookAt-FPosition).Normalize.XMul(FRight);
end;

function TRenderCamera.GetDefaultDirection: TRenderVector;
begin
  result := FLookAt - FPosition;
end;

function TRenderCamera.GetRayDirection(pnt: TPoint): TRenderVector;
begin
  result := (FLookAt-FPosition).Normalize + FRight*(pnt.x/FResolution.x-0.5)+Fup*(pnt.y-FResolution.Y*0.5)/Resolution.x ;
end;

procedure TRenderCamera.SetDefaultDirection(AValue: TRenderVector);
begin
  LookAt := FPosition + AValue;
end;

procedure TRenderCamera.SetResolution(AValue: TFTuple);
begin
  if FResolution=AValue then Exit;
  FResolution:=AValue;
end;


procedure TRenderSimpleCamera.SetAngle(AValue: extended);
begin
  if FAngle=AValue then Exit;
  FAngle:=AValue;
end;



end.

