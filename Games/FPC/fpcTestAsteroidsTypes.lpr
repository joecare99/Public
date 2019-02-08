program fpcTestAsteroidsTypes;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, TestAsteroTypes;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

