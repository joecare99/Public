unit tst_AHW52_ProfessionListSelectionTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52ProfessionListSelection = class(TTestCase)
  private
    FShowEventCount: Integer;
    procedure MakeTestFormInvisible(form: TCustomForm);
    procedure RecordFormShow(Sender: TObject);
  published
    procedure TestClickCopiesSelectedAndUnselectedIndices;
    procedure TestUnboundCounterIncrementAndZeroClear;
    procedure TestUnboundCounterDecrement;
    procedure TestDoubleClickCopiesProfessionAndShowsEditor;
  end;

implementation

uses
  StdCtrls, SysUtils, Unit36, Unit37;

procedure TTestAHW52ProfessionListSelection.MakeTestFormInvisible(
  form: TCustomForm);
begin
  form.AlphaBlend := True;
  form.AlphaBlendValue := 0;
  form.ShowInTaskBar := stNever;
end;

procedure TTestAHW52ProfessionListSelection.RecordFormShow(Sender: TObject);
begin
  Inc(FShowEventCount);
end;

procedure TTestAHW52ProfessionListSelection.
  TestClickCopiesSelectedAndUnselectedIndices;
var
  professionDialog: TForm36;
begin
  professionDialog := TForm36.CreateNew(nil);
  try
    professionDialog.ListBox1 := TListBox.Create(professionDialog);
    professionDialog.ListBox1.Items.Add('First synthetic profession');
    professionDialog.ListBox1.Items.Add('Second synthetic profession');

    professionDialog.ListBox1.ItemIndex := 1;
    GlobalVar_025353B8 := -99;
    professionDialog.ListBox1Click(professionDialog.ListBox1);
    AssertEquals('Selected index should be copied.', 1,
      GlobalVar_025353B8);

    professionDialog.ListBox1.ItemIndex := -1;
    professionDialog.ListBox1Click(professionDialog.ListBox1);
    AssertEquals('No-selection index should be copied.', -1,
      GlobalVar_025353B8);
  finally
    GlobalVar_025353B8 := 0;
    professionDialog.Free;
  end;
end;

procedure TTestAHW52ProfessionListSelection.
  TestUnboundCounterIncrementAndZeroClear;
var
  professionDialog: TForm36;
begin
  professionDialog := TForm36.CreateNew(nil);
  try
    GlobalVar_025353BC := 3;
    GlobalVar_025353B4 := 'Preserve';
    professionDialog._PROC_00575A19(professionDialog);
    AssertEquals('Increment callback should add one.', 4,
      GlobalVar_025353BC);
    AssertEquals('Nonzero result should preserve the string.', 'Preserve',
      GlobalVar_025353B4);

    GlobalVar_025353BC := -1;
    GlobalVar_025353B4 := 'Clear at zero';
    professionDialog._PROC_00575A19(professionDialog);
    AssertEquals('Increment should reach zero.', 0, GlobalVar_025353BC);
    AssertEquals('Zero result should clear the shared string.', '',
      GlobalVar_025353B4);
  finally
    GlobalVar_025353B8 := 0;
    GlobalVar_025353BC := 0;
    GlobalVar_025353B4 := '';
    professionDialog.Free;
  end;
end;

procedure TTestAHW52ProfessionListSelection.TestUnboundCounterDecrement;
var
  professionDialog: TForm36;
begin
  professionDialog := TForm36.CreateNew(nil);
  try
    GlobalVar_025353BC := 3;
    professionDialog._PROC_00575A54(professionDialog);
    AssertEquals('Decrement callback should subtract one.', 2,
      GlobalVar_025353BC);
  finally
    GlobalVar_025353BC := 0;
    professionDialog.Free;
  end;
end;

procedure TTestAHW52ProfessionListSelection.
  TestDoubleClickCopiesProfessionAndShowsEditor;
var
  professionList: TForm36;
  professionEditor: TForm37;
begin
  Application.Initialize;
  professionList := TForm36.CreateNew(nil);
  professionEditor := TForm37.CreateNew(nil);
  try
    professionList.ListBox1 := TListBox.Create(professionList);
    professionList.ListBox1.Items.Add('Synthetic profession');
    professionList.ListBox1.ItemIndex := 0;
    professionEditor.Label3 := TLabel.Create(professionEditor);
    professionEditor.Edit1 := TEdit.Create(professionEditor);
    MakeTestFormInvisible(professionEditor);
    professionEditor.OnShow := @RecordFormShow;
    Unit37.Form37 := professionEditor;
    FShowEventCount := 0;
    GlobalVar_025353B4 := 'Previous value';

    professionList.ListBox1DblClick(professionList.ListBox1);

    AssertEquals('Selected profession should be shared.',
      'Synthetic profession', GlobalVar_025353B4);
    AssertEquals('Label should receive the original prefix.',
      'Aktueller Beruf :    Synthetic profession',
      professionEditor.Label3.Caption);
    AssertEquals('Editor should receive the selected profession.',
      'Synthetic profession', professionEditor.Edit1.Text);
    AssertEquals('Editor should be visible.', True,
      professionEditor.Visible);
    AssertEquals('Editor should be shown once.', 1, FShowEventCount);
  finally
    Unit37.Form37 := nil;
    GlobalVar_025353B4 := '';
    professionEditor.Free;
    professionList.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52ProfessionListSelection);

end.
