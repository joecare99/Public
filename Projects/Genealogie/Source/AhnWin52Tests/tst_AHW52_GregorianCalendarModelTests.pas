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
    procedure TestCaseYearBounds;
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

procedure TTestAHW52GregorianCalendarModel.TestCaseYearBounds;
begin
    VerifyYearBounds;
end;

procedure TTestAHW52GregorianCalendarModel.TestCaseViewModelContract;
begin
    VerifyViewModelContract;
end;

initialization
  RegisterTest(TTestAHW52GregorianCalendarModel);

end.
