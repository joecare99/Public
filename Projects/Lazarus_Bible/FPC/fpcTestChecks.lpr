program fpcTestChecks;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_Checks;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

