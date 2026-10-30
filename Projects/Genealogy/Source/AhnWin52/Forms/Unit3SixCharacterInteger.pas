unit Unit3SixCharacterInteger;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

function FormatUnit3SixCharacterInteger(AValue: Integer): string;

implementation

uses
  SysUtils;

function FormatUnit3SixCharacterInteger(AValue: Integer): string;
var
  paddedValue: string;
  firstCharacter: Integer;
begin
  paddedValue := '000000' + IntToStr(AValue);
  firstCharacter := Length(paddedValue) - 5;
  Result := Copy(paddedValue, firstCharacter, 6);
end;

end.
