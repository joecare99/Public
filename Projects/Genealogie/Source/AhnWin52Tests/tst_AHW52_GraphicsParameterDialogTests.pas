unit tst_AHW52_GraphicsParameterDialogTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Unit12, Unit13;

type
  TTestAHW52GraphicsParameterDialog = class(TTestCase)
  private
    FGraphicButtonClickCount: Integer;
    function CreateDialogWithControls: TForm12;
    procedure SetCheckBoxes(dialog: TForm12; checked: Boolean);
    procedure AssertCheckBoxes(dialog: TForm12; expected: Boolean);
    procedure SetOptionFlags(value: LongInt);
    procedure AssertOptionFlags(expected: LongInt);
    procedure HandleGraphicButtonClick(Sender: TObject);
    function CreateGraphicForm: TForm13;
  published
    procedure TestCancelSetsStateAndCancelModalResult;
    procedure TestFirstRadioChecksEveryField;
    procedure TestSecondRadioClearsEveryField;
    procedure TestFormShowInitializesDefaultControls;
    procedure TestFormShowHidesStartNumberForDescendantMode;
    procedure TestSpeedButtonCopiesOptionsAndDispatchesVorgr1;
    procedure TestSpeedButtonDispatchesVorgr2;
    procedure TestSpeedButtonDispatchesNachgr1AndFocusesButton;
    procedure TestSpeedButtonDispatchesNachgr2;
    procedure TestSpeedButtonLeavesUnknownModeUnchanged;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Buttons, Controls, Forms, Spin, StdCtrls, SysUtils;

function TTestAHW52GraphicsParameterDialog.CreateDialogWithControls: TForm12;
begin
  Result := TForm12.CreateNew(nil);
  Result.CheckBox1 := TCheckBox.Create(Result);
  Result.CheckBox2 := TCheckBox.Create(Result);
  Result.CheckBox3 := TCheckBox.Create(Result);
  Result.CheckBox4 := TCheckBox.Create(Result);
  Result.CheckBox5 := TCheckBox.Create(Result);
  Result.CheckBox6 := TCheckBox.Create(Result);
  Result.CheckBox7 := TCheckBox.Create(Result);
  Result.CheckBox8 := TCheckBox.Create(Result);
  Result.CheckBox1.Parent := Result;
  Result.CheckBox2.Parent := Result;
  Result.CheckBox3.Parent := Result;
  Result.CheckBox4.Parent := Result;
  Result.CheckBox5.Parent := Result;
  Result.CheckBox6.Parent := Result;
  Result.CheckBox7.Parent := Result;
  Result.CheckBox8.Parent := Result;
  Result.Label2 := TLabel.Create(Result);
  Result.Label2.Parent := Result;
  Result.SpinEdit1 := TSpinEdit.Create(Result);
  Result.SpinEdit1.Parent := Result;
  Result.SpinEdit2 := TSpinEdit.Create(Result);
  Result.SpinEdit2.Parent := Result;
end;

