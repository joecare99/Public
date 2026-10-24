unit Unit3SixCharacterSpaceInteger;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

function FormatUnit3SixCharacterSpaceInteger(AValue: Integer): string;

implementation

uses
  SysUtils;

function FormatUnit3SixCharacterSpaceInteger(AValue: Integer): string;
var
  paddedValue: string;
  firstCharacter: Integer;
begin
  paddedValue := '      ' + IntToStr(AValue);
  firstCharacter := Length(paddedValue) - 5;
  Result := Copy(paddedValue, firstCharacter, 6);
end;

end.
