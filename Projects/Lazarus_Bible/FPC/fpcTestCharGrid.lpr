program fpcTestCharGrid;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_CharGrid;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

