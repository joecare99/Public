unit tst_AHW52_Unit24RadioPresetTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit24RadioPresets = class(TTestCase)
  published
    procedure TestRadioButton4ChecksAllElevenPresetCheckboxes;
    procedure TestRadioButton5UnchecksAllElevenPresetCheckboxes;
    procedure TestPresetsLeaveOtherCheckboxesUnchanged;
    procedure TestCheckBox17ClickClearsCheckBox18OnlyWhenUnchecked;
    procedure TestCheckBox18ClickClearsCheckBox18OnlyWhenCheckBox17IsUnchecked;
  end;

implementation

uses
  Classes, Controls, Forms, StdCtrls, OrtsfamilienbuchOptionsForm;

function CreatePresetForm: TOrtsfamilienbuchOptionsForm;
begin
  Result := TOrtsfamilienbuchOptionsForm.CreateNew(nil);
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
  Result.CheckBox14 := TCheckBox.Create(Result);
  Result.CheckBox16 := TCheckBox.Create(Result);
  Result.CheckBox17 := TCheckBox.Create(Result);
  Result.CheckBox18 := TCheckBox.Create(Result);
end;

procedure AssertPresetValues(TestCase: TTestCase;
  Form: TOrtsfamilienbuchOptionsForm; Expected: Boolean);
begin
  TestCase.AssertEquals(Expected, Form.CheckBox1.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox2.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox3.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox4.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox5.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox6.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox7.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox8.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox9.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox10.Checked);
  TestCase.AssertEquals(Expected, Form.CheckBox11.Checked);
end;

procedure TTestAHW52Unit24RadioPresets.
  TestRadioButton4ChecksAllElevenPresetCheckboxes;
var
  Form: TOrtsfamilienbuchOptionsForm;
begin
  Form := CreatePresetForm;
  try
    Form.RadioButton4Click(nil);
    AssertPresetValues(Self, Form, True);
  finally
    Form.Free;
  end;
end;

procedure TTestAHW52Unit24RadioPresets.
  TestRadioButton5UnchecksAllElevenPresetCheckboxes;
var
  Form: TOrtsfamilienbuchOptionsForm;
begin
  Form := CreatePresetForm;
  try
    Form.CheckBox1.Checked := True;
    Form.CheckBox2.Checked := True;
    Form.CheckBox3.Checked := True;
    Form.CheckBox4.Checked := True;
    Form.CheckBox5.Checked := True;
    Form.CheckBox6.Checked := True;
    Form.CheckBox7.Checked := True;
    Form.CheckBox8.Checked := True;
    Form.CheckBox9.Checked := True;
    Form.CheckBox10.Checked := True;
    Form.CheckBox11.Checked := True;

    Form.RadioButton5Click(nil);
    AssertPresetValues(Self, Form, False);
  finally
    Form.Free;
  end;
end;

procedure TTestAHW52Unit24RadioPresets.
  TestPresetsLeaveOtherCheckboxesUnchanged;
var
  Form: TOrtsfamilienbuchOptionsForm;
begin
  Form := CreatePresetForm;
  try
    Form.CheckBox14.Checked := True;
    Form.CheckBox16.Checked := True;
    Form.CheckBox17.Checked := True;
    Form.CheckBox18.Checked := True;

    Form.RadioButton4Click(nil);
    AssertTrue('The preset does not alter CheckBox14.',
      Form.CheckBox14.Checked);
    AssertTrue('The preset does not alter CheckBox16.',
      Form.CheckBox16.Checked);
    AssertTrue('The preset does not alter CheckBox17.',
      Form.CheckBox17.Checked);
    AssertTrue('The preset does not alter CheckBox18.',
      Form.CheckBox18.Checked);

    Form.RadioButton5Click(nil);
    AssertTrue('The second preset does not alter CheckBox14.',
      Form.CheckBox14.Checked);
    AssertTrue('The second preset does not alter CheckBox16.',
      Form.CheckBox16.Checked);
    AssertTrue('The second preset does not alter CheckBox17.',
      Form.CheckBox17.Checked);
    AssertTrue('The second preset does not alter CheckBox18.',
      Form.CheckBox18.Checked);
  finally
    Form.Free;
  end;
end;

procedure TTestAHW52Unit24RadioPresets.
  TestCheckBox17ClickClearsCheckBox18OnlyWhenUnchecked;
var
  Form: TOrtsfamilienbuchOptionsForm;
begin
  Form := CreatePresetForm;
  try
    Form.CheckBox17.Checked := True;
    Form.CheckBox18.Checked := True;
    Form.CheckBox14.Checked := True;
    Form.CheckBox16.Checked := False;

    Form.CheckBox17Click(nil);
    AssertTrue('With CheckBox17 enabled, CheckBox18 remains unchanged.',
      Form.CheckBox18.Checked);
    AssertTrue('The handler leaves unrelated checked state intact.',
      Form.CheckBox14.Checked);
    AssertFalse('The handler leaves unrelated unchecked state intact.',
      Form.CheckBox16.Checked);

    Form.CheckBox17.Checked := False;
    Form.CheckBox17Click(nil);
    AssertFalse('With CheckBox17 disabled, CheckBox18 is cleared.',
      Form.CheckBox18.Checked);
  finally
    Form.Free;
  end;
end;

procedure TTestAHW52Unit24RadioPresets.
  TestCheckBox18ClickClearsCheckBox18OnlyWhenCheckBox17IsUnchecked;
var
  Form: TOrtsfamilienbuchOptionsForm;
begin
  Form := CreatePresetForm;
  try
    Form.CheckBox17.Checked := True;
    Form.CheckBox18.Checked := True;
    Form.CheckBox18Click(nil);
    AssertTrue('With CheckBox17 enabled, CheckBox18 remains unchanged.',
      Form.CheckBox18.Checked);

    Form.CheckBox17.Checked := False;
    Form.CheckBox18.Checked := True;
    Form.CheckBox18Click(nil);
    AssertFalse('With CheckBox17 disabled, CheckBox18 is cleared.',
      Form.CheckBox18.Checked);
  finally
    Form.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit24RadioPresets);

end.
