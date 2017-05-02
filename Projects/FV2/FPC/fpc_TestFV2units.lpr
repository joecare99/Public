program fpc_TestFV2units;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, fpcunittestrunner, GuiTestRunner, testfv2driver,
  testfv2tcanvas, testfv2Views;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGUITestRunner, TestRunner);
  Application.Run;
end.

