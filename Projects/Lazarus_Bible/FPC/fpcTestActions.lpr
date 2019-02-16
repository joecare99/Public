program fpcTestActions;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, lazmouseandkeyinput, tst_Actions;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

