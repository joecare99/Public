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
  procedure SetLookAt(AValue: TRenderPoint);
public
    // Abstract Camera definition
      property Position:TRenderPoint read FPosition write SetPosition;
      property LookAt:TRenderPoint read FLookAt write SetLookAt;
    end;

    TRenderSimpleCamera=Class(TRenderCamera)

    end;

implementation

{ TRenderCamera }

procedure TRenderCamera.SetLookAt(AValue: TRenderPoint);
begin
  if FLookAt=AValue then Exit;
  FLookAt:=AValue;
end;

end.

