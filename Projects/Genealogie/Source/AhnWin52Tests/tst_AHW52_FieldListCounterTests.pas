unit tst_AHW52_FieldListCounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52FieldListCounters = class(TTestCase)
  published
    procedure TestIncrementPreservesStringsWhenCounterRemainsNonzero;
    procedure TestIncrementClearsStringsWhenCounterBecomesZero;
    procedure TestDecrement;
    procedure TestCancelSetsSentinelAndGlobalModalResult;
    procedure TestPrintButtonUsesGlobalModalTargetWhenListsAreSelected;
    procedure TestListBox3DoubleClickDeletesSelectedItemFromGlobalForm;
    procedure TestListBox1DoubleClickAddsSelectedItemToGlobalTargetList;
    procedure TestListBox2DoubleClickAddsSelectedItemToGlobalTargetList;
    procedure TestListBox4DoubleClickDeletesSelectedItemFromGlobalList;
    procedure TestListBox5DoubleClickAddsOneHofnameAndSelectsRadioMode;
    procedure TestButton2AddsSelectedFirstListItemToGlobalThirdList;
    procedure TestButton3AddsSelectedSecondListItemToGlobalFourthList;
    procedure TestButton4DeletesSelectedGlobalThirdListItem;
    procedure TestButton5DeletesSelectedGlobalFourthListItem;
    procedure TestButton6ClearsGlobalThirdList;
    procedure TestButton7ClearsGlobalFourthList;
    procedure TestRadioButton4ChecksFirstElevenFields;
    procedure TestRadioButton5ClearsFirstElevenFields;
    procedure TestHofnameListButtonAddsSelectedItemAndSetsRadioMode;
    procedure TestHofnameListButtonDeletesSelectionAndReenablesRadioModes;
    procedure TestHofnameListButtonClearsTargetAndReenablesRadioModes;
    procedure TestCheckBox17ClickUsesCheckBox17AsGate;
    procedure TestCheckBox18ClickUsesCheckBox17AsGate;
  end;

implementation

uses
  Controls, Forms, StdCtrls, SysUtils, Unit24;

procedure TTestAHW52FieldListCounters.
  TestIncrementPreservesStringsWhenCounterRemainsNonzero;
var
  fieldListForm: TForm24;
begin
  fieldListForm := TForm24.CreateNew(nil);
  try
    GlobalVar_0061E0D4 := 3;
    GlobalVar_0061E0D0 := 'First synthetic field';
    GlobalVar_0061E0CC := 'Second synthetic field';

    fieldListForm._PROC_0055FA85(fieldListForm);

    AssertEquals(4, GlobalVar_0061E0D4);
    AssertEquals('First synthetic field', GlobalVar_0061E0D0);
    AssertEquals('Second synthetic field', GlobalVar_0061E0CC);
  finally
    GlobalVar_0061E0D4 := 0;
    GlobalVar_0061E0D0 := '';
    GlobalVar_0061E0CC := '';
    fieldListForm.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestIncrementClearsStringsWhenCounterBecomesZero;
var
  fieldListForm: TForm24;
begin
  fieldListForm := TForm24.CreateNew(nil);
  try
    GlobalVar_0061E0D4 := -1;
    GlobalVar_0061E0D0 := 'First synthetic field';
    GlobalVar_0061E0CC := 'Second synthetic field';

    fieldListForm._PROC_0055FA85(fieldListForm);

    AssertEquals(0, GlobalVar_0061E0D4);
    AssertEquals('', GlobalVar_0061E0D0);
    AssertEquals('', GlobalVar_0061E0CC);
  finally
    GlobalVar_0061E0D4 := 0;
    GlobalVar_0061E0D0 := '';
    GlobalVar_0061E0CC := '';
    fieldListForm.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.TestDecrement;
var
  fieldListForm: TForm24;
begin
  fieldListForm := TForm24.CreateNew(nil);
  try
    GlobalVar_0061E0D4 := 3;

    fieldListForm._PROC_0055FAC8(fieldListForm);

    AssertEquals(2, GlobalVar_0061E0D4);
  finally
    GlobalVar_0061E0D4 := 0;
    GlobalVar_0061E0D0 := '';
    GlobalVar_0061E0CC := '';
    fieldListForm.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestCancelSetsSentinelAndGlobalModalResult;
