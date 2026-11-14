unit Unit1ByteUppercase;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

function UpperCaseUnit1Bytes(const AValue: AnsiString): AnsiString;

implementation

uses
  SysUtils;

function UpperCaseUnit1Bytes(const AValue: AnsiString): AnsiString;
var
  index: Integer;
  byteValue: AnsiString;
begin
  Result := '';
  for index := 1 to Length(AValue) do
  begin
    case Ord(AValue[index]) of
      $E4:
        Result := Result + AnsiChar($C4);
      $F6:
        Result := Result + AnsiChar($D6);
      $FC:
        Result := Result + AnsiChar($DC);
    else
      begin
        byteValue := Copy(AValue, index, 1);
        Result := Result + UpperCase(byteValue);
      end;
    end;
  end;
end;

end.
