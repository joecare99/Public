program fpcTestGrueStew;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_GrueStew, tst_GrueStewCon;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

