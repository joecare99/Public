unit tst_AHW52_RevolutionCalendarFormTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52RevolutionCalendarForm = class(TTestCase)
  private
    FCloseEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
  published
    procedure TestFormCreateScalesForLargeScreen;
    procedure TestEmptyCalendarComboChangesPreserveOutput;
    procedure TestBerechnenConvertsOrdinaryDate;
    procedure TestBerechnenMapsAllMonthStarts;
    procedure TestBerechnenConvertsLeapComplementaryDay;
    procedure TestBerechnenAllowsLastDateBeforeCalendarCutoff;
    procedure TestBerechnenClearsDatesAfterCalendarCutoff;
    procedure TestBerechnenPreservesOutputWhenInputIsEmpty;
    procedure TestFinishButtonClosesForm;
    procedure TestUnboundButtonHandlerClosesReceiver;
    procedure TestEscapeClosesForm;
    procedure TestOtherKeyDoesNotCloseForm;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Classes, StdCtrls, SysUtils, Unit7;

var
  CalendarMessageBoxCount: Integer;
  CalendarMessageText: string;
  CalendarMessageCaption: string;

function SuppressCalendarMessageBox(Text, Caption: PChar;
  Flags: Longint): Integer;
begin
  Inc(CalendarMessageBoxCount);
  CalendarMessageText := StrPas(Text);
  CalendarMessageCaption := StrPas(Caption);
  Result := 1;
end;

procedure PrepareCalendarInputs(calendarForm: TForm7);
const
  RepublicanYears: array[0..13] of string = (
    ' I', ' II', ' III', ' IV', ' V', ' VI', ' VII',
    ' VIII', ' IX', ' X', ' XI', ' XII', ' XIII', ' XIV');
var
  index: Integer;
begin
  calendarForm.ComboBox1 := TComboBox.Create(calendarForm);
  calendarForm.ComboBox1.Parent := calendarForm;
  for index := 1 to 30 do
    calendarForm.ComboBox1.Items.Add(Format('%2d', [index]));
  for index := 1 to 5 do
    calendarForm.ComboBox1.Items.Add('jc ' + IntToStr(index));
  calendarForm.ComboBox1.Items.Add('jrev');

  calendarForm.ComboBox2 := TComboBox.Create(calendarForm);
  calendarForm.ComboBox2.Parent := calendarForm;
  for index := 0 to 11 do
    case index of
      1: calendarForm.ComboBox2.Items.Add('Brumaire');
      2: calendarForm.ComboBox2.Items.Add('Frimaire');
      11: calendarForm.ComboBox2.Items.Add('Fructidor');
    else
      calendarForm.ComboBox2.Items.Add('Month ' + IntToStr(index));
    end;

  calendarForm.ComboBox3 := TComboBox.Create(calendarForm);
  calendarForm.ComboBox3.Parent := calendarForm;
  for index := 0 to 13 do
    calendarForm.ComboBox3.Items.Add(RepublicanYears[index]);

  calendarForm.Edit1 := TEdit.Create(calendarForm);
  calendarForm.Edit1.Parent := calendarForm;
end;

procedure TTestAHW52RevolutionCalendarForm.
  TestFormCreateScalesForLargeScreen;
var
  calendarForm: TForm7;
  screenWidth: Integer;
  screenHeight: Integer;
begin
  Application.Initialize;
  screenWidth := Screen.Width;
  screenHeight := Screen.Height;
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.SetBounds(0, 0, 640, 480);
    calendarForm.FormCreate(calendarForm);

    if (screenWidth > 640) and (screenHeight > 480) then
      AssertEquals('Large screens scale the calendar to screen width.',
        screenWidth, calendarForm.Width)
    else
      AssertEquals('Smaller screens retain the original form width.',
        640, calendarForm.Width);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestBerechnenConvertsOrdinaryDate;
var
  calendarForm: TForm7;
  previousFormatSettings: TFormatSettings;
  previousMessageBoxFunction: TMessageBoxFunction;
begin
  Application.Initialize;
  previousFormatSettings := DefaultFormatSettings;
  previousMessageBoxFunction := MessageBoxFunction;
  MessageBoxFunction := @SuppressCalendarMessageBox;
  CalendarMessageBoxCount := 0;
  DefaultFormatSettings.ShortDateFormat := 'dd.mm.yyyy';
  DefaultFormatSettings.DateSeparator := '.';
  calendarForm := TForm7.CreateNew(nil);
  try
    PrepareCalendarInputs(calendarForm);
    calendarForm.ComboBox1.ItemIndex := 0;
    calendarForm.ComboBox2.ItemIndex := 1;
    calendarForm.ComboBox3.ItemIndex := 1;

    calendarForm.berechnen;

    AssertEquals('23.10.1793', calendarForm.Edit1.Text);
    AssertEquals(0, CalendarMessageBoxCount);
  finally
    MessageBoxFunction := previousMessageBoxFunction;
    calendarForm.Free;
    DefaultFormatSettings := previousFormatSettings;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestBerechnenMapsAllMonthStarts;
