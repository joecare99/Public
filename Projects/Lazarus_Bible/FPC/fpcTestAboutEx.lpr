program fpcTestAboutEx;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_AboutEx;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

