program GameLogicTests;

{$mode objfpc}{$H+}

uses
  consoletestrunner,
  testgames;

var
  TestRunner: TTestRunner;

begin
  DefaultRunAllTests := True;
  DefaultFormat := fPlain;
  TestRunner := TTestRunner.Create(nil);
  try
    TestRunner.Initialize;
    TestRunner.Title := 'Virtual Desktop game logic tests';
    TestRunner.Run;
  finally
    TestRunner.Free;
  end;
end.
