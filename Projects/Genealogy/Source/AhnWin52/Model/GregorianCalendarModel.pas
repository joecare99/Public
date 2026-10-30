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
  /// Number of weekly dates emitted by the legacy Unit10 Easter calendar loop.
  LiturgicalSundayCount = 13;
  /// First year accepted by the calendar form and model.
  CalendarFirstSupportedYear = 1582;
  /// Last year accepted by the calendar form and model.
  CalendarLastSupportedYear = 2499;

type
  /// Day-number cells for one four-month panel; zero represents an empty cell.
  TCalendarDayGrid = array[0..CalendarColumnCount - 1, 0..CalendarRowCount - 1] of Word;
  /// The three panels covering all twelve months of one Gregorian year.
  TCalendarDayGrids = array[0..CalendarGridCount - 1] of TCalendarDayGrid;
  /// Weekly dates emitted by the legacy Unit10 loop, from Easter - 63 through Easter + 21.
  TLiturgicalSundayDates = array[0..LiturgicalSundayCount - 1] of TDateTime;

/// Builds the three date panels using the calendar form's recovered spacing.
/// <param name="Year">Gregorian year to render; must be within the supported range.</param>
/// <param name="Grids">Receives day numbers indexed by panel, column, and weekday row.</param>
/// <exception cref="EConvertError">Year is outside the supported range.</exception>
/// <exception cref="ERangeError">The recovered layout cannot fit a day into 28 columns.</exception>
procedure BuildCalendarGrids(const Year: Longint; out Grids: TCalendarDayGrids);

/// Computes Gregorian Easter using the integer computus recovered from Unit10.rechnen.
/// <param name="Year">Gregorian year to calculate; must be within the supported range.</param>
/// <exception cref="EConvertError">Year is outside the supported range.</exception>
function CalculateGregorianEasterDate(const Year: Longint): TDateTime;

/// Builds the 13 weekly dates emitted by Unit10.rechnen, starting 63 days before Easter.
function BuildLiturgicalSundayDates(const EasterDate: TDateTime): TLiturgicalSundayDates;

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

function CalculateGregorianEasterDate(const Year: Longint): TDateTime;
var
  century, yearCycle400, lunarCorrection, weekdayCorrection: Integer;
  goldenNumber, yearRemainder4, yearRemainder7, epact, easterOffset: Integer;
begin
  if (Year < CalendarFirstSupportedYear) or (Year > CalendarLastSupportedYear) then
    raise EConvertError.CreateFmt(
      'Easter year must be between %d and %d.',
      [CalendarFirstSupportedYear, CalendarLastSupportedYear]);

  goldenNumber := Year mod 19;
  yearRemainder4 := Year mod 4;
  yearRemainder7 := Year mod 7;
  century := Year div 100;
  yearCycle400 := Year div 400;
  lunarCorrection := ((8 * century + 13) div 25) - 2;
  epact := (19 * goldenNumber +
    ((century - yearCycle400 - 2 + 15) - lunarCorrection)) mod 30;
  weekdayCorrection := (century - yearCycle400 - 2 + 6) mod 7;

  if epact = 29 then
    epact := 28
  else if (epact = 28) and (goldenNumber >= 11) then
    epact := 27;

  easterOffset := (2 * yearRemainder4 + 4 * yearRemainder7 +
    6 * epact + weekdayCorrection) mod 7;
  Result := EncodeDate(Year, 3, 21) + epact + easterOffset + 1;
end;

function BuildLiturgicalSundayDates(const EasterDate: TDateTime): TLiturgicalSundayDates;
var
  index: Integer;
begin
  Result[Low(Result)] := EasterDate - 63;
  for index := Low(Result) + 1 to High(Result) do
    Result[index] := Result[index - 1] + 7;
end;

end.
