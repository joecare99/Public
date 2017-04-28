program fpcunitStrUtils;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, baseunits, test_StrUtils;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

