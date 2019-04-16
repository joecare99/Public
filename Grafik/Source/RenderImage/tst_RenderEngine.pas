unit tst_RenderEngine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils {$IFDEF FPC}, fpcunit, testregistry {$ELSE}, testframework {$ENDIF},
 cls_RenderBase, cls_RenderSimpleObjects,
  cls_RenderEngine;

type

  { TTestRenderImage }

  TTestRenderImage= class(TTestCase)
  Private
    FRenderEngine:TRenderEngine;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CheckEquals(const Exp, Act: TFTriple; eps: extended; Msg: String);
      overload;
  published
    procedure TestSetUp;
    procedure TestRay;
  end;

implementation

uses graphics;

procedure TTestRenderImage.SetUp;
begin
  FRenderEngine := TRenderEngine.create;
end;

procedure TTestRenderImage.TearDown;
begin
  Freeandnil(FRenderEngine);
end;

procedure TTestRenderImage.CheckEquals(const Exp, Act: TFTriple; eps: extended;
  Msg: String);
begin
  CheckEquals(exp.X,act.X,eps,Msg+'[X]');
  CheckEquals(exp.Y,act.Y,eps,Msg+'[Y]');
  CheckEquals(exp.Z,act.Z,eps,Msg+'[Z]');
end;

procedure TTestRenderImage.TestSetUp;
begin
  CheckNotNull(FRenderEngine,'FrenderEngine is assignes');
end;

procedure TTestRenderImage.TestRay;
var
  lRay: TRenderRay;
  lSphere: TSphere;
  HitData: THitData;
begin
  lSphere := TSphere.Create(
     Trenderpoint.copy(0,0,0),
     1.0,
     clWhite);
  FRenderEngine.
  Append(lSphere);
  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
    CheckEquals(true,lSphere.HitTest(lRay,HitData),'Sphere.HitTest1');
    CheckEquals(1.0,HitData.Distance,1e-15,'HitData.Distance');
    CheckEquals(FTriple(0,0,-1),HitData.HitPoint,1e-15,'HitData.HitPoint');
    CheckEquals(FTriple(0,0,-1),HitData.Normalvec,1e-15,'HitData.Normalvec');

    lRay.Direction := FTriple(0.5,0.5,sqrt(0.5));
    CheckEquals(false,lSphere.HitTest(lRay,HitData),'Sphere.HitTest2');

    CheckEquals(RGBToColor(0,0,0),FRenderEngine.Trace(lRay,1.0,1));

  finally
    freeandnil(lRay);
    freeandnil(hitdata);
  end;

end;

initialization

  RegisterTest(TTestRenderImage);
end.

