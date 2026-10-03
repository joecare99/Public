program VirtualDesktopTests;

{$mode objfpc}{$H+}

uses
  consoletestrunner,
  testcalculatorviewmodel,
  testcalendarviewmodel,
  testnotepadviewmodel,
  testalarmclockviewmodel,
  testapplicationcomposition,
  testappdomains,
  testmvvm;

var
  Application: TTestRunner;

begin
  DefaultRunAllTests := True;
  DefaultFormat := fPlain;
  Application := TTestRunner.Create(nil);
  Application.Initialize;
  Application.Title := 'VirtualDesktop view-model tests';
  Application.Run;
  Application.Free;
end.
