program project1;

{$mode objfpc}{$H+}

uses
  consoletestrunner, fpcunit, speedtests;

var
  lApp: TTestRunner;
begin
  lApp := TTestRunner.Create(nil);
  try
    lApp.Run;
  finally
    lApp.Free;
  end;
end.

