unit Unit13GraphicTextHelpers;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

function FormatGraphicPersonNumber(Value: Integer): RawByteString;
function UppercaseGraphicText(const Value: RawByteString): RawByteString;
function NormalizeGraphicLabel(const Value: RawByteString): RawByteString;

implementation

uses
  StrUtils;

function FormatGraphicPersonNumber(Value: Integer): RawByteString;
var
  paddedValue: string;
begin
  paddedValue := '000000' + IntToStr(Value);
  Result := Copy(paddedValue, Length(paddedValue) - 5, 6);
end;

function UppercaseGraphicText(const Value: RawByteString): RawByteString;
var
  index: SizeInt;
  character: RawByteString;
begin
  Result := '';
  for index := 1 to Length(Value) do
  begin
    case Byte(Value[index]) of
      $E4: Result := Result + AnsiChar($C4);
      $F6: Result := Result + AnsiChar($D6);
      $FC: Result := Result + AnsiChar($DC);
    else
      begin
        character := Value[index];
        Result := Result + UpperCase(character);
      end;
    end;
  end;
end;

function NormalizeGraphicLabel(const Value: RawByteString): RawByteString;
var
  workingValue: RawByteString;
  index: SizeInt;
begin
  Result := Value;
  if Trim(Value) = '..' then
  begin
    Result := '';
    Exit;
  end;

  if Copy(Value, 1, 2) = 'HK' then
  begin
    Result := 'HK ' + Copy(Value, 4, 7);
    Exit;
  end;

  if Pos('vo.r', Value) > 0 then
  begin
    Result := Copy(Value, 1, 2) + Copy(Value, 4, 1) + ' ' +
      RightStr(Value, 4);
    Exit;
  end;

  if Pos('na.ch', Value) > 0 then
  begin
    Result := Copy(Value, 1, 2) + Copy(Value, 4, 1) + ' ' +
      RightStr(Value, 4);
    Exit;
  end;

  if Trim(Value) = '' then
    Exit;

  workingValue := Value;
  while (Length(workingValue) > 0) and
    (Byte(workingValue[1]) in [Ord('.'), Ord(' ')]) do
    workingValue := Copy(workingValue, 2, 9);
  Result := workingValue;

  if (Length(workingValue) = 0) or
    (Byte(workingValue[1]) <= Ord('9')) then
    Exit;

  Result := '';
  for index := 1 to Length(workingValue) do
    if workingValue[index] <> '.' then
      Result := Result + workingValue[index];

  for index := 1 to Length(Result) do
    if Byte(Result[index]) < Ord(':') then
    begin
      Insert(' ', Result, index);
      Exit;
    end;
end;

end.
