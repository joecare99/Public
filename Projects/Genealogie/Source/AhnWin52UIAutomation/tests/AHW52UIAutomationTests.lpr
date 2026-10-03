program AHW52UIAutomationTests;

{$mode objfpc}{$H+}

uses
  consoletestrunner,
  tst_AHW52UIProfileTests,
  tst_AHW52UIExperimentTests;

var
  TestRunner: TTestRunner;
begin
  TestRunner := TTestRunner.Create(nil);
  try
    TestRunner.Initialize;
    TestRunner.Run;
  finally
    TestRunner.Free;
  end;
end.
