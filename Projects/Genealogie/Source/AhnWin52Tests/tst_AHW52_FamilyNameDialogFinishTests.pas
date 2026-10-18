unit tst_AHW52_FamilyNameDialogFinishTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52FamilyNameDialogFinish = class(TTestCase)
  published
    procedure TestFinishResetsSelectionAndClosesDialog;
    procedure TestUnboundCounterIncrementAndZeroClear;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Controls, Forms, StdCtrls, Unit39, Unit40;

procedure TTestAHW52FamilyNameDialogFinish.
  TestFinishResetsSelectionAndClosesDialog;
var
  familyNameForm: TForm39;
begin
  familyNameForm := TForm39.CreateNew(nil);
  Form39 := familyNameForm;
  try
    familyNameForm.ListBox1 := TListBox.Create(familyNameForm);
    familyNameForm.ListBox1.Items.Add('First synthetic family name');
    familyNameForm.ListBox1.Items.Add('Second synthetic family name');
    familyNameForm.ListBox1.ItemIndex := 1;
    GlobalVar_025353D0 := 1;

    familyNameForm.BitBtn1Click(nil);

    AssertEquals('Selection state should be reset.', 0,
      GlobalVar_025353D0);
    AssertEquals('List should return to its first item.', 0,
      familyNameForm.ListBox1.ItemIndex);
    AssertEquals('Finish should set the cancel modal result.', mrCancel,
      familyNameForm.ModalResult);
  finally
    Form39 := nil;
    GlobalVar_025353D0 := 0;
    familyNameForm.Free;
  end;
end;

procedure TTestAHW52FamilyNameDialogFinish.
  TestUnboundCounterIncrementAndZeroClear;
var
  familyNameForm: TForm39;
begin
  familyNameForm := TForm39.CreateNew(nil);
  try
    GlobalVar_025353D4 := 5;
    GlobalVar_025353CC := 'Keep this value';
    familyNameForm._PROC_00576970(familyNameForm);
    AssertEquals('Increment callback should add one.', 6,
      GlobalVar_025353D4);
    AssertEquals('Nonzero result should preserve the string.',
      'Keep this value', GlobalVar_025353CC);

    GlobalVar_025353D4 := -1;
    GlobalVar_025353CC := 'Clear at zero';
    familyNameForm._PROC_00576970(familyNameForm);
    AssertEquals('Increment should reach zero.', 0, GlobalVar_025353D4);
    AssertEquals('Zero result should clear the shared string.', '',
      GlobalVar_025353CC);
  finally
    GlobalVar_025353D4 := 0;
    GlobalVar_025353CC := '';
    familyNameForm.Free;
  end;
end;

procedure TTestAHW52FamilyNameDialogFinish.TestUnboundCounterDecrement;
var
  familyNameForm: TForm39;
begin
  familyNameForm := TForm39.CreateNew(nil);
  try
    GlobalVar_025353D4 := 5;
    familyNameForm._PROC_005769AC(familyNameForm);
    AssertEquals('Decrement callback should subtract one.', 4,
      GlobalVar_025353D4);
  finally
    GlobalVar_025353D4 := 0;
    familyNameForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52FamilyNameDialogFinish);

end.
