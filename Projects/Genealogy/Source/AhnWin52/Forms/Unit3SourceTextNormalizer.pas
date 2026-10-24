unit Unit3SourceTextNormalizer;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

function NormalizeUnit3SourceText(const AValue: string): string;

implementation

uses
  SysUtils, StrUtils;

function NormalizeUnit3SourceText(const AValue: string): string;
var
  sourceText: string;
  cleanedText: string;
  index: Integer;
begin
  sourceText := AValue;
  Result := sourceText;

  if Trim(sourceText) = '..' then
  begin
    Result := '';
    Exit;
  end;

  if Copy(sourceText, 1, 2) = 'HK' then
  begin
    Result := 'HK ' + Copy(sourceText, 4, 7);
    Exit;
  end;

  if Pos('vo.r', sourceText) > 0 then
  begin
    Result := Copy(sourceText, 1, 2) + Copy(sourceText, 4, 1) + ' ' +
      RightStr(sourceText, 4);
    Exit;
  end;

  if Pos('na.ch', sourceText) > 0 then
  begin
    Result := Copy(sourceText, 1, 2) + Copy(sourceText, 4, 2) + ' ' +
      RightStr(sourceText, 4);
    Exit;
  end;

  if Trim(sourceText) = '' then
    Exit;

  while (sourceText <> '') and
    ((sourceText[1] = '.') or (sourceText[1] = ' ')) do
    sourceText := Copy(sourceText, 2, 9);

  Result := sourceText;
  if (sourceText = '') or (Ord(sourceText[1]) <= Ord('9')) then
    Exit;

  cleanedText := '';
  for index := 1 to Length(sourceText) do
    if sourceText[index] <> '.' then
      cleanedText := cleanedText + sourceText[index];

  Result := cleanedText;
  for index := 1 to Length(cleanedText) do
    if Ord(cleanedText[index]) < Ord(':') then
    begin
      Result := Copy(cleanedText, 1, index - 1) + ' ' +
        Copy(cleanedText, index, MaxInt);
      Break;
    end;
end;

end.
