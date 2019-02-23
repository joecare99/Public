program fpcTestAddPage;

{$mode objfpc}{$H+}

uses
   Interfaces, Forms, GuiTestRunner, fpcunittestrunner,  tst_AddPage;

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.
