program fpcTestFVHistlist;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_FVHistList;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

