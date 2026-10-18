unit tst_AHW52_GregorianCalendarModelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52GregorianCalendarModel = class(TTestCase)
  published
    procedure TestCaseAllSupportedYears;
    procedure TestCaseKnownPlacements;
    procedure TestUnit6PanelStartsAcrossSupportedYears;
    procedure TestCaseYearBounds;
    procedure TestGregorianEasterKnownDates;
    procedure TestGregorianEasterAcrossSupportedRange;
    procedure TestGregorianEasterYearBounds;
    procedure TestLiturgicalSundaySequenceForKnownEaster;
    procedure TestLiturgicalSundaySequenceAcrossSupportedYears;
    procedure TestCaseViewModelContract;
  end;

implementation

uses
  SysUtils, DateUtils, GregorianCalendarModel,
  GregorianCalendarViewModelIntf, GregorianCalendarViewModel;

procedure AssertEqual(const Description: string; Expected, Actual: Longint);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected %d, got %d.',
      [Description, Expected, Actual]);
end;

procedure AssertText(const Description, Expected, Actual: string);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected "%s", got "%s".',
      [Description, Expected, Actual]);
end;

procedure AssertCalendarCell(const Description: string; const Grids: TCalendarDayGrids;
  GridIndex, Column, Row, ExpectedDay: Integer);
begin
  AssertEqual(Description, ExpectedDay, Grids[GridIndex][Column][Row]);
end;

procedure VerifyYear(Year: Integer);
var
  grids: TCalendarDayGrids;
  gridIndex, column, row, cellCount, expectedCount: Integer;
begin
  BuildCalendarGrids(Year, grids);
  cellCount := 0;
  for gridIndex := Low(grids) to High(grids) do
    for column := Low(grids[gridIndex]) to High(grids[gridIndex]) do
      for row := Low(grids[gridIndex][column]) to High(grids[gridIndex][column]) do
        if grids[gridIndex][column][row] <> 0 then
          Inc(cellCount);

  if IsLeapYear(Year) then
    expectedCount := 366
  else
    expectedCount := 365;
  AssertEqual(Format('%d populated date cells', [Year]), expectedCount, cellCount);
  AssertCalendarCell(Format('%d grid clear origin', [Year]), grids, 0, 0, 0, 0);
end;

procedure VerifyKnownPlacements;
var
  grids: TCalendarDayGrids;
begin
  BuildCalendarGrids(1582, grids);
  AssertCalendarCell('1582-01-01', grids, 0, 3, 5, 1);

  BuildCalendarGrids(1900, grids);
  AssertCalendarCell('1900-01-01', grids, 0, 3, 1, 1);
  AssertCalendarCell('1900-02-01', grids, 0, 9, 4, 1);
  AssertCalendarCell('1900 non-leap February 29', grids, 0, 13, 4, 0);

  BuildCalendarGrids(2000, grids);
  AssertCalendarCell('2000-01-01', grids, 0, 3, 6, 1);
  AssertCalendarCell('2000-02-01', grids, 0, 10, 2, 1);
  AssertCalendarCell('2000-02-29', grids, 0, 14, 2, 29);

  BuildCalendarGrids(2499, grids);
  AssertCalendarCell('2499-01-01', grids, 0, 3, 4, 1);
end;

procedure VerifyYearBounds;
var
  grids: TCalendarDayGrids;
  rejected: Boolean;
begin
  rejected := False;
  try
    BuildCalendarGrids(CalendarFirstSupportedYear - 1, grids);
  except
    on EConvertError do
      rejected := True;
  end;
  if not rejected then
    raise Exception.Create('A year below the supported range was accepted.');

  rejected := False;
  try
    BuildCalendarGrids(CalendarLastSupportedYear + 1, grids);
  except
    on EConvertError do
      rejected := True;
  end;
  if not rejected then
    raise Exception.Create('A year above the supported range was accepted.');
end;

procedure VerifyViewModelContract;
var
  viewModel: IGregorianCalendarViewModel;
  rejected: Boolean;
begin
  viewModel := TGregorianCalendarViewModel.Create;
  viewModel.Year := 2000;
  AssertEqual('ViewModel year', 2000, viewModel.Year);
  AssertText('Sunday label', 'So', viewModel.GetWeekdayLabel(0));
  AssertText('Leap day text', '29', viewModel.GetDayCellText(0, 14, 2));
  AssertText('Blank cell text', '', viewModel.GetDayCellText(0, 1, 0));

  rejected := False;
  try
    viewModel.Year := 2500;
  except
    on EConvertError do
      rejected := True;
  end;
  if not rejected then
    raise Exception.Create('The view model accepted a year above the supported range.');
  AssertEqual('Year after rejected update', 2000, viewModel.Year);
  AssertText('Data after rejected update', '29', viewModel.GetDayCellText(0, 14, 2));
end;

var
  year: Integer;

procedure TTestAHW52GregorianCalendarModel.TestCaseAllSupportedYears;
var
  year: Integer;
begin
  for year := CalendarFirstSupportedYear to CalendarLastSupportedYear do
    VerifyYear(year);
end;

procedure TTestAHW52GregorianCalendarModel.TestCaseKnownPlacements;
begin
    VerifyKnownPlacements;
end;

procedure TTestAHW52GregorianCalendarModel.
  TestUnit6PanelStartsAcrossSupportedYears;
