program fpcTestBitView2;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_BitView2;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

