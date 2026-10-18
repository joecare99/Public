unit tst_AHW52_Unit10CounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit10Counters = class(TTestCase)
  published
    procedure TestIncrementChangesAddressBackedCounterByOne;
    procedure TestDecrementDoesNotClampAtZero;
  end;

implementation

uses
  Forms, Unit10;

procedure TTestAHW52Unit10Counters.
  TestIncrementChangesAddressBackedCounterByOne;
var
  browserForm: TForm10;
  previousCounter: LongInt;
begin
  previousCounter := GlobalVar_0061E0B0;
  browserForm := nil;
  try
    browserForm := TForm10.CreateNew(nil);
    GlobalVar_0061E0B0 := -2;
    browserForm._PROC_0055B2B5(nil);
    AssertEquals(-1, GlobalVar_0061E0B0);
  finally
    GlobalVar_0061E0B0 := previousCounter;
    if Assigned(browserForm) then
      browserForm.Free;
  end;
end;

procedure TTestAHW52Unit10Counters.TestDecrementDoesNotClampAtZero;
var
  browserForm: TForm10;
  previousCounter: LongInt;
begin
  previousCounter := GlobalVar_0061E0B0;
  browserForm := nil;
  try
    browserForm := TForm10.CreateNew(nil);
    GlobalVar_0061E0B0 := 0;
    browserForm._PROC_0055B2E4(nil);
    AssertEquals(-1, GlobalVar_0061E0B0);

    GlobalVar_0061E0B0 := 9;
    browserForm._PROC_0055B2E4(nil);
    AssertEquals(8, GlobalVar_0061E0B0);
  finally
    GlobalVar_0061E0B0 := previousCounter;
    if Assigned(browserForm) then
      browserForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit10Counters);

end.
