unit cls_RenderCamera;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_RenderBase;

type TRenderCamera=Class(TRenderBaseObject)
    // Abstract Camera definition
      property Position;
      property LookAt:
    end;

    TRenderSimpleCamera=Class(TRenderCamera)

    end;

implementation

end.

