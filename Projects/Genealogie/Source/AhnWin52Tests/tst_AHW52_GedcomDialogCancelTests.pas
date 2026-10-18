unit tst_AHW52_GedcomDialogCancelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52GedcomDialog = class(TTestCase)
  private
    FCloseSequence: string;
    procedure RecordMainFormClose(Sender: TObject;
      var CloseAction: TCloseAction);
    procedure RecordDialogClose(Sender: TObject;
      var CloseAction: TCloseAction);
  published
    procedure TestParameterDialogShowSelectsUtf8AndFocusesName;
    procedure TestChooserDismissButtonClosesChooser;
    procedure TestChooserActivationClearsAllChoices;
    procedure TestCancelClosesOwnerThenDialog;
    procedure TestUnboundCounterIncrementAndZeroClear;
    procedure TestUnboundCounterDecrement;
    procedure TestParameterCounterIncrement;
    procedure TestParameterCounterDecrement;
  end;

implementation

uses
  Classes, Controls, StdCtrls, SysUtils, Unit26, Unit27;

procedure TTestAHW52GedcomDialog.
  TestParameterDialogShowSelectsUtf8AndFocusesName;
var
  parameterDialog: TOKBottomDlg1;
begin
  parameterDialog := TOKBottomDlg1.CreateNew(nil);
  try
    parameterDialog.Edit1 := TEdit.Create(parameterDialog);
    parameterDialog.Edit1.Parent := parameterDialog;
    parameterDialog.RadioButton2 := TRadioButton.Create(parameterDialog);
    parameterDialog.RadioButton2.Parent := parameterDialog;

    parameterDialog.FormShow(parameterDialog);

    AssertTrue('The UTF-8 option should be selected.',
      parameterDialog.RadioButton2.Checked);
    AssertTrue('The name edit should receive focus.',
      parameterDialog.ActiveControl = parameterDialog.Edit1);
  finally
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GedcomDialog.TestParameterCounterIncrement;
var
  parameterDialog: TOKBottomDlg1;
begin
  parameterDialog := TOKBottomDlg1.CreateNew(nil);
  try
    GlobalVar_0061DFF0 := 8;
    parameterDialog._PROC_0054DD45(parameterDialog);
    AssertEquals('Increment callback should add one.', 9,
      GlobalVar_0061DFF0);
  finally
    GlobalVar_0061DFF0 := 0;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GedcomDialog.TestParameterCounterDecrement;
var
  parameterDialog: TOKBottomDlg1;
begin
  parameterDialog := TOKBottomDlg1.CreateNew(nil);
  try
    GlobalVar_0061DFF0 := 8;
    parameterDialog._PROC_0054DD74(parameterDialog);
    AssertEquals('Decrement callback should subtract one.', 7,
      GlobalVar_0061DFF0);
  finally
    GlobalVar_0061DFF0 := 0;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GedcomDialog.RecordMainFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FCloseSequence := FCloseSequence + 'main;';
  CloseAction := caHide;
end;

procedure TTestAHW52GedcomDialog.RecordDialogClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  FCloseSequence := FCloseSequence + 'dialog;';
  CloseAction := caHide;
end;

procedure TTestAHW52GedcomDialog.TestChooserDismissButtonClosesChooser;
var
  gedcomForm: TForm26;
begin
  Application.Initialize;
  FCloseSequence := '';
  gedcomForm := TForm26.CreateNew(nil);
  Unit26.Form26 := gedcomForm;
  try
    gedcomForm.OnClose := @RecordMainFormClose;
    gedcomForm.SpeedButton1Click(gedcomForm.SpeedButton1);

    if FCloseSequence <> 'main;' then
      raise Exception.CreateFmt('Unexpected close sequence: %s',
        [FCloseSequence]);
  finally
    Unit26.Form26 := nil;
    gedcomForm.Free;
  end;
end;

procedure TTestAHW52GedcomDialog.TestChooserActivationClearsAllChoices;
var
  gedcomForm: TForm26;
