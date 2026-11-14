unit tst_AHW52_Unit18ComboBoxExitTests;

{$mode objfpc}{$H+}

interface

uses
  Controls, Forms, fpcunit, StdCtrls, testregistry, Unit18;

type
  TTestAHW52Unit18ComboBoxExit = class(TTestCase)
  private
    function CreateUnstreamedForm: TForm18;
    procedure SetRelationshipValues(sourceForm: TForm18;
      const conditionText, dependentText: string);
    procedure ExecuteExitHandlers(sourceForm: TForm18);
    procedure AssertDependentValues(sourceForm: TForm18;
      const expectedText: string);
  published
    procedure TestLivingValueClearsAllDependentFields;
    procedure TestComparisonIsExactAndPreservesOtherValues;
    procedure TestFormCloseStoresEdit23TextInGlobalState;
    procedure TestSpeedButtonsClearOnlyTheirSearchRows;
    procedure TestFormShowDisablesSearchActionsAndFocusesFirstField;
    procedure TestButton5ClearsAllSearchCriteria;
  end;

implementation

uses
  SysUtils;

type
  TSearchInputControls = array[0..34] of TControl;

const
  SearchRowStarts: array[0..8] of Integer =
    (0, 3, 7, 11, 15, 19, 23, 27, 31);
  SearchRowEnds: array[0..8] of Integer =
    (2, 6, 10, 14, 18, 22, 26, 30, 34);

function GetSearchInputControls(sourceForm: TForm18): TSearchInputControls;
begin
  Result[0] := sourceForm.ComboBox1;
  Result[1] := sourceForm.ComboBox2;
  Result[2] := sourceForm.Edit1;
  Result[3] := sourceForm.ComboBox15;
  Result[4] := sourceForm.ComboBox3;
  Result[5] := sourceForm.ComboBox4;
  Result[6] := sourceForm.Edit2;
  Result[7] := sourceForm.ComboBox16;
  Result[8] := sourceForm.ComboBox5;
  Result[9] := sourceForm.ComboBox6;
  Result[10] := sourceForm.Edit3;
  Result[11] := sourceForm.ComboBox17;
  Result[12] := sourceForm.ComboBox7;
  Result[13] := sourceForm.ComboBox8;
  Result[14] := sourceForm.Edit4;
  Result[15] := sourceForm.ComboBox18;
  Result[16] := sourceForm.ComboBox9;
  Result[17] := sourceForm.ComboBox10;
  Result[18] := sourceForm.Edit5;
  Result[19] := sourceForm.ComboBox19;
  Result[20] := sourceForm.ComboBox11;
  Result[21] := sourceForm.ComboBox12;
  Result[22] := sourceForm.Edit6;
  Result[23] := sourceForm.ComboBox20;
  Result[24] := sourceForm.ComboBox13;
  Result[25] := sourceForm.ComboBox14;
  Result[26] := sourceForm.Edit7;
  Result[27] := sourceForm.ComboBox23;
  Result[28] := sourceForm.ComboBox22;
  Result[29] := sourceForm.ComboBox21;
  Result[30] := sourceForm.Edit8;
  Result[31] := sourceForm.ComboBox24;
  Result[32] := sourceForm.ComboBox25;
  Result[33] := sourceForm.ComboBox26;
  Result[34] := sourceForm.Edit9;
end;

procedure SetSearchInputText(control: TControl; const value: string);
begin
  if control is TComboBox then
    TComboBox(control).Text := value
  else if control is TEdit then
    TEdit(control).Text := value
  else
    raise Exception.Create('Unexpected search input control type.');
end;

function GetSearchInputText(control: TControl): string;
begin
  if control is TComboBox then
    Result := TComboBox(control).Text
  else if control is TEdit then
    Result := TEdit(control).Text
  else
    raise Exception.Create('Unexpected search input control type.');
end;

