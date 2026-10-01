unit tst_AHW52_DescendantParameterPresetsTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Unit19;

type
  TTestAHW52DescendantParameterPresets = class(TTestCase)
  private
    function CreateDialogWithCheckBoxes: TForm19;
    procedure SetCheckBoxes(dialog: TForm19; checked: Boolean);
    procedure AssertCheckBoxes(dialog: TForm19; expected: Boolean);
  published
    procedure TestFirstRadioChecksAllFields;
    procedure TestSecondRadioClearsAllFields;
    procedure TestCheckbox15ClickChecksItself;
    procedure TestGenerationStartDecrementStopsAtOne;
    procedure TestGenerationStartIncrement;
    procedure TestGenerationCountDecrementStopsAtOne;
    procedure TestGenerationCountIncrement;
    procedure TestListTypeVisibilityUsesAlphSubstring;
    procedure TestNamgvIsListingProvenNoOp;
  end;

implementation

uses
  Forms, StdCtrls, SysUtils;

function TTestAHW52DescendantParameterPresets.CreateDialogWithCheckBoxes:
  TForm19;
begin
  Result := TForm19.CreateNew(nil);
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
  Result.CheckBox11 := TCheckBox.Create(Result);
  Result.CheckBox12 := TCheckBox.Create(Result);
  Result.CheckBox13 := TCheckBox.Create(Result);
  Result.CheckBox14 := TCheckBox.Create(Result);
  Result.CheckBox15 := TCheckBox.Create(Result);
  Result.CheckBox16 := TCheckBox.Create(Result);
  Result.CheckBox17 := TCheckBox.Create(Result);
end;

