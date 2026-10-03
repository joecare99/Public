unit tst_AHW52_ComparisonParameterRadioTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, PersonComparisonOptionsForm;

type
  TTestAHW52ComparisonParameterRadio = class(TTestCase)
  private
    function CreateDialogWithControls: TPersonComparisonOptionsForm;
    procedure SetCheckBoxes(dialog: TPersonComparisonOptionsForm; checked: Boolean);
    procedure AssertCheckBoxes(dialog: TPersonComparisonOptionsForm; expected: Boolean);
  published
    procedure TestFirstRadioEnablesAllCheckBoxesAndClearsRadios;
    procedure TestSecondRadioDisablesAllCheckBoxesAndClearsRadios;
  end;

implementation

uses
  Forms, StdCtrls, SysUtils;

function TTestAHW52ComparisonParameterRadio.CreateDialogWithControls: TPersonComparisonOptionsForm;
begin
  Result := TPersonComparisonOptionsForm.CreateNew(nil);
  Result.CheckBox1 := TCheckBox.Create(Result);
  Result.CheckBox2 := TCheckBox.Create(Result);
  Result.CheckBox3 := TCheckBox.Create(Result);
  Result.CheckBox4 := TCheckBox.Create(Result);
  Result.CheckBox5 := TCheckBox.Create(Result);
  Result.CheckBox6 := TCheckBox.Create(Result);
  Result.CheckBox7 := TCheckBox.Create(Result);
  Result.CheckBox8 := TCheckBox.Create(Result);
  Result.CheckBox9 := TCheckBox.Create(Result);
  Result.CheckBox10 := TCheckBox.Create(Result);
  Result.RadioButton1 := TRadioButton.Create(Result);
  Result.RadioButton2 := TRadioButton.Create(Result);
end;

procedure TTestAHW52ComparisonParameterRadio.SetCheckBoxes(dialog: TPersonComparisonOptionsForm;
  checked: Boolean);
begin
  dialog.CheckBox1.Checked := checked;
  dialog.CheckBox2.Checked := checked;
  dialog.CheckBox3.Checked := checked;
  dialog.CheckBox4.Checked := checked;
  dialog.CheckBox5.Checked := checked;
  dialog.CheckBox6.Checked := checked;
  dialog.CheckBox7.Checked := checked;
  dialog.CheckBox8.Checked := checked;
  dialog.CheckBox9.Checked := checked;
  dialog.CheckBox10.Checked := checked;
end;

procedure TTestAHW52ComparisonParameterRadio.AssertCheckBoxes(dialog: TPersonComparisonOptionsForm;
  expected: Boolean);
var
  checkBoxes: array[0..9] of TCheckBox;
  index: Integer;
begin
  checkBoxes[0] := dialog.CheckBox1;
  checkBoxes[1] := dialog.CheckBox2;
  checkBoxes[2] := dialog.CheckBox3;
  checkBoxes[3] := dialog.CheckBox4;
  checkBoxes[4] := dialog.CheckBox5;
  checkBoxes[5] := dialog.CheckBox6;
  checkBoxes[6] := dialog.CheckBox7;
  checkBoxes[7] := dialog.CheckBox8;
  checkBoxes[8] := dialog.CheckBox9;
  checkBoxes[9] := dialog.CheckBox10;
  for index := Low(checkBoxes) to High(checkBoxes) do
    AssertTrue(Format('CheckBox%d expected Checked=%s.', [index + 1,
      BoolToStr(expected, True)]), checkBoxes[index].Checked = expected);
end;

procedure TTestAHW52ComparisonParameterRadio.
  TestFirstRadioEnablesAllCheckBoxesAndClearsRadios;
var
  comparisonDialog: TPersonComparisonOptionsForm;
begin
  comparisonDialog := CreateDialogWithControls;
  try
    SetCheckBoxes(comparisonDialog, False);
    comparisonDialog.RadioButton1.Checked := True;
    comparisonDialog.RadioButton2.Checked := True;

    comparisonDialog.RadioButton1Click(comparisonDialog.RadioButton1);

    AssertCheckBoxes(comparisonDialog, True);
    AssertFalse(comparisonDialog.RadioButton1.Checked);
    AssertFalse(comparisonDialog.RadioButton2.Checked);
  finally
    comparisonDialog.Free;
  end;
end;

procedure TTestAHW52ComparisonParameterRadio.
  TestSecondRadioDisablesAllCheckBoxesAndClearsRadios;
var
  comparisonDialog: TPersonComparisonOptionsForm;
begin
  comparisonDialog := CreateDialogWithControls;
  try
    SetCheckBoxes(comparisonDialog, True);
    comparisonDialog.RadioButton1.Checked := True;
    comparisonDialog.RadioButton2.Checked := True;

    comparisonDialog.RadioButton2Click(comparisonDialog.RadioButton2);

    AssertCheckBoxes(comparisonDialog, False);
    AssertFalse(comparisonDialog.RadioButton1.Checked);
    AssertFalse(comparisonDialog.RadioButton2.Checked);
  finally
    comparisonDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52ComparisonParameterRadio);

end.
