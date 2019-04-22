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
    procedure TestRay1InSphere;
    procedure TestRayvsSphere2;
    procedure TestRay2;
    procedure TestRayvsPlane2;
    Procedure TestShowScene1;
    Procedure TestShowScene2;
    Procedure TestShowScene2b;
    Procedure TestShowScene3;
    Procedure TestShowScene4;
    Procedure TestShowScene5;
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
  lLastTime: QWord;
begin
  fFrmPictureDisplay.Caption:= TestSuiteName + ': '+TestName;
  fFrmPictureDisplay.Show;
//  fBitmap.Clear;
  lLastTime:=GetTickCount64;
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
       if abs(int64(GetTickCount64- lLastTime))>1000 then
         begin
           lLastTime:=GetTickCount64;
           fFrmPictureDisplay.Invalidate;
           Application.ProcessMessages;

         end;
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
     clYellow,FTriple(1,0,0));
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
     clLime,FTriple(0.8,0.2,0.0)));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(-0.7,-0.3,0),
     0.7,
     clRed));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0.7,-0.3,0),
     0.7,
     clBlue,FTriple(0.1,0.9,0.0)));
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

procedure TTestRenderImage.TestShowScene2b;
var
  lSphere: TSphere;
  lRay: TRenderRay;
begin
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0,-1001.0,0),
     1000.0,
     clLime,FTriple(0.8,0.2,0.0)));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0,0,0),
     20.0,
     RenderColor(0.5,0.5,1),FTriple(0.2,0.8,0.0)));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(-0.7,-0.3,0),
     0.7,
     clRed));
  FRenderEngine.Append(TSphere.Create(
     Trenderpoint.copy(0.7,-0.3,0),
     0.7,
     clBlue,FTriple(0.1,0.9,0.0)));
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

procedure TTestRenderImage.TestShowScene4;
var
  lRay: TRenderRay;
  i: Integer;
begin
  FRenderEngine.Append(Tplane.Create(
     FTriple(0,-1.0,0),
     FTriple(0,1.0,0),
     clLime,FTriple(0.8,0.2,0)));
  FRenderEngine.Append(Tplane.Create(
     FTriple(0,12.0,0),
     FTriple(0,-1.0,0),
     RenderColor(0.5,0.7,1.5),FTriple(1.0,0.0,0)));
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
  for i := 0 to 15 do
    FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10+(i mod 4)*0.25,10-(i div 4)*0.25,-10)));

  lRay:=TRenderRay.Create(FTriple(0,0,-3),FTriple(0,0,1));
  try
    TestRenderScene(lRay);
  finally
    freeandnil(lRay);
  end;
end;

procedure TTestRenderImage.TestShowScene5;
var
  lRay: TRenderRay;
  i: Integer;
