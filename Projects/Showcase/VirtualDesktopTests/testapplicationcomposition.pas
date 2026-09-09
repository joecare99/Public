unit testapplicationcomposition;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DateUtils, fpcunit, testregistry, Services,
  CalculatorViewModel, CalendarViewModel, NotepadViewModel,
  AlarmClockViewModel;

type
  TCompositionClock = class(TInterfacedObject, IClockService)
  private
    FValue: TDateTime;
  public
    constructor Create(const AValue: TDateTime);
    function Now: TDateTime;
  end;

  TCompositionNoteStorage = class(TInterfacedObject, INoteStorage)
  private
    FText: string;
  public
    constructor Create(const AText: string);
    function LoadText: string;
    procedure SaveText(const AText: string);
    property Text: string read FText;
  end;

  TExistingApplicationCompositionTest = class(TTestCase)
  published
    procedure ComposesCalculatorCalendarNotepadAndAlarm;
    procedure KeepsComposedApplicationStateIndependent;
  end;

implementation

constructor TCompositionClock.Create(const AValue: TDateTime);
begin
  FValue := AValue;
end;

function TCompositionClock.Now: TDateTime;
begin
  Result := FValue;
end;

constructor TCompositionNoteStorage.Create(const AText: string);
begin
  FText := AText;
end;

function TCompositionNoteStorage.LoadText: string;
begin
  Result := FText;
end;

procedure TCompositionNoteStorage.SaveText(const AText: string);
begin
  FText := AText;
end;

procedure TExistingApplicationCompositionTest.ComposesCalculatorCalendarNotepadAndAlarm;
var
  Clock: IClockService;
  Storage: INoteStorage;
  Calculator: TCalculatorViewModel;
  Calendar: TCalendarViewModel;
  Notepad: TNotepadViewModel;
  Alarm: TAlarmClockViewModel;
  ClockValue: TDateTime;
begin
  ClockValue := EncodeDateTime(2026, 9, 6, 13, 5, 2, 399);
  Clock := TCompositionClock.Create(ClockValue);
  Storage := TCompositionNoteStorage.Create('Existing note');
  Calculator := TCalculatorViewModel.Create;
  Calendar := TCalendarViewModel.Create(Clock);
  Notepad := TNotepadViewModel.Create(Storage);
  Alarm := TAlarmClockViewModel.Create(Clock);
  try
    AssertEquals('0', Calculator.Display);
    AssertEquals(DateOf(ClockValue), Calendar.SelectedDate, 0);
    AssertEquals('Existing note', Notepad.Text);
    AssertFalse(Notepad.Dirty);
    AssertEquals('13:05:02', Alarm.CurrentTimeCaption);
    AssertEquals('07:30', Alarm.AlarmCaption);
    AssertFalse(Alarm.Enabled);
  finally
    Alarm.Free;
    Notepad.Free;
    Calendar.Free;
    Calculator.Free;
  end;
end;

procedure TExistingApplicationCompositionTest.KeepsComposedApplicationStateIndependent;
var
  Clock: IClockService;
  StorageObject: TCompositionNoteStorage;
  Storage: INoteStorage;
  Calculator: TCalculatorViewModel;
  Calendar: TCalendarViewModel;
  Notepad: TNotepadViewModel;
  Alarm: TAlarmClockViewModel;
  SelectedDate: TDateTime;
begin
  Clock := TCompositionClock.Create(EncodeDateTime(2026, 9, 6, 13, 5, 2, 0));
  StorageObject := TCompositionNoteStorage.Create('Before');
  Storage := StorageObject;
  Calculator := TCalculatorViewModel.Create;
  Calendar := TCalendarViewModel.Create(Clock);
  Notepad := TNotepadViewModel.Create(Storage);
  Alarm := TAlarmClockViewModel.Create(Clock);
  try
    Calculator.PressDigit('2');
    Calculator.PressOperator('+');
    Calculator.PressDigit('3');
    Calculator.PressEquals;

    SelectedDate := EncodeDateTime(2030, 12, 24, 18, 30, 45, 123);
    Calendar.SelectDate(SelectedDate);
    Notepad.UpdateText('After');
    Notepad.Save;
    Alarm.SetAlarm(EncodeDateTime(2030, 12, 24, 21, 5, 10, 0));
    Alarm.Toggle;

    AssertEquals('5', Calculator.Display);
    AssertEquals(DateOf(SelectedDate), Calendar.SelectedDate, 0);
    AssertEquals('After', StorageObject.Text);
    AssertFalse(Notepad.Dirty);
    AssertEquals('21:05', Alarm.AlarmCaption);
    AssertTrue(Alarm.Enabled);

    AssertEquals('13:05:02', Alarm.CurrentTimeCaption);
    AssertEquals(FormatDateTime('mmmm yyyy', SelectedDate),
      Calendar.MonthCaption);
  finally
    Alarm.Free;
    Notepad.Free;
    Calendar.Free;
    Calculator.Free;
  end;
end;

initialization
  RegisterTest(TExistingApplicationCompositionTest);

end.
