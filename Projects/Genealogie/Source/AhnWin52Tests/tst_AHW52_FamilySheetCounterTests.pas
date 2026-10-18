unit tst_AHW52_FamilySheetCounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52FamilySheetCounters = class(TTestCase)
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
  Forms, Unit32;

procedure TTestAHW52FamilySheetCounters.SetCleanupStrings(
  const value: string);
var
  index: Integer;
begin
  GlobalVar_0061E0A0 := value;
  GlobalVar_0061E0A4 := value;
  for index := Low(GlobalVar_0061E064) to High(GlobalVar_0061E064) do
    GlobalVar_0061E064[index] := value;
end;

procedure TTestAHW52FamilySheetCounters.AssertCleanupStrings(
  const value: string);
var
  index: Integer;
begin
  AssertEquals(value, GlobalVar_0061E0A0);
  AssertEquals(value, GlobalVar_0061E0A4);
  for index := Low(GlobalVar_0061E064) to High(GlobalVar_0061E064) do
    AssertEquals(value, GlobalVar_0061E064[index]);
end;

procedure TTestAHW52FamilySheetCounters.
  TestDecrementsAddressBackedCounterWithoutClamping;
var
  familySheet: TForm32;
begin
  familySheet := TForm32.CreateNew(nil);
  try
    GlobalVar_0061E0A8 := 8;
    familySheet._PROC_00559D98(familySheet);
    AssertEquals(7, GlobalVar_0061E0A8);

    GlobalVar_0061E0A8 := 0;
    familySheet._PROC_00559D98(familySheet);
    AssertEquals(-1, GlobalVar_0061E0A8);
  finally
    GlobalVar_0061E0A8 := 0;
    familySheet.Free;
  end;
end;

procedure TTestAHW52FamilySheetCounters.
  TestIncrementPreservesStringsWhenCounterRemainsNonzero;
var
  familySheet: TForm32;
begin
  familySheet := TForm32.CreateNew(nil);
  try
    GlobalVar_0061E0A8 := 5;
    SetCleanupStrings('preserved');
    familySheet._PROC_00559D3C(familySheet);
    AssertEquals(6, GlobalVar_0061E0A8);
    AssertCleanupStrings('preserved');
  finally
    GlobalVar_0061E0A8 := 0;
    SetCleanupStrings('');
    familySheet.Free;
  end;
end;

procedure TTestAHW52FamilySheetCounters.
  TestIncrementClearsStringsWhenCounterBecomesZero;
var
  familySheet: TForm32;
begin
  familySheet := TForm32.CreateNew(nil);
  try
    GlobalVar_0061E0A8 := -1;
    SetCleanupStrings('cleared at zero');
    familySheet._PROC_00559D3C(familySheet);
    AssertEquals(0, GlobalVar_0061E0A8);
    AssertCleanupStrings('');
  finally
    GlobalVar_0061E0A8 := 0;
    SetCleanupStrings('');
    familySheet.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52FamilySheetCounters);

end.
