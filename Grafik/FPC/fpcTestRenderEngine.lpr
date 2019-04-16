program fpcTestRenderEngine;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_RenderEngine, cls_RenderSimpleObjects,
  cls_RenderBase, cls_RenderCamera, cls_RenderEngine, cls_RenderColor;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

