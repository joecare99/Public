unit tst_AHW52_Unit17CounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit17Counters = class(TTestCase)
  published
    procedure TestIncrementChangesAddressBackedCounter;
    procedure TestDecrementChangesAddressBackedCounterWithoutClamping;
  end;

implementation

uses
  Forms, Unit17;

procedure TTestAHW52Unit17Counters.
  TestIncrementChangesAddressBackedCounter;
var
  optionForm: TForm17;
  previousCounter: LongInt;
begin
  previousCounter := GlobalVar_0061DFD8;
  optionForm := nil;
  try
    optionForm := TForm17.CreateNew(nil);
    GlobalVar_0061DFD8 := 0;
    optionForm._PROC_0054524D(nil);
    AssertEquals(1, GlobalVar_0061DFD8);

    GlobalVar_0061DFD8 := 5;
    optionForm._PROC_0054524D(nil);
    AssertEquals(6, GlobalVar_0061DFD8);
  finally
    GlobalVar_0061DFD8 := previousCounter;
    if Assigned(optionForm) then
      optionForm.Free;
  end;
end;

procedure TTestAHW52Unit17Counters.
  TestDecrementChangesAddressBackedCounterWithoutClamping;
var
  optionForm: TForm17;
  previousCounter: LongInt;
begin
  previousCounter := GlobalVar_0061DFD8;
  optionForm := nil;
  try
    optionForm := TForm17.CreateNew(nil);
    GlobalVar_0061DFD8 := 0;
    optionForm._PROC_0054527C(nil);
    AssertEquals(-1, GlobalVar_0061DFD8);

    GlobalVar_0061DFD8 := 5;
    optionForm._PROC_0054527C(nil);
    AssertEquals(4, GlobalVar_0061DFD8);
  finally
    GlobalVar_0061DFD8 := previousCounter;
    if Assigned(optionForm) then
      optionForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit17Counters);

end.