function TTestAHW52Unit18ComboBoxExit.CreateUnstreamedForm: TForm18;
begin
  Result := TForm18.CreateNew(nil);
  try
    Result.ComboBox1 := TComboBox.Create(Result);
    Result.ComboBox1.Parent := Result;
    Result.Button1 := TButton.Create(Result);
    Result.Button1.Parent := Result;
    Result.Button7 := TButton.Create(Result);
    Result.Button7.Parent := Result;
    Result.ComboBox2 := TComboBox.Create(Result);
    Result.ComboBox2.Parent := Result;
    Result.ComboBox3 := TComboBox.Create(Result);
    Result.ComboBox3.Parent := Result;
    Result.ComboBox4 := TComboBox.Create(Result);
    Result.ComboBox4.Parent := Result;
    Result.ComboBox5 := TComboBox.Create(Result);
    Result.ComboBox5.Parent := Result;
    Result.ComboBox6 := TComboBox.Create(Result);
    Result.ComboBox6.Parent := Result;
    Result.ComboBox7 := TComboBox.Create(Result);
    Result.ComboBox7.Parent := Result;
    Result.ComboBox8 := TComboBox.Create(Result);
    Result.ComboBox8.Parent := Result;
    Result.ComboBox9 := TComboBox.Create(Result);
    Result.ComboBox9.Parent := Result;
    Result.ComboBox10 := TComboBox.Create(Result);
    Result.ComboBox10.Parent := Result;
    Result.ComboBox11 := TComboBox.Create(Result);
    Result.ComboBox11.Parent := Result;
    Result.ComboBox12 := TComboBox.Create(Result);
    Result.ComboBox12.Parent := Result;
    Result.ComboBox13 := TComboBox.Create(Result);
    Result.ComboBox13.Parent := Result;
    Result.ComboBox14 := TComboBox.Create(Result);
    Result.ComboBox14.Parent := Result;
    Result.ComboBox15 := TComboBox.Create(Result);
    Result.ComboBox15.Parent := Result;
    Result.ComboBox16 := TComboBox.Create(Result);
    Result.ComboBox16.Parent := Result;
    Result.ComboBox17 := TComboBox.Create(Result);
    Result.ComboBox17.Parent := Result;
    Result.ComboBox18 := TComboBox.Create(Result);
    Result.ComboBox18.Parent := Result;
    Result.ComboBox19 := TComboBox.Create(Result);
    Result.ComboBox19.Parent := Result;
    Result.ComboBox20 := TComboBox.Create(Result);
    Result.ComboBox20.Parent := Result;
    Result.ComboBox21 := TComboBox.Create(Result);
    Result.ComboBox21.Parent := Result;
    Result.ComboBox22 := TComboBox.Create(Result);
    Result.ComboBox22.Parent := Result;
    Result.ComboBox23 := TComboBox.Create(Result);
    Result.ComboBox23.Parent := Result;
    Result.ComboBox24 := TComboBox.Create(Result);
    Result.ComboBox24.Parent := Result;
    Result.ComboBox25 := TComboBox.Create(Result);
    Result.ComboBox25.Parent := Result;
    Result.ComboBox26 := TComboBox.Create(Result);
    Result.ComboBox26.Parent := Result;

    Result.Edit1 := TEdit.Create(Result);
    Result.Edit1.Parent := Result;
    Result.Edit2 := TEdit.Create(Result);
    Result.Edit2.Parent := Result;
    Result.Edit3 := TEdit.Create(Result);
    Result.Edit3.Parent := Result;
    Result.Edit4 := TEdit.Create(Result);
    Result.Edit4.Parent := Result;
    Result.Edit5 := TEdit.Create(Result);
    Result.Edit5.Parent := Result;
    Result.Edit6 := TEdit.Create(Result);
    Result.Edit6.Parent := Result;
    Result.Edit7 := TEdit.Create(Result);
    Result.Edit7.Parent := Result;
    Result.Edit8 := TEdit.Create(Result);
    Result.Edit8.Parent := Result;
    Result.Edit9 := TEdit.Create(Result);
    Result.Edit9.Parent := Result;
    Result.Edit23 := TEdit.Create(Result);
    Result.Edit23.Parent := Result;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

procedure TTestAHW52Unit18ComboBoxExit.SetRelationshipValues(
  sourceForm: TForm18; const conditionText, dependentText: string);
