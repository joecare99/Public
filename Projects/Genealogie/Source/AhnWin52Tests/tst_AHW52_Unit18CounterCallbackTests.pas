unit tst_AHW52_Unit18CounterCallbackTests;

{$mode objfpc}{$H+}

interface

uses
  Forms, fpcunit, testregistry, Unit18;

type
  TTestAHW52Unit18CounterCallbacks = class(TTestCase)
  published
    procedure TestIncrementPreservesStringsForNonzeroCount;
    procedure TestIncrementClearsStringsWhenCountBecomesZero;
    procedure TestDecrementIsNotClamped;
  end;

implementation

procedure TTestAHW52Unit18CounterCallbacks.
  TestIncrementPreservesStringsForNonzeroCount;
var
  sourceForm: TForm18;
  previousCount: Integer;
  previousFirstString: string;
  previousSecondString: string;
begin
  previousCount := GlobalVar_0061DFE8;
  previousFirstString := GlobalVar_0061DFE0;
  previousSecondString := GlobalVar_0061DFE4;
  sourceForm := TForm18.CreateNew(nil);
  try
    GlobalVar_0061DFE8 := 0;
    GlobalVar_0061DFE0 := 'first value';
    GlobalVar_0061DFE4 := 'second value';

    sourceForm._PROC_0054D870(sourceForm);

    AssertEquals(1, GlobalVar_0061DFE8);
    AssertEquals('first value', GlobalVar_0061DFE0);
    AssertEquals('second value', GlobalVar_0061DFE4);
  finally
    GlobalVar_0061DFE8 := previousCount;
    GlobalVar_0061DFE0 := previousFirstString;
    GlobalVar_0061DFE4 := previousSecondString;
    sourceForm.Free;
  end;
end;

procedure TTestAHW52Unit18CounterCallbacks.
  TestIncrementClearsStringsWhenCountBecomesZero;
var
  sourceForm: TForm18;
  previousCount: Integer;
  previousFirstString: string;
  previousSecondString: string;
begin
  previousCount := GlobalVar_0061DFE8;
  previousFirstString := GlobalVar_0061DFE0;
  previousSecondString := GlobalVar_0061DFE4;
  sourceForm := TForm18.CreateNew(nil);
  try
    GlobalVar_0061DFE8 := -1;
    GlobalVar_0061DFE0 := 'first value';
    GlobalVar_0061DFE4 := 'second value';

    sourceForm._PROC_0054D870(sourceForm);

    AssertEquals(0, GlobalVar_0061DFE8);
    AssertEquals('', GlobalVar_0061DFE0);
    AssertEquals('', GlobalVar_0061DFE4);
  finally
    GlobalVar_0061DFE8 := previousCount;
    GlobalVar_0061DFE0 := previousFirstString;
    GlobalVar_0061DFE4 := previousSecondString;
    sourceForm.Free;
  end;
end;

procedure TTestAHW52Unit18CounterCallbacks.TestDecrementIsNotClamped;
var
  sourceForm: TForm18;
  previousCount: Integer;
  previousFirstString: string;
  previousSecondString: string;
begin
  previousCount := GlobalVar_0061DFE8;
  previousFirstString := GlobalVar_0061DFE0;
  previousSecondString := GlobalVar_0061DFE4;
  sourceForm := TForm18.CreateNew(nil);
  try
    GlobalVar_0061DFE8 := 0;
    GlobalVar_0061DFE0 := 'first value';
    GlobalVar_0061DFE4 := 'second value';

    sourceForm._PROC_0054D8B4(sourceForm);

    AssertEquals(-1, GlobalVar_0061DFE8);
    AssertEquals('first value', GlobalVar_0061DFE0);
    AssertEquals('second value', GlobalVar_0061DFE4);
  finally
    GlobalVar_0061DFE8 := previousCount;
    GlobalVar_0061DFE0 := previousFirstString;
    GlobalVar_0061DFE4 := previousSecondString;
    sourceForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit18CounterCallbacks);

end.
