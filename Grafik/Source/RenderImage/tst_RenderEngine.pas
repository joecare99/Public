UNIT tst_RenderEngine;

{$mode objfpc}{$H+}

INTERFACE

USES
  Classes, SysUtils, Forms, Graphics
 {$IFDEF FPC}, fpcunit, testregistry {$ELSE}, testframework {$ENDIF},
  cls_RenderBase, cls_RenderColor, cls_RenderSimpleObjects,
  cls_RenderEngine;

TYPE

  { TTestRenderObjects }

  TTestRenderObjects = CLASS(TTestCase)
  private
    FRenderEngine: TRenderEngine;
  protected
    PROCEDURE SetUp; override;
    PROCEDURE TearDown; override;
    PROCEDURE CheckEquals(CONST Exp, Act: TFTriple; eps: Extended; Msg: String);
      overload;
    PROCEDURE CheckEquals(CONST Exp, Act: TRenderColor; Msg: String);
      overload;
  published
    PROCEDURE TestSetUp;
    PROCEDURE TestRay1Sphere;
    PROCEDURE TestRay1InSphere;
    PROCEDURE TestRayvsSphere2;
    PROCEDURE TestRay2Plane;
    PROCEDURE TestRayvsPlane2;
    PROCEDURE TestRay3Box;
    PROCEDURE TestRay3InBox;
    PROCEDURE TestRayvsBox3;
    PROCEDURE TestRay4Disc;
    PROCEDURE TestRayvsDisk4;
    PROCEDURE TestRay5Cylinder;
    PROCEDURE TestRay5InCylinder;
    PROCEDURE TestRayvsCylinder5;
  END;

  { TTestRenderImage }

  TTestRenderImage = CLASS(TTestCase)
  private
    FRenderEngine: TRenderEngine;
    fFrmPictureDisplay: TForm;
    fBitmap: TBitmap;
    PROCEDURE OnFormPaint(Sender: TObject);
    PROCEDURE TestRenderScene(VAR lRay: TRenderRay);
  protected
    PROCEDURE SetUp; override;
    PROCEDURE TearDown; override;
  published
    PROCEDURE TestSetUp;
    PROCEDURE TestShowScene1;
    PROCEDURE TestShowScene2;
    PROCEDURE TestShowScene2b;
    PROCEDURE TestShowScene3;
    PROCEDURE TestShowScene4;
    PROCEDURE TestShowScene5;
    PROCEDURE TestShowScene6a;
    PROCEDURE TestShowScene6;
    PROCEDURE TestShowScene7;
    PROCEDURE TestShowScene8;
    PROCEDURE TestShowScene9;
  public
    CONSTRUCTOR Create; override;
    DESTRUCTOR Destroy; override;
  end;

IMPLEMENTATION

USES cls_RenderLightSource;

type TBoolArray=packed array[0..63] of boolean;


procedure TTestRenderImage.TestRenderScene(var lRay: TRenderRay);
VAR
  x: Integer;
  y, i: Integer;
  lLastTime: QWord;
  bits: int64;
  lRCol:TRenderColor;

BEGIN
  bits:=$6030016916936DA6;
  fFrmPictureDisplay.Hide;
  fFrmPictureDisplay.Show;
  fFrmPictureDisplay.Caption := TestSuiteName + ': ' + TestName;
  //  fBitmap.Clear;
  lLastTime := GetTickCount64;
  FOR y := 0 TO fFrmPictureDisplay.ClientHeight - 1 DO
  BEGIN
    FOR x := 0 TO fFrmPictureDisplay.ClientWidth - 1 DO
    BEGIN
      lRay.Direction := FTriple(
        (x - fFrmPictureDisplay.ClientWidth div 2) * 0.0025,
        (-y + fFrmPictureDisplay.ClientHeight div 2) * 0.0025, 1);
      fBitmap.Canvas.Pixels[x, y] :=
        FRenderEngine.trace(lRay, 1.0, 1).Color;
    END;
    IF abs(Int64(GetTickCount64 - lLastTime)) > 1000 THEN
    BEGIN
      lLastTime := GetTickCount64;
      fFrmPictureDisplay.Invalidate;
      Application.ProcessMessages;
    END;
  END;
  // Sign
  for i := 0 to 62 do
    begin
      lRCol.color := fBitmap.Canvas.Pixels[fBitmap.Width-1- i mod 21 ,fBitmap.Height-1- i div 21];
      fBitmap.Canvas.Pixels[fBitmap.Width-1- i mod 21 ,fBitmap.Height-1- i div 21] := lRCol.Mix(clWhite*(bits shr i and 1),0.5)
    end;

  fFrmPictureDisplay.Invalidate;
  Application.ProcessMessages;
  // Todo: Save Picture (opional)
END;

procedure TTestRenderImage.OnFormPaint(Sender: TObject);
BEGIN
  IF assigned(fBitmap) THEN
    fFrmPictureDisplay.Canvas.StretchDraw(
      rect(0, 0, fFrmPictureDisplay.ClientWidth, fFrmPictureDisplay.ClientHeight), fBitmap);
END;

procedure TTestRenderImage.SetUp;
BEGIN
  FRenderEngine := TRenderEngine.Create;
END;

procedure TTestRenderImage.TearDown;
BEGIN
  FreeAndNil(FRenderEngine);
END;


procedure TTestRenderImage.TestSetUp;
BEGIN
  CheckNotNull(FRenderEngine, 'FrenderEngine is assigned');
  CheckNotNull(fFrmPictureDisplay, 'FrenderEngine is assigned');
  CheckNotNull(fBitmap, 'FrenderEngine is assigned');
END;

procedure TTestRenderImage.TestShowScene1;
VAR
  lSphere: TSphere;
  lRay:    TRenderRay;
BEGIN
  lSphere := TSphere.Create(Trenderpoint.copy(0, 0, 0), 1.0,
    clYellow, FTriple(1, 0, 0));
  FRenderEngine.Append(lSphere);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderImage.TestShowScene2;
VAR
  lRay:    TRenderRay;
BEGIN
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0, -1001.0, 0),
    1000.0, clLime, FTriple(0.8, 0.2, 0.0)));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(-0.7, -0.3, 0),
    0.7, clRed));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.7, -0.3, 0),
    0.7, clBlue, FTriple(0.1, 0.9, 0.0)));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.0, 0.7, 0.0),
    0.7, clYellow));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderImage.TestShowScene2b;
VAR
  lRay:    TRenderRay;
BEGIN
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0, -1001.0, 0),
    1000.0, clLime, FTriple(0.8, 0.2, 0.0)));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0, 0, 0),
    20.0, RenderColor(0.5, 0.5, 1), FTriple(0.2, 0.8, 0.0)));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(-0.7, -0.3, 0),
    0.7, clRed));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.7, -0.3, 0),
    0.7, clBlue, FTriple(0.1, 0.9, 0.0)));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.0, 0.7, 0.0),
    0.7, clYellow));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderImage.TestShowScene3;
VAR
  lRay: TRenderRay;
BEGIN
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0, -1001.0, 0),
    1000.0, clLime));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(-0.7, -0.3, 0),
    0.7, clRed));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.7, -0.3, 0),
    0.7, clBlue));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.0, 0.6, 0.0),
    0.7, clYellow));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-9, 9, -10)));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 9, -10)));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-9, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderImage.TestShowScene4;
