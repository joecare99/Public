program fpcTestCardBase;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, testCardBase;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

