unit DateWeekdayAbbreviation;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

function ResolveDateWeekdayAbbreviation(const DateText: string): string;

implementation

uses
  SysUtils;

function ResolveDateWeekdayAbbreviation(const DateText: string): string;
var
  parsedDate: TDateTime;
begin
  Result := '';
  try
    parsedDate := StrToDate(DateText);
  except
    Exit;
  end;

  case DayOfWeek(parsedDate) of
    1: Result := 'So';
    2: Result := 'Mo';
    3: Result := 'Di';
    4: Result := 'Mi';
    5: Result := 'Do';
    6: Result := 'Fr';
    7: Result := 'Sa';
  end;
end;

end.
