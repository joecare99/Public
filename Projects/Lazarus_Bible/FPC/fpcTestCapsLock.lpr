program fpcTestCapsLock;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_CapsLock;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

