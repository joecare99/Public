unit GregorianCalendarModel;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

const
  /// Number of monthly calendar panels in the legacy view.
  CalendarGridCount = 3;
  /// Number of horizontal week positions, including the weekday-label column.
  CalendarColumnCount = 28;
  /// Number of weekday rows, ordered Sunday through Saturday.
  CalendarRowCount = 7;
  /// First year accepted by the calendar form and model.
  CalendarFirstSupportedYear = 1582;
  /// Last year accepted by the calendar form and model.
  CalendarLastSupportedYear = 2499;

type
  /// Day-number cells for one four-month panel; zero represents an empty cell.
  TCalendarDayGrid = array[0..CalendarColumnCount - 1, 0..CalendarRowCount - 1] of Word;
  /// The three panels covering all twelve months of one Gregorian year.
  TCalendarDayGrids = array[0..CalendarGridCount - 1] of TCalendarDayGrid;

/// Builds the three date panels using the calendar form's recovered spacing.
/// <param name="Year">Gregorian year to render; must be within the supported range.</param>
/// <param name="Grids">Receives day numbers indexed by panel, column, and weekday row.</param>
/// <exception cref="EConvertError">Year is outside the supported range.</exception>
/// <exception cref="ERangeError">The recovered layout cannot fit a day into 28 columns.</exception>
procedure BuildCalendarGrids(const Year: Longint; out Grids: TCalendarDayGrids);

implementation

uses
  DateUtils;

procedure BuildCalendarGrids(const Year: Longint; out Grids: TCalendarDayGrids);
var
  column, day, gridIndex, month, monthDayCount, row, weekColumn, weekday: Integer;
begin
  if (Year < CalendarFirstSupportedYear) or (Year > CalendarLastSupportedYear) then
    raise EConvertError.CreateFmt(
      'Calendar year must be between %d and %d.',
      [CalendarFirstSupportedYear, CalendarLastSupportedYear]);

  for gridIndex := Low(Grids) to High(Grids) do
    for column := Low(Grids[gridIndex]) to High(Grids[gridIndex]) do
      for row := Low(Grids[gridIndex][column]) to High(Grids[gridIndex][column]) do
        Grids[gridIndex][column][row] := 0;

  weekColumn := 1;
  for month := 1 to 12 do
  begin
    if (month = 5) or (month = 9) then
      weekColumn := 1;
    Inc(weekColumn, 2);
    gridIndex := (month - 1) div 4;
    monthDayCount := DaysInAMonth(Year, month);

    for day := 1 to monthDayCount do
    begin
      weekday := DayOfWeek(EncodeDate(Year, month, day)) - 1;
      if weekColumn >= CalendarColumnCount then
        raise ERangeError.CreateFmt(
          'Calendar year %d exceeds the %d-column grid.',
          [Year, CalendarColumnCount]);

      Grids[gridIndex][weekColumn][weekday] := day;
      if weekday = 6 then
        Inc(weekColumn);
    end;
  end;
end;

end.
