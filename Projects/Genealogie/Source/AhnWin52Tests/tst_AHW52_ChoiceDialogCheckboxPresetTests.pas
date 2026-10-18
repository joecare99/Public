unit tst_AHW52_ChoiceDialogCheckboxPresetTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms, Unit31;

type
  TTestAHW52ChoiceDialogCheckboxPresets = class(TTestCase)
  private
    FCloseEventCount: Integer;
    FHideEventCount: Integer;
    function CreateDialogWithCheckBoxes: TForm31;
    procedure MakeTestFormInvisible(form: TCustomForm);
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure RecordFormHide(Sender: TObject);
    procedure SetCheckBoxes(dialog: TForm31; checked: Boolean);
    procedure AssertMarkAllPreset(dialog: TForm31);
    procedure AssertCheckBoxes(dialog: TForm31; expected: Boolean);
  published
    procedure TestMarkAllChecksEveryOptionExceptClearAll;
    procedure TestClearAllUnchecksEveryOption;
    procedure TestFinishHandlerHidesGlobalForm;
    procedure TestCancelHandlerClosesGlobalForm;
  end;

implementation

uses
  StdCtrls, SysUtils;

procedure TTestAHW52ChoiceDialogCheckboxPresets.MakeTestFormInvisible(
  form: TCustomForm);
begin
  form.AlphaBlend := True;
  form.AlphaBlendValue := 0;
  form.ShowInTaskBar := stNever;
end;

function TTestAHW52ChoiceDialogCheckboxPresets.CreateDialogWithCheckBoxes:
  TForm31;
begin
  Result := TForm31.CreateNew(nil);
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
end;

procedure TTestAHW52ChoiceDialogCheckboxPresets.SetCheckBoxes(dialog: TForm31;
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
end;

procedure TTestAHW52ChoiceDialogCheckboxPresets.RecordFormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52ChoiceDialogCheckboxPresets.RecordFormHide(Sender: TObject);
begin
  Inc(FHideEventCount);
end;

procedure TTestAHW52ChoiceDialogCheckboxPresets.AssertCheckBoxes(
  dialog: TForm31; expected: Boolean);
var
  checkBoxes: array[0..15] of TCheckBox;
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
  for index := Low(checkBoxes) to High(checkBoxes) do
    AssertTrue(Format('CheckBox%d expected Checked=%s.', [index + 1,
      BoolToStr(expected, True)]), checkBoxes[index].Checked = expected);
end;

procedure TTestAHW52ChoiceDialogCheckboxPresets.AssertMarkAllPreset(
  dialog: TForm31);
var
  checkBoxes: array[0..15] of TCheckBox;
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
  for index := Low(checkBoxes) to High(checkBoxes) do
    AssertTrue(Format('CheckBox%d has unexpected Checked state.', [index + 1]),
      checkBoxes[index].Checked = (index <> 9));
end;

procedure TTestAHW52ChoiceDialogCheckboxPresets.
  TestMarkAllChecksEveryOptionExceptClearAll;
var
  dialog: TForm31;
begin
  dialog := CreateDialogWithCheckBoxes;
  try
    SetCheckBoxes(dialog, False);
    dialog.CheckBox9Click(dialog.CheckBox9);
    AssertMarkAllPreset(dialog);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52ChoiceDialogCheckboxPresets.TestClearAllUnchecksEveryOption;
var
  dialog: TForm31;
begin
  dialog := CreateDialogWithCheckBoxes;
  try
    SetCheckBoxes(dialog, True);
    dialog.CheckBox10Click(dialog.CheckBox10);
    AssertCheckBoxes(dialog, False);
  finally
    dialog.Free;
  end;
end;

procedure TTestAHW52ChoiceDialogCheckboxPresets.TestFinishHandlerHidesGlobalForm;
var
  receiver: TForm31;
  target: TForm31;
begin
  Application.Initialize;
  FHideEventCount := 0;
  target := TForm31.CreateNew(nil);
  receiver := TForm31.CreateNew(nil);
  Unit31.Form31 := target;
  try
    MakeTestFormInvisible(target);
    MakeTestFormInvisible(receiver);
    target.OnHide := @RecordFormHide;
    target.Show;
    receiver.Show;
    receiver.BitBtn1Click(receiver);

    AssertEquals('The global target should receive one hide event.', 1,
      FHideEventCount);
    AssertFalse('The global target should be hidden.', target.Visible);
    AssertTrue('The method receiver should remain visible.', receiver.Visible);
  finally
    Unit31.Form31 := nil;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52ChoiceDialogCheckboxPresets.TestCancelHandlerClosesGlobalForm;
var
  receiver: TForm31;
  target: TForm31;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  target := TForm31.CreateNew(nil);
  receiver := TForm31.CreateNew(nil);
  Unit31.Form31 := target;
  try
    MakeTestFormInvisible(target);
    MakeTestFormInvisible(receiver);
    target.OnClose := @RecordFormClose;
    target.Show;
    receiver.Show;
    receiver.BitBtn2Click(receiver);

    AssertEquals('The global target should receive one close event.', 1,
      FCloseEventCount);
    AssertFalse('The close action should hide the global target.',
      target.Visible);
    AssertTrue('The method receiver should remain visible.', receiver.Visible);
  finally
    Unit31.Form31 := nil;
    receiver.Free;
    target.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52ChoiceDialogCheckboxPresets);

end.
