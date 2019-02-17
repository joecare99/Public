program fpcTestBitView;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_BitView;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

