unit TestOGLScnGroup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, TestOGLSceneComp, Cmp_OpenGLScene;

type

  { TTestOGlSceneGroup }

   TTestOGlSceneGroup=class(TTestOGlSceneBase)
   private
     F3DGroup:TO3DGroup;
   protected
     procedure SetUp; override;
     procedure TearDown; override;
   published
     procedure TestSetUp;override;
     Procedure TestReadAttributes;
     Procedure TestWriteAttributes;
   end;


implementation

uses Unt_VariantProcs;
{ TTestOGlSceneGroup }

procedure TTestOGlSceneGroup.SetUp;
begin
  inherited SetUp;
  F3DGroup := TO3DGroup.Create(nil);
end;

procedure TTestOGlSceneGroup.TearDown;
begin
  freeandnil(F3DGroup);
  inherited TearDown;
end;

procedure TTestOGlSceneGroup.TestSetUp;
begin
  inherited TestSetUp;
  CheckNotNull(F3DGroup,'Group-Obj is assigned');
end;

procedure TTestOGlSceneGroup.TestReadAttributes;
begin
  CheckEquals('("Translation","TPointF","Rotation.Amount","Double","Rotation.Vector","TPointF","Transl.Amount","Double","Transl.Vector","TPointF")',
    Var2string(F3DGroup.ListAttr,true),'F3DGroup.ListAttr');
  CheckEquals(5,F3DGroup.AttrCount,'F3DGroup.AttrCount');
  CheckEquals('("PointF",("X",0,"Y",0,"Z",0))',var2String(F3DGroup.Attributes[0],true),'Read0 F3DGroup.Attribute[0]');
  CheckEquals('0',var2String(F3DGroup.Attributes[1],true),'Read0 F3DGroup.Attribute[1]');
  CheckEquals('("PointF",("X",0,"Y",0,"Z",0))',var2String(F3DGroup.Attributes[2],true),'Read0 F3DGroup.Attribute[2]');
  CheckEquals('0',var2String(F3DGroup.Attributes[3],true),'Read0 F3DGroup.Attribute[3]');
  CheckEquals('("PointF",("X",0,"Y",0,"Z",0))',var2String(F3DGroup.Attributes[4],true),'Read0 F3DGroup.Attribute[4]');

  F3DGroup.moveto (PointF(1,2,3));
  CheckEquals('("PointF",("X",1,"Y",2,"Z",3))',var2String(F3DGroup.Attributes[0],true),'Read1 F3DGroup.Attribute[0]');
  F3DGroup.RotVector := eX;
  CheckEquals('("PointF",("X",1,"Y",0,"Z",0))',var2String(F3DGroup.Attributes[2],true),'Read1 F3DGroup.Attribute[2]');
  F3DGroup.RotAmount := 45;
  CheckEquals('45',var2String(F3DGroup.Attributes[1],true),'Read1 F3DGroup.Attribute[1]');
  F3DGroup.TranslVector := eZ;
  CheckEquals('("PointF",("X",0,"Y",0,"Z",1))',var2String(F3DGroup.Attributes[4],true),'Read1 F3DGroup.Attribute[4]');
  F3DGroup.TranslAmount := 1.234;
  CheckEquals('1.234',var2String(F3DGroup.Attributes[3],TestFormatSettings,true),'Read1 F3DGroup.Attribute[3]');

  F3DGroup.moveto (PointF(4,5,6));
  CheckEquals('("PointF",("X",4,"Y",5,"Z",6))',var2String(F3DGroup.Attributes['Translation'],true),'Read F3DGroup.Attribute[Translation]');
  F3DGroup.RotVector := eY;
  CheckEquals('("PointF",("X",0,"Y",1,"Z",0))',var2String(F3DGroup.Attributes['Rotation.Vector'],true),'Read F3DGroup.Attribute[Rotation.Vector]');
  F3DGroup.RotAmount := 60;
  CheckEquals('60',var2String(F3DGroup.Attributes['Rotation.Amount'],true),'Read F3DGroup.Attribute[Rotation.Amount]');
  F3DGroup.TranslVector := eX;
  CheckEquals('("PointF",("X",1,"Y",0,"Z",0))',var2String(F3DGroup.Attributes['Transl.Vector'],true),'Read F3DGroup.Attribute[Rotation.Vector]');
  F3DGroup.TranslAmount := 4.321;
  CheckEquals('4.321',var2String(F3DGroup.Attributes['Transl.Amount'],TestFormatSettings,true),'Read F3DGroup.Attribute[Rotation.Amount]');
end;

procedure TTestOGlSceneGroup.TestWriteAttributes;
begin
  CheckEquals('("PointF",("X",0,"Y",0,"Z",0))',var2String(F3DGroup.Attributes[0],true),'F3DGroup.Attribute[0]');
  CheckEquals('0',var2String(F3DGroup.Attributes[1],true),'F3DGroup.Attribute[1]');
  CheckEquals('("PointF",("X",0,"Y",0,"Z",0))',var2String(F3DGroup.Attributes[2],true),'F3DGroup.Attribute[2]');
  CheckEquals('0',var2String(F3DGroup.Attributes[3],true),'Read0 F3DGroup.Attribute[3]');
  CheckEquals('("PointF",("X",0,"Y",0,"Z",0))',var2String(F3DGroup.Attributes[4],true),'Read0 F3DGroup.Attribute[4]');

  F3DGroup.Attributes[0]:= PointF(1,2,3).AsVariant;
  CheckEqualPoint(PointF(1,2,3),F3DGroup.Translation,'Write F3DGroup.Attribute[0]');
  F3DGroup.Attributes[2] := eX.AsVariant;
  CheckEqualPoint(eX,F3DGroup.RotVector,'Write F3DGroup.Attribute[2]');
  F3DGroup.Attributes[1] := 45;
  CheckEquals(45,F3DGroup.RotAmount,'F3DGroup.Attribute[0]');
  F3DGroup.Attributes[4] := eZ.AsVariant;
  CheckEqualPoint(eZ,F3DGroup.TranslVector,'Write F3DGroup.Attribute[2]');
  F3DGroup.Attributes[3] := 1.234;
  CheckEquals(1.234,F3DGroup.TranslAmount,'F3DGroup.Attribute[0]');

  F3DGroup.Attributes['Translation']:= PointF(6,5,4).AsVariant;
  CheckEqualPoint(PointF(6,5,4),F3DGroup.Translation,'Write F3DGroup.Attribute[Translation]');
  F3DGroup.Attributes['Rotation.Vector'] := eY.AsVariant;
  CheckEqualPoint(eY,F3DGroup.RotVector,'Write F3DGroup.Attribute[Rotation.Vector]');
  F3DGroup.Attributes['Rotation.Amount'] := 60;
  CheckEquals(60,F3DGroup.RotAmount,'F3DGroup.Attribute[Rotation.Amount]');
  F3DGroup.Attributes['Transl.Vector'] := eX.AsVariant;
  CheckEqualPoint(eX,F3DGroup.TranslVector,'Write F3DGroup.Attribute[Transl.Vector]');
  F3DGroup.Attributes['Transl.Amount'] := 4.321;
  CheckEquals(4.321,F3DGroup.TranslAmount,'F3DGroup.Attribute[Transl.Vector]');
end;

initialization

   RegisterTest('TTestOGlScene',TTestOGlSceneGroup);
end.

