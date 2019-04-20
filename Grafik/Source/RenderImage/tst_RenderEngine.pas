unit tst_RenderEngine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Forms, graphics {$IFDEF FPC}, fpcunit, testregistry {$ELSE}, testframework {$ENDIF},
 cls_RenderBase,cls_RenderColor, cls_RenderSimpleObjects,
  cls_RenderEngine;

type

  { TTestRenderImage }

  TTestRenderImage= class(TTestCase)
  Private
    FRenderEngine:TRenderEngine;
    fFrmPictureDisplay:TForm;
    fBitmap:TBitmap;
    procedure OnFormPaint(Sender: TObject);
    procedure TestRenderScene(var lRay: TRenderRay);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CheckEquals(const Exp, Act: TFTriple; eps: extended; Msg: String);
      overload;
    procedure CheckEquals(const Exp, Act: TRenderColor; Msg: String);
      overload;
  published
    procedure TestSetUp;
    procedure TestRay1;
    procedure TestRayvsSphere2;
    Procedure TestShowScene1;
    Procedure TestShowScene2;
    Procedure TestShowScene3;
    public
      constructor Create; override;
      destructor Destroy; override;
  end;

implementation

uses cls_RenderLightSource;

procedure TTestRenderImage.TestRenderScene(var lRay: TRenderRay);
var
  x: Integer;
  y: Integer;
begin
  fFrmPictureDisplay.Caption:= TestSuiteName + ': '+TestName;
  fFrmPictureDisplay.Show;
//  fBitmap.Clear;
  for y := 0 to fFrmPictureDisplay.ClientHeight-1 do
    begin
       for x := 0 to fFrmPictureDisplay.ClientWidth-1 do
         begin
            lRay.Direction:=FTriple(
              (x-fFrmPictureDisplay.ClientWidth div 2)*0.0025,
              (-y+fFrmPictureDisplay.ClientHeight div 2)*0.0025,
              1);
            fBitmap.Canvas.Pixels[x, y]:=FRenderEngine.trace(lRay,
              1.0, 1).Color;
         end;
       fFrmPictureDisplay.Invalidate;
       Application.ProcessMessages;
    end ;
end;

procedure TTestRenderImage.OnFormPaint(Sender: TObject);
begin
  if assigned(fBitmap) then
    fFrmPictureDisplay.Canvas.StretchDraw(rect(0,0,fFrmPictureDisplay.ClientWidth,fFrmPictureDisplay.ClientHeight),fBitmap);
end;

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

procedure TTestRenderImage.CheckEquals(const Exp, Act: TRenderColor; Msg: String
  );
const cEps = 1e-4;
begin
  CheckEquals(exp.Red,act.Red,cEps,Msg+'[Red]');
  CheckEquals(exp.Green,act.Green,cEps,Msg+'[Green]');
  CheckEquals(exp.Blue,act.Blue,cEps,Msg+'[Blue]');
end;

procedure TTestRenderImage.TestSetUp;
begin
  CheckNotNull(FRenderEngine,'FrenderEngine is assigned');
  CheckNotNull(fFrmPictureDisplay,'FrenderEngine is assigned');
  CheckNotNull(fBitmap,'FrenderEngine is assigned');
end;

procedure TTestRenderImage.TestShowScene1;
var
  lSphere: TSphere;
  lRay: TRenderRay;
begin
  lSphere := TSphere.Create(
     Trenderpoint.copy(0,0,0),
     1.0,
     clYellow);
  FRenderEngine.Append(lSphere);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10,10,-10)));

  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
    TestRenderScene(lRay);
  finally
    freeandnil(lRay);
  end;
end;

procedure TTestRenderImage.TestShowScene2;
var
  lSphere: TSphere;
  lRay: TRenderRay;
begin
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0,-1001.0,0),
     1000.0,
     clLime));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(-0.7,-0.3,0),
     0.7,
     clRed));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0.7,-0.3,0),
     0.7,
     clBlue));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0.0,0.7,0.0),
     0.7,
     clYellow));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10,10,-10)));

  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
    TestRenderScene(lRay);
  finally
    freeandnil(lRay);
  end;
end;

procedure TTestRenderImage.TestShowScene3;
var
  lSphere: TSphere;
  lRay: TRenderRay;
begin
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0,-1001.0,0),
     1000.0,
     clLime));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(-0.7,-0.3,0),
     0.7,
     clRed));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0.7,-0.3,0),
     0.7,
     clBlue));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0.0,0.6,0.0),
     0.7,
     clYellow));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10,10,-10)));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-9,9,-10)));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10,9,-10)));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-9,10,-10)));

  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
    TestRenderScene(lRay);
  finally
    freeandnil(lRay);
  end;
end;

constructor TTestRenderImage.Create;
begin
  inherited Create;

  fFrmPictureDisplay:= TForm.Create(Application);
      fFrmPictureDisplay.Height := 512;
      fFrmPictureDisplay.Width := 720;
      fFrmPictureDisplay.OnPaint:=@OnFormPaint;

      fBitmap:=TBitmap.Create;
      fBitmap.Height := fFrmPictureDisplay.ClientHeight;
      fBitmap.Width := fFrmPictureDisplay.ClientWidth;
      fBitmap.PixelFormat:=pf24bit;

end;

destructor TTestRenderImage.Destroy;
begin
//  fFrmPictureDisplay.Hide;
  FreeAndNil(fBitmap);
  inherited Destroy;
end;

procedure TTestRenderImage.TestRay1;
var
  lRay: TRenderRay;
  lSphere: TSphere;
  HitData: THitData;
  y, x, i: Integer;
  bDist: extended;
begin
  lSphere := TSphere.Create(
     Trenderpoint.copy(0,0,0),
     1.0,
     clWhite);
  FRenderEngine.Append(lSphere);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10,10,-10)));

  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
    CheckEquals(true,lSphere.HitTest(lRay,HitData),'Sphere.HitTest1');
    CheckEquals(1.0,HitData.Distance,1e-15,'HitData.Distance');
    CheckEquals(FTriple(0,0,-1),HitData.HitPoint,1e-15,'HitData.HitPoint');
    CheckEquals(FTriple(0,0,-1),HitData.Normalvec,1e-15,'HitData.Normalvec');

    CheckEquals(RenderColor(0.5832,0.5832,0.5832),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray');

    lRay.Direction := FTriple(0.5,0.5,sqrt(0.5));
    CheckEquals(false,lSphere.HitTest(lRay,HitData),'Sphere.HitTest2');

    CheckEquals(RenderColor(0,0,0),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray2');

    for i := 0 to 10000 do
      begin
        lRay.Direction := FTriple(random-0.5,Random-0.5,2.0);
        CheckEquals(true,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary');
        CheckEquals(true,lSphere.HitTest(lRay,HitData),'Sphere.HitTest3');
        CheckEquals(bDist,HitData.Distance,1e-14,'Hitdata.HP.Distance');
        CheckEquals(1.0,HitData.HitPoint.GLen,1e-14,'Hitdata.HP.Glen3');
        CheckEquals(HitData.HitPoint,HitData.Normalvec,1e-14,'Hitdata.HP.Normalvec');

      end;
  finally
    freeandnil(lRay);
  end;

end;

procedure TTestRenderImage.TestRayvsSphere2;
var
  lSphere: TSphere;
  lRay: TRenderRay;
begin
  lSphere := TSphere.Create(
     Trenderpoint.copy(0,-100,0),
     100.0,
     clWhite);

  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try

  finally
    freeandnil(lRay);
  end;
end;

initialization

  RegisterTest(TTestRenderImage);
end.