var
  fieldListForm: TForm24;
  globalDialog: TForm24;
  previousDialog: TForm24;
  previousSentinel: string;
begin
  fieldListForm := TForm24.CreateNew(nil);
  globalDialog := nil;
  previousDialog := Unit24.Form24;
  previousSentinel := GlobalVar_02535B50;
  try
    globalDialog := TForm24.CreateNew(nil);
    Unit24.Form24 := globalDialog;
    GlobalVar_02535B50 := 'previous value';

    fieldListForm.SpeedButton2Click(fieldListForm);

    AssertEquals('butt8', GlobalVar_02535B50);
    AssertEquals(mrCancel, globalDialog.ModalResult);
    AssertEquals(mrNone, fieldListForm.ModalResult);
  finally
    GlobalVar_02535B50 := previousSentinel;
    Unit24.Form24 := previousDialog;
    globalDialog.Free;
    fieldListForm.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestPrintButtonUsesGlobalModalTargetWhenListsAreSelected;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
  previousSentinel: string;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  previousSentinel := GlobalVar_02535B50;
  try
    receiver.ListBox3 := TListBox.Create(receiver);
    receiver.ListBox4 := TListBox.Create(receiver);
    receiver.ListBox6 := TListBox.Create(receiver);
    receiver.ListBox6.Items.Add('Selected synthetic farm name');
    target.ModalResult := mrNone;
    Unit24.Form24 := target;
    GlobalVar_02535B50 := '';

    receiver.SpeedButton1Click(nil);

    AssertEquals('butt1', GlobalVar_02535B50);
    AssertEquals(mrCancel, target.ModalResult);
    AssertEquals(mrNone, receiver.ModalResult);
  finally
    Unit24.Form24 := previousForm;
    GlobalVar_02535B50 := previousSentinel;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestListBox3DoubleClickDeletesSelectedItemFromGlobalForm;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox3 := TListBox.Create(receiver);
    target.ListBox3 := TListBox.Create(target);
    target.ListBox3.Items.Add('First retained field');
    target.ListBox3.Items.Add('Selected field');
    target.ListBox3.Items.Add('Last retained field');
    target.ListBox3.ItemIndex := 1;
    Unit24.Form24 := target;

    receiver.ListBox3DblClick(receiver.ListBox3);

    AssertEquals('The selected field should be removed from global Form24.',
      2, target.ListBox3.Items.Count);
    AssertEquals('The earlier item should be retained.',
      'First retained field', target.ListBox3.Items[0]);
    AssertEquals('The later item should be retained.',
      'Last retained field', target.ListBox3.Items[1]);
    AssertEquals('The receiver list should not be modified.',
      0, receiver.ListBox3.Items.Count);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestListBox1DoubleClickAddsSelectedItemToGlobalTargetList;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox1 := TListBox.Create(receiver);
    receiver.ListBox3 := TListBox.Create(receiver);
    target.ListBox1 := TListBox.Create(target);
    target.ListBox3 := TListBox.Create(target);
    target.ListBox1.Items.Add('Unselected field');
    target.ListBox1.Items.Add('Selected field');
    target.ListBox1.ItemIndex := 1;
    target.ListBox3.Items.Add('Existing target field');
    Unit24.Form24 := target;

    receiver.ListBox1DblClick(receiver.ListBox1);

    AssertEquals(2, target.ListBox3.Items.Count);
    AssertEquals('Existing target field', target.ListBox3.Items[0]);
    AssertEquals('Selected field', target.ListBox3.Items[1]);
    AssertEquals(2, target.ListBox1.Items.Count);
    AssertEquals(0, receiver.ListBox3.Items.Count);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestListBox2DoubleClickAddsSelectedItemToGlobalTargetList;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox2 := TListBox.Create(receiver);
    receiver.ListBox4 := TListBox.Create(receiver);
    target.ListBox2 := TListBox.Create(target);
    target.ListBox4 := TListBox.Create(target);
    target.ListBox2.Items.Add('Unselected profession');
    target.ListBox2.Items.Add('Selected profession');
    target.ListBox2.ItemIndex := 1;
    target.ListBox4.Items.Add('Existing target profession');
    Unit24.Form24 := target;

    receiver.ListBox2DblClick(receiver.ListBox2);

    AssertEquals(2, target.ListBox4.Items.Count);
    AssertEquals('Existing target profession', target.ListBox4.Items[0]);
    AssertEquals('Selected profession', target.ListBox4.Items[1]);
    AssertEquals(2, target.ListBox2.Items.Count);
    AssertEquals(0, receiver.ListBox4.Items.Count);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestListBox4DoubleClickDeletesSelectedItemFromGlobalList;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox6 := TListBox.Create(receiver);
    receiver.ListBox6.Items.Add('Receiver-only item');
    target.ListBox4 := TListBox.Create(target);
    target.ListBox4.Items.Add('First retained profession');
    target.ListBox4.Items.Add('Selected profession');
    target.ListBox4.Items.Add('Last retained profession');
    target.ListBox4.ItemIndex := 1;
    Unit24.Form24 := target;

    receiver.ListBox4DblClick(receiver.ListBox6);

    AssertEquals(2, target.ListBox4.Items.Count);
    AssertEquals('First retained profession', target.ListBox4.Items[0]);
    AssertEquals('Last retained profession', target.ListBox4.Items[1]);
    AssertEquals(1, receiver.ListBox6.Items.Count);
    AssertEquals('Receiver-only item', receiver.ListBox6.Items[0]);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestListBox5DoubleClickAddsOneHofnameAndSelectsRadioMode;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.RadioButton1 := TRadioButton.Create(receiver);
    receiver.RadioButton2 := TRadioButton.Create(receiver);
    receiver.RadioButton3 := TRadioButton.Create(receiver);
    receiver.RadioButton1.Enabled := True;
    receiver.RadioButton2.Checked := False;
    receiver.RadioButton3.Enabled := True;
    receiver.ListBox5 := TListBox.Create(receiver);
    receiver.ListBox6 := TListBox.Create(receiver);

    target.ListBox5 := TListBox.Create(target);
    target.ListBox6 := TListBox.Create(target);
    target.ListBox5.Items.Add('Selected synthetic Hofname');
    target.ListBox5.ItemIndex := 0;
    Unit24.Form24 := target;

    receiver.ListBox5DblClick(receiver.ListBox5);

    AssertEquals(1, target.ListBox6.Items.Count);
    AssertEquals('Selected synthetic Hofname', target.ListBox6.Items[0]);
    AssertEquals(1, target.ListBox5.Items.Count);
    AssertFalse(receiver.RadioButton1.Enabled);
    AssertTrue(receiver.RadioButton2.Checked);
    AssertFalse(receiver.RadioButton3.Enabled);
    AssertEquals(0, receiver.ListBox6.Items.Count);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestHofnameListButtonAddsSelectedItemAndSetsRadioMode;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.RadioButton1 := TRadioButton.Create(receiver);
    receiver.RadioButton2 := TRadioButton.Create(receiver);
    receiver.RadioButton3 := TRadioButton.Create(receiver);
    receiver.ListBox5 := TListBox.Create(receiver);
    receiver.ListBox6 := TListBox.Create(receiver);
    target.ListBox5 := TListBox.Create(target);
    target.ListBox6 := TListBox.Create(target);
    target.ListBox5.Items.Add('Selected button Hofname');
    target.ListBox5.ItemIndex := 0;
    Unit24.Form24 := target;

    receiver.Button1Click(nil);

    AssertEquals(1, target.ListBox6.Items.Count);
    AssertEquals('Selected button Hofname', target.ListBox6.Items[0]);
    AssertEquals(1, target.ListBox5.Items.Count);
    AssertFalse(receiver.RadioButton1.Enabled);
    AssertTrue(receiver.RadioButton2.Checked);
    AssertFalse(receiver.RadioButton3.Enabled);
    AssertEquals(0, receiver.ListBox6.Items.Count);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestHofnameListButtonDeletesSelectionAndReenablesRadioModes;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.RadioButton1 := TRadioButton.Create(receiver);
    receiver.RadioButton3 := TRadioButton.Create(receiver);
    receiver.RadioButton1.Enabled := False;
    receiver.RadioButton3.Enabled := False;
    target.ListBox6 := TListBox.Create(target);
    target.ListBox6.Items.Add('Selected synthetic Hofname');
    target.ListBox6.ItemIndex := 0;
    Unit24.Form24 := target;

    receiver.Button8Click(nil);

    AssertEquals(0, target.ListBox6.Items.Count);
    AssertTrue(receiver.RadioButton1.Enabled);
    AssertTrue(receiver.RadioButton3.Enabled);

    target.ListBox6.Items.Add('Retained synthetic Hofname');
    target.ListBox6.Items.Add('Selected synthetic Hofname');
    target.ListBox6.ItemIndex := 1;
    receiver.RadioButton1.Enabled := False;
    receiver.RadioButton3.Enabled := False;

    receiver.Button8Click(nil);

    AssertEquals(1, target.ListBox6.Items.Count);
    AssertEquals('Retained synthetic Hofname', target.ListBox6.Items[0]);
    AssertFalse(receiver.RadioButton1.Enabled);
    AssertFalse(receiver.RadioButton3.Enabled);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestHofnameListButtonClearsTargetAndReenablesRadioModes;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.RadioButton1 := TRadioButton.Create(receiver);
    receiver.RadioButton3 := TRadioButton.Create(receiver);
    receiver.RadioButton1.Enabled := False;
    receiver.RadioButton3.Enabled := False;
    target.ListBox6 := TListBox.Create(target);
    target.ListBox6.Items.Add('First synthetic Hofname');
    target.ListBox6.Items.Add('Second synthetic Hofname');
    Unit24.Form24 := target;

    receiver.Button10Click(nil);

    AssertEquals(0, target.ListBox6.Items.Count);
    AssertTrue(receiver.RadioButton1.Enabled);
    AssertTrue(receiver.RadioButton3.Enabled);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestButton2AddsSelectedFirstListItemToGlobalThirdList;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox3 := TListBox.Create(receiver);
    receiver.ListBox3.Items.Add('Receiver-only target');
    target.ListBox1 := TListBox.Create(target);
    target.ListBox3 := TListBox.Create(target);
    target.ListBox1.Items.Add('Unselected first-list item');
    target.ListBox1.Items.Add('Selected first-list item');
    target.ListBox1.ItemIndex := 1;
    target.ListBox3.Items.Add('Existing third-list item');
    Unit24.Form24 := target;

    receiver.Button2Click(nil);

    AssertEquals(2, target.ListBox3.Items.Count);
    AssertEquals('Existing third-list item', target.ListBox3.Items[0]);
    AssertEquals('Selected first-list item', target.ListBox3.Items[1]);
    AssertEquals(2, target.ListBox1.Items.Count);
    AssertEquals(1, receiver.ListBox3.Items.Count);
    AssertEquals('Receiver-only target', receiver.ListBox3.Items[0]);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestButton3AddsSelectedSecondListItemToGlobalFourthList;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox4 := TListBox.Create(receiver);
    receiver.ListBox4.Items.Add('Receiver-only profession');
    target.ListBox2 := TListBox.Create(target);
    target.ListBox4 := TListBox.Create(target);
    target.ListBox2.Items.Add('Unselected second-list item');
    target.ListBox2.Items.Add('Selected second-list item');
    target.ListBox2.ItemIndex := 1;
    target.ListBox4.Items.Add('Existing fourth-list item');
    Unit24.Form24 := target;

    receiver.Button3Click(nil);

    AssertEquals(2, target.ListBox4.Items.Count);
    AssertEquals('Existing fourth-list item', target.ListBox4.Items[0]);
    AssertEquals('Selected second-list item', target.ListBox4.Items[1]);
    AssertEquals(2, target.ListBox2.Items.Count);
    AssertEquals(1, receiver.ListBox4.Items.Count);
    AssertEquals('Receiver-only profession', receiver.ListBox4.Items[0]);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestButton4DeletesSelectedGlobalThirdListItem;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox3 := TListBox.Create(receiver);
    receiver.ListBox3.Items.Add('Receiver-only item');
    target.ListBox3 := TListBox.Create(target);
    target.ListBox3.Items.Add('Retained third-list item');
    target.ListBox3.Items.Add('Selected third-list item');
    target.ListBox3.ItemIndex := 1;
    Unit24.Form24 := target;

    receiver.Button4Click(nil);

    AssertEquals(1, target.ListBox3.Items.Count);
    AssertEquals('Retained third-list item', target.ListBox3.Items[0]);
    AssertEquals('Receiver-only item', receiver.ListBox3.Items[0]);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestButton5DeletesSelectedGlobalFourthListItem;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox4 := TListBox.Create(receiver);
    receiver.ListBox4.Items.Add('Receiver-only item');
    target.ListBox4 := TListBox.Create(target);
    target.ListBox4.Items.Add('Retained fourth-list item');
    target.ListBox4.Items.Add('Selected fourth-list item');
    target.ListBox4.ItemIndex := 1;
    Unit24.Form24 := target;

    receiver.Button5Click(nil);

    AssertEquals(1, target.ListBox4.Items.Count);
    AssertEquals('Retained fourth-list item', target.ListBox4.Items[0]);
    AssertEquals('Receiver-only item', receiver.ListBox4.Items[0]);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestButton6ClearsGlobalThirdList;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox3 := TListBox.Create(receiver);
    receiver.ListBox3.Items.Add('Receiver-only item');
    target.ListBox3 := TListBox.Create(target);
    target.ListBox3.Items.Add('First third-list item');
    target.ListBox3.Items.Add('Second third-list item');
    Unit24.Form24 := target;

    receiver.Button6Click(nil);

    AssertEquals(0, target.ListBox3.Items.Count);
    AssertEquals(1, receiver.ListBox3.Items.Count);
    AssertEquals('Receiver-only item', receiver.ListBox3.Items[0]);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestButton7ClearsGlobalFourthList;
