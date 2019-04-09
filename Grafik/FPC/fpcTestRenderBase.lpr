program fpcTestRenderBase;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_RenderBase, tst_RenderBase2, tst_RenderBaseAngle;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

