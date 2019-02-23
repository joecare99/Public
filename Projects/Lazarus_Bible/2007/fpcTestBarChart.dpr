program fpcTestBarChart;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_BarChart;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

