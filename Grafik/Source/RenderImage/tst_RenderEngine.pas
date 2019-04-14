unit tst_RenderEngine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils {$IFDEF FPC}, fpcunit, testregistry {$ELSE}, testframework {$ENDIF},
  cls_RenderSimpleObjects,
  cls_RenderEngine;

type

  { TTestRenderImage }

  TTestRenderImage= class(TTestCase)
  Private
    FRenderEngine:TRenderEngine;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestRay;
  end;

implementation

uses graphics,cls_RenderBase;

procedure TTestRenderImage.SetUp;
begin
  FRenderEngine := TRenderEngine.create;
end;

procedure TTestRenderImage.TearDown;
begin
  Freeandnil(FRenderEngine);
end;

procedure TTestRenderImage.TestSetUp;
begin
  CheckNotNull(FRenderEngine,'FrenderEngine is assignes');
end;

procedure TTestRenderImage.TestRay;
var
  lRay: TRenderRay;
begin
  FRenderEngine.
  Append(TSphere.Create(
     Trenderpoint.copy(0,0,0),
     1.0,
     clWhite));
  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
  CheckEquals(RGBToColor(0,0,0),FRenderEngine.Trace(lRay,1.0,1));

  finally
    freeandnil(lRay)
  end;
end;

initialization

  RegisterTest(TTestRenderImage);
end.

