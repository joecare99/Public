unit Unit3PlacePrefixReordering;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

function ReorderUnit3NumericPlacePrefix(const AValue: string): string;

implementation

uses
  SysUtils;

function ReorderUnit3NumericPlacePrefix(const AValue: string): string;
var
  separatorIndex: Integer;
  trimmedLength: Integer;
  suffix: string;
  prefix: string;
begin
  Result := AValue;
  if (AValue = '') or (Pos(AValue[1], '1234567890') = 0) then
    Exit;

  separatorIndex := Pos(' ', AValue);
  trimmedLength := Length(Trim(AValue));
  suffix := Copy(AValue, separatorIndex + 1, trimmedLength);
  prefix := Copy(AValue, 1, separatorIndex - 1);
  Result := suffix + ' ' + prefix;
end;

end.
