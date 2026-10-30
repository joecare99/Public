unit Unit19ThreeCharacterSpaceInteger;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

function FormatUnit19ThreeCharacterSpaceInteger(AValue: Integer): string;

implementation

uses
  SysUtils;

function FormatUnit19ThreeCharacterSpaceInteger(AValue: Integer): string;
var
  paddedValue: string;
  firstCharacter: Integer;
begin
  paddedValue := '   ' + IntToStr(AValue);
  firstCharacter := Length(paddedValue) - 2;
  Result := Copy(paddedValue, firstCharacter, 3);
end;

end.
