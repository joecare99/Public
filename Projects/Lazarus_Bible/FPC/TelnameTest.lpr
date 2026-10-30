program TelnameTest;

{$mode objfpc}{$H+}

uses
  consoletestrunner,
  tst_Telname;

var
  TestRunner: TTestRunner;
begin
  TestRunner := TTestRunner.Create(nil);
  try
    TestRunner.Initialize;
    TestRunner.Title := 'Telname model tests';
    TestRunner.Run;
  finally
    TestRunner.Free;
  end;
end.