begin
  FRenderEngine.Append(Tplane.Create(
     FTriple(0,-1.0,0),
     FTriple(0,1.0,0),
     clLime,FTriple(0.8,0.2,0)));
  FRenderEngine.Append(Tplane.Create(
     FTriple(0,12.0,0),
     FTriple(0,-1.0,0),
     RenderColor(0.5,0.7,1.5),FTriple(1.0,0.0,0)));
  FRenderEngine.Append(Tplane.Create(
     FTriple(1.0,0,1.0),
     FTriple(-0.1,0.0,-1),
     RenderColor(1,1,1),FTriple(0.05,0.95,0)));
  FRenderEngine.Append(Tplane.Create(
     FTriple(-1.0,0,-2.5),
     FTriple(0.05,0.0,1),
     RenderColor(1,1,1),FTriple(0.05,0.95,0)));

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
  for i := 0 to 15 do
    FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10+(i mod 4)*0.25,10-(i div 4)*0.25,-2)));

  lRay:=TRenderRay.Create(FTriple(1,0,-2.5),FTriple(0,0,1));
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
     clWhite,FTriple(0.85734,0.1,0.0));
  FRenderEngine.Append(lSphere);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10,10,-10)));

  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
    CheckEquals(true,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary');
    CheckEquals(1.0,bDist,1e-14,'Hitdata.HP.Distance');
    CheckEquals(true,lSphere.HitTest(lRay,HitData),'Sphere.HitTest1');
    CheckEquals(1.0,HitData.Distance,1e-15,'HitData.Distance');
    CheckEquals(FTriple(0,0,-1),HitData.HitPoint,1e-15,'HitData.HitPoint');
    CheckEquals(FTriple(0,0,-1),HitData.Normalvec,1e-15,'HitData.Normalvec');

    CheckEquals(RenderColor(0.5,0.5,0.5),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray');

    lRay.Direction := FTriple(0.5,0.5,sqrt(0.5));
    CheckEquals(false,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary2');
    CheckEquals(-1.0,bDist,1e-14,'Hitdata.HP.Distance2');
    CheckEquals(false,lSphere.HitTest(lRay,HitData),'Sphere.HitTest2');
    CheckEquals(-1.0,HitData.Distance,1e-15,'HitData.Distance2');

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

procedure TTestRenderImage.TestRay1InSphere;
var
  lRay: TRenderRay;
  lSphere: TSphere;
  HitData: THitData;
  y, x, i: Integer;
  bDist: extended;
begin
  lSphere := TSphere.Create(
     Trenderpoint.copy(0,0,0),
     2.0,
     clWhite,FTriple(0.9,0.1,0.0));
  FRenderEngine.Append(lSphere);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-1,1,-1)));

  lRay:=TRenderRay.Create(FTriple(0,0,0),FTriple(0,0,1));
  try
    CheckEquals(true,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary');
    CheckEquals(0.0,bDist,1e-14,'Hitdata.HP.Distance');
    CheckEquals(true,lSphere.HitTest(lRay,HitData),'Sphere.HitTest1');
    CheckEquals(2.0,HitData.Distance,1e-15,'HitData.Distance');
    CheckEquals(FTriple(0,0,2),HitData.HitPoint,1e-15,'HitData.HitPoint');
    CheckEquals(FTriple(0,0,-1),HitData.Normalvec,1e-15,'HitData.Normalvec');

    CheckEquals(RenderColor(0.887311,0.887311,0.887311),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray');

    lRay.Direction := FTriple(0.5,0.5,sqrt(0.5));
    CheckEquals(true,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary2');
    CheckEquals(0.0,bDist,1e-14,'Hitdata.HP.Distance2');
    CheckEquals(true,lSphere.HitTest(lRay,HitData),'Sphere.HitTest2');
    CheckEquals(2.0,HitData.Distance,1e-15,'HitData.Distance2');
    CheckEquals(FTriple(1,1,sqrt(2)),HitData.HitPoint,1e-15,'HitData.HitPoint2');
    CheckEquals(FTriple(-0.5,-0.5,-sqrt(0.5)),HitData.Normalvec,1e-15,'HitData.Normalvec2');

    CheckEquals(RenderColor(1,1,1)*0.858293,FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray2');

    for i := 0 to 10000 do
      begin
        lRay.Direction := FTriple(random-0.5,Random-0.5,2.0);
        CheckEquals(true,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary');
        CheckEquals(0.0,bDist,1e-14,'Hitdata.HP.Distance');
        CheckEquals(true,lSphere.HitTest(lRay,HitData),'Sphere.HitTest3');
        CheckEquals(2.0,HitData.Distance,1e-14,'Hitdata.HP.Distance');
        CheckEquals(2.0,HitData.HitPoint.GLen,1e-14,'Hitdata.HP.Glen3');
        CheckEquals(HitData.HitPoint*-0.5,HitData.Normalvec,1e-14,'Hitdata.HP.Normalvec');

      end;
  finally
    freeandnil(lRay);
  end;
end;

procedure TTestRenderImage.TestRayvsSphere2;
var
  lSphere: TSphere;
  lRay: TRenderRay;
  HitData: THitData;
  bDist: extended;
  i: Integer;
begin
  lSphere := TSphere.Create(
     Trenderpoint.copy(0,-1000.1,0),
     1000.0,
     clWhite,FTriple(1,0,0));

  FRenderEngine.Append(lSphere);
  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
    // First Test Some well known points
    // 1
    CheckEquals(false,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary');
    CheckEquals(-1.0,bDist,1e-14,'Boundary.Distance');
    CheckEquals(false,lSphere.HitTest(lRay,HitData),'Sphere.HitTest');

    CheckEquals(RenderColor(0,0,0),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray1');

    // 2
    lRay.Direction:=FTriple(0,0.5,1) ;
    CheckEquals(false,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary2');
    CheckEquals(-1.0,bDist,1e-14,'Boundary.Distance2');
    CheckEquals(false,lSphere.HitTest(lRay,HitData),'Sphere.HitTest2');

    CheckEquals(RenderColor(0,0,0),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray2');

    // 3
    lRay.Direction:=FTriple(0,-0.5,1) ;
    CheckEquals(true,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary3');
    CheckEquals(0.22721,bDist,1e-5,'Boundary.Distance3');
    CheckEquals(true,lSphere.HitTest(lRay,HitData),'Sphere.HitTest3');
    CheckEquals(0.22721,HitData.Distance,1e-5,format('Hitdata.HP.Distance3',[i]));
    CheckEquals(FTriple(0,-0.1016142,-1.79677161),HitData.HitPoint,1e-7,'HitData.HitPoint3');
    CheckEquals(FTriple(0,0.99999838,-1.79677161e-3),HitData.Normalvec,1e-7,'HitData.Normalvec3');

    CheckEquals(RenderColor(1,1,1),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray2');

    // Random
    for i := 0 to 10000 do
      begin
        lRay.Direction := FTriple(random-0.5,Random-1.0,2.0);
        if (lray.Direction.y<-0.05) or ((lray.Direction.y<-0.01) and lSphere.BoundaryTest(lRay,bDist)) then
          begin
        CheckEquals(true,lSphere.BoundaryTest(lRay,bDist),format('Sphere.Boundary[%d]',[i]));
        CheckEquals(true,lSphere.HitTest(lRay,HitData),format('Sphere.HitTest[%d]',[i]));
        CheckEquals(bDist,HitData.Distance,1e-10,format('Hitdata.HP.Distance[%d]',[i]));
        CheckEquals(1000.0,(HitData.HitPoint-lSphere.Position).GLen,1e-12,format('Hitdata.HP.Glen[%d]',[i]));
        CheckEquals((HitData.HitPoint-lSphere.Position)*0.001,HitData.Normalvec,1e-12,format('Hitdata.HP.Normalvec[%d]',[i]));
        CheckEquals(0.995,HitData.Normalvec.y,0.005,format('Hitdata.HP.Normalvec.y[%d]',[i]));
        end
        else
        begin
      CheckEquals(false,lSphere.BoundaryTest(lRay,bDist),'Sphere.Boundary');
      CheckEquals(false,lSphere.HitTest(lRay,HitData),'Sphere.HitTest3');
      CheckEquals(-1.0,bDist,1e-14,'Hitdata.HP.Distance');
      CheckEquals(-1.0,HitData.Distance,1e-14,'Hitdata.HP.Glen3');
      end
      end;
  finally
    freeandnil(lRay);
  end;
end;

procedure TTestRenderImage.TestRay2;
var
  lRay: TRenderRay;
  lPlane: TPlane;
  HitData: THitData;
  y, x, i: Integer;
  bDist: extended;
begin
  lPlane := TPlane.Create(
     FTriple(0,0,0),
     FTriple(0,0,-1),
     clWhite,FTriple(0.80690397017,0.0,0.0));
  FRenderEngine.Append(lPlane);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10,10,-10)));

  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
    CheckEquals(true,lPlane.BoundaryTest(lRay,bDist),'Plane.Boundary');
    CheckEquals(2.0,bDist,1e-14,'Hitdata.HP.Distance');
    CheckEquals(true,lPlane.HitTest(lRay,HitData),'Plane.HitTest1');
    CheckEquals(2.0,HitData.Distance,1e-15,'HitData.Distance');
    CheckEquals(FTriple(0,0,0),HitData.HitPoint,1e-15,'HitData.HitPoint');
    CheckEquals(FTriple(0,0,-1),HitData.Normalvec,1e-15,'HitData.Normalvec');

    CheckEquals(RenderColor(0.5,0.5,0.5),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray');

    lRay.Direction := FTriple(0.5,0.5,0);
    CheckEquals(false,lPlane.BoundaryTest(lRay,bDist),'Plane.Boundary2');
    CheckEquals(-1.0,bDist,1e-14,'Hitdata.HP.Distance2');
    CheckEquals(false,lPlane.HitTest(lRay,HitData),'Plane.HitTest2');
    CheckEquals(-1.0,HitData.Distance,1e-15,'HitData.Distance2');

    CheckEquals(RenderColor(0,0,0),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray2');

    for i := 0 to 10000 do
      begin
        lRay.Direction := FTriple(random-0.5,Random-0.5,2.0);
        CheckEquals(true,lPlane.BoundaryTest(lRay,bDist),'Plane.Boundary');
        CheckEquals(true,lPlane.HitTest(lRay,HitData),'Plane.HitTest3');
        CheckEquals(bDist,HitData.Distance,1e-14,'Hitdata.HP.Distance');
        CheckEquals(0.0,HitData.HitPoint.z,1e-14,'Hitdata.HP.z');
        CheckEquals(FTriple(0,0,-1),HitData.Normalvec,1e-14,'Hitdata.HP.Normalvec');

      end;
  finally
    freeandnil(lRay);
  end;

end;

procedure TTestRenderImage.TestRayvsPlane2;
var
  lPlane: TPlane;
  lRay: TRenderRay;
  HitData: THitData;
  bDist: extended;
  i: Integer;
begin
  lPlane := TPlane.Create(
     FTriple(0,-0.1,0),
     FTriple(0,1,0),
     clWhite,FTriple(1,0,0));

  FRenderEngine.Append(lPlane);
  lRay:=TRenderRay.Create(FTriple(0,0,-2),FTriple(0,0,1));
  try
    // First Test Some well known points
    // 1
    CheckEquals(false,lPlane.BoundaryTest(lRay,bDist),'Plane.Boundary');
    CheckEquals(-1.0,bDist,1e-14,'Boundary.Distance');
    CheckEquals(false,lPlane.HitTest(lRay,HitData),'Plane.HitTest');

    CheckEquals(RenderColor(0,0,0),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray1');

    // 2
    lRay.Direction:=FTriple(0,0.5,1) ;
    CheckEquals(false,lPlane.BoundaryTest(lRay,bDist),'Plane.Boundary2');
    CheckEquals(-1.0,bDist,1e-14,'Boundary.Distance2');
    CheckEquals(false,lPlane.HitTest(lRay,HitData),'Plane.HitTest2');

    CheckEquals(RenderColor(0,0,0),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray2');

    // 3
    lRay.Direction:=FTriple(0,-0.5,1) ;
    CheckEquals(true,lPlane.BoundaryTest(lRay,bDist),'Plane.Boundary3');
    CheckEquals(0.223606,bDist,1e-5,'Boundary.Distance3');
    CheckEquals(true,lPlane.HitTest(lRay,HitData),'Plane.HitTest3');
    CheckEquals(0.223606,HitData.Distance,1e-5,format('Hitdata.HP.Distance3',[i]));
    CheckEquals(FTriple(0,-0.1,-1.8),HitData.HitPoint,1e-7,'HitData.HitPoint3');
    CheckEquals(FTriple(0,1,0),HitData.Normalvec,1e-7,'HitData.Normalvec3');

    CheckEquals(RenderColor(1,1,1),FRenderEngine.Trace(lRay,1.0,1),'Trace one Ray2');

    // Random
    for i := 0 to 10000 do
      begin
        lRay.Direction := FTriple(random-0.5,Random-1.0,2.0);
        if (lray.Direction.y<-1e-12) or ((lray.Direction.y<-1e-15) and lPlane.BoundaryTest(lRay,bDist)) then
          begin
        CheckEquals(true,lPlane.BoundaryTest(lRay,bDist),format('Plane.Boundary[%d]',[i]));
        CheckEquals(true,lPlane.HitTest(lRay,HitData),format('Plane.HitTest[%d]',[i]));
        CheckEquals(bDist,HitData.Distance,1e-14,format('Hitdata.HP.Distance[%d]',[i]));
        CheckEquals(-0.1,HitData.HitPoint.y,1e-14,format('Hitdata.HP.y[%d]',[i]));
        CheckEquals(FTriple(0,1,0),HitData.Normalvec,1e-14,format('Hitdata.HP.Normalvec[%d]',[i]));
        end
        else
        begin
      CheckEquals(false,lPlane.BoundaryTest(lRay,bDist),'Plane.Boundary');
      CheckEquals(false,lPlane.HitTest(lRay,HitData),'Plane.HitTest3');
      CheckEquals(-1.0,bDist,1e-14,'Hitdata.HP.Distance');
      CheckEquals(-1.0,HitData.Distance,1e-14,'Hitdata.HP.Glen3');
      end
      end;
  finally
    freeandnil(lRay);
  end;
end;

initialization

  RegisterTest(TTestRenderImage);
end.

