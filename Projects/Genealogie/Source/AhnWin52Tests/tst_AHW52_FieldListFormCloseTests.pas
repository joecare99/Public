unit tst_AHW52_FieldListFormCloseTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52FieldListFormClose = class(TTestCase)
  published
    procedure TestFormCloseSerializesListsAndStoresSelectionFlags;
  end;

implementation

uses
  Controls, StdCtrls, Unit24;

procedure TTestAHW52FieldListFormClose.
  TestFormCloseSerializesListsAndStoresSelectionFlags;
var
  fieldListForm: TForm24;
  checkBoxes: array[1..18] of TCheckBox;
  previousFlags: array[1..18] of LongInt;
  previousFieldList: string;
  previousFarmNameList: string;
  i: Integer;
begin
  previousFieldList := GlobalVar_0061E0CC;
  previousFarmNameList := GlobalVar_0061E0D0;
  previousFlags[1] := GlobalVar_025353E0;
  previousFlags[2] := GlobalVar_025353E4;
  previousFlags[3] := GlobalVar_025353E8;
  previousFlags[4] := GlobalVar_025353EC;
  previousFlags[5] := GlobalVar_025353F0;
  previousFlags[6] := GlobalVar_025353F4;
  previousFlags[7] := GlobalVar_025353F8;
  previousFlags[8] := GlobalVar_025353FC;
  previousFlags[9] := GlobalVar_02535400;
  previousFlags[10] := GlobalVar_02535404;
  previousFlags[11] := GlobalVar_02535408;
  previousFlags[12] := GlobalVar_0253540C;
  previousFlags[13] := GlobalVar_02535410;
  previousFlags[14] := GlobalVar_02535414;
  previousFlags[15] := GlobalVar_02535418;
  previousFlags[16] := GlobalVar_0253541C;
  previousFlags[17] := GlobalVar_02535420;
  previousFlags[18] := GlobalVar_02535424;

  fieldListForm := TForm24.CreateNew(nil);
  try
    fieldListForm.ListBox3 := TListBox.Create(fieldListForm);
    fieldListForm.ListBox3.Parent := fieldListForm;
    fieldListForm.ListBox3.Items.Add('First field');
    fieldListForm.ListBox3.Items.Add('Second field');
    fieldListForm.ListBox4 := TListBox.Create(fieldListForm);
    fieldListForm.ListBox4.Parent := fieldListForm;
    fieldListForm.ListBox4.Items.Add('First farm name');
    fieldListForm.ListBox4.Items.Add('Second farm name');

    fieldListForm.RadioButton1 := TRadioButton.Create(fieldListForm);
    fieldListForm.RadioButton1.Parent := fieldListForm;
    fieldListForm.RadioButton1.Checked := True;
    fieldListForm.RadioButton2 := TRadioButton.Create(fieldListForm);
    fieldListForm.RadioButton2.Parent := fieldListForm;
    fieldListForm.RadioButton3 := TRadioButton.Create(fieldListForm);
    fieldListForm.RadioButton3.Parent := fieldListForm;

    for i := Low(checkBoxes) to High(checkBoxes) do
    begin
      checkBoxes[i] := TCheckBox.Create(fieldListForm);
      checkBoxes[i].Parent := fieldListForm;
      checkBoxes[i].Checked := (i mod 2) = 0;
    end;
    fieldListForm.CheckBox1 := checkBoxes[1];
    fieldListForm.CheckBox2 := checkBoxes[2];
    fieldListForm.CheckBox3 := checkBoxes[3];
    fieldListForm.CheckBox4 := checkBoxes[4];
    fieldListForm.CheckBox5 := checkBoxes[5];
    fieldListForm.CheckBox6 := checkBoxes[6];
    fieldListForm.CheckBox7 := checkBoxes[7];
    fieldListForm.CheckBox8 := checkBoxes[8];
    fieldListForm.CheckBox9 := checkBoxes[9];
    fieldListForm.CheckBox10 := checkBoxes[10];
    fieldListForm.CheckBox11 := checkBoxes[11];
    fieldListForm.CheckBox14 := checkBoxes[14];
    fieldListForm.CheckBox16 := checkBoxes[16];
    fieldListForm.CheckBox17 := checkBoxes[17];
    fieldListForm.CheckBox18 := checkBoxes[18];

    GlobalVar_025353E0 := -1;
    GlobalVar_025353E4 := -1;
    GlobalVar_025353E8 := -1;
    GlobalVar_025353EC := -1;
    GlobalVar_025353F0 := -1;
    GlobalVar_025353F4 := -1;
    GlobalVar_025353F8 := -1;
    GlobalVar_025353FC := -1;
    GlobalVar_02535400 := -1;
    GlobalVar_02535404 := -1;
    GlobalVar_02535408 := -1;
    GlobalVar_0253540C := -1;
    GlobalVar_02535410 := -1;
    GlobalVar_02535414 := -1;
    GlobalVar_02535418 := -1;
    GlobalVar_0253541C := -1;
    GlobalVar_02535420 := -1;
    GlobalVar_02535424 := -1;

    fieldListForm.FormClose(fieldListForm);

    AssertEquals('Field list should preserve item order and trailing delimiter.',
      'First field%Second field%', GlobalVar_0061E0CC);
    AssertEquals('Farm-name list should preserve item order and trailing delimiter.',
      'First farm name%Second farm name%', GlobalVar_0061E0D0);
    AssertEquals(1, GlobalVar_025353E0);
    AssertEquals(0, GlobalVar_025353E4);
    AssertEquals(0, GlobalVar_025353E8);
    AssertEquals(1, GlobalVar_025353EC);
    AssertEquals(0, GlobalVar_025353F0);
    AssertEquals(1, GlobalVar_025353F4);
    AssertEquals(0, GlobalVar_025353F8);
    AssertEquals(1, GlobalVar_025353FC);
    AssertEquals(0, GlobalVar_02535400);
    AssertEquals(1, GlobalVar_02535404);
    AssertEquals(1, GlobalVar_02535408);
    AssertEquals(1, GlobalVar_0253540C);
    AssertEquals(1, GlobalVar_02535410);
    AssertEquals(0, GlobalVar_02535414);
    AssertEquals(1, GlobalVar_02535418);
    AssertEquals(0, GlobalVar_0253541C);
    AssertEquals(0, GlobalVar_02535420);
    AssertEquals(0, GlobalVar_02535424);

    fieldListForm.ListBox3.Clear;
    fieldListForm.ListBox4.Clear;
    fieldListForm.RadioButton1.Checked := False;
    fieldListForm.RadioButton2.Checked := True;
    for i := Low(checkBoxes) to High(checkBoxes) do
      checkBoxes[i].Checked := False;

    fieldListForm.FormClose(fieldListForm);

    AssertEquals('Empty field list should clear its shared string.',
      '', GlobalVar_0061E0CC);
    AssertEquals('Empty farm-name list should clear its shared string.',
      '', GlobalVar_0061E0D0);
    AssertEquals(0, GlobalVar_025353E0);
    AssertEquals(1, GlobalVar_025353E4);
    AssertEquals(0, GlobalVar_025353E8);
    AssertEquals(0, GlobalVar_025353EC);
    AssertEquals(0, GlobalVar_025353F0);
    AssertEquals(0, GlobalVar_025353F4);
    AssertEquals(0, GlobalVar_025353F8);
    AssertEquals(0, GlobalVar_025353FC);
    AssertEquals(0, GlobalVar_02535400);
    AssertEquals(0, GlobalVar_02535404);
    AssertEquals(0, GlobalVar_02535408);
    AssertEquals(0, GlobalVar_0253540C);
    AssertEquals(0, GlobalVar_02535410);
    AssertEquals(0, GlobalVar_02535414);
    AssertEquals(0, GlobalVar_02535418);
    AssertEquals(0, GlobalVar_0253541C);
    AssertEquals(0, GlobalVar_02535420);
    AssertEquals(0, GlobalVar_02535424);

    fieldListForm.RadioButton2.Checked := False;
    fieldListForm.RadioButton3.Checked := True;
    fieldListForm.FormClose(fieldListForm);
    AssertEquals(0, GlobalVar_025353E0);
    AssertEquals(0, GlobalVar_025353E4);
    AssertEquals(1, GlobalVar_025353E8);

    fieldListForm.RadioButton3.Checked := False;
    fieldListForm.FormClose(fieldListForm);
    AssertEquals(0, GlobalVar_025353E0);
    AssertEquals(0, GlobalVar_025353E4);
    AssertEquals(0, GlobalVar_025353E8);
  finally
    GlobalVar_025353E0 := previousFlags[1];
    GlobalVar_025353E4 := previousFlags[2];
    GlobalVar_025353E8 := previousFlags[3];
    GlobalVar_025353EC := previousFlags[4];
    GlobalVar_025353F0 := previousFlags[5];
    GlobalVar_025353F4 := previousFlags[6];
    GlobalVar_025353F8 := previousFlags[7];
    GlobalVar_025353FC := previousFlags[8];
    GlobalVar_02535400 := previousFlags[9];
    GlobalVar_02535404 := previousFlags[10];
    GlobalVar_02535408 := previousFlags[11];
    GlobalVar_0253540C := previousFlags[12];
    GlobalVar_02535410 := previousFlags[13];
    GlobalVar_02535414 := previousFlags[14];
    GlobalVar_02535418 := previousFlags[15];
    GlobalVar_0253541C := previousFlags[16];
    GlobalVar_02535420 := previousFlags[17];
    GlobalVar_02535424 := previousFlags[18];
    GlobalVar_0061E0CC := previousFieldList;
    GlobalVar_0061E0D0 := previousFarmNameList;
    fieldListForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52FieldListFormClose);

end.
