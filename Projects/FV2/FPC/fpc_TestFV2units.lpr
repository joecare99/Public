program fpc_TestFV2units;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, fpcunittestrunner, fv2testrunner, testfv2driver,
  testfv2tcanvas, testfv2Views;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfv2TestRunner, TestRunner);
  Application.Run;
end.

