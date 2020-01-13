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
end;

initialization

   RegisterTest('TTestOGlScene',TTestOGlSceneGroup);
end.

