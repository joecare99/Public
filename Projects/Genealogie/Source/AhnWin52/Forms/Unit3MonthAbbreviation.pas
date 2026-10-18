unit Unit3MonthAbbreviation;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

function NormalizeUnit3MonthAbbreviation(const AValue: string): string;

implementation

uses
  SysUtils;

const
  MonthTokens: array[0..15] of string = (
    'JAN', 'FEB', 'MAR', 'M'#$C4'R', 'APR', 'MAY', 'MAI', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'OKT', 'NOV', 'DEC', 'DEZ');
  MonthNumbers: array[0..15] of string = (
    '01', '02', '03', '03', '04', '05', '05', '06',
    '07', '08', '09', '10', '10', '11', '12', '12');

function NormalizeUnit3MonthAbbreviation(const AValue: string): string;
var
  monthList: string;
  tokenPosition: Integer;
  monthIndex: Integer;
  currentPosition: Integer;
  trimmedValue: string;
begin
  monthList := '';
  for monthIndex := Low(MonthTokens) to High(MonthTokens) do
    monthList := monthList + MonthTokens[monthIndex];

  tokenPosition := Pos(AValue, monthList);
  if tokenPosition > 0 then
  begin
    currentPosition := 1;
    for monthIndex := Low(MonthTokens) to High(MonthTokens) do
    begin
      if tokenPosition = currentPosition then
      begin
        Result := MonthNumbers[monthIndex];
        Exit;
      end;
      Inc(currentPosition, Length(MonthTokens[monthIndex]));
    end;
  end;

  trimmedValue := Trim(AValue);
  Result := Copy(trimmedValue, 1, 2);
end;

end.
