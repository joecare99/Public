program fpcTestOGLScene;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, lazopenglcontext, TestOGLSceneComp,
  TestOGLScnBaseObjects, TestOGLScnGroup;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