var
  receiver: TForm24;
  target: TForm24;
  previousForm: TForm24;
begin
  receiver := TForm24.CreateNew(nil);
  target := TForm24.CreateNew(nil);
  previousForm := Unit24.Form24;
  try
    receiver.ListBox4 := TListBox.Create(receiver);
    receiver.ListBox4.Items.Add('Receiver-only item');
    target.ListBox4 := TListBox.Create(target);
    target.ListBox4.Items.Add('First fourth-list item');
    target.ListBox4.Items.Add('Second fourth-list item');
    Unit24.Form24 := target;

    receiver.Button7Click(nil);

    AssertEquals(0, target.ListBox4.Items.Count);
    AssertEquals(1, receiver.ListBox4.Items.Count);
    AssertEquals('Receiver-only item', receiver.ListBox4.Items[0]);
  finally
    Unit24.Form24 := previousForm;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestRadioButton4ChecksFirstElevenFields;
var
  fieldListForm: TForm24;
  checkBoxes: array[1..11] of TCheckBox;
  index: Integer;
begin
  fieldListForm := TForm24.CreateNew(nil);
  try
    fieldListForm.CheckBox1 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox2 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox3 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox4 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox5 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox6 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox7 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox8 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox9 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox10 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox11 := TCheckBox.Create(fieldListForm);
    checkBoxes[1] := fieldListForm.CheckBox1;
    checkBoxes[2] := fieldListForm.CheckBox2;
    checkBoxes[3] := fieldListForm.CheckBox3;
    checkBoxes[4] := fieldListForm.CheckBox4;
    checkBoxes[5] := fieldListForm.CheckBox5;
    checkBoxes[6] := fieldListForm.CheckBox6;
    checkBoxes[7] := fieldListForm.CheckBox7;
    checkBoxes[8] := fieldListForm.CheckBox8;
    checkBoxes[9] := fieldListForm.CheckBox9;
    checkBoxes[10] := fieldListForm.CheckBox10;
    checkBoxes[11] := fieldListForm.CheckBox11;
    for index := Low(checkBoxes) to High(checkBoxes) do
      checkBoxes[index].Checked := False;

    fieldListForm.RadioButton4Click(fieldListForm);

    for index := Low(checkBoxes) to High(checkBoxes) do
      AssertTrue('Checkbox ' + IntToStr(index) + ' should be checked',
        checkBoxes[index].Checked);
  finally
    fieldListForm.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestRadioButton5ClearsFirstElevenFields;
