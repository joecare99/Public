unit DBParadoxConformanceVectors;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

function ReadDBParadoxVector(const Name: string): string;
function DecodeDBParadoxHex(const Value: string): TBytes;

implementation

uses
  Classes;

function FindVectorFile: string;
var
  SearchDirectory, ParentDirectory, Candidate: string;
begin
  Result := GetEnvironmentVariable('DBPARADOX_CONFORMANCE_VECTOR_FILE');
  if Result <> '' then
  begin
    Result := ExpandFileName(Result);
    if not FileExists(Result) then
      raise Exception.CreateFmt(
        'The configured DBParadox conformance vector file does not exist: %s',
        [Result]);
    Exit;
  end;

  SearchDirectory := ExpandFileName(ExtractFilePath(ParamStr(0)));
  repeat
    Candidate := IncludeTrailingPathDelimiter(SearchDirectory) +
      'Components' + PathDelim + 'Source' + PathDelim + 'DBParadox' +
      PathDelim + 'Tests' + PathDelim + 'Conformance' + PathDelim +
      'vectors.txt';
    if FileExists(Candidate) then
    begin
      Result := Candidate;
      Exit;
    end;
    ParentDirectory := ExtractFileDir(ExcludeTrailingPathDelimiter(SearchDirectory));
    if ParentDirectory = SearchDirectory then
      Break;
    SearchDirectory := ParentDirectory;
  until False;

  raise Exception.Create(
    'Could not locate Components\Source\DBParadox\Tests\Conformance\vectors.txt.');
end;

function ReadDBParadoxVector(const Name: string): string;
var
  Lines: TStringList;
  Line: string;
  Separator: SizeInt;
  Index: Integer;
begin
  Lines := TStringList.Create;
  try
    Lines.LoadFromFile(FindVectorFile);
    for Index := 0 to Lines.Count - 1 do
    begin
      Line := Trim(Lines[Index]);
      if (Line = '') or (Line[1] = '#') then
        Continue;
      Separator := Pos('=', Line);
      if (Separator > 0) and
        SameText(Copy(Line, 1, Separator - 1), Name) then
      begin
        Result := Copy(Line, Separator + 1, MaxInt);
        Exit;
      end;
    end;
  finally
    Lines.Free;
  end;
  raise Exception.CreateFmt('DBParadox vector "%s" was not found.', [Name]);
end;

function DecodeDBParadoxHex(const Value: string): TBytes;
var
  Index: SizeInt;
begin
  if (Length(Value) = 0) or ((Length(Value) mod 2) <> 0) then
    raise Exception.Create('A DBParadox hexadecimal vector has an invalid length.');
  Result := nil;
  SetLength(Result, Length(Value) div 2);
  for Index := 0 to High(Result) do
    Result[Index] := Byte(StrToInt('$' + Copy(Value, Index * 2 + 1, 2)));
end;

end.