const
  ExpectedDates: array[0..11] of string = (
    '23.09.1793', '23.10.1793', '22.11.1793', '22.12.1793',
    '21.01.1794', '20.02.1794', '22.03.1794', '21.04.1794',
    '21.05.1794', '20.06.1794', '20.07.1794', '19.08.1794');
var
  calendarForm: TForm7;
  previousFormatSettings: TFormatSettings;
  previousMessageBoxFunction: TMessageBoxFunction;
  monthIndex: Integer;
begin
  Application.Initialize;
  previousFormatSettings := DefaultFormatSettings;
  previousMessageBoxFunction := MessageBoxFunction;
  MessageBoxFunction := @SuppressCalendarMessageBox;
  CalendarMessageBoxCount := 0;
  DefaultFormatSettings.ShortDateFormat := 'dd.mm.yyyy';
  DefaultFormatSettings.DateSeparator := '.';
  calendarForm := TForm7.CreateNew(nil);
  try
    PrepareCalendarInputs(calendarForm);
    calendarForm.ComboBox1.ItemIndex := 0;
    calendarForm.ComboBox3.ItemIndex := 1;

    for monthIndex := 0 to 11 do
    begin
      calendarForm.ComboBox2.ItemIndex := monthIndex;
      calendarForm.berechnen;
      AssertEquals('Unexpected start date for month index ' +
        IntToStr(monthIndex), ExpectedDates[monthIndex],
        calendarForm.Edit1.Text);
    end;
    AssertEquals(0, CalendarMessageBoxCount);
  finally
    MessageBoxFunction := previousMessageBoxFunction;
    calendarForm.Free;
    DefaultFormatSettings := previousFormatSettings;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.
  TestBerechnenConvertsLeapComplementaryDay;
var
  calendarForm: TForm7;
  previousFormatSettings: TFormatSettings;
  previousMessageBoxFunction: TMessageBoxFunction;
  yearIndex: Integer;
  expectedDates: array[2..10] of string;
begin
  Application.Initialize;
  previousFormatSettings := DefaultFormatSettings;
  previousMessageBoxFunction := MessageBoxFunction;
  MessageBoxFunction := @SuppressCalendarMessageBox;
  CalendarMessageBoxCount := 0;
  DefaultFormatSettings.ShortDateFormat := 'dd.mm.yyyy';
  DefaultFormatSettings.DateSeparator := '.';
  calendarForm := TForm7.CreateNew(nil);
  try
    PrepareCalendarInputs(calendarForm);
    calendarForm.ComboBox1.ItemIndex := 30;
    calendarForm.ComboBox2.ItemIndex := 11;
    expectedDates[2] := '18.09.1795';
    expectedDates[6] := '18.09.1799';
    expectedDates[10] := '19.09.1803';
    CalendarMessageText := '';
    CalendarMessageCaption := '';
    for yearIndex := 2 to 10 do
      if yearIndex in [2, 6, 10] then
      begin
        calendarForm.ComboBox3.ItemIndex := yearIndex;
        calendarForm.berechnen;
        AssertEquals('Unexpected complementary date for year index ' +
          IntToStr(yearIndex), expectedDates[yearIndex],
          calendarForm.Edit1.Text);

        calendarForm.ComboBox1.ItemIndex := 35;
        case yearIndex of
          2: expectedDates[yearIndex] := '23.09.1795';
          6: expectedDates[yearIndex] := '23.09.1799';
          10: expectedDates[yearIndex] := '24.09.1803';
        end;
        calendarForm.berechnen;
        AssertEquals('Unexpected jrev date for year index ' +
          IntToStr(yearIndex), expectedDates[yearIndex],
          calendarForm.Edit1.Text);
        calendarForm.ComboBox1.ItemIndex := 30;
      end;
    AssertEquals(0, CalendarMessageBoxCount);
  finally
    MessageBoxFunction := previousMessageBoxFunction;
    calendarForm.Free;
    DefaultFormatSettings := previousFormatSettings;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.
  TestBerechnenAllowsLastDateBeforeCalendarCutoff;
var
  calendarForm: TForm7;
  previousFormatSettings: TFormatSettings;
  previousMessageBoxFunction: TMessageBoxFunction;
begin
  Application.Initialize;
  previousFormatSettings := DefaultFormatSettings;
  previousMessageBoxFunction := MessageBoxFunction;
  MessageBoxFunction := @SuppressCalendarMessageBox;
  CalendarMessageBoxCount := 0;
  DefaultFormatSettings.ShortDateFormat := 'dd.mm.yyyy';
  DefaultFormatSettings.DateSeparator := '.';
  calendarForm := TForm7.CreateNew(nil);
  try
    PrepareCalendarInputs(calendarForm);
    calendarForm.ComboBox1.ItemIndex := 29;
    calendarForm.ComboBox2.ItemIndex := 2;
    calendarForm.ComboBox3.ItemIndex := 13;

    calendarForm.berechnen;

    AssertEquals('22.12.1805', calendarForm.Edit1.Text);
    AssertEquals(0, CalendarMessageBoxCount);
  finally
    MessageBoxFunction := previousMessageBoxFunction;
    calendarForm.Free;
    DefaultFormatSettings := previousFormatSettings;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.
  TestBerechnenClearsDatesAfterCalendarCutoff;