var
  fieldListForm: TForm24;
  checkBoxes: array[1..11] of TCheckBox;
  index: Integer;
begin
  fieldListForm := TForm24.CreateNew(nil);
  try
    fieldListForm.CheckBox1 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox2 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox3 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox4 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox5 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox6 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox7 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox8 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox9 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox10 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox11 := TCheckBox.Create(fieldListForm);
    checkBoxes[1] := fieldListForm.CheckBox1;
    checkBoxes[2] := fieldListForm.CheckBox2;
    checkBoxes[3] := fieldListForm.CheckBox3;
    checkBoxes[4] := fieldListForm.CheckBox4;
    checkBoxes[5] := fieldListForm.CheckBox5;
    checkBoxes[6] := fieldListForm.CheckBox6;
    checkBoxes[7] := fieldListForm.CheckBox7;
    checkBoxes[8] := fieldListForm.CheckBox8;
    checkBoxes[9] := fieldListForm.CheckBox9;
    checkBoxes[10] := fieldListForm.CheckBox10;
    checkBoxes[11] := fieldListForm.CheckBox11;
    for index := Low(checkBoxes) to High(checkBoxes) do
      checkBoxes[index].Checked := True;

    fieldListForm.RadioButton5Click(fieldListForm);

    for index := Low(checkBoxes) to High(checkBoxes) do
      AssertFalse('Checkbox ' + IntToStr(index) + ' should be clear',
        checkBoxes[index].Checked);
  finally
    fieldListForm.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestCheckBox17ClickUsesCheckBox17AsGate;