VAR
  lRay: TRenderRay;
  i:    Integer;
BEGIN
  FRenderEngine.Append(Tplane.Create(FTriple(0, -1.0, 0),
    FTriple(0, 1.0, 0), clLime, FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(Tplane.Create(FTriple(0, 12.0, 0),
    FTriple(0, -1.0, 0), RenderColor(0.5, 0.7, 1.5), FTriple(1.0, 0.0, 0)));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(-0.7, -0.3, 0),
    0.7, clRed));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.7, -0.3, 0),
    0.7, clBlue));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.0, 0.6, 0.0),
    0.7, clYellow));
  FOR i := 0 TO 15 DO
    FRenderEngine.Append(TRenderLightsource.Create(
      FTriple(-10 + (i mod 4) * 0.25, 10 - (i div 4) * 0.25, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -3), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderImage.TestShowScene5;
VAR
  lRay: TRenderRay;
  i:    Integer;
BEGIN
  FRenderEngine.Append(Tplane.Create(FTriple(0, -1.0, 0),
    FTriple(0, 1.0, 0), clLime, FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(Tplane.Create(FTriple(0, 12.0, 0),
    FTriple(0, -1.0, 0), RenderColor(0.5, 0.7, 1.5), FTriple(1.0, 0.0, 0)));
  FRenderEngine.Append(Tplane.Create(FTriple(1.0, 0, 1.0),
    FTriple(-0.1, 0.0, -1), RenderColor(1, 1, 1), FTriple(0.05, 0.95, 0)));
  FRenderEngine.Append(Tplane.Create(FTriple(-1.0, 0, -2.5),
    FTriple(0.05, 0.0, 1), RenderColor(1, 1, 1), FTriple(0.05, 0.95, 0)));

  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(-0.7, -0.3, 0),
    0.7, clRed));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.7, -0.3, 0),
    0.7, clBlue));
  FRenderEngine.Append(TSphere.Create(Trenderpoint.copy(0.0, 0.6, 0.0),
    0.7, clYellow));
  FOR i := 0 TO 15 DO
    FRenderEngine.Append(TRenderLightsource.Create(
      FTriple(-10 + (i mod 4) * 0.25, 10 - (i div 4) * 0.25, -2)));

  lRay := TRenderRay.Create(FTriple(1, 0, -2.5), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderImage.TestShowScene6a;
var
  lCenter: TFTriple;
  lBarSize: Extended;
  lRay: TRenderRay;
  i: Integer;
begin
  lCenter:=FTriple(-0.3, -0.5, -0.01);
  lBarSize := 0.5;
  FRenderEngine.Append(TBox.Create(lCenter,
    FTriple(4, lBarSize, lBarSize), RenderColor(1, 1, 1), FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TBox.Create(lCenter,
    FTriple(lBarSize,4,  lBarSize), RenderColor(1, 1, 1), FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TBox.Create(lCenter,
    FTriple(lBarSize,lBarSize,4), RenderColor(1, 1, 1), FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TSphere.Create(lCenter,
    lBarSize*0.9, RenderColor(1, 1, 1), FTriple(0.8, 0.2, 0)));

  FOR i := 0 TO 0 DO
    FRenderEngine.Append(TRenderLightsource.Create(
      FTriple(lCenter.X+0.9 + (i mod 4) * 0.125, lCenter.Y+1.9 - (i div 4) * 0.125,lCenter.z -1.5)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
end;

procedure TTestRenderImage.TestShowScene6;
VAR
  lRay: TRenderRay;
  i:    Integer;
  lCenter: TFTriple;
  lBarSize: Extended;
BEGIN
  lCenter:=FTriple(-1.5, -1.0, -0.01);
  lBarSize := 0.5;
  FRenderEngine.MaxDepth:=30;
  FRenderEngine.Append(TBox.Create(lCenter,
    FTriple(4, 4, 4), RenderColor(1, 1, 1), FTriple(0.05, 0.95, 0)));
  FRenderEngine.Append(TBox.Create(lCenter,
    FTriple(4, lBarSize, lBarSize), RenderColor(1, 1, 1), FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TBox.Create(lCenter,
    FTriple(lBarSize,4,  lBarSize), RenderColor(1, 1, 1), FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TBox.Create(lCenter,
    FTriple(lBarSize,lBarSize,4), RenderColor(1, 1, 1), FTriple(0.8, 0.2, 0)));

  FOR i := 0 TO 15 DO
    FRenderEngine.Append(TRenderLightsource.Create(
      FTriple(lCenter.X+0.9 + (i mod 4) * 0.125, lCenter.Y+1.9 - (i div 4) * 0.125,lCenter.z -1.5)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderImage.TestShowScene7;
VAR
  lRay:    TRenderRay;
BEGIN
  FRenderEngine.Append(TDisc.Create(FTriple(0, 0.5, 0),FTriple(0, 0, -1),1.0,clWhite,FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TDisc.Create(FTriple(1, -0.3, 0),FTriple(0, 1, -1),0.5,clLime,FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TDisc.Create(FTriple(-1, -0.3, 0),FTriple(0, -1, 1),0.5,clRed,FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TDisc.Create(FTriple(0, -0.6, -0.5),FTriple(0, 1, 0.2),1.5,clBlue,FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
end;

procedure TTestRenderImage.TestShowScene8;
VAR
  lRay:    TRenderRay;
BEGIN
  FRenderEngine.Append(TCylinder.Create(FTriple(0, 0.1, 0),FTriple(0, 0.7, -1),0.2,clWhite,FTriple(0.6, 0.4, 0)));
  FRenderEngine.Append(TCylinder.Create(FTriple(1, 0, 0),FTriple(1, -0.01, 1),0.35,clLime,FTriple(0.6, 0.4, 0)));
  FRenderEngine.Append(TCylinder.Create(FTriple(-1, -0.01, 1),FTriple(-1, 0, 0),0.35,clRed,FTriple(0.6, 0.4, 0)));
{  FRenderEngine.Append(TDisc.Create(FTriple(1, -0.3, 0),FTriple(0, 1, -1),0.5,clLime,FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TDisc.Create(FTriple(-1, -0.3, 0),FTriple(0, -1, 1),0.5,clRed,FTriple(0.8, 0.2, 0)));  }

  FRenderEngine.Append(TCylinder.Create(FTriple(0, -0.35, -0),FTriple(0, -0.4, -0),1.3,clBlue,FTriple(0.4, 0.6, 0)));
//  FRenderEngine.Append(TDisc.Create(FTriple(0, -0.30, -0),FTriple(0, -1, 0),1.3,clBlue,FTriple(0.8, 0.2, 0)));
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    TestRenderScene(lRay);
  FINALLY
    FreeAndNil(lRay);
  END;
end;

procedure TTestRenderImage.TestShowScene9;
begin

end;

constructor TTestRenderImage.Create;
BEGIN
  INHERITED Create;

  fFrmPictureDisplay := TForm.Create(Application);
  fFrmPictureDisplay.Height := 512;
  fFrmPictureDisplay.Width := 720;
  fFrmPictureDisplay.OnPaint := @OnFormPaint;

  fBitmap := TBitmap.Create;
  fBitmap.Height := fFrmPictureDisplay.ClientHeight;
  fBitmap.Width := fFrmPictureDisplay.ClientWidth;
  fBitmap.PixelFormat := pf24bit;

END;

destructor TTestRenderImage.Destroy;
BEGIN
  //  fFrmPictureDisplay.Hide;
  FreeAndNil(fBitmap);
  INHERITED Destroy;
END;

procedure TTestRenderObjects.SetUp;
BEGIN
  FRenderEngine := TRenderEngine.Create;
END;

procedure TTestRenderObjects.TearDown;
BEGIN
  FreeAndNil(FRenderEngine);
END;

procedure TTestRenderObjects.CheckEquals(const Exp, Act: TFTriple;
  eps: Extended; Msg: String);
BEGIN
  CheckEquals(exp.X, act.X, eps, Msg + '[X]');
  CheckEquals(exp.Y, act.Y, eps, Msg + '[Y]');
  CheckEquals(exp.Z, act.Z, eps, Msg + '[Z]');
END;

procedure TTestRenderObjects.CheckEquals(const Exp, Act: TRenderColor;
  Msg: String);
CONST
  cEps = 1e-4;
BEGIN
  CheckEquals(exp.Red, act.Red, cEps, Msg + '[Red]');
  CheckEquals(exp.Green, act.Green, cEps, Msg + '[Green]');
  CheckEquals(exp.Blue, act.Blue, cEps, Msg + '[Blue]');
end;


procedure TTestRenderObjects.TestSetUp;
begin
  CheckNotNull(FRenderEngine, 'FrenderEngine is assigned');
end;

procedure TTestRenderObjects.TestRay1Sphere;
VAR
  lRay:    TRenderRay;
  lSphere: TSphere;
  HitData: THitData;
   i: Integer;
  bDist:   Extended;
BEGIN
  lSphere := TSphere.Create(Trenderpoint.copy(0, 0, 0), 1.0,
    clWhite, FTriple(0.85734, 0.1, 0.0));
  FRenderEngine.Append(lSphere);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    CheckEquals(True, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary');
    CheckEquals(1.0, bDist, 1e-14, 'Hitdata.HP.Distance');
    CheckEquals(True, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest1');
    CheckEquals(1.0, HitData.Distance, 1e-15, 'HitData.Distance');
    CheckEquals(FTriple(0, 0, -1), HitData.HitPoint, 1e-15, 'HitData.HitPoint');
    CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-15, 'HitData.Normalvec');

    CheckEquals(RenderColor(1, 1, 1) * 0.5, FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray');

    lRay.Direction := FTriple(0.5, 0.5, sqrt(0.5));
    CheckEquals(False, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance2');
    CheckEquals(False, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest2');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance2');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    FOR i := 0 TO 10000 DO
    BEGIN
      lRay.Direction := FTriple(random - 0.5, Random - 0.5, 2.0);
      CheckEquals(True, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary');
      CheckEquals(True, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest3');
      CheckEquals(bDist, HitData.Distance, 1e-14, 'Hitdata.HP.Distance');
      CheckEquals(1.0, HitData.HitPoint.GLen, 1e-14, 'Hitdata.HP.Glen3');
      CheckEquals(HitData.HitPoint, HitData.Normalvec, 1e-14, 'Hitdata.HP.Normalvec');

    END;
  FINALLY
    FreeAndNil(lRay);
  END;

END;

procedure TTestRenderObjects.TestRay1InSphere;
VAR
  lRay:    TRenderRay;
  lSphere: TSphere;
  HitData: THitData;
  i: Integer;
  bDist:   Extended;
BEGIN
  lSphere := TSphere.Create(Trenderpoint.copy(0, 0, 0), 2.0,
    clWhite, FTriple(0.9, 0.1, 0.0));
  FRenderEngine.Append(lSphere);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-1, 1, -1)));

  lRay := TRenderRay.Create(FTriple(0, 0, 0), FTriple(0, 0, 1));
  TRY
    CheckEquals(True, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary');
    CheckEquals(0.0, bDist, 1e-14, 'Hitdata.HP.Distance');
    CheckEquals(True, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest1');
    CheckEquals(2.0, HitData.Distance, 1e-15, 'HitData.Distance');
    CheckEquals(FTriple(0, 0, 2), HitData.HitPoint, 1e-15, 'HitData.HitPoint');
    CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-15, 'HitData.Normalvec');

    CheckEquals(RenderColor(0.887311, 0.887311, 0.887311), FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray');

    lRay.Direction := FTriple(0.5, 0.5, sqrt(0.5));
    CheckEquals(True, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary2');
    CheckEquals(0.0, bDist, 1e-14, 'Hitdata.HP.Distance2');
    CheckEquals(True, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest2');
    CheckEquals(2.0, HitData.Distance, 1e-15, 'HitData.Distance2');
    CheckEquals(FTriple(1, 1, sqrt(2)), HitData.HitPoint, 1e-15, 'HitData.HitPoint2');
    CheckEquals(FTriple(-0.5, -0.5, -sqrt(0.5)), HitData.Normalvec, 1e-15,
      'HitData.Normalvec2');

    CheckEquals(RenderColor(1, 1, 1) * 0.858293, FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray2');

    FOR i := 0 TO 10000 DO
    BEGIN
      lRay.Direction := FTriple(random - 0.5, Random - 0.5, 2.0);
      CheckEquals(True, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary');
      CheckEquals(0.0, bDist, 1e-14, 'Hitdata.HP.Distance');
      CheckEquals(True, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest3');
      CheckEquals(2.0, HitData.Distance, 1e-14, 'Hitdata.HP.Distance');
      CheckEquals(2.0, HitData.HitPoint.GLen, 1e-14, 'Hitdata.HP.Glen3');
      CheckEquals(HitData.HitPoint * -0.5, HitData.Normalvec, 1e-14,
        'Hitdata.HP.Normalvec');

    END;
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderObjects.TestRayvsSphere2;
VAR
  lSphere: TSphere;
  lRay: TRenderRay;
  HitData: THitData;
  bDist: Extended;
  i: Integer;
BEGIN
  lSphere := TSphere.Create(Trenderpoint.copy(0, -1000.1, 0),
    1000.0, clWhite, FTriple(1, 0, 0));

  FRenderEngine.Append(lSphere);
  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    // First Test Some well known points
    // 1
    CheckEquals(False, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance');
    CheckEquals(False, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray1');

    // 2
    lRay.Direction := FTriple(0, 0.5, 1);
    CheckEquals(False, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance2');
    CheckEquals(False, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest2');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // 3
    lRay.Direction := FTriple(0, -0.5, 1);
    CheckEquals(True, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary3');
    CheckEquals(0.22721, bDist, 1e-5, 'Boundary.Distance3');
    CheckEquals(True, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest3');
    CheckEquals(0.22721, HitData.Distance, 1e-5, format('Hitdata.HP.Distance3', []));
    CheckEquals(FTriple(0, -0.1016142, -1.79677161), HitData.HitPoint,
      1e-7, 'HitData.HitPoint3');
    CheckEquals(FTriple(0, 0.99999838, -1.79677161e-3), HitData.Normalvec,
      1e-7, 'HitData.Normalvec3');

    CheckEquals(RenderColor(1, 1, 1), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // Random
    FOR i := 0 TO 10000 DO
    BEGIN
      lRay.Direction := FTriple(random - 0.5, Random - 1.0, 2.0);
      IF (lray.Direction.y < -0.05) or ((lray.Direction.y < -0.01) and
        lSphere.BoundaryTest(lRay, bDist)) THEN
      BEGIN
        CheckEquals(True, lSphere.BoundaryTest(lRay, bDist), format(
          'Sphere.Boundary[%d]', [i]));
        CheckEquals(True, lSphere.HitTest(lRay, HitData), format('Sphere.HitTest[%d]', [i]));
        CheckEquals(bDist, HitData.Distance, 1e-10, format('Hitdata.HP.Distance[%d]', [i]));
        CheckEquals(1000.0, (HitData.HitPoint - lSphere.Position).GLen,
          1e-12, format('Hitdata.HP.Glen[%d]', [i]));
        CheckEquals((HitData.HitPoint - lSphere.Position) * 0.001,
          HitData.Normalvec, 1e-12, format('Hitdata.HP.Normalvec[%d]', [i]));
        CheckEquals(0.995, HitData.Normalvec.y, 0.005, format(
          'Hitdata.HP.Normalvec.y[%d]', [i]));
      END
      ELSE
      BEGIN
        CheckEquals(False, lSphere.BoundaryTest(lRay, bDist), 'Sphere.Boundary');
        CheckEquals(False, lSphere.HitTest(lRay, HitData), 'Sphere.HitTest3');
        CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance');
        CheckEquals(-1.0, HitData.Distance, 1e-14, 'Hitdata.HP.Glen3');
      END;
    END;
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderObjects.TestRay2Plane;
VAR
  lRay:    TRenderRay;
  lPlane:  TPlane;
  HitData: THitData;
   i: Integer;
  bDist:   Extended;
BEGIN
  lPlane := TPlane.Create(FTriple(0, 0, 0), FTriple(0, 0, -1),
    clWhite, FTriple(0.80690397017, 0.0, 0.0));
  FRenderEngine.Append(lPlane);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    CheckEquals(True, lPlane.BoundaryTest(lRay, bDist), 'Plane.Boundary');
    CheckEquals(2.0, bDist, 1e-14, 'Hitdata.HP.Distance');
    CheckEquals(True, lPlane.HitTest(lRay, HitData), 'Plane.HitTest1');
    CheckEquals(2.0, HitData.Distance, 1e-15, 'HitData.Distance');
    CheckEquals(FTriple(0, 0, 0), HitData.HitPoint, 1e-15, 'HitData.HitPoint');
    CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-15, 'HitData.Normalvec');

    CheckEquals(RenderColor(0.5, 0.5, 0.5), FRenderEngine.Trace(lRay, 1.0, 1),
      'Trace one Ray');

    lRay.Direction := FTriple(0.5, 0.5, 0);
    CheckEquals(False, lPlane.BoundaryTest(lRay, bDist), 'Plane.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance2');
    CheckEquals(False, lPlane.HitTest(lRay, HitData), 'Plane.HitTest2');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance2');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    FOR i := 0 TO 10000 DO
    BEGIN
      lRay.Direction := FTriple(random - 0.5, Random - 0.5, 2.0);
      CheckEquals(True, lPlane.BoundaryTest(lRay, bDist), 'Plane.Boundary');
      CheckEquals(True, lPlane.HitTest(lRay, HitData), 'Plane.HitTest3');
      CheckEquals(bDist, HitData.Distance, 1e-14, 'Hitdata.HP.Distance');
      CheckEquals(0.0, HitData.HitPoint.z, 1e-14, 'Hitdata.HP.z');
      CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-14, 'Hitdata.HP.Normalvec');

    END;
  FINALLY
    FreeAndNil(lRay);
  END;

END;

procedure TTestRenderObjects.TestRayvsPlane2;
VAR
  lPlane: TPlane;
  lRay: TRenderRay;
  HitData: THitData;
  bDist: Extended;
  i: Integer;
BEGIN
  lPlane := TPlane.Create(FTriple(0, -0.1, 0), FTriple(0, 1, 0),
    clWhite, FTriple(1, 0, 0));

  FRenderEngine.Append(lPlane);
  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    // First Test Some well known points
    // 1
    CheckEquals(False, lPlane.BoundaryTest(lRay, bDist), 'Plane.Boundary');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance');
    CheckEquals(False, lPlane.HitTest(lRay, HitData), 'Plane.HitTest');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray1');

    // 2
    lRay.Direction := FTriple(0, 0.5, 1);
    CheckEquals(False, lPlane.BoundaryTest(lRay, bDist), 'Plane.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance2');
    CheckEquals(False, lPlane.HitTest(lRay, HitData), 'Plane.HitTest2');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // 3
    lRay.Direction := FTriple(0, -0.5, 1);
    CheckEquals(True, lPlane.BoundaryTest(lRay, bDist), 'Plane.Boundary3');
    CheckEquals(0.223606, bDist, 1e-5, 'Boundary.Distance3');
    CheckEquals(True, lPlane.HitTest(lRay, HitData), 'Plane.HitTest3');
    CheckEquals(0.223606, HitData.Distance, 1e-5, format('Hitdata.HP.Distance3', []));
    CheckEquals(FTriple(0, -0.1, -1.8), HitData.HitPoint, 1e-7, 'HitData.HitPoint3');
    CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-7, 'HitData.Normalvec3');

    CheckEquals(RenderColor(1, 1, 1), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // Random
    FOR i := 0 TO 10000 DO
    BEGIN
      lRay.Direction := FTriple(random - 0.5, Random - 1.0, 2.0);
      IF (lray.Direction.y < -1e-12) or ((lray.Direction.y < -1e-15) and
        lPlane.BoundaryTest(lRay, bDist)) THEN
      BEGIN
        CheckEquals(True, lPlane.BoundaryTest(lRay, bDist), format(
          'Plane.Boundary[%d]', [i]));
        CheckEquals(True, lPlane.HitTest(lRay, HitData), format('Plane.HitTest[%d]', [i]));
        CheckEquals(bDist, HitData.Distance, 1e-14, format('Hitdata.HP.Distance[%d]', [i]));
        CheckEquals(-0.1, HitData.HitPoint.y, 1e-14, format('Hitdata.HP.y[%d]', [i]));
        CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-14, format(
          'Hitdata.HP.Normalvec[%d]', [i]));
      END
      ELSE
      BEGIN
        CheckEquals(False, lPlane.BoundaryTest(lRay, bDist), 'Plane.Boundary');
        CheckEquals(False, lPlane.HitTest(lRay, HitData), 'Plane.HitTest3');
        CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance');
        CheckEquals(-1.0, HitData.Distance, 1e-14, 'Hitdata.HP.Glen3');
      END;
    END;
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderObjects.TestRay3Box;
VAR
  lRay:    TRenderRay;
  lBox:    TBox;
  HitData: THitData;
   i: Integer;
  bDist:   Extended;
  lExpTriple: TFTriple;
BEGIN
  lBox := TBox.Create(FTriple(0, 0, 0), FTriple(1, 1, 1),
    clWhite, FTriple(0.9, 0.1, 0.0));
  FRenderEngine.Append(lBox);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    // von Vorne
    CheckEquals(True, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary');
    CheckEquals(1.5, bDist, 1e-14, 'Boundary.Distance');
    CheckEquals(True, lBox.HitTest(lRay, HitData), 'Box.HitTest1');
    CheckEquals(1.5, HitData.Distance, 1e-15, 'HitData.Distance');
    CheckEquals(FTriple(0, 0, -0.5), HitData.HitPoint, 1e-15, 'HitData.HitPoint');
    CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-15, 'HitData.Normalvec');

    CheckEquals(RenderColor(1, 1, 1) * 0.5416713, FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray');

    lRay.Direction := FTriple(0.5, 0.5, sqrt(0.5));
    CheckEquals(False, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance2');
    CheckEquals(False, lBox.HitTest(lRay, HitData), 'Box.HitTest2');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance2');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // von Unten
    lray.StartPoint := FTriple(0, -2, 0);
    lRay.Direction  := FTriple(0, 1, 0);
    CheckEquals(True, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary3');
    CheckEquals(1.5, bDist, 1e-14, 'Boundary.Distance3');
    CheckEquals(True, lBox.HitTest(lRay, HitData), 'Box.HitTest3');
    CheckEquals(1.5, HitData.Distance, 1e-15, 'HitData.Distance3');
    CheckEquals(FTriple(0, -0.5, 0), HitData.HitPoint, 1e-15, 'HitData.HitPoint3');
    CheckEquals(FTriple(0, -1, 0), HitData.Normalvec, 1e-15, 'HitData.Normalvec3');

    CheckEquals(RenderColor(1, 1, 1) * 0.09, FRenderEngine.Trace(lRay, 1.0, 1),
      'Trace one Ray3');

    lRay.Direction := FTriple(0.5, sqrt(0.5), 0.5);
    CheckEquals(False, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary4');
    CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance4');
    CheckEquals(False, lBox.HitTest(lRay, HitData), 'Box.HitTest4');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance4');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray4');

    // von Links
    lray.StartPoint := FTriple(-2, 0, 0);
    lRay.Direction  := FTriple(1, 0, 0);
    CheckEquals(True, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary5');
    CheckEquals(1.5, bDist, 1e-14, 'Boundary.Distance5');
    CheckEquals(True, lBox.HitTest(lRay, HitData), 'Box.HitTest5');
    CheckEquals(1.5, HitData.Distance, 1e-15, 'HitData.Distance5');
    CheckEquals(FTriple(-0.5, 0, 0), HitData.HitPoint, 1e-15, 'HitData.HitPoint5');
    CheckEquals(FTriple(-1, 0, 0), HitData.Normalvec, 1e-15, 'HitData.Normalvec5');

    CheckEquals(RenderColor(1, 1, 1) * 0.5416713, FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray5');

    lRay.Direction := FTriple(sqrt(0.5), 0.5, 0.5);
    CheckEquals(False, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary6');
    CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance6');
    CheckEquals(False, lBox.HitTest(lRay, HitData), 'Box.HitTest6');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance6');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray6');

    lray.StartPoint := FTriple(0, 0, -2);
    FOR i := 0 TO 10000 DO
    BEGIN
      // Todo: all Sides
      lExpTriple     := FTriple(random - 0.5, Random - 0.5, 1.5);
      lRay.Direction := lExpTriple;
      CheckEquals(True, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary[%d]');
      CheckEquals(True, lBox.HitTest(lRay, HitData), 'Box.HitTest[%d]');
      CheckEquals(bDist, HitData.Distance, 1e-14, 'Hitdata.HP.Distance[%d]');
      lExpTriple.z := -0.5;
      CheckEquals(lExpTriple, HitData.HitPoint, 1e-14, 'Hitdata.HP.Glen[%d]');
      CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-14, 'Hitdata.HP.Normalvec[%d]');
    END;
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderObjects.TestRay3InBox;
VAR
  lRay:    TRenderRay;
  lBox:    TBox;
  HitData: THitData;
   i: Integer;
  bDist:   Extended;
  lExpTriple: TFTriple;
BEGIN
  lBox := TBox.Create(Trenderpoint.copy(0, 0, 0), FTriple(4, 4, 4),
    clWhite, FTriple(0.9, 0.1, 0.0));
  FRenderEngine.Append(lBox);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-1, 1, -1)));

  lRay := TRenderRay.Create(FTriple(0, 0, 0), FTriple(0, 0, 1));
  TRY
    CheckEquals(True, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary');
    CheckEquals(0.0, bDist, 1e-14, 'Boundary.Distance');
    CheckEquals(True, lBox.HitTest(lRay, HitData), 'Box.HitTest1');
    CheckEquals(2.0, HitData.Distance, 1e-15, 'HitData.Distance');
    CheckEquals(FTriple(0, 0, 2), HitData.HitPoint, 1e-15, 'HitData.HitPoint');
    CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-15, 'HitData.Normalvec');

    CheckEquals(RenderColor(0.887311, 0.887311, 0.887311), FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray');

    lRay.Direction := FTriple(0.5, 0.5, sqrt(0.5));
    CheckEquals(True, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary2');
    CheckEquals(0.0, bDist, 1e-14, 'Hitdata.HP.Distance2');
    CheckEquals(True, lBox.HitTest(lRay, HitData), 'Box.HitTest2');
    CheckEquals(sqrt(8), HitData.Distance, 1e-15, 'HitData.Distance2');
    CheckEquals(FTriple(sqrt(2), sqrt(2), 2), HitData.HitPoint, 1e-15, 'HitData.HitPoint2');
    CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-15, 'HitData.Normalvec2');

    CheckEquals(RenderColor(1, 1, 1) * 0.726423, FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray2');

    FOR i := 0 TO 10000 DO
    BEGIN
      // Todo: all Sides
      lExpTriple     := FTriple(random - 0.5, Random - 0.5, 2.0);
      lRay.Direction := lExpTriple;
      CheckEquals(True, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary');
      CheckEquals(0.0, bDist, 1e-14, 'Hitdata.HP.Distance');
      CheckEquals(True, lBox.HitTest(lRay, HitData), 'Box.HitTest3');
      CheckEquals(lExpTriple.glen, HitData.Distance, 1e-14, 'Hitdata.HP.Distance');
      CheckEquals(lExpTriple, HitData.HitPoint, 1e-14, 'Hitdata.HP.Glen3');
      CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-14, 'Hitdata.HP.Normalvec');

    END;
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderObjects.TestRayvsBox3;
VAR
  lBox: TBox;
  lRay: TRenderRay;
  HitData: THitData;
  bDist: Extended;
  i: Integer;
BEGIN
  lBox := TBox.Create(Trenderpoint.copy(0, -1000.1, 0),
    FTriple(1, 1, 1) * 2000.0, clWhite, FTriple(1, 0, 0));

  FRenderEngine.Append(lBox);
  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    // First Test Some well known points
    // 1
    CheckEquals(False, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance');
    CheckEquals(False, lBox.HitTest(lRay, HitData), 'Box.HitTest');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray1');

    // 2
    lRay.Direction := FTriple(0, 0.5, 1);
    CheckEquals(False, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance2');
    CheckEquals(False, lBox.HitTest(lRay, HitData), 'Box.HitTest2');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // 3
    lRay.Direction := FTriple(0, -0.5, 1);
    CheckEquals(True, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary3');
    CheckEquals(0.223606, bDist, 1e-5, 'Boundary.Distance3');
    CheckEquals(True, lBox.HitTest(lRay, HitData), 'Box.HitTest3');
    CheckEquals(0.223606, HitData.Distance, 1e-5, format('Hitdata.HP.Distance3', []));
    CheckEquals(FTriple(0, -0.1, -1.8), HitData.HitPoint, 1e-7, 'HitData.HitPoint3');
    CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-7, 'HitData.Normalvec3');

    CheckEquals(RenderColor(1, 1, 1), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // Random
    FOR i := 0 TO 10000 DO
    BEGIN
      lRay.Direction := FTriple(random - 0.5, Random - 1.0, 2.0);
      IF (lray.Direction.y < -1e-4) or ((lray.Direction.y < -1e-5) and
        lBox.BoundaryTest(lRay, bDist)) THEN
      BEGIN
        CheckEquals(True, lBox.BoundaryTest(lRay, bDist), format('Box.Boundary[%d]', [i]));
        CheckEquals(True, lBox.HitTest(lRay, HitData), format('Box.HitTest[%d]', [i]));
        CheckEquals(bDist, HitData.Distance, 1e-14, format('Hitdata.HP.Distance[%d]', [i]));
        CheckEquals(-0.1, HitData.HitPoint.y, 1e-12, format('Hitdata.HP.y[%d]', [i]));
        CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-14, format(
          'Hitdata.HP.Normalvec[%d]', [i]));
      END
      ELSE
      BEGIN
        CheckEquals(False, lBox.BoundaryTest(lRay, bDist), 'Box.Boundary');
        CheckEquals(False, lBox.HitTest(lRay, HitData), 'Box.HitTest3');
        CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance');
        CheckEquals(-1.0, HitData.Distance, 1e-14, 'Hitdata.HP.Glen3');
      END;
    END;
  FINALLY
    FreeAndNil(lRay);
  END;
END;

procedure TTestRenderObjects.TestRay4Disc;
VAR
  lRay:    TRenderRay;
  lDisc:  TDisc;
  HitData: THitData;
   i: Integer;
  bDist:   Extended;
BEGIN
  lDisc := TDisc.Create(FTriple(0, 0, 0), FTriple(0, 0, -1),1.0,
    clWhite, FTriple(0.80690397017, 0.0, 0.0));
  FRenderEngine.Append(lDisc);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    CheckEquals(True, lDisc.BoundaryTest(lRay, bDist), 'Disc.Boundary');
    CheckEquals(2.0, bDist, 1e-14, 'Hitdata.HP.Distance');
    CheckEquals(True, lDisc.HitTest(lRay, HitData), 'Disc.HitTest1');
    CheckEquals(2.0, HitData.Distance, 1e-15, 'HitData.Distance');
    CheckEquals(FTriple(0, 0, 0), HitData.HitPoint, 1e-15, 'HitData.HitPoint');
    CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-15, 'HitData.Normalvec');

    CheckEquals(RenderColor(0.5, 0.5, 0.5), FRenderEngine.Trace(lRay, 1.0, 1),
      'Trace one Ray');

    lRay.Direction := FTriple(0.5, 0.5, 1.3);
    CheckEquals(False, lDisc.BoundaryTest(lRay, bDist), 'Disc.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance2');
    CheckEquals(False, lDisc.HitTest(lRay, HitData), 'Disc.HitTest2');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance2');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    FOR i := 0 TO 10000 DO
    BEGIN
      lRay.Direction := FTriple(random - 0.5, Random - 0.5, 1.6);
      CheckEquals(True, lDisc.BoundaryTest(lRay, bDist), 'Disc.Boundary');
      CheckEquals(True, lDisc.HitTest(lRay, HitData), 'Disc.HitTest3');
      CheckEquals(bDist, HitData.Distance, 1e-14, 'Hitdata.HP.Distance');
      CheckEquals(0.0, HitData.HitPoint.z, 1e-14, 'Hitdata.HP.z');
      CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-14, 'Hitdata.HP.Normalvec');

    END;
  FINALLY
    FreeAndNil(lRay);
  END;
end;

procedure TTestRenderObjects.TestRayvsDisk4;
VAR
  lDisc: TDisc;
  lRay: TRenderRay;
  HitData: THitData;
  bDist: Extended;
  i: Integer;
BEGIN
  lDisc := TDisc.Create(FTriple(0, -0.1, 0), FTriple(0, 1, 0),1000.0,
    clWhite, FTriple(1, 0, 0));

  FRenderEngine.Append(lDisc);
  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    // First Test Some well known points
    // 1
    CheckEquals(False, lDisc.BoundaryTest(lRay, bDist), 'Disc.Boundary');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance');
    CheckEquals(False, lDisc.HitTest(lRay, HitData), 'Disc.HitTest');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray1');

    // 2
    lRay.Direction := FTriple(0, 0.5, 1);
    CheckEquals(False, lDisc.BoundaryTest(lRay, bDist), 'Disc.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance2');
    CheckEquals(False, lDisc.HitTest(lRay, HitData), 'Disc.HitTest2');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // 3
    lRay.Direction := FTriple(0, -0.5, 1);
    CheckEquals(True, lDisc.BoundaryTest(lRay, bDist), 'Disc.Boundary3');
    CheckEquals(0.223606, bDist, 1e-5, 'Boundary.Distance3');
    CheckEquals(True, lDisc.HitTest(lRay, HitData), 'Disc.HitTest3');
    CheckEquals(0.223606, HitData.Distance, 1e-5, format('Hitdata.HP.Distance3', []));
    CheckEquals(FTriple(0, -0.1, -1.8), HitData.HitPoint, 1e-7, 'HitData.HitPoint3');
    CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-7, 'HitData.Normalvec3');

    CheckEquals(RenderColor(1, 1, 1), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // Random
    FOR i := 0 TO 10000 DO
    BEGIN
      lRay.Direction := FTriple(random - 0.5, Random - 1.0, 2.0);
      IF (lray.Direction.y < -1e-4) or ((lray.Direction.y < -1e-5) and
        lDisc.BoundaryTest(lRay, bDist)) THEN
      BEGIN
        CheckEquals(True, lDisc.BoundaryTest(lRay, bDist), format(
          'Disc.Boundary[%d]', [i]));
        CheckEquals(True, lDisc.HitTest(lRay, HitData), format('Disc.HitTest[%d]', [i]));
        CheckEquals(bDist, HitData.Distance, 1e-14, format('Hitdata.HP.Distance[%d]', [i]));
        CheckEquals(-0.1, HitData.HitPoint.y, 1e-14, format('Hitdata.HP.y[%d]', [i]));
        CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-14, format(
          'Hitdata.HP.Normalvec[%d]', [i]));
      END
      ELSE
      BEGIN
        CheckEquals(False, lDisc.BoundaryTest(lRay, bDist), 'Disc.Boundary');
        CheckEquals(False, lDisc.HitTest(lRay, HitData), 'Disc.HitTest3');
        CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance');
        CheckEquals(-1.0, HitData.Distance, 1e-14, 'Hitdata.HP.Glen3');
      END;
    END;
  FINALLY
    FreeAndNil(lRay);
  END;
end;

procedure TTestRenderObjects.TestRay5Cylinder;
VAR
  lRay:    TRenderRay;
  lCylinder:    TCylinder;
  HitData: THitData;
   i: Integer;
  bDist:   Extended;
  lExpTriple: TFTriple;
BEGIN
  lCylinder := TCylinder.Create(FTriple(0, -1, 0), FTriple(0, 1, 0),1.0,
    clWhite, FTriple(0.9, 0.1, 0.0));
  FRenderEngine.Append(lCylinder);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-10, 10, -10)));

  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    // von Vorne
    CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary');
    CheckEquals(1.0, bDist, 1e-14, 'Boundary.Distance');
    CheckEquals(True, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest1');
    CheckEquals(1.0, HitData.Distance, 1e-15, 'HitData.Distance');
    CheckEquals(FTriple(0, 0, -1.0), HitData.HitPoint, 1e-15, 'HitData.HitPoint');
    CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-15, 'HitData.Normalvec');

    CheckEquals(RenderColor(1, 1, 1) * 0.52488, FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray');

    lRay.Direction := FTriple(0.5, 0.5, 0.86);
    CheckEquals(False, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance2');
    CheckEquals(False, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest2');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance2');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // von Unten
    lray.StartPoint := FTriple(0, -2, 0);
    lRay.Direction  := FTriple(0, 1, 0);
    CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary3');
    CheckEquals(1.0, bDist, 1e-14, 'Boundary.Distance3');
    CheckEquals(True, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest3');
    CheckEquals(1.0, HitData.Distance, 1e-15, 'HitData.Distance3');
    CheckEquals(FTriple(0, -1.0, 0), HitData.HitPoint, 1e-15, 'HitData.HitPoint3');
    CheckEquals(FTriple(0, -1, 0), HitData.Normalvec, 1e-15, 'HitData.Normalvec3');

    CheckEquals(RenderColor(1, 1, 1) * 0.09, FRenderEngine.Trace(lRay, 1.0, 1),
      'Trace one Ray3');

    lRay.Direction := FTriple(0.5, 0.7, 0.5);
    CheckEquals(False, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary4');
    CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance4');
    CheckEquals(False, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest4');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance4');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray4');

    // von Links
    lray.StartPoint := FTriple(-2, 0, 0);
    lRay.Direction  := FTriple(1, 0, 0);
    CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary5');
    CheckEquals(1.0, bDist, 1e-14, 'Boundary.Distance5');
    CheckEquals(True, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest5');
    CheckEquals(1.0, HitData.Distance, 1e-15, 'HitData.Distance5');
    CheckEquals(FTriple(-1.0, 0, 0), HitData.HitPoint, 1e-15, 'HitData.HitPoint5');
    CheckEquals(FTriple(-1, 0, 0), HitData.Normalvec, 1e-15, 'HitData.Normalvec5');

    CheckEquals(RenderColor(1, 1, 1) * 0.52488, FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray5');

    lRay.Direction := FTriple(0.86, 0.5, 0.5);
    CheckEquals(False, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary6');
    CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance6');
    CheckEquals(False, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest6');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance6');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray6');

    // von Oben
    lray.StartPoint := FTriple(0,  2, 0);
    lRay.Direction  := FTriple(0, -1, 0);
    CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary7');
    CheckEquals(1.0, bDist, 1e-14, 'Boundary.Distance7');
    CheckEquals(True, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest7');
    CheckEquals(1.0, HitData.Distance, 1e-15, 'HitData.Distance7');
    CheckEquals(FTriple(0, 1.0, 0), HitData.HitPoint, 1e-15, 'HitData.HitPoint7');
    CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-15, 'HitData.Normalvec7');

    CheckEquals(RenderColor(1, 1, 1) * 0.524885, FRenderEngine.Trace(lRay, 1.0, 1),
      'Trace one Ray7');

    lRay.Direction := FTriple(0.5, 0.7, 0.5);
    CheckEquals(False, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary8');
    CheckEquals(-1.0, bDist, 1e-14, 'Hitdata.HP.Distance8');
    CheckEquals(False, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest8');
    CheckEquals(-1.0, HitData.Distance, 1e-15, 'HitData.Distance8');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray8');

    lray.StartPoint := FTriple(0, 0, -2);
    FOR i := 0 TO 10000 DO
    BEGIN
      // Todo: all Sides
      lExpTriple     := FTriple(random - 0.5, Random - 0.5, 1.0);
      lRay.Direction := lExpTriple;
      CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), format('Cylinder.Boundary[%d]',[i]));
      CheckEquals(True, lCylinder.HitTest(lRay, HitData),format( 'Cylinder.HitTest[%d],[i])',[i]));
      CheckEquals(bDist, HitData.Distance, 1e-14,format( 'Hitdata.HP.Distance[%d]',[i]));
      lExpTriple:=FTriple(0,1,0)* HitData.HitPoint.y;
      CheckEquals(1.0, (HitData.HitPoint-lExpTriple).glen, 1e-14,format( 'Hitdata.HP.Glen[%d]',[i]));
      CheckEquals(HitData.HitPoint-lExpTriple, HitData.Normalvec, 1e-14,format( 'Hitdata.HP.Normalvec[%d]',[i]));
    END;
  FINALLY
    FreeAndNil(lRay);
  END;
end;

procedure TTestRenderObjects.TestRay5InCylinder;
VAR
  lRay:    TRenderRay;
  lCylinder:    TCylinder;
  HitData: THitData;
   i: Integer;
  bDist, lExpX:   Extended;
  lExpTriple: TFTriple;
BEGIN
  lCylinder := TCylinder.Create(Trenderpoint.copy(0, -1, 0), FTriple(0, 1, 0),3.0,
    clWhite, FTriple(0.9, 0.1, 0.0));
  FRenderEngine.Append(lCylinder);
  FRenderEngine.Append(TRenderLightsource.Create(FTriple(-1, 1, -1)));

  lRay := TRenderRay.Create(FTriple(0, 0, 0), FTriple(0, 0, 1));
  TRY
    CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary');
    CheckEquals(0.0, bDist, 1e-14, 'Boundary.Distance');
    CheckEquals(True, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest1');
    CheckEquals(3.0, HitData.Distance, 1e-15, 'HitData.Distance');
    CheckEquals(FTriple(0, 0, 3), HitData.HitPoint, 1e-15, 'HitData.HitPoint');
    CheckEquals(FTriple(0, 0, -1), HitData.Normalvec, 1e-15, 'HitData.Normalvec');

    CheckEquals(RenderColor(1, 1, 1)*0.93819, FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray');

    lRay.Direction := FTriple(0.5, 0.5, sqrt(0.5));
    CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary2');
    CheckEquals(0.0, bDist, 1e-14, 'Hitdata.HP.Distance2');
    CheckEquals(True, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest2');
    CheckEquals(2.0, HitData.Distance, 1e-15, 'HitData.Distance2');
    CheckEquals(FTriple(1, 1, sqrt(2)), HitData.HitPoint, 1e-15, 'HitData.HitPoint2');
    CheckEquals(FTriple(0, -1, 0), HitData.Normalvec, 1e-15, 'HitData.Normalvec2');

    CheckEquals(RenderColor(1, 1, 1) * 0.178783, FRenderEngine.Trace(
      lRay, 1.0, 1), 'Trace one Ray2');

    FOR i := 0 TO 10000 DO
    BEGIN
      // Todo: all Sides
      lExpX :=random - 0.5;
      lExpTriple     := FTriple(lExpX, Random - 0.5, sqrt(9.0-sqr(lExpX)));
      lRay.Direction := lExpTriple;
      CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary');
      CheckEquals(0.0, bDist, 1e-14, 'Hitdata.HP.Distance');
      CheckEquals(True, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest3');
      CheckEquals(lExpTriple.glen, HitData.Distance, 1e-14, 'Hitdata.HP.Distance');
      CheckEquals(lExpTriple, HitData.HitPoint, 1e-14, 'Hitdata.HP.Glen3');
      CheckEquals(FTriple(-lRay.Direction.x, 0, -lRay.Direction.z).Normalize, HitData.Normalvec, 1e-14, 'Hitdata.HP.Normalvec');

    END;
  FINALLY
    FreeAndNil(lRay);
  END;
end;

procedure TTestRenderObjects.TestRayvsCylinder5;
VAR
  lCylinder: TCylinder;
  lCylinder2: TCylinder;
  lRay: TRenderRay;
  HitData: THitData;
  bDist: Extended;
  i: Integer;
BEGIN
  lCylinder := TCylinder.Create(FTriple(0, -0.1, 0), FTriple(0, -0.2, 0),1000.0,
    clWhite, FTriple(1, 0, 0));
  lCylinder2 := TCylinder.Create(FTriple(0, -0.2, 0), FTriple(0, -0.1, 0),1000.0,
    clWhite, FTriple(1, 0, 0));

  FRenderEngine.Append(lCylinder);
  lRay := TRenderRay.Create(FTriple(0, 0, -2), FTriple(0, 0, 1));
  TRY
    // First Test Some well known points
    // 1
    CheckEquals(False, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance');
    CheckEquals(False, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray1');

    CheckEquals(False, lCylinder2.BoundaryTest(lRay, bDist), 'Cylinder.Boundary1a');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance1a');
    CheckEquals(False, lCylinder2.HitTest(lRay, HitData), 'Cylinder.HitTest1a');

    // 2
    lRay.Direction := FTriple(0, 0.5, 1);
    CheckEquals(False, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary2');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance2');
    CheckEquals(False, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest2');
    CheckEquals(False, lCylinder2.BoundaryTest(lRay, bDist), 'Cylinder.Boundary2a');
    CheckEquals(-1.0, bDist, 1e-14, 'Boundary.Distance2a');
    CheckEquals(False, lCylinder2.HitTest(lRay, HitData), 'Cylinder.HitTest2a');

    CheckEquals(RenderColor(0, 0, 0), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // 3
    lRay.Direction := FTriple(0, -0.5, 1);
    CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), 'Cylinder.Boundary3');
    CheckEquals(0.223606, bDist, 1e-5, 'Boundary.Distance3');
    CheckEquals(True, lCylinder.HitTest(lRay, HitData), 'Cylinder.HitTest3');
    CheckEquals(0.223606, HitData.Distance, 1e-5, format('Hitdata.HP.Distance3', []));
    CheckEquals(FTriple(0, -0.1, -1.8), HitData.HitPoint, 1e-7, 'HitData.HitPoint3');
    CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-7, 'HitData.Normalvec3');

    CheckEquals(True, lCylinder2.BoundaryTest(lRay, bDist), 'Cylinder.Boundary3a');
    CheckEquals(0.223606, bDist, 1e-5, 'Boundary.Distance3a');
    CheckEquals(True, lCylinder2.HitTest(lRay, HitData), 'Cylinder.HitTest3a');
    CheckEquals(0.223606, HitData.Distance, 1e-5, format('Hitdata.HP.Distance3a', []));
    CheckEquals(FTriple(0, -0.1, -1.8), HitData.HitPoint, 1e-7, 'HitData.HitPoint3a');
    CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-7, 'HitData.Normalvec3a');

    CheckEquals(RenderColor(1, 1, 1), FRenderEngine.Trace(lRay, 1.0, 1), 'Trace one Ray2');

    // Random
    FOR i := 0 TO 10000 DO
    BEGIN
      lRay.Direction := FTriple(random - 0.5, Random - 1.0, 2.0);
      IF (lray.Direction.y < -1e-4) or ((lray.Direction.y < -1e-5) and
        lCylinder.BoundaryTest(lRay, bDist)) THEN
      BEGIN
        CheckEquals(True, lCylinder.BoundaryTest(lRay, bDist), format(
          'Cylinder.Boundary[%d]', [i]));
        CheckEquals(True, lCylinder.HitTest(lRay, HitData), format('Cylinder.HitTest[%d]', [i]));
        CheckEquals(bDist, HitData.Distance, 1e-14, format('Hitdata.HP.Distance[%d]', [i]));
        CheckEquals(-0.1, HitData.HitPoint.y, 1e-14, format('Hitdata.HP.y[%d]', [i]));
        CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-14, format(
          'Hitdata.HP.Normalvec[%d]', [i]));
        CheckEquals(True, lCylinder2.BoundaryTest(lRay, bDist), format(
          'Cylinder.Boundary[%d]a', [i]));
        CheckEquals(True, lCylinder2.HitTest(lRay, HitData), format('Cylinder.HitTest[%d]a', [i]));
        CheckEquals(bDist, HitData.Distance, 1e-14, format('Hitdata.HP.Distance[%d]a', [i]));
        CheckEquals(-0.1, HitData.HitPoint.y, 1e-14, format('Hitdata.HP.y[%d]a', [i]));
        CheckEquals(FTriple(0, 1, 0), HitData.Normalvec, 1e-14, format(
        'Hitdata.HP.Normalvec[%d]a', [i]));
      END
      ELSE
      BEGIN
        CheckEquals(false, lCylinder.BoundaryTest(lRay, bDist), format(
          'Cylinder.Boundary[%d]', [i]));
        CheckEquals(false, lCylinder.HitTest(lRay, HitData), format('Cylinder.HitTest[%d]', [i]));
        CheckEquals(-1.0, bDist, 1e-14, 'Boundary.DistanceX');
        CheckEquals(-1.0, HitData.Distance, 1e-14, 'Hitdata.DistanceX');
        CheckEquals(false, lCylinder2.BoundaryTest(lRay, bDist), format(
          'Cylinder.Boundary[%d]a', [i]));
        CheckEquals(false, lCylinder2.HitTest(lRay, HitData), format('Cylinder.HitTest[%d]a', [i]));
        CheckEquals(-1.0, bDist, 1e-14, 'Boundary.DistanceXa');
        CheckEquals(-1.0, HitData.Distance, 1e-14, 'Hitdata.DistanceXa');
      END;
    END;
  FINALLY
    FreeAndNil(lRay);
  END;
end;

INITIALIZATION

  RegisterTests([TTestRenderObjects,TTestRenderImage]);
END.












































