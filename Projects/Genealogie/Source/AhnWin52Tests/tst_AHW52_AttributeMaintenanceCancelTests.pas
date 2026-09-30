unit tst_AHW52_AttributeMaintenanceCancelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52AttributeMaintenanceCancel = class(TTestCase)
  private
    FCloseEventCount: Integer;
    FShowEventCount: Integer;
    procedure MakeTestFormInvisible(form: TCustomForm);
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure RecordFormShow(Sender: TObject);
  published
    procedure TestNameDialogCancelButtonClosesForm;
    procedure TestNameDialogActivationCopiesSharedNameIntoEdit;
    procedure TestSourceNameListEnterDispatchesToNameEditor;
    procedure TestSourceNameListClickCopiesSelectedAndUnselectedIndices;
    procedure TestProfessionDialogCancelButtonClosesForm;
    procedure TestNameDialogUnboundCounterIncrement;
    procedure TestNameDialogUnboundCounterDecrement;
    procedure TestProfessionDialogUnboundCounterIncrement;
    procedure TestProfessionDialogUnboundCounterDecrement;
    procedure TestSourceNameDialogUnboundCounterIncrementAndClear;
    procedure TestSourceNameDialogUnboundCounterDecrement;
  end;

implementation

uses
  SysUtils, StdCtrls, Unit28, Unit34, Unit37;

procedure TTestAHW52AttributeMaintenanceCancel.MakeTestFormInvisible(
  form: TCustomForm);
begin
  form.AlphaBlend := True;
  form.AlphaBlendValue := 0;
  form.ShowInTaskBar := stNever;
end;

procedure TTestAHW52AttributeMaintenanceCancel.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52AttributeMaintenanceCancel.RecordFormShow(Sender: TObject);
begin
  Inc(FShowEventCount);
end;

procedure TTestAHW52AttributeMaintenanceCancel.TestNameDialogCancelButtonClosesForm;
var
  nameDialog: TForm34;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  nameDialog := TForm34.CreateNew(nil);
  Unit34.Form34 := nameDialog;
  try
    nameDialog.OnClose := @RecordFormClose;
    nameDialog.BitBtn1Click(nameDialog.BitBtn1);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit34.Form34 := nil;
    nameDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.
  TestNameDialogActivationCopiesSharedNameIntoEdit;
var
  nameDialog: TForm34;
begin
  Application.Initialize;
  nameDialog := TForm34.CreateNew(nil);
  try
    nameDialog.Edit1 := TEdit.Create(nameDialog);
    GlobalVar_0253539C := 'Synthetic name';
    nameDialog.FormActivate(nameDialog);

    if nameDialog.Edit1.Text <> 'Synthetic name' then
      raise Exception.CreateFmt('Expected the shared name in Edit1, got "%s".',
        [nameDialog.Edit1.Text]);
  finally
    GlobalVar_0253539C := '';
    nameDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.
  TestSourceNameListEnterDispatchesToNameEditor;
var
  sourceNameDialog: TForm28;
  nameDialog: TForm34;
  key: Char;
  selectedName: string;
