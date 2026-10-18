unit Unit1DateDifferenceCore;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

{ Components must already have passed the caller's legacy date validation. }
function BuildUnit1ValidatedDateDifferenceText(ADay1, AMonth1, AYear1,
  ADay2, AMonth2, AYear2: Integer; AYearsOnly: Boolean): string;

implementation

uses
  SysUtils, DateUtils;

function BuildUnit1ValidatedDateDifferenceText(ADay1, AMonth1, AYear1,
  ADay2, AMonth2, AYear2: Integer; AYearsOnly: Boolean): string;
var
  diffDay: Integer;
  diffMonth: Integer;
  diffYear: Integer;
  dayText: string;
  monthText: string;
  yearText: string;
begin
  diffDay := ADay2 - ADay1;
  diffMonth := AMonth2 - AMonth1;
  diffYear := AYear2 - AYear1;

  if diffDay < 0 then
  begin
    Dec(diffMonth);
    diffDay := (DaysInAMonth(AYear1, AMonth1) - ADay1) + ADay2;
  end;

  if diffMonth < 0 then
  begin
    Dec(diffYear);
    Inc(diffMonth, 12);
  end;

  dayText := '';
  monthText := '';
  yearText := '';

  if diffDay > 0 then
    dayText := IntToStr(diffDay) + ' T';
  if diffMonth > 0 then
    monthText := IntToStr(diffMonth) + ' M ';
  if diffYear > 0 then
    yearText := IntToStr(diffYear) + ' J ';

  if AYearsOnly then
    Result := yearText
  else
    Result := yearText + monthText + dayText;
end;

end.