procedure TTestAHW52DescendantParameterPresets.SetCheckBoxes(dialog: TForm19;
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
  dialog.CheckBox11.Checked := checked;
  dialog.CheckBox12.Checked := checked;
  dialog.CheckBox13.Checked := checked;
  dialog.CheckBox14.Checked := checked;
  dialog.CheckBox15.Checked := checked;
  dialog.CheckBox16.Checked := checked;
  dialog.CheckBox17.Checked := checked;
end;

procedure TTestAHW52DescendantParameterPresets.AssertCheckBoxes(dialog: TForm19;
  expected: Boolean);
var
  checkBoxes: array[0..16] of TCheckBox;
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
  checkBoxes[10] := dialog.CheckBox11;
  checkBoxes[11] := dialog.CheckBox12;
  checkBoxes[12] := dialog.CheckBox13;
  checkBoxes[13] := dialog.CheckBox14;
  checkBoxes[14] := dialog.CheckBox15;
  checkBoxes[15] := dialog.CheckBox16;
  checkBoxes[16] := dialog.CheckBox17;
  for index := Low(checkBoxes) to High(checkBoxes) do
    AssertTrue(Format('CheckBox%d expected Checked=%s.', [index + 1,
      BoolToStr(expected, True)]), checkBoxes[index].Checked = expected);
end;

procedure TTestAHW52DescendantParameterPresets.TestFirstRadioChecksAllFields;
var
  dialog: TForm19;
begin
  dialog := CreateDialogWithCheckBoxes;
  try
    SetCheckBoxes(dialog, False);
    dialog.RadioButton1Click(dialog);
    AssertCheckBoxes(dialog, True);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterPresets.TestSecondRadioClearsAllFields;
var
  dialog: TForm19;
begin
  dialog := CreateDialogWithCheckBoxes;
  try
    SetCheckBoxes(dialog, True);
    dialog.RadioButton2Click(dialog);
    AssertCheckBoxes(dialog, False);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterPresets.TestCheckbox15ClickChecksItself;
var
  dialog: TForm19;
begin
  dialog := CreateDialogWithCheckBoxes;
  try
    dialog.CheckBox15.Checked := False;
    dialog.CheckBox15Click(dialog.CheckBox15);
    AssertTrue('CheckBox15 should be checked after its click handler.',
      dialog.CheckBox15.Checked);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterPresets.
  TestGenerationStartDecrementStopsAtOne;
var
  dialog: TForm19;
begin
  dialog := TForm19.CreateNew(nil);
  try
    dialog.Edit1 := TEdit.Create(dialog);
    dialog.Edit1.Text := '1';
    dialog.Edit2 := TEdit.Create(dialog);
    dialog.Edit2.Text := '7';

    dialog.Button1Click(dialog.Button1);

    AssertEquals('1', dialog.Edit1.Text);
    AssertEquals('7', dialog.Edit2.Text);

    dialog.Edit1.Text := '2';
    dialog.Button1Click(dialog.Button1);
    AssertEquals('1', dialog.Edit1.Text);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterPresets.TestGenerationStartIncrement;
var
  dialog: TForm19;
begin
  dialog := TForm19.CreateNew(nil);
  try
    dialog.Edit1 := TEdit.Create(dialog);
    dialog.Edit1.Text := '4';
    dialog.Edit2 := TEdit.Create(dialog);
    dialog.Edit2.Text := '7';

    dialog.Button2Click(dialog.Button2);

    AssertEquals('5', dialog.Edit1.Text);
    AssertEquals('7', dialog.Edit2.Text);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterPresets.
  TestGenerationCountDecrementStopsAtOne;
var
  dialog: TForm19;
begin
  dialog := TForm19.CreateNew(nil);
  try
    dialog.Edit1 := TEdit.Create(dialog);
    dialog.Edit1.Text := '6';
    dialog.Edit2 := TEdit.Create(dialog);
    dialog.Edit2.Text := '1';

    dialog.Button3Click(dialog.Button3);

    AssertEquals('6', dialog.Edit1.Text);
    AssertEquals('1', dialog.Edit2.Text);

    dialog.Edit2.Text := '2';
    dialog.Button3Click(dialog.Button3);
    AssertEquals('1', dialog.Edit2.Text);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterPresets.TestGenerationCountIncrement;
var
  dialog: TForm19;
begin
  dialog := TForm19.CreateNew(nil);
  try
    dialog.Edit1 := TEdit.Create(dialog);
    dialog.Edit1.Text := '6';
    dialog.Edit2 := TEdit.Create(dialog);
    dialog.Edit2.Text := '4';

    dialog.Button4Click(dialog.Button4);

    AssertEquals('6', dialog.Edit1.Text);
    AssertEquals('5', dialog.Edit2.Text);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterPresets.
  TestListTypeVisibilityUsesAlphSubstring;
var
  dialog: TForm19;
begin
  dialog := TForm19.CreateNew(nil);
  try
    dialog.ComboBox1 := TComboBox.Create(dialog);
    dialog.CheckBox7 := TCheckBox.Create(dialog);
    dialog.CheckBox8 := TCheckBox.Create(dialog);
    dialog.CheckBox6 := TCheckBox.Create(dialog);

    dialog.ComboBox1.Text := 'Stammliste';
    dialog.CheckBox7.Visible := False;
    dialog.CheckBox8.Visible := False;
    dialog.CheckBox6.Visible := False;
    dialog.ComboBox1Change(dialog.ComboBox1);
    AssertTrue(dialog.CheckBox7.Visible);
    AssertTrue(dialog.CheckBox8.Visible);
    AssertFalse(dialog.CheckBox6.Visible);

    dialog.ComboBox1.Text := 'alph - sortiert';
    dialog.CheckBox7.Visible := True;
    dialog.CheckBox8.Visible := True;
    dialog.ComboBox1Change(dialog.ComboBox1);
    AssertFalse(dialog.CheckBox7.Visible);
    AssertFalse(dialog.CheckBox8.Visible);

    dialog.ComboBox1.Text := 'ALPH';
    dialog.ComboBox1Change(dialog.ComboBox1);
    AssertTrue(dialog.CheckBox7.Visible);
    AssertTrue(dialog.CheckBox8.Visible);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52DescendantParameterPresets.TestNamgvIsListingProvenNoOp;
var
  dialog: TForm19;
begin
  dialog := CreateDialogWithCheckBoxes;
  try
    dialog.Caption := 'Synthetic dialog';
    dialog.ModalResult := 0;
    dialog.CheckBox1.Checked := True;
    dialog.CheckBox7.Visible := False;
    dialog.CheckBox8.Visible := True;

    dialog.namgv(dialog);

    AssertEquals('Synthetic dialog', dialog.Caption);
    AssertEquals(0, dialog.ModalResult);
    AssertTrue(dialog.CheckBox1.Checked);
    AssertFalse(dialog.CheckBox7.Visible);
    AssertTrue(dialog.CheckBox8.Visible);
  finally
    dialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52DescendantParameterPresets);

end.