begin
  Application.Initialize;
  sourceNameDialog := TForm28.CreateNew(nil);
  nameDialog := TForm34.CreateNew(nil);
  Unit34.Form34 := nameDialog;
  try
    selectedName := '  Selected synthetic name  ';
    sourceNameDialog.ListBox1 := TListBox.Create(sourceNameDialog);
    sourceNameDialog.ListBox1.Items.Add(selectedName);
    sourceNameDialog.ListBox1.ItemIndex := 0;

    nameDialog.Label3 := TLabel.Create(nameDialog);
    MakeTestFormInvisible(nameDialog);
    nameDialog.OnShow := @RecordFormShow;
    FShowEventCount := 0;
    nameDialog.Hide;

    GlobalVar_0253539C := 'Unchanged before Enter';
    key := 'x';
    sourceNameDialog.ListBox1KeyPress(sourceNameDialog.ListBox1, key);
    AssertEquals('Non-Enter input should preserve the shared name.',
      'Unchanged before Enter', GlobalVar_0253539C);
    AssertEquals('Non-Enter input should not show the editor.', 0,
      FShowEventCount);
    AssertFalse('Non-Enter input should leave the editor hidden.',
      nameDialog.Visible);
    AssertEquals('The handler should not consume non-Enter input.', 'x', key);

    key := #$0D;
    sourceNameDialog.ListBox1KeyPress(sourceNameDialog.ListBox1, key);
    AssertEquals('Enter should copy the selected name unchanged.',
      selectedName, GlobalVar_0253539C);
    AssertEquals('The caption should preserve the selected text.',
      'Aktueller Name: ' + selectedName, nameDialog.Label3.Caption);
    AssertEquals('Enter should show the editor once.', 1, FShowEventCount);
    AssertTrue('The editor should be visible after Enter.', nameDialog.Visible);
    AssertEquals('The handler should not consume Enter.', #$0D, key);
  finally
    nameDialog.Hide;
    Unit34.Form34 := nil;
    GlobalVar_0253539C := '';
    nameDialog.Free;
    sourceNameDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.
  TestSourceNameListClickCopiesSelectedAndUnselectedIndices;
var
  sourceNameDialog: TForm28;
begin
  sourceNameDialog := TForm28.CreateNew(nil);
  try
    sourceNameDialog.ListBox1 := TListBox.Create(sourceNameDialog);
    sourceNameDialog.ListBox1.Items.Add('Synthetic source');
    sourceNameDialog.ListBox1.ItemIndex := 0;
    sourceNameDialog.ListBox1Click(sourceNameDialog.ListBox1);
    AssertEquals('The selected source index should be copied.',
      0, GlobalVar_025353A0);

    sourceNameDialog.ListBox1.ItemIndex := -1;
    sourceNameDialog.ListBox1Click(sourceNameDialog.ListBox1);
    AssertEquals('The no-selection index should be copied.',
      -1, GlobalVar_025353A0);
  finally
    GlobalVar_025353A0 := 0;
    sourceNameDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.TestProfessionDialogCancelButtonClosesForm;
var
  professionDialog: TForm37;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  professionDialog := TForm37.CreateNew(nil);
  Unit37.Form37 := professionDialog;
  try
    professionDialog.OnClose := @RecordFormClose;
    professionDialog.BitBtn1Click(professionDialog.BitBtn1);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit37.Form37 := nil;
    professionDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.
  TestNameDialogUnboundCounterIncrement;
var
  nameDialog: TForm34;
begin
  nameDialog := TForm34.CreateNew(nil);
  try
    GlobalVar_02535394 := 12;
    nameDialog._PROC_00573E85(nameDialog);
    AssertEquals('Increment callback should add one.', 13,
      GlobalVar_02535394);
  finally
    GlobalVar_02535394 := 0;
    nameDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.
  TestNameDialogUnboundCounterDecrement;
var
  nameDialog: TForm34;
begin
  nameDialog := TForm34.CreateNew(nil);
  try
    GlobalVar_02535394 := 12;
    nameDialog._PROC_00573EB4(nameDialog);
    AssertEquals('Decrement callback should subtract one.', 11,
      GlobalVar_02535394);
  finally
    GlobalVar_02535394 := 0;
    nameDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.
  TestProfessionDialogUnboundCounterIncrement;
var
  professionDialog: TForm37;
begin
  professionDialog := TForm37.CreateNew(nil);
  try
    GlobalVar_025353AC := 23;
    professionDialog._PROC_00574FA5(professionDialog);
    AssertEquals('Increment callback should add one.', 24,
      GlobalVar_025353AC);
  finally
    GlobalVar_025353AC := 0;
    professionDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.
  TestProfessionDialogUnboundCounterDecrement;
var
  professionDialog: TForm37;
begin
  professionDialog := TForm37.CreateNew(nil);
  try
    GlobalVar_025353AC := 23;
    professionDialog._PROC_00574FD4(professionDialog);
    AssertEquals('Decrement callback should subtract one.', 22,
      GlobalVar_025353AC);
  finally
    GlobalVar_025353AC := 0;
    professionDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.
  TestSourceNameDialogUnboundCounterIncrementAndClear;
var
  sourceNameDialog: TForm28;
begin
  sourceNameDialog := TForm28.CreateNew(nil);
  try
    GlobalVar_025353A4 := 4;
    GlobalVar_0253539C := 'Preserve';
    sourceNameDialog._PROC_00574ACC(sourceNameDialog);
    AssertEquals('Increment callback should add one.', 5,
      GlobalVar_025353A4);
    AssertEquals('Nonzero result should preserve the shared string.',
      'Preserve', GlobalVar_0253539C);

    GlobalVar_025353A4 := -1;
    GlobalVar_0253539C := 'Clear at zero';
    sourceNameDialog._PROC_00574ACC(sourceNameDialog);
    AssertEquals('Increment should reach zero.', 0, GlobalVar_025353A4);
    AssertEquals('Zero result should clear the shared string.', '',
      GlobalVar_0253539C);
  finally
    GlobalVar_025353A4 := 0;
    GlobalVar_0253539C := '';
    sourceNameDialog.Free;
  end;
end;

procedure TTestAHW52AttributeMaintenanceCancel.
  TestSourceNameDialogUnboundCounterDecrement;
var
  sourceNameDialog: TForm28;
begin
  sourceNameDialog := TForm28.CreateNew(nil);
  try
    GlobalVar_025353A4 := 4;
    sourceNameDialog._PROC_00574B08(sourceNameDialog);
    AssertEquals('Decrement callback should subtract one.', 3,
      GlobalVar_025353A4);
  finally
    GlobalVar_025353A4 := 0;
    sourceNameDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52AttributeMaintenanceCancel);

end.
