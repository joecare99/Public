unit TestOGLScnBaseObjects;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit,  testregistry, TestOGLSceneComp, Cmp_OpenGLScene;

type
  { TTestOGlSceneBaseObj }

   TTestOGlSceneBaseObj=class(TTestOGlSceneBase)
   private
     F3DBasisObject:T3DBasisObject;
   protected
     procedure SetUp; override;
     procedure TearDown; override;
   published
     procedure TestSetUp;override;
     Procedure TestMoveTo;
     procedure TestRotate;
     procedure TestReadAttributes;
   end;

implementation

uses Unt_VariantProcs;

{ TTestOGlSceneBaseObj }

procedure TTestOGlSceneBaseObj.SetUp;
begin
  inherited SetUp;
  F3DBasisObject:=T3DBasisObject.Create(nil){%H-};
end;

procedure TTestOGlSceneBaseObj.TearDown;
begin
  Freeandnil(F3DBasisObject);
  inherited TearDown;
end;

procedure TTestOGlSceneBaseObj.TestSetUp;
begin
  inherited TestSetUp;
  CheckNotNull(F3DBasisObject,'Working Object is assigned');
  CheckEqualPoint(Zero,F3DBasisObject.Translation,'No Translation');
  CheckEqualPoint(Zero,F3DBasisObject.RotVector,'No Rotation');
end;

procedure TTestOGlSceneBaseObj.TestMoveTo;
begin
  CheckEqualPoint(Zero,F3DBasisObject.Translation,'No Translation');
  F3DBasisObject.MoveTo(1,2,3);
  CheckEqualPoint(PointF(1,2,3),F3DBasisObject.Translation,'Def Translation1');
  F3DBasisObject.MoveTo(pointF(6,5,4));
  CheckEqualPoint(PointF(6,5,4),F3DBasisObject.Translation,'Def Translation2');
end;

procedure TTestOGlSceneBaseObj.TestRotate;
begin
  CheckEqualPoint(Zero,F3DBasisObject.RotVector,'No Rotation');
  F3DBasisObject.Rotate(1,2,3,4);
  CheckEqualPoint(PointF(2,3,4),F3DBasisObject.RotVector,'def. Rotation');
end;

procedure TTestOGlSceneBaseObj.TestReadAttributes;
begin
  CheckEquals('("Translation","TPointF","Rotation.Amount","Double","Rotation.Vector","TPointF")',
    var2String(F3DBasisObject.ListAttr,true),'F3DBasisObject.ListAttr');
  CheckEquals(3,F3DBasisObject.AttrCount,'F3DBasisObject.AttrCount');
  CheckEquals('("PointF",("X",0,"Y",0,"Z",0))',var2String(F3DBasisObject.Attribute[0],true),'F3DBasisObject.Attribute[0]');
  CheckEquals('0',var2String(F3DBasisObject.Attribute[1],true),'F3DBasisObject.Attribute[1]');
  CheckEquals('("PointF",("X",0,"Y",0,"Z",0))',var2String(F3DBasisObject.Attribute[2],true),'F3DBasisObject.Attribute[2]');
  F3DBasisObject.moveto (PointF(1,2,3));
  CheckEquals('("PointF",("X",1,"Y",2,"Z",3))',var2String(F3DBasisObject.Attribute[0],true),'F3DBasisObject.Attribute[0]');
  F3DBasisObject.RotVector := eX;
  CheckEquals('("PointF",("X",1,"Y",0,"Z",0))',var2String(F3DBasisObject.Attribute[2],true),'F3DBasisObject.Attribute[0]');
  F3DBasisObject.RotAmount := 45;
  CheckEquals('45',var2String(F3DBasisObject.Attribute[1],true),'F3DBasisObject.Attribute[0]');
end;
//"F3DBasisObject.Attribute[0]" expected: <> but was: <("PointF",("X",0,"Y",0,"Z",0))>


initialization

  RegisterTest('TTestOGlScene',TTestOGlSceneBaseObj);
end.

