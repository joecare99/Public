program fpcTestWernerEng;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, testWernerEng, wernereng, werner_levdefc,
  Frm_WernerShowGrid;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.CreateForm(TFrmWernerShowGrid, FrmWernerShowGrid);
  Application.Run;
end.