var
  fieldListForm: TForm24;
begin
  fieldListForm := TForm24.CreateNew(nil);
  try
    fieldListForm.CheckBox17 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox18 := TCheckBox.Create(fieldListForm);

    fieldListForm.CheckBox17.Checked := False;
    fieldListForm.CheckBox18.Checked := True;
    fieldListForm.CheckBox17Click(fieldListForm.CheckBox17);
    AssertFalse(fieldListForm.CheckBox18.Checked);

    fieldListForm.CheckBox17.Checked := True;
    fieldListForm.CheckBox18.Checked := True;
    fieldListForm.CheckBox17Click(fieldListForm.CheckBox17);
    AssertTrue(fieldListForm.CheckBox18.Checked);
  finally
    fieldListForm.Free;
  end;
end;

procedure TTestAHW52FieldListCounters.
  TestCheckBox18ClickUsesCheckBox17AsGate;
var
  fieldListForm: TForm24;
begin
  fieldListForm := TForm24.CreateNew(nil);
  try
    fieldListForm.CheckBox17 := TCheckBox.Create(fieldListForm);
    fieldListForm.CheckBox18 := TCheckBox.Create(fieldListForm);

    fieldListForm.CheckBox17.Checked := False;
    fieldListForm.CheckBox18.Checked := True;
    fieldListForm.CheckBox18Click(fieldListForm.CheckBox18);
    AssertFalse(fieldListForm.CheckBox18.Checked);

    fieldListForm.CheckBox17.Checked := True;
    fieldListForm.CheckBox18.Checked := True;
    fieldListForm.CheckBox18Click(fieldListForm.CheckBox18);
    AssertTrue(fieldListForm.CheckBox18.Checked);
  finally
    fieldListForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52FieldListCounters);

end.
