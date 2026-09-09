unit testcalendarviewmodel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DateUtils, fpcunit, testregistry, CalendarViewModel,
  Services;

type
  TFixedClockService = class(TInterfacedObject, IClockService)
  private
    FValue: TDateTime;
  public
    constructor Create(const AValue: TDateTime);
    function Now: TDateTime;
  end;

  TCalendarViewModelTest = class(TTestCase)
  published
    procedure SelectsTheClockDateWithoutItsTime;
    procedure SelectDateRemovesTheTimePart;
    procedure CaptionsUseTheSelectedDate;
  end;

implementation

constructor TFixedClockService.Create(const AValue: TDateTime);
begin
  FValue := AValue;
end;

function TFixedClockService.Now: TDateTime;
begin
  Result := FValue;
end;

procedure TCalendarViewModelTest.SelectsTheClockDateWithoutItsTime;
var
  Clock: IClockService;
  ViewModel: TCalendarViewModel;
  ClockValue: TDateTime;
begin
  ClockValue := EncodeDateTime(2026, 9, 6, 12, 51, 7, 700);
  Clock := TFixedClockService.Create(ClockValue);
  ViewModel := TCalendarViewModel.Create(Clock);
  try
    AssertEquals(DateOf(ClockValue), ViewModel.SelectedDate, 0);
  finally
    ViewModel.Free;
  end;
end;

procedure TCalendarViewModelTest.SelectDateRemovesTheTimePart;
var
  Clock: IClockService;
  ViewModel: TCalendarViewModel;
  Selected: TDateTime;
begin
  Clock := TFixedClockService.Create(EncodeDate(2026, 1, 1));
  ViewModel := TCalendarViewModel.Create(Clock);
  try
    Selected := EncodeDateTime(2030, 12, 24, 18, 30, 45, 123);
    ViewModel.SelectDate(Selected);
    AssertEquals(DateOf(Selected), ViewModel.SelectedDate, 0);
  finally
    ViewModel.Free;
  end;
end;

procedure TCalendarViewModelTest.CaptionsUseTheSelectedDate;
var
  Clock: IClockService;
  ViewModel: TCalendarViewModel;
  Selected: TDateTime;
begin
  Clock := TFixedClockService.Create(EncodeDate(2026, 1, 1));
  ViewModel := TCalendarViewModel.Create(Clock);
  try
    Selected := EncodeDate(2030, 12, 24);
    ViewModel.SelectDate(Selected);

    AssertEquals(FormatDateTime('mmmm yyyy', Selected),
      ViewModel.MonthCaption);
    AssertEquals(FormatDateTime('dddd, dd. mmmm yyyy', Selected),
      ViewModel.SelectedDateCaption);
  finally
    ViewModel.Free;
  end;
end;

initialization
  RegisterTest(TCalendarViewModelTest);

end.
