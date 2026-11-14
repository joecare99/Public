unit tst_AHW52_Unit17CheckboxPresetTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Unit17;

type
  TTestAHW52Unit17CheckboxPresets = class(TTestCase)
  private
    function CreateDialogWithCheckBoxes: TForm17;
    procedure SetCheckBoxes(dialog: TForm17; checked: Boolean);
    procedure AssertCheckBoxes(dialog: TForm17; expected: Boolean);
  published
    procedure TestRadioButton1ChecksEveryField;
    procedure TestRadioButton2ClearsEveryField;
  end;

implementation

uses
  Forms, StdCtrls, SysUtils;

type
  TUnit17CheckBoxes = array[0..14] of TCheckBox;

function GetCheckBoxes(dialog: TForm17): TUnit17CheckBoxes;
begin
  Result[0] := dialog.CheckBox1;
  Result[1] := dialog.CheckBox2;
  Result[2] := dialog.CheckBox3;
  Result[3] := dialog.CheckBox4;
  Result[4] := dialog.CheckBox5;
  Result[5] := dialog.CheckBox6;
  Result[6] := dialog.CheckBox7;
  Result[7] := dialog.CheckBox8;
  Result[8] := dialog.CheckBox9;
  Result[9] := dialog.CheckBox11;
  Result[10] := dialog.CheckBox12;
  Result[11] := dialog.CheckBox13;
  Result[12] := dialog.CheckBox14;
  Result[13] := dialog.CheckBox15;
  Result[14] := dialog.CheckBox16;
end;

function TTestAHW52Unit17CheckboxPresets.CreateDialogWithCheckBoxes: TForm17;
begin
  Result := TForm17.CreateNew(nil);
  Result.CheckBox1 := TCheckBox.Create(Result);
  Result.CheckBox2 := TCheckBox.Create(Result);
  Result.CheckBox3 := TCheckBox.Create(Result);
  Result.CheckBox4 := TCheckBox.Create(Result);
  Result.CheckBox5 := TCheckBox.Create(Result);
  Result.CheckBox6 := TCheckBox.Create(Result);
  Result.CheckBox7 := TCheckBox.Create(Result);
  Result.CheckBox8 := TCheckBox.Create(Result);
  Result.CheckBox9 := TCheckBox.Create(Result);
  Result.CheckBox11 := TCheckBox.Create(Result);
  Result.CheckBox12 := TCheckBox.Create(Result);
  Result.CheckBox13 := TCheckBox.Create(Result);
  Result.CheckBox14 := TCheckBox.Create(Result);
  Result.CheckBox15 := TCheckBox.Create(Result);
  Result.CheckBox16 := TCheckBox.Create(Result);
end;

procedure TTestAHW52Unit17CheckboxPresets.SetCheckBoxes(dialog: TForm17;
  checked: Boolean);
var
  checkBoxes: TUnit17CheckBoxes;
  index: Integer;
begin
  checkBoxes := GetCheckBoxes(dialog);
  for index := Low(checkBoxes) to High(checkBoxes) do
    checkBoxes[index].Checked := checked;
end;

procedure TTestAHW52Unit17CheckboxPresets.AssertCheckBoxes(dialog: TForm17;
  expected: Boolean);
var
  checkBoxes: TUnit17CheckBoxes;
  index: Integer;
begin
  checkBoxes := GetCheckBoxes(dialog);
  for index := Low(checkBoxes) to High(checkBoxes) do
    AssertTrue(Format('Checkbox %d expected Checked=%s.', [index + 1,
      BoolToStr(expected, True)]), checkBoxes[index].Checked = expected);
end;

procedure TTestAHW52Unit17CheckboxPresets.TestRadioButton1ChecksEveryField;
var
  dialog: TForm17;
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

procedure TTestAHW52Unit17CheckboxPresets.TestRadioButton2ClearsEveryField;
var
  dialog: TForm17;
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

initialization
  RegisterTest(TTestAHW52Unit17CheckboxPresets);

end.
