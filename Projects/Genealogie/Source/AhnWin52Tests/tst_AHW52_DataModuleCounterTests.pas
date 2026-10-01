unit tst_AHW52_DataModuleCounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52DataModuleCounters = class(TTestCase)
  published
    procedure TestDirectCounterDecrement;
  end;

implementation

uses
  Forms, Unit2;

procedure TTestAHW52DataModuleCounters.TestDirectCounterDecrement;
var
  dataModule: TDataModule2;
begin
  dataModule := TDataModule2.CreateNew(nil);
  try
    GlobalVar_0061DF0C := 9;
    dataModule._PROC_00533514(dataModule);
    AssertEquals(8, GlobalVar_0061DF0C);
  finally
    GlobalVar_0061DF0C := 0;
    dataModule.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52DataModuleCounters);

end.
