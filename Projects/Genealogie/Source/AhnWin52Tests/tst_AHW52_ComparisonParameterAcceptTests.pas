unit tst_AHW52_ComparisonParameterAcceptTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, PersonComparisonOptionsForm;

type
  TTestAHW52ComparisonParameterAccept = class(TTestCase)
  private
    function CreateDialogWithCheckBoxes: TPersonComparisonOptionsForm;
    procedure SetCheckBoxes(dialog: TPersonComparisonOptionsForm; checked: Boolean);
  published
    procedure TestAcceptCollectsSelectedFieldsAndFlags;
    procedure TestAcceptClearsFieldListWhenNothingIsSelected;
  end;

implementation

uses
  Controls, Forms, StdCtrls;

function TTestAHW52ComparisonParameterAccept.CreateDialogWithCheckBoxes:
  TPersonComparisonOptionsForm;
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
end;

procedure TTestAHW52ComparisonParameterAccept.SetCheckBoxes(
  dialog: TPersonComparisonOptionsForm; checked: Boolean);
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

procedure TTestAHW52ComparisonParameterAccept.
  TestAcceptCollectsSelectedFieldsAndFlags;
var
  comparisonDialog: TPersonComparisonOptionsForm;
begin
  comparisonDialog := CreateDialogWithCheckBoxes;
  Form35 := comparisonDialog;
  try
    SetCheckBoxes(comparisonDialog, True);
    GlobalVar_02535B90 := 0;
    GlobalVar_02535B98 := 'stale';
    GlobalVar_02535B8C := 0;
    GlobalVar_02535B88 := 0;
    GlobalVar_02535B68 := 0;
    GlobalVar_02535B6C := 0;
    GlobalVar_02535B70 := 0;
    GlobalVar_02535B74 := 0;
    GlobalVar_02535B78 := 0;
    GlobalVar_02535B7C := 0;
    GlobalVar_02535B80 := 0;
    GlobalVar_02535B84 := 0;

    comparisonDialog.BitBtn3Click(nil);

    AssertEquals(1, GlobalVar_02535B90);
    AssertEquals(1, GlobalVar_02535B8C);
    AssertEquals(1, GlobalVar_02535B88);
    AssertEquals(1, GlobalVar_02535B68);
    AssertEquals(1, GlobalVar_02535B6C);
    AssertEquals(1, GlobalVar_02535B70);
    AssertEquals(1, GlobalVar_02535B74);
    AssertEquals(1, GlobalVar_02535B78);
    AssertEquals(1, GlobalVar_02535B7C);
    AssertEquals(1, GlobalVar_02535B80);
    AssertEquals(1, GlobalVar_02535B84);
    AssertEquals(', ID, Beruf, Geb.Jahr, Geb.Ort, Taufjahr, Taufort, ' +
      'St.Jahr, St.Ort, Best.Jahr, Best.Ort', GlobalVar_02535B98);
    AssertEquals(mrCancel, comparisonDialog.ModalResult);
  finally
    Form35 := nil;
    GlobalVar_02535B90 := 0;
    GlobalVar_02535B98 := '';
    GlobalVar_02535B8C := 0;
    GlobalVar_02535B88 := 0;
    GlobalVar_02535B68 := 0;
    GlobalVar_02535B6C := 0;
    GlobalVar_02535B70 := 0;
    GlobalVar_02535B74 := 0;
    GlobalVar_02535B78 := 0;
    GlobalVar_02535B7C := 0;
    GlobalVar_02535B80 := 0;
    GlobalVar_02535B84 := 0;
    comparisonDialog.Free;
  end;
end;

procedure TTestAHW52ComparisonParameterAccept.
  TestAcceptClearsFieldListWhenNothingIsSelected;
var
  comparisonDialog: TPersonComparisonOptionsForm;
begin
  comparisonDialog := CreateDialogWithCheckBoxes;
  Form35 := comparisonDialog;
  try
    SetCheckBoxes(comparisonDialog, False);
    GlobalVar_02535B90 := 0;
    GlobalVar_02535B98 := 'stale';
    GlobalVar_02535B68 := 7;

    comparisonDialog.BitBtn3Click(nil);

    AssertEquals(1, GlobalVar_02535B90);
    AssertEquals('', GlobalVar_02535B98);
    AssertEquals('An unchecked field flag is left untouched.', 7,
      GlobalVar_02535B68);
    AssertEquals(mrCancel, comparisonDialog.ModalResult);
  finally
    Form35 := nil;
    GlobalVar_02535B90 := 0;
    GlobalVar_02535B98 := '';
    GlobalVar_02535B68 := 0;
    comparisonDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52ComparisonParameterAccept);

end.