begin
  sourceForm.ComboBox1.Text := conditionText;
  sourceForm.ComboBox3.Text := conditionText;
  sourceForm.ComboBox5.Text := conditionText;
  sourceForm.ComboBox7.Text := conditionText;
  sourceForm.ComboBox9.Text := conditionText;
  sourceForm.ComboBox11.Text := conditionText;
  sourceForm.ComboBox13.Text := conditionText;
  sourceForm.ComboBox22.Text := conditionText;
  sourceForm.ComboBox25.Text := conditionText;

  sourceForm.ComboBox2.Text := dependentText;
  sourceForm.ComboBox4.Text := dependentText;
  sourceForm.ComboBox6.Text := dependentText;
  sourceForm.ComboBox8.Text := dependentText;
  sourceForm.ComboBox10.Text := dependentText;
  sourceForm.ComboBox12.Text := dependentText;
  sourceForm.ComboBox14.Text := dependentText;
  sourceForm.ComboBox21.Text := dependentText;
  sourceForm.ComboBox26.Text := dependentText;
  sourceForm.Edit1.Text := dependentText;
  sourceForm.Edit2.Text := dependentText;
  sourceForm.Edit3.Text := dependentText;
  sourceForm.Edit4.Text := dependentText;
  sourceForm.Edit5.Text := dependentText;
  sourceForm.Edit6.Text := dependentText;
  sourceForm.Edit7.Text := dependentText;
  sourceForm.Edit8.Text := dependentText;
  sourceForm.Edit9.Text := dependentText;
end;

procedure TTestAHW52Unit18ComboBoxExit.ExecuteExitHandlers(
  sourceForm: TForm18);
begin
  sourceForm.ComboBox1Exit(sourceForm.ComboBox1);
  sourceForm.ComboBox3Exit(sourceForm.ComboBox3);
  sourceForm.ComboBox5Exit(sourceForm.ComboBox5);
  sourceForm.ComboBox7Exit(sourceForm.ComboBox7);
  sourceForm.ComboBox9Exit(sourceForm.ComboBox9);
  sourceForm.ComboBox11Exit(sourceForm.ComboBox11);
  sourceForm.ComboBox13Exit(sourceForm.ComboBox13);
  sourceForm.ComboBox22Exit(sourceForm.ComboBox22);
  sourceForm.ComboBox25Exit(sourceForm.ComboBox25);
end;

procedure TTestAHW52Unit18ComboBoxExit.AssertDependentValues(
  sourceForm: TForm18; const expectedText: string);
begin
  AssertEquals(expectedText, sourceForm.ComboBox2.Text);
  AssertEquals(expectedText, sourceForm.ComboBox4.Text);
  AssertEquals(expectedText, sourceForm.ComboBox6.Text);
  AssertEquals(expectedText, sourceForm.ComboBox8.Text);
  AssertEquals(expectedText, sourceForm.ComboBox10.Text);
  AssertEquals(expectedText, sourceForm.ComboBox12.Text);
  AssertEquals(expectedText, sourceForm.ComboBox14.Text);
  AssertEquals(expectedText, sourceForm.ComboBox21.Text);
  AssertEquals(expectedText, sourceForm.ComboBox26.Text);
  AssertEquals(expectedText, sourceForm.Edit1.Text);
  AssertEquals(expectedText, sourceForm.Edit2.Text);
  AssertEquals(expectedText, sourceForm.Edit3.Text);
  AssertEquals(expectedText, sourceForm.Edit4.Text);
  AssertEquals(expectedText, sourceForm.Edit5.Text);
  AssertEquals(expectedText, sourceForm.Edit6.Text);
  AssertEquals(expectedText, sourceForm.Edit7.Text);
  AssertEquals(expectedText, sourceForm.Edit8.Text);
  AssertEquals(expectedText, sourceForm.Edit9.Text);
end;

procedure TTestAHW52Unit18ComboBoxExit.
  TestLivingValueClearsAllDependentFields;
var
  sourceForm: TForm18;
begin
  sourceForm := CreateUnstreamedForm;
  try
    SetRelationshipValues(sourceForm, 'lebt', 'synthetic');
    ExecuteExitHandlers(sourceForm);
    AssertDependentValues(sourceForm, '');
  finally
    sourceForm.Free;
  end;
end;

procedure TTestAHW52Unit18ComboBoxExit.
  TestComparisonIsExactAndPreservesOtherValues;
var
  sourceForm: TForm18;
