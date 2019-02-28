program fpcTestGrueStew;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_GrueStew;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

