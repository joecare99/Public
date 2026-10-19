program DBParadoxBdeFixtureGenerator;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, DBParadoxConformanceVectors, DBParadoxRecordEncoder,
  DBParadoxTableFileBuilder;

procedure SaveBytes(const FileName: string; const Data: TBytes);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    if Length(Data) > 0 then
      Stream.WriteBuffer(Data[0], Length(Data));
  finally
    Stream.Free;
  end;
end;

function LoadBytes(const FileName: string): TBytes;
var
  Stream: TFileStream;
begin
  Result := nil;
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    SetLength(Result, Stream.Size);
    if Length(Result) > 0 then
      Stream.ReadBuffer(Result[0], Length(Result));
  finally
    Stream.Free;
  end;
end;

var
  OutputDirectory, TemplateDirectory, DatabasePath: string;
  RowIndex: Integer;
  KeyValues: TStringList;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
begin
  try
    if ParamCount <> 2 then
      raise Exception.Create(
        'Usage: DBParadoxBdeFixtureGenerator <template-directory> <output-directory>');
    TemplateDirectory := ExpandFileName(ParamStr(1));
    OutputDirectory := ExpandFileName(ParamStr(2));
    if not ForceDirectories(OutputDirectory) then
      raise Exception.CreateFmt('Cannot create output directory: %s', [OutputDirectory]);

    SetLength(Fields, 1);
    Fields[0].Name := 'ID';
    Fields[0].TypeCode := $04;
    Fields[0].Length := 4;
    KeyValues := TStringList.Create;
    try
      KeyValues.Delimiter := ',';
      KeyValues.StrictDelimiter := True;
      KeyValues.DelimitedText :=
        ReadDBParadoxVector('bde-integer-primary-key-values');
      SetLength(Rows, KeyValues.Count);
      for RowIndex := 0 to KeyValues.Count - 1 do
        Rows[RowIndex] := [UnicodeString(KeyValues[RowIndex])];
    finally
      KeyValues.Free;
    end;

    Built := BuildDBParadoxTableFiles(
      LoadBytes(IncludeTrailingPathDelimiter(TemplateDirectory) + 'Synthetic.DB'),
      LoadBytes(IncludeTrailingPathDelimiter(TemplateDirectory) + 'Synthetic.PX'),
      Fields, 0, Rows);
    DatabasePath := IncludeTrailingPathDelimiter(OutputDirectory) + 'Synthetic.DB';
    SaveBytes(DatabasePath, Built.DatabaseFile);
    SaveBytes(ChangeFileExt(DatabasePath, '.PX'), Built.PrimaryIndexFile);
    WriteLn('FIXTURE=Pascal');
    WriteLn('DATABASE=', DatabasePath);
    WriteLn('PRIMARY_INDEX=', ChangeFileExt(DatabasePath, '.PX'));
    WriteLn('RECORDS=3');
  except
    on E: Exception do
    begin
      WriteLn(StdErr, 'ERROR=', E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