begin
  sourceForm := CreateUnstreamedForm;
  try
    SetRelationshipValues(sourceForm, 'LEBT', 'synthetic');
    ExecuteExitHandlers(sourceForm);
    AssertDependentValues(sourceForm, 'synthetic');
  finally
    sourceForm.Free;
  end;
end;

procedure TTestAHW52Unit18ComboBoxExit.
  TestFormCloseStoresEdit23TextInGlobalState;
var
  sourceForm: TForm18;
  previousValue: string;
begin
  previousValue := GlobalVar_0253593C;
  sourceForm := CreateUnstreamedForm;
  try
    sourceForm.Edit23.Text := 'synthetic close value';
    sourceForm.FormClose(sourceForm);
    AssertEquals('synthetic close value', GlobalVar_0253593C);
  finally
    GlobalVar_0253593C := previousValue;
    sourceForm.Free;
  end;
end;

procedure TTestAHW52Unit18ComboBoxExit.
  TestSpeedButtonsClearOnlyTheirSearchRows;
var
  sourceForm: TForm18;
  controls: TSearchInputControls;
  rowIndex: Integer;
  controlIndex: Integer;
  expectedText: string;
begin
  sourceForm := CreateUnstreamedForm;
  try
    controls := GetSearchInputControls(sourceForm);
    for rowIndex := 0 to High(SearchRowStarts) do
    begin
      for controlIndex := Low(controls) to High(controls) do
        SetSearchInputText(controls[controlIndex], 'synthetic');

      case rowIndex of
        0: sourceForm.SpeedButton2Click(nil);
        1: sourceForm.SpeedButton3Click(nil);
        2: sourceForm.SpeedButton4Click(nil);
        3: sourceForm.SpeedButton5Click(nil);
        4: sourceForm.SpeedButton6Click(nil);
        5: sourceForm.SpeedButton7Click(nil);
        6: sourceForm.SpeedButton8Click(nil);
        7: sourceForm.SpeedButton9Click(nil);
        8: sourceForm.SpeedButton10Click(nil);
      end;

      for controlIndex := Low(controls) to High(controls) do
      begin
        expectedText := 'synthetic';
        if (controlIndex >= SearchRowStarts[rowIndex]) and
          (controlIndex <= SearchRowEnds[rowIndex]) then
          expectedText := '';
        AssertEquals(
          'Unexpected text in search control ' + IntToStr(controlIndex),
          expectedText, GetSearchInputText(controls[controlIndex]));
      end;
    end;
  finally
    sourceForm.Free;
  end;
end;

procedure TTestAHW52Unit18ComboBoxExit.
  TestFormShowDisablesSearchActionsAndFocusesFirstField;
var
  sourceForm: TForm18;
begin
  sourceForm := CreateUnstreamedForm;
  try
    sourceForm.Button1.Enabled := True;
    sourceForm.Button7.Enabled := True;

    sourceForm.FormShow(nil);

    AssertFalse('The search action starts disabled.',
      sourceForm.Button1.Enabled);
    AssertFalse('The save action starts disabled.',
      sourceForm.Button7.Enabled);
    AssertTrue('The first field receives focus.',
      sourceForm.ActiveControl = sourceForm.ComboBox1);
  finally
    sourceForm.Free;
  end;
end;

procedure TTestAHW52Unit18ComboBoxExit.
  TestButton5ClearsAllSearchCriteria;
var
  sourceForm: TForm18;
  controls: TSearchInputControls;
  controlIndex: Integer;
begin
  sourceForm := CreateUnstreamedForm;
  try
    controls := GetSearchInputControls(sourceForm);
    for controlIndex := Low(controls) to High(controls) do
      SetSearchInputText(controls[controlIndex], 'synthetic');
    sourceForm.Edit23.Text := 'synthetic';

    sourceForm.Button5Click(nil);

    for controlIndex := Low(controls) to High(controls) do
      AssertEquals('Search control ' + IntToStr(controlIndex) + ' is cleared.',
        '', GetSearchInputText(controls[controlIndex]));
    AssertEquals('The saved-search input is cleared.', '', sourceForm.Edit23.Text);
    AssertTrue('The first search field receives focus.',
      sourceForm.ActiveControl = sourceForm.ComboBox1);
  finally
    sourceForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit18ComboBoxExit);

end.
