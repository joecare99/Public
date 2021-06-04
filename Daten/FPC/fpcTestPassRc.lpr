program fpcTestPassRc;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, TestPassRc, tcPasWriteStatements;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

