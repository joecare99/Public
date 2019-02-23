program fpcTestBarTest2;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_BarTest2;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

