program fpcTestCalc64;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_Calc64;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

