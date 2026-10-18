unit FrenchRepublicanComplementaryDays;

{$mode objfpc}{$H+}

interface

type
  TFrenchRepublicanComplementaryDayClass = (
    frcdNotComplementary, frcdValid, frcdInvalid);

function ClassifyFrenchRepublicanComplementaryDay(const DayText,
  MonthText: string; YearIndex: Integer):
  TFrenchRepublicanComplementaryDayClass;

implementation

uses
  SysUtils;

function ClassifyFrenchRepublicanComplementaryDay(const DayText,
  MonthText: string; YearIndex: Integer):
  TFrenchRepublicanComplementaryDayClass;
begin
  if (DayText <= '30') or (DayText > 'jrev') then
  begin
    Result := frcdNotComplementary;
    Exit;
  end;

  if (Trim(MonthText) = 'Fructidor') and (YearIndex in [2, 6, 10]) then
    Result := frcdValid
  else
    Result := frcdInvalid;
end;

end.
