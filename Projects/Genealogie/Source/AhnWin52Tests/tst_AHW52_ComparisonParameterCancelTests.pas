unit tst_AHW52_ComparisonParameterCancelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52ComparisonParameterCancel = class(TTestCase)
  published
    procedure TestCancelResetsSelectionStateAndModalResult;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Controls, Forms, PersonComparisonOptionsForm;

procedure TTestAHW52ComparisonParameterCancel.TestUnboundCounterIncrement;
var
  comparisonDialog: TPersonComparisonOptionsForm;
begin
  comparisonDialog := TPersonComparisonOptionsForm.CreateNew(nil);
  try
    GlobalVar_025358FC := 5;
    comparisonDialog._PROC_005CFAA4(comparisonDialog);
    AssertEquals('Increment callback should add one.', 6,
      GlobalVar_025358FC);
  finally
    GlobalVar_025358FC := 0;
    comparisonDialog.Free;
  end;
end;

procedure TTestAHW52ComparisonParameterCancel.TestUnboundCounterDecrement;
var
  comparisonDialog: TPersonComparisonOptionsForm;
begin
  comparisonDialog := TPersonComparisonOptionsForm.CreateNew(nil);
  try
    GlobalVar_025358FC := 5;
    comparisonDialog._PROC_005CFAD4(comparisonDialog);
    AssertEquals('Decrement callback should subtract one.', 4,
      GlobalVar_025358FC);
  finally
    GlobalVar_025358FC := 0;
    comparisonDialog.Free;
  end;
end;

procedure TTestAHW52ComparisonParameterCancel.
  TestCancelResetsSelectionStateAndModalResult;
var
  comparisonDialog: TPersonComparisonOptionsForm;
begin
  comparisonDialog := TPersonComparisonOptionsForm.CreateNew(nil);
  Form35 := comparisonDialog;
  try
    GlobalVar_02535B90 := 1;

    comparisonDialog.BitBtn4Click(nil);

    AssertEquals('Cancel should clear the selected-row state.', 0,
      GlobalVar_02535B90);
    AssertEquals('Cancel should set the cancel modal result.', mrCancel,
      comparisonDialog.ModalResult);
  finally
    Form35 := nil;
    GlobalVar_02535B90 := 0;
    comparisonDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52ComparisonParameterCancel);

end.
