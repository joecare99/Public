program fpcTestCalc32;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_Calc32;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

