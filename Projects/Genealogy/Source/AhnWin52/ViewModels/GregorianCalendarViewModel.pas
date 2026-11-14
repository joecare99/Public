unit GregorianCalendarViewModel;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  GregorianCalendarModel, GregorianCalendarViewModelIntf;

type
  /// Adapts the calendar model's numeric cells to the strings consumed by the form.
  TGregorianCalendarViewModel = class(TInterfacedObject, IGregorianCalendarViewModel)
  private
    FYear: Longint;
    FCalendarGrids: TCalendarDayGrids;
  public
    /// Creates a ViewModel initialized to the current system year.
    constructor Create;
    /// Returns the year whose calendar is currently cached.
    function GetYear: Longint;
    /// Atomically replaces the cached calendar after validating and building Value.
    /// If model validation fails, the previous year and cells remain unchanged.
    /// <param name="Value">Supported Gregorian year to calculate and display.</param>
    /// <exception cref="EConvertError">Value is outside the supported range.</exception>
    procedure SetYear(const Value: Longint);
    /// Returns the German two-letter weekday label for Row.
    /// <param name="Row">Zero-based weekday row, Sunday through Saturday.</param>
    /// <exception cref="ERangeError">Row is outside 0..6.</exception>
    function GetWeekdayLabel(const Row: Integer): string;
    /// Formats a day cell as decimal text, or returns an empty string for a blank cell.
    /// <param name="GridIndex">Zero-based four-month panel index.</param>
    /// <param name="Column">Zero-based calendar-grid column.</param>
    /// <param name="Row">Zero-based weekday row.</param>
    /// <exception cref="ERangeError">A panel, column, or row index is invalid.</exception>
    function GetDayCellText(const GridIndex, Column, Row: Integer): string;
  end;

implementation

uses
  SysUtils;

const
  WeekdayLabels: array[0..CalendarRowCount - 1] of string =
    ('So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa');

constructor TGregorianCalendarViewModel.Create;
var
  currentYear, currentMonth, currentDay: Word;
begin
  inherited Create;
  DecodeDate(Date, currentYear, currentMonth, currentDay);
  SetYear(currentYear);
end;

function TGregorianCalendarViewModel.GetYear: Longint;
begin
  Result := FYear;
end;

procedure TGregorianCalendarViewModel.SetYear(const Value: Longint);
var
  calendarGrids: TCalendarDayGrids;
begin
  BuildCalendarGrids(Value, calendarGrids);
  FCalendarGrids := calendarGrids;
  FYear := Value;
end;

function TGregorianCalendarViewModel.GetWeekdayLabel(const Row: Integer): string;
begin
  if (Row < Low(WeekdayLabels)) or (Row > High(WeekdayLabels)) then
    raise ERangeError.CreateFmt('Weekday row %d is outside the calendar grid.', [Row]);
  Result := WeekdayLabels[Row];
end;

function TGregorianCalendarViewModel.GetDayCellText(const GridIndex, Column,
  Row: Integer): string;
var
  day: Word;
begin
  if (GridIndex < Low(FCalendarGrids)) or (GridIndex > High(FCalendarGrids)) then
    raise ERangeError.CreateFmt('Calendar grid index %d is invalid.', [GridIndex]);
  if (Column < Low(FCalendarGrids[GridIndex])) or
    (Column > High(FCalendarGrids[GridIndex])) then
    raise ERangeError.CreateFmt('Calendar column %d is invalid.', [Column]);
  if (Row < Low(FCalendarGrids[GridIndex][Column])) or
    (Row > High(FCalendarGrids[GridIndex][Column])) then
    raise ERangeError.CreateFmt('Calendar row %d is invalid.', [Row]);

  day := FCalendarGrids[GridIndex][Column][Row];
  if day = 0 then
    Result := ''
  else
    Result := IntToStr(day);
end;

end.
