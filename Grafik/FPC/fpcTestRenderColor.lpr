program fpcTestRenderColor;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_RenderColor, frm_DisplTestColor;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.CreateForm(TFrmDisplayTestColor, FrmDisplayTestColor);
  Application.Run;
end.

