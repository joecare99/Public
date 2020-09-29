program fpcTestLaby4;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_Laby4, unt_Laby4;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