var
  year: Integer;
  grids: TCalendarDayGrids;
  firstOfMonth: TDateTime;
begin
  for year := CalendarFirstSupportedYear to CalendarLastSupportedYear do
  begin
    BuildCalendarGrids(year, grids);

    firstOfMonth := EncodeDate(year, 1, 1);
    AssertCalendarCell(Format('%d January panel start', [year]), grids,
      0, 3, DayOfWeek(firstOfMonth) - 1, 1);

    firstOfMonth := EncodeDate(year, 5, 1);
    AssertCalendarCell(Format('%d May panel start', [year]), grids,
      1, 3, DayOfWeek(firstOfMonth) - 1, 1);

    firstOfMonth := EncodeDate(year, 9, 1);
    AssertCalendarCell(Format('%d September panel start', [year]), grids,
      2, 3, DayOfWeek(firstOfMonth) - 1, 1);
  end;
end;

procedure TTestAHW52GregorianCalendarModel.TestCaseYearBounds;
begin
    VerifyYearBounds;
end;

procedure TTestAHW52GregorianCalendarModel.TestGregorianEasterKnownDates;
begin
  AssertEquals('1582 Gregorian reform year',
    EncodeDate(1582, 4, 18), CalculateGregorianEasterDate(1582));
  AssertEquals('1900 non-leap century',
    EncodeDate(1900, 4, 15), CalculateGregorianEasterDate(1900));
  AssertEquals('2000 leap century',
    EncodeDate(2000, 4, 23), CalculateGregorianEasterDate(2000));
  AssertEquals('2024',
    EncodeDate(2024, 3, 31), CalculateGregorianEasterDate(2024));
  AssertEquals('2100 non-leap century',
    EncodeDate(2100, 3, 28), CalculateGregorianEasterDate(2100));
  AssertEquals('2499 upper supported year',
    EncodeDate(2499, 3, 29), CalculateGregorianEasterDate(2499));
end;

procedure TTestAHW52GregorianCalendarModel.
  TestGregorianEasterAcrossSupportedRange;
var
  year: Integer;
  easterDate: TDateTime;
begin
  for year := CalendarFirstSupportedYear to CalendarLastSupportedYear do
  begin
    easterDate := CalculateGregorianEasterDate(year);
    AssertEquals(Format('%d Easter weekday', [year]), 1, DayOfWeek(easterDate));
    if (easterDate < EncodeDate(year, 3, 22)) or
      (easterDate > EncodeDate(year, 4, 25)) then
      raise Exception.CreateFmt('Easter date for %d is outside March 22-April 25.',
        [year]);
  end;
end;

procedure TTestAHW52GregorianCalendarModel.TestGregorianEasterYearBounds;
var
  rejected: Boolean;
begin
  rejected := False;
  try
    CalculateGregorianEasterDate(CalendarFirstSupportedYear - 1);
  except
    on EConvertError do
      rejected := True;
  end;
  if not rejected then
    raise Exception.Create('Easter calculator accepted a year below the supported range.');

  rejected := False;
  try
    CalculateGregorianEasterDate(CalendarLastSupportedYear + 1);
  except
    on EConvertError do
      rejected := True;
  end;
  if not rejected then
    raise Exception.Create('Easter calculator accepted a year above the supported range.');
end;

procedure TTestAHW52GregorianCalendarModel.
  TestLiturgicalSundaySequenceForKnownEaster;
var
  dates: TLiturgicalSundayDates;
  index: Integer;
begin
  dates := BuildLiturgicalSundayDates(EncodeDate(2024, 3, 31));
  AssertEquals('Sequence count', LiturgicalSundayCount, Length(dates));
  AssertEquals('First date is Easter minus 63 days',
    EncodeDate(2024, 1, 28), dates[Low(dates)]);
  AssertEquals('Easter is the tenth sequence date',
    EncodeDate(2024, 3, 31), dates[9]);
  AssertEquals('Last date is Easter plus 21 days',
    EncodeDate(2024, 4, 21), dates[High(dates)]);

  for index := Low(dates) to High(dates) do
    AssertEquals(Format('Sequence date %d is Sunday', [index]),
      1, DayOfWeek(dates[index]));
end;

procedure TTestAHW52GregorianCalendarModel.
  TestLiturgicalSundaySequenceAcrossSupportedYears;
var
  year, index: Integer;
  easterDate: TDateTime;
  dates: TLiturgicalSundayDates;
begin
  for year := CalendarFirstSupportedYear to CalendarLastSupportedYear do
  begin
    easterDate := CalculateGregorianEasterDate(year);
    dates := BuildLiturgicalSundayDates(easterDate);
    AssertEquals(Format('%d first date', [year]),
      easterDate - 63, dates[Low(dates)]);
    AssertEquals(Format('%d last date', [year]),
      easterDate + 21, dates[High(dates)]);
    for index := Low(dates) to High(dates) do
      AssertEquals(Format('%d sequence weekday %d', [year, index]),
        1, DayOfWeek(dates[index]));
    for index := Low(dates) + 1 to High(dates) do
    begin
      AssertEquals(Format('%d sequence interval %d', [year, index]),
        7, Trunc(dates[index] - dates[index - 1]));
    end;
  end;
end;

procedure TTestAHW52GregorianCalendarModel.TestCaseViewModelContract;
begin
    VerifyViewModelContract;
end;

initialization
  RegisterTest(TTestAHW52GregorianCalendarModel);

end.