procedure TTestAHW52GraphicsParameterDialog.SetCheckBoxes(dialog: TForm12;
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
end;

procedure TTestAHW52GraphicsParameterDialog.AssertCheckBoxes(dialog: TForm12;
  expected: Boolean);
var
  checkBoxes: array[0..7] of TCheckBox;
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
  for index := Low(checkBoxes) to High(checkBoxes) do
    AssertTrue(Format('CheckBox%d expected Checked=%s.', [index + 1,
      BoolToStr(expected, True)]), checkBoxes[index].Checked = expected);
end;

procedure TTestAHW52GraphicsParameterDialog.SetOptionFlags(value: LongInt);
begin
  GlobalVar_0061E2BC := value;
  GlobalVar_0061E2C0 := value;
  GlobalVar_0061E2C4 := value;
  GlobalVar_0061E2C8 := value;
  GlobalVar_0061E2CC := value;
  GlobalVar_0061E2D0 := value;
  GlobalVar_0061E2D4 := value;
  GlobalVar_0061E2D8 := value;
end;

procedure TTestAHW52GraphicsParameterDialog.AssertOptionFlags(
  expected: LongInt);
var
  flags: array[0..7] of LongInt;
  index: Integer;
begin
  flags[0] := GlobalVar_0061E2BC;
  flags[1] := GlobalVar_0061E2C0;
  flags[2] := GlobalVar_0061E2C4;
  flags[3] := GlobalVar_0061E2C8;
  flags[4] := GlobalVar_0061E2CC;
  flags[5] := GlobalVar_0061E2D0;
  flags[6] := GlobalVar_0061E2D4;
  flags[7] := GlobalVar_0061E2D8;
  for index := Low(flags) to High(flags) do
    AssertEquals(Format('Option flag %d should be reset.', [index + 1]),
      expected, flags[index]);
end;

procedure TTestAHW52GraphicsParameterDialog.HandleGraphicButtonClick(
  Sender: TObject);
begin
  Inc(FGraphicButtonClickCount);
end;

function TTestAHW52GraphicsParameterDialog.CreateGraphicForm: TForm13;
begin
  FGraphicButtonClickCount := 0;
  Result := TForm13.CreateNew(nil);
  Result.Button2 := TSpeedButton.Create(Result);
  Result.Button2.Parent := Result;
  Result.Button2.OnClick := @HandleGraphicButtonClick;
  Unit13.Form13 := Result;
end;

procedure TTestAHW52GraphicsParameterDialog.TestFirstRadioChecksEveryField;
var
  parameterDialog: TForm12;
begin
  parameterDialog := CreateDialogWithControls;
  try
    SetCheckBoxes(parameterDialog, False);

    parameterDialog.RadioButton1Click(nil);

    AssertCheckBoxes(parameterDialog, True);
  finally
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.
  TestFormShowInitializesDefaultControls;
var
  parameterDialog: TForm12;
begin
  parameterDialog := CreateDialogWithControls;
  try
    SetOptionFlags(1);
    GlobalVar_0253592C := 'Vorgr1';
    parameterDialog.CheckBox1.Visible := False;
    parameterDialog.CheckBox2.Visible := False;
    parameterDialog.CheckBox8.Visible := True;
    parameterDialog.Label2.Visible := False;
    parameterDialog.SpinEdit2.Visible := False;

    parameterDialog.FormShow(parameterDialog);

    AssertOptionFlags(0);
    AssertTrue(parameterDialog.CheckBox1.Visible);
    AssertTrue(parameterDialog.CheckBox2.Visible);
    AssertFalse(parameterDialog.CheckBox8.Visible);
    AssertTrue(parameterDialog.Label2.Visible);
    AssertTrue(parameterDialog.SpinEdit2.Visible);
    AssertTrue('SpinEdit1 should be the active control.',
      parameterDialog.ActiveControl = parameterDialog.SpinEdit1);
  finally
    SetOptionFlags(0);
    GlobalVar_0253592C := '';
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.
  TestFormShowHidesStartNumberForDescendantMode;
var
  parameterDialog: TForm12;
begin
  parameterDialog := CreateDialogWithControls;
  try
    SetOptionFlags(1);
    GlobalVar_0253592C := 'Nachgr1';

    parameterDialog.FormShow(parameterDialog);

    AssertOptionFlags(0);
    AssertTrue(parameterDialog.CheckBox1.Visible);
    AssertFalse(parameterDialog.CheckBox2.Visible);
    AssertFalse(parameterDialog.CheckBox8.Visible);
    AssertFalse(parameterDialog.Label2.Visible);
    AssertFalse(parameterDialog.SpinEdit2.Visible);
    AssertTrue('SpinEdit1 should remain the active control.',
      parameterDialog.ActiveControl = parameterDialog.SpinEdit1);
  finally
    SetOptionFlags(0);
    GlobalVar_0253592C := '';
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.
  TestSpeedButtonCopiesOptionsAndDispatchesVorgr1;
var
  parameterDialog: TForm12;
  graphicForm: TForm13;
  previousParameterDialog: TForm12;
  previousGraphicForm: TForm13;
begin
  Application.Initialize;
  previousParameterDialog := Unit12.Form12;
  previousGraphicForm := Unit13.Form13;
  parameterDialog := CreateDialogWithControls;
  graphicForm := CreateGraphicForm;
  Unit12.Form12 := parameterDialog;
  try
    SetOptionFlags(0);
    GlobalVar_0061E2C0 := 9;
    GlobalVar_0253592C := 'Vorgr1';
    parameterDialog.SpinEdit1.Value := 14;
    parameterDialog.CheckBox1.Checked := True;
    parameterDialog.CheckBox3.Checked := True;
    parameterDialog.CheckBox8.Checked := True;

    parameterDialog.SpeedButton1Click(parameterDialog.SpeedButton1);

    AssertEquals('Checked options should set their flags.', 1,
      GlobalVar_0061E2BC);
    AssertEquals('Unchecked options should retain their prior flag.', 9,
      GlobalVar_0061E2C0);
    AssertEquals(1, GlobalVar_0061E2C4);
    AssertEquals(1, GlobalVar_0061E2D8);
    AssertEquals('Vorfahren-Grafik I', graphicForm.Caption);
    AssertTrue('The graphics form should be shown.', graphicForm.Visible);
    AssertEquals('The handler assigns modal result value 2.', mrCancel,
      parameterDialog.ModalResult);
  finally
    SetOptionFlags(0);
    GlobalVar_0253592C := '';
    graphicForm.Hide;
    Unit13.Form13 := previousGraphicForm;
    graphicForm.Free;
    Unit12.Form12 := previousParameterDialog;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.TestSpeedButtonDispatchesVorgr2;
var
  parameterDialog: TForm12;
  graphicForm: TForm13;
  previousParameterDialog: TForm12;
  previousGraphicForm: TForm13;
begin
  Application.Initialize;
  previousParameterDialog := Unit12.Form12;
  previousGraphicForm := Unit13.Form13;
  parameterDialog := CreateDialogWithControls;
  graphicForm := CreateGraphicForm;
  Unit12.Form12 := parameterDialog;
  try
    GlobalVar_0253592C := 'Vorgr2';
    parameterDialog.SpinEdit1.Value := 1;

    parameterDialog.SpeedButton1Click(parameterDialog.SpeedButton1);

    AssertEquals('Vorfahren-Grafik II', graphicForm.Caption);
    AssertTrue('The graphics form should be shown.', graphicForm.Visible);
    AssertEquals(mrCancel, parameterDialog.ModalResult);
  finally
    GlobalVar_0253592C := '';
    graphicForm.Hide;
    Unit13.Form13 := previousGraphicForm;
    graphicForm.Free;
    Unit12.Form12 := previousParameterDialog;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.
  TestSpeedButtonDispatchesNachgr1AndFocusesButton;
var
  parameterDialog: TForm12;
  graphicForm: TForm13;
  previousParameterDialog: TForm12;
  previousGraphicForm: TForm13;
begin
  Application.Initialize;
  previousParameterDialog := Unit12.Form12;
  previousGraphicForm := Unit13.Form13;
  parameterDialog := CreateDialogWithControls;
  graphicForm := CreateGraphicForm;
  Unit12.Form12 := parameterDialog;
  try
    GlobalVar_0253592C := 'Nachgr1';

    parameterDialog.SpeedButton1Click(parameterDialog.SpeedButton1);

    AssertEquals('Nachfahren-Grafik I', graphicForm.Caption);
    AssertTrue('The graphics form should be shown.', graphicForm.Visible);
    AssertEquals('The Button2 click should be dispatched after Show.', 1,
      FGraphicButtonClickCount);
    AssertEquals(mrCancel, parameterDialog.ModalResult);
  finally
    GlobalVar_0253592C := '';
    graphicForm.Hide;
    Unit13.Form13 := previousGraphicForm;
    graphicForm.Free;
    Unit12.Form12 := previousParameterDialog;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.TestSpeedButtonDispatchesNachgr2;
var
  parameterDialog: TForm12;
  graphicForm: TForm13;
  previousParameterDialog: TForm12;
  previousGraphicForm: TForm13;
begin
  Application.Initialize;
  previousParameterDialog := Unit12.Form12;
  previousGraphicForm := Unit13.Form13;
  parameterDialog := CreateDialogWithControls;
  graphicForm := CreateGraphicForm;
  Unit12.Form12 := parameterDialog;
  try
    GlobalVar_0253592C := 'Nachgr2';

    parameterDialog.SpeedButton1Click(parameterDialog.SpeedButton1);

    AssertEquals('Nachfahren-Grafik II', graphicForm.Caption);
    AssertTrue('The graphics form should be shown.', graphicForm.Visible);
    AssertEquals(mrCancel, parameterDialog.ModalResult);
  finally
    GlobalVar_0253592C := '';
    graphicForm.Hide;
    Unit13.Form13 := previousGraphicForm;
    graphicForm.Free;
    Unit12.Form12 := previousParameterDialog;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.
  TestSpeedButtonLeavesUnknownModeUnchanged;
var
  parameterDialog: TForm12;
  previousParameterDialog: TForm12;
  previousGraphicForm: TForm13;
begin
  previousParameterDialog := Unit12.Form12;
  previousGraphicForm := Unit13.Form13;
  parameterDialog := CreateDialogWithControls;
  Unit12.Form12 := parameterDialog;
  Unit13.Form13 := nil;
  try
    SetOptionFlags(0);
    GlobalVar_0253592C := 'Unbekannt';
    parameterDialog.CheckBox4.Checked := True;
    parameterDialog.SpeedButton1Click(parameterDialog.SpeedButton1);

    AssertEquals(1, GlobalVar_0061E2C8);
    AssertEquals('An unrecognized mode should not set a modal result.',
      mrNone, parameterDialog.ModalResult);
  finally
    SetOptionFlags(0);
    GlobalVar_0253592C := '';
    Unit13.Form13 := previousGraphicForm;
    Unit12.Form12 := previousParameterDialog;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.TestSecondRadioClearsEveryField;
var
  parameterDialog: TForm12;
begin
  parameterDialog := CreateDialogWithControls;
  try
    SetCheckBoxes(parameterDialog, True);

    parameterDialog.RadioButton2Click(nil);

    AssertCheckBoxes(parameterDialog, False);
  finally
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.
  TestCancelSetsStateAndCancelModalResult;
var
  parameterDialog: TForm12;
begin
  Application.Initialize;
  parameterDialog := TForm12.CreateNew(nil);
  Unit12.Form12 := parameterDialog;
  try
    GlobalVar_02535948 := 0;
    parameterDialog.ModalResult := 0;
    parameterDialog.SpeedButton2Click(parameterDialog.SpeedButton2);

    if GlobalVar_02535948 <> 1 then
      raise Exception.Create('Cancel should set the address-based state to 1.');
    if parameterDialog.ModalResult <> mrCancel then
      raise Exception.CreateFmt('Expected mrCancel, got %d.',
        [parameterDialog.ModalResult]);
  finally
    GlobalVar_02535948 := 0;
    Unit12.Form12 := nil;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.TestUnboundCounterIncrement;
var
  parameterDialog: TForm12;
begin
  parameterDialog := TForm12.CreateNew(nil);
  try
    GlobalVar_0061E100 := 4;
    parameterDialog._PROC_00562BB1(parameterDialog);
    AssertEquals('Increment callback should add one.', 5,
      GlobalVar_0061E100);
  finally
    GlobalVar_0061E100 := 0;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicsParameterDialog.TestUnboundCounterDecrement;
var
  parameterDialog: TForm12;
begin
  parameterDialog := TForm12.CreateNew(nil);
  try
    GlobalVar_0061E100 := 4;
    parameterDialog._PROC_00562BE0(parameterDialog);
    AssertEquals('Decrement callback should subtract one.', 3,
      GlobalVar_0061E100);
  finally
    GlobalVar_0061E100 := 0;
    parameterDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52GraphicsParameterDialog);

end.