var
  calendarForm: TForm7;
  previousFormatSettings: TFormatSettings;
  previousMessageBoxFunction: TMessageBoxFunction;
begin
  Application.Initialize;
  previousFormatSettings := DefaultFormatSettings;
  previousMessageBoxFunction := MessageBoxFunction;
  MessageBoxFunction := @SuppressCalendarMessageBox;
  CalendarMessageBoxCount := 0;
  CalendarMessageText := '';
  CalendarMessageCaption := '';
  DefaultFormatSettings.ShortDateFormat := 'dd.mm.yyyy';
  DefaultFormatSettings.DateSeparator := '.';
  calendarForm := TForm7.CreateNew(nil);
  try
    PrepareCalendarInputs(calendarForm);
    calendarForm.ComboBox1.ItemIndex := 0;
    calendarForm.ComboBox2.ItemIndex := 4;
    calendarForm.ComboBox3.ItemIndex := 13;
    calendarForm.Edit1.Text := 'Previous date';

    calendarForm.berechnen;

    AssertEquals('', calendarForm.Edit1.Text);
    AssertEquals(1, CalendarMessageBoxCount);
    AssertEquals('Der Revolutionskalender endete am 31.12.1805.',
      CalendarMessageText);
    AssertEquals('Aus war''s ...', CalendarMessageCaption);
  finally
    MessageBoxFunction := previousMessageBoxFunction;
    calendarForm.Free;
    DefaultFormatSettings := previousFormatSettings;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.
  TestBerechnenPreservesOutputWhenInputIsEmpty;
var
  calendarForm: TForm7;
begin
  calendarForm := TForm7.CreateNew(nil);
  try
    PrepareCalendarInputs(calendarForm);
    calendarForm.Edit1.Text := 'Existing synthetic output';

    calendarForm.berechnen;

    AssertEquals('Existing synthetic output', calendarForm.Edit1.Text);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.
  TestEmptyCalendarComboChangesPreserveOutput;
var
  calendarForm: TForm7;
begin
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.ComboBox1 := TComboBox.Create(calendarForm);
    calendarForm.ComboBox2 := TComboBox.Create(calendarForm);
    calendarForm.ComboBox3 := TComboBox.Create(calendarForm);
    calendarForm.Edit1 := TEdit.Create(calendarForm);
    calendarForm.Edit1.Text := 'Existing synthetic output';

    calendarForm.ComboBox1Change(calendarForm.ComboBox1);
    calendarForm.ComboBox2Change(calendarForm.ComboBox2);
    calendarForm.ComboBox3Change(calendarForm.ComboBox3);

    AssertEquals('Existing synthetic output', calendarForm.Edit1.Text);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52RevolutionCalendarForm.TestFinishButtonClosesForm;
var
  calendarForm: TForm7;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  calendarForm := TForm7.CreateNew(nil);
  Unit7.Form7 := calendarForm;
  try
    calendarForm.OnClose := @RecordFormClose;
    calendarForm.BitBtn1Click(calendarForm.BitBtn1);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit7.Form7 := nil;
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.
  TestUnboundButtonHandlerClosesReceiver;
var
  calendarForm: TForm7;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.OnClose := @RecordFormClose;
    calendarForm.Button1Click(nil);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestEscapeClosesForm;
var
  calendarForm: TForm7;
  key: Word;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.OnClose := @RecordFormClose;
    key := $1B;
    calendarForm.FormKeyDown(calendarForm, key, []);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestOtherKeyDoesNotCloseForm;
var
  calendarForm: TForm7;
  key: Word;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  calendarForm := TForm7.CreateNew(nil);
  try
    calendarForm.OnClose := @RecordFormClose;
    key := $41;
    calendarForm.FormKeyDown(calendarForm, key, []);

    if FCloseEventCount <> 0 then
      raise Exception.CreateFmt('Expected no close event, got %d.',
        [FCloseEventCount]);
  finally
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestUnboundCounterIncrement;
var
  calendarForm: TForm7;
begin
  calendarForm := TForm7.CreateNew(nil);
  try
    GlobalVar_025358F4 := 41;
    calendarForm._PROC_005CF32C(calendarForm);
    AssertEquals('Increment callback should add one.', 42,
      GlobalVar_025358F4);
  finally
    GlobalVar_025358F4 := 0;
    calendarForm.Free;
  end;
end;

procedure TTestAHW52RevolutionCalendarForm.TestUnboundCounterDecrement;
var
  calendarForm: TForm7;
begin
  calendarForm := TForm7.CreateNew(nil);
  try
    GlobalVar_025358F4 := 41;
    calendarForm._PROC_005CF35C(calendarForm);
    AssertEquals('Decrement callback should subtract one.', 40,
      GlobalVar_025358F4);
  finally
    GlobalVar_025358F4 := 0;
    calendarForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52RevolutionCalendarForm);

end.