begin
  Application.Initialize;
  gedcomForm := TForm26.CreateNew(nil);
  try
    gedcomForm.RadioButton1 := TRadioButton.Create(gedcomForm);
    gedcomForm.RadioButton1.Parent := gedcomForm;
    gedcomForm.RadioButton2 := TRadioButton.Create(gedcomForm);
    gedcomForm.RadioButton2.Parent := gedcomForm;
    gedcomForm.RadioButton3 := TRadioButton.Create(gedcomForm);
    gedcomForm.RadioButton3.Parent := gedcomForm;

    gedcomForm.RadioButton1.Checked := True;
    gedcomForm.FormActivate(gedcomForm);
    if gedcomForm.RadioButton1.Checked or gedcomForm.RadioButton2.Checked or
      gedcomForm.RadioButton3.Checked then
      raise Exception.Create('Activation must clear the first choice');

    gedcomForm.RadioButton2.Checked := True;
    gedcomForm.FormActivate(gedcomForm);
    if gedcomForm.RadioButton1.Checked or gedcomForm.RadioButton2.Checked or
      gedcomForm.RadioButton3.Checked then
      raise Exception.Create('Activation must clear the second choice');

    gedcomForm.RadioButton3.Checked := True;
    gedcomForm.FormActivate(gedcomForm);
    if gedcomForm.RadioButton1.Checked or gedcomForm.RadioButton2.Checked or
      gedcomForm.RadioButton3.Checked then
      raise Exception.Create('Activation must clear the third choice');
  finally
    gedcomForm.Free;
  end;
end;

procedure TTestAHW52GedcomDialog.TestCancelClosesOwnerThenDialog;
var
  gedcomForm: TForm26;
  parameterDialog: TOKBottomDlg1;
begin
  Application.Initialize;
  FCloseSequence := '';
  gedcomForm := TForm26.CreateNew(nil);
  parameterDialog := TOKBottomDlg1.CreateNew(nil);
  Unit26.Form26 := gedcomForm;
  Unit27.OKBottomDlg1 := parameterDialog;
  try
    gedcomForm.OnClose := @RecordMainFormClose;
    parameterDialog.OnClose := @RecordDialogClose;
    parameterDialog.SpeedButton2Click(parameterDialog.SpeedButton2);

    if FCloseSequence <> 'main;dialog;' then
      raise Exception.CreateFmt('Unexpected close sequence: %s',
        [FCloseSequence]);
  finally
    Unit27.OKBottomDlg1 := nil;
    Unit26.Form26 := nil;
    parameterDialog.Free;
    gedcomForm.Free;
  end;
end;

procedure TTestAHW52GedcomDialog.TestUnboundCounterIncrementAndZeroClear;
var
  gedcomForm: TForm26;
begin
  gedcomForm := TForm26.CreateNew(nil);
  try
    GlobalVar_0061E00C := 6;
    GlobalVar_0061E008 := 'Preserve';
    gedcomForm._PROC_00550578(gedcomForm);
    AssertEquals('Increment callback should add one.', 7,
      GlobalVar_0061E00C);
    AssertEquals('Nonzero result should preserve the string.', 'Preserve',
      GlobalVar_0061E008);

    GlobalVar_0061E00C := -1;
    GlobalVar_0061E008 := 'Clear at zero';
    gedcomForm._PROC_00550578(gedcomForm);
    AssertEquals('Increment should reach zero.', 0, GlobalVar_0061E00C);
    AssertEquals('Zero result should clear the string.', '',
      GlobalVar_0061E008);
  finally
    GlobalVar_0061E00C := 0;
    GlobalVar_0061E008 := '';
    gedcomForm.Free;
  end;
end;

procedure TTestAHW52GedcomDialog.TestUnboundCounterDecrement;
var
  gedcomForm: TForm26;
begin
  gedcomForm := TForm26.CreateNew(nil);
  try
    GlobalVar_0061E00C := 6;
    gedcomForm._PROC_005505B4(gedcomForm);
    AssertEquals('Decrement callback should subtract one.', 5,
      GlobalVar_0061E00C);
  finally
    GlobalVar_0061E00C := 0;
    gedcomForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52GedcomDialog);

end.
