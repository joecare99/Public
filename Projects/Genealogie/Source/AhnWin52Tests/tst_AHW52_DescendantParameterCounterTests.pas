unit tst_AHW52_DescendantParameterCounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52DescendantParameterCounters = class(TTestCase)
  private
    procedure SetCleanupStrings(const value: string);
    procedure AssertCleanupStrings(const value: string);
  published
    procedure TestDecrementsAddressBackedCounterWithoutClamping;
    procedure TestIncrementPreservesStringsWhenCounterRemainsNonzero;
    procedure TestIncrementClearsStringsWhenCounterBecomesZero;
  end;

implementation

uses
  Forms, Unit19;

procedure TTestAHW52DescendantParameterCounters.SetCleanupStrings(
  const value: string);
begin
  GlobalVar_0061E014 := value;
  GlobalVar_0061E018 := value;
  GlobalVar_0061E01C := value;
  GlobalVar_0061E020 := value;
  GlobalVar_0061E024 := value;
  GlobalVar_0061E028 := value;
  GlobalVar_0061E02C := value;
  GlobalVar_0061E030 := value;
  GlobalVar_0061E034 := value;
  GlobalVar_0061E038 := value;
  GlobalVar_0061E03C := value;
  GlobalVar_0061E040 := value;
end;

procedure TTestAHW52DescendantParameterCounters.AssertCleanupStrings(
  const value: string);
begin
  AssertEquals(value, GlobalVar_0061E014);
  AssertEquals(value, GlobalVar_0061E018);
  AssertEquals(value, GlobalVar_0061E01C);
  AssertEquals(value, GlobalVar_0061E020);
  AssertEquals(value, GlobalVar_0061E024);
  AssertEquals(value, GlobalVar_0061E028);
  AssertEquals(value, GlobalVar_0061E02C);
  AssertEquals(value, GlobalVar_0061E030);
  AssertEquals(value, GlobalVar_0061E034);
  AssertEquals(value, GlobalVar_0061E038);
  AssertEquals(value, GlobalVar_0061E03C);
  AssertEquals(value, GlobalVar_0061E040);
end;

procedure TTestAHW52DescendantParameterCounters.
  TestDecrementsAddressBackedCounterWithoutClamping;
var
  dialog: TForm19;
begin
  dialog := TForm19.CreateNew(nil);
  try
    GlobalVar_0061E05C := 12;
    dialog._PROC_00558ABC(dialog);
    AssertEquals(11, GlobalVar_0061E05C);

    GlobalVar_0061E05C := 0;
    dialog._PROC_00558ABC(dialog);
    AssertEquals(-1, GlobalVar_0061E05C);
  finally
    GlobalVar_0061E05C := 0;
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterCounters.
  TestIncrementPreservesStringsWhenCounterRemainsNonzero;
var
  dialog: TForm19;
begin
  dialog := TForm19.CreateNew(nil);
  try
    GlobalVar_0061E05C := 4;
    SetCleanupStrings('preserved');
    dialog._PROC_00558A15(dialog);
    AssertEquals(5, GlobalVar_0061E05C);
    AssertCleanupStrings('preserved');
  finally
    GlobalVar_0061E05C := 0;
    SetCleanupStrings('');
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterCounters.
  TestIncrementClearsStringsWhenCounterBecomesZero;
var
  dialog: TForm19;
begin
  dialog := TForm19.CreateNew(nil);
  try
    GlobalVar_0061E05C := -1;
    SetCleanupStrings('cleared at zero');
    dialog._PROC_00558A15(dialog);
    AssertEquals(0, GlobalVar_0061E05C);
    AssertCleanupStrings('');
  finally
    GlobalVar_0061E05C := 0;
    SetCleanupStrings('');
    dialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52DescendantParameterCounters);

end.
