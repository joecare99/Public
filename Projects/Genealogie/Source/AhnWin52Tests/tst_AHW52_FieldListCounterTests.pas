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
