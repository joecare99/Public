unit tst_AHW52_Unit16AddressCounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit16AddressCounter = class(TTestCase)
  published
    procedure TestIncrementAdvancesCounter;
    procedure TestIncrementCrossesZero;
    procedure TestIncrementWrapsAtMaximumLongInt;
    procedure TestDecrementLowersCounter;
    procedure TestDecrementDoesNotClampAtZero;
    procedure TestDecrementWrapsAtMinimumLongInt;
  end;

implementation

uses
  Unit16AddressCounter;

procedure TTestAHW52Unit16AddressCounter.TestIncrementAdvancesCounter;
var
  previousValue: LongInt;
begin
  previousValue := GlobalVar_0061E0C4;
  try
    GlobalVar_0061E0C4 := 12;
    IncrementUnit16AddressCounter;
    AssertEquals(13, GlobalVar_0061E0C4);
  finally
    GlobalVar_0061E0C4 := previousValue;
  end;
end;

procedure TTestAHW52Unit16AddressCounter.TestIncrementCrossesZero;
var
  previousValue: LongInt;
begin
  previousValue := GlobalVar_0061E0C4;
  try
    GlobalVar_0061E0C4 := -1;
    IncrementUnit16AddressCounter;
    AssertEquals(0, GlobalVar_0061E0C4);
  finally
    GlobalVar_0061E0C4 := previousValue;
  end;
end;

procedure TTestAHW52Unit16AddressCounter.TestIncrementWrapsAtMaximumLongInt;
var
  previousValue: LongInt;
begin
  previousValue := GlobalVar_0061E0C4;
  try
    GlobalVar_0061E0C4 := High(LongInt);
    IncrementUnit16AddressCounter;
    AssertEquals(Low(LongInt), GlobalVar_0061E0C4);
  finally
    GlobalVar_0061E0C4 := previousValue;
  end;
end;

procedure TTestAHW52Unit16AddressCounter.TestDecrementLowersCounter;
var
  previousValue: LongInt;
begin
  previousValue := GlobalVar_0061E0C4;
  try
    GlobalVar_0061E0C4 := 12;
    DecrementUnit16AddressCounter;
    AssertEquals(11, GlobalVar_0061E0C4);
  finally
    GlobalVar_0061E0C4 := previousValue;
  end;
end;

procedure TTestAHW52Unit16AddressCounter.TestDecrementDoesNotClampAtZero;
var
  previousValue: LongInt;
begin
  previousValue := GlobalVar_0061E0C4;
  try
    GlobalVar_0061E0C4 := 0;
    DecrementUnit16AddressCounter;
    AssertEquals(-1, GlobalVar_0061E0C4);
  finally
    GlobalVar_0061E0C4 := previousValue;
  end;
end;

procedure TTestAHW52Unit16AddressCounter.TestDecrementWrapsAtMinimumLongInt;
var
  previousValue: LongInt;
begin
  previousValue := GlobalVar_0061E0C4;
  try
    GlobalVar_0061E0C4 := Low(LongInt);
    DecrementUnit16AddressCounter;
    AssertEquals(High(LongInt), GlobalVar_0061E0C4);
  finally
    GlobalVar_0061E0C4 := previousValue;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit16AddressCounter);

end.
