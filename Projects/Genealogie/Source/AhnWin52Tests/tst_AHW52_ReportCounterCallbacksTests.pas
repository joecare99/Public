unit tst_AHW52_ReportCounterCallbacksTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit,
  testregistry;

type
  TTestAHW52ReportCounterCallbacks = class(TTestCase)
  published
    procedure TestUnit5CounterDecrementsWithoutClamping;
    procedure TestUnit15CounterDecrementsWithoutClamping;
    procedure TestUnit23CounterDecrementsWithoutClamping;
    procedure TestUnit25CounterDecrementsWithoutClamping;
  end;

implementation

uses
  Forms,
  SingleColumnA4ReportForm,
  SingleColumnA4ReportVariantForm,
  FokoFilePrintForm,
  TwoColumnA4ReportForm;

procedure TTestAHW52ReportCounterCallbacks.
  TestUnit5CounterDecrementsWithoutClamping;
var
  reportForm: TSingleColumnA4ReportForm;
  previousValue: LongInt;
begin
  previousValue := GlobalVar_0061DFA0;
  reportForm := TSingleColumnA4ReportForm.CreateNew(nil);
  try
    GlobalVar_0061DFA0 := 4;
    reportForm._PROC_00539EBC(reportForm);
    AssertEquals(3, GlobalVar_0061DFA0);

    GlobalVar_0061DFA0 := 0;
    reportForm._PROC_00539EBC(reportForm);
    AssertEquals(-1, GlobalVar_0061DFA0);
  finally
    GlobalVar_0061DFA0 := previousValue;
    reportForm.Free;
  end;
end;

procedure TTestAHW52ReportCounterCallbacks.
  TestUnit15CounterDecrementsWithoutClamping;
var
  reportForm: TSingleColumnA4ReportVariantForm;
  previousValue: LongInt;
begin
  previousValue := GlobalVar_0061DF14;
  reportForm := TSingleColumnA4ReportVariantForm.CreateNew(nil);
  try
    GlobalVar_0061DF14 := 4;
    reportForm._PROC_005338D0(reportForm);
    AssertEquals(3, GlobalVar_0061DF14);

    GlobalVar_0061DF14 := 0;
    reportForm._PROC_005338D0(reportForm);
    AssertEquals(-1, GlobalVar_0061DF14);
  finally
    GlobalVar_0061DF14 := previousValue;
    reportForm.Free;
  end;
end;

procedure TTestAHW52ReportCounterCallbacks.
  TestUnit23CounterDecrementsWithoutClamping;
var
  reportForm: TFokoFilePrintForm;
  previousValue: LongInt;
begin
  previousValue := GlobalVar_025358D0;
  reportForm := TFokoFilePrintForm.CreateNew(nil);
  try
    GlobalVar_025358D0 := 4;
    reportForm._PROC_005CB970(reportForm);
    AssertEquals(3, GlobalVar_025358D0);

    GlobalVar_025358D0 := 0;
    reportForm._PROC_005CB970(reportForm);
    AssertEquals(-1, GlobalVar_025358D0);
  finally
    GlobalVar_025358D0 := previousValue;
    reportForm.Free;
  end;
end;

procedure TTestAHW52ReportCounterCallbacks.
  TestUnit25CounterDecrementsWithoutClamping;
var
  reportForm: TTwoColumnA4ReportForm;
  previousValue: LongInt;
begin
  previousValue := GlobalVar_0061E0DC;
  reportForm := TTwoColumnA4ReportForm.CreateNew(nil);
  try
    GlobalVar_0061E0DC := 4;
    reportForm._PROC_0055FDD4(reportForm);
    AssertEquals(3, GlobalVar_0061E0DC);

    GlobalVar_0061E0DC := 0;
    reportForm._PROC_0055FDD4(reportForm);
    AssertEquals(-1, GlobalVar_0061E0DC);
  finally
    GlobalVar_0061E0DC := previousValue;
    reportForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52ReportCounterCallbacks);

end.
