program fpcTestRenderBase;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_RenderBase;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

