unit tst_DBParadoxPrimaryKeyDiscovery;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxFileReader, fpcunit, testregistry;

type
  TTestDBParadoxPrimaryKeyDiscovery = class(TTestCase)
  private
    function MakeDatabaseTemplate(const Fields: array of TDBParadoxFileField;
      RecordSize, BlockSizeKB: Integer): TBytes;
    function MakePrimaryIndexTemplate(KeyType: Byte; KeyLength,
      BlockSizeKB: Integer): TBytes;
    function WriteBytes(const Extension: string; const Data: TBytes): string;
  published
    procedure DiscoversPrimaryKeyFromIndexBlockKeys;
    procedure RequiresExplicitMappingForAmbiguousFields;
    procedure RejectsNoMatchingIndexBoundary;
    procedure RequiresExplicitMappingForEmptyAmbiguousTable;
    procedure ReadsPrimaryIndexTreeAcrossLevels;
  end;

implementation

uses
  Classes, DBParadoxPrimaryKeyDiscovery, DBParadoxRecordEncoder,
  DBParadoxTableFileBuilder;

procedure WriteUInt16LE(var Data: TBytes; Offset: SizeInt; Value: Word);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
end;

function TTestDBParadoxPrimaryKeyDiscovery.MakeDatabaseTemplate(
  const Fields: array of TDBParadoxFileField;
  RecordSize, BlockSizeKB: Integer): TBytes;
var
  TableNameOffset, FieldNamesOffset: SizeInt;
  FieldIndex: SizeInt;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, RecordSize);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 0;
  Result[5] := BlockSizeKB;
  WriteUInt16LE(Result, $21, Length(Fields));
  WriteUInt16LE(Result, $23, 1);
  Result[$39] := $0C;
  TableNameOffset := $78 + Length(Fields) * 2 + 4 +
    Length(Fields) * 4;
  FieldNamesOffset := TableNameOffset + 261;
  Move('Synthetic'#0, Result[TableNameOffset], Length('Synthetic') + 1);
  for FieldIndex := 0 to High(Fields) do
  begin
    Result[$78 + FieldIndex * 2] := Fields[FieldIndex].FieldType;
    Result[$79 + FieldIndex * 2] := Fields[FieldIndex].FieldLength;
    if Fields[FieldIndex].FieldType = $0A then
      Result[$79 + FieldIndex * 2] := 0;
    Move(Fields[FieldIndex].Name[1], Result[FieldNamesOffset],
      Length(Fields[FieldIndex].Name));
    Inc(FieldNamesOffset, Length(Fields[FieldIndex].Name) + 1);
  end;
end;

function TTestDBParadoxPrimaryKeyDiscovery.MakePrimaryIndexTemplate(
  KeyType: Byte; KeyLength, BlockSizeKB: Integer): TBytes;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, KeyLength + 6);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 1;
  Result[5] := BlockSizeKB;
  WriteUInt16LE(Result, $21, 1);
  Result[$58] := KeyType;
  Result[$59] := KeyLength;
end;

function TTestDBParadoxPrimaryKeyDiscovery.WriteBytes(
  const Extension: string; const Data: TBytes): string;
var
  Stream: TFileStream;
begin
  Result := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'DBParadoxPrimaryKey-' + IntToStr(GetTickCount64) + Extension;
  Stream := TFileStream.Create(Result, fmCreate);
  try
    if Length(Data) > 0 then
      Stream.WriteBuffer(Data[0], Length(Data));
  finally
    Stream.Free;
  end;
end;

procedure TTestDBParadoxPrimaryKeyDiscovery.
  DiscoversPrimaryKeyFromIndexBlockKeys;
var
  Fields: TDBParadoxRecordFields;
  FileFields: TDBParadoxFileFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
  FileRows: TDBParadoxFileRows;
  RecordSize: Integer;
  DatabaseName, IndexName: string;
begin
  SetLength(Fields, 3);
  Fields[0].Name := 'OtherID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  Fields[1].Name := 'ID';
  Fields[1].TypeCode := $04;
  Fields[1].Length := 4;
  Fields[2].Name := 'Label';
  Fields[2].TypeCode := $01;
  Fields[2].Length := 8;
  SetLength(FileFields, Length(Fields));
  FileFields[0].Name := Fields[0].Name;
  FileFields[0].FieldType := Fields[0].TypeCode;
  FileFields[0].FieldLength := Fields[0].Length;
  FileFields[0].Offset := 0;
  FileFields[1].Name := Fields[1].Name;
  FileFields[1].FieldType := Fields[1].TypeCode;
  FileFields[1].FieldLength := Fields[1].Length;
  FileFields[1].Offset := 4;
  FileFields[2].Name := Fields[2].Name;
  FileFields[2].FieldType := Fields[2].TypeCode;
  FileFields[2].FieldLength := Fields[2].Length;
  FileFields[2].Offset := 8;
  SetLength(Rows, 3);
  Rows[0] := ['50', '1', 'One'];
  Rows[1] := ['51', '2', 'Two'];
  Rows[2] := ['52', '3', 'Three'];
  Built := BuildDBParadoxTableFiles(
    MakeDatabaseTemplate(FileFields, 16, 2),
    MakePrimaryIndexTemplate($04, 4, 2), Fields, 1, Rows);
  DatabaseName := WriteBytes('.DB', Built.DatabaseFile);
  IndexName := WriteBytes('.PX', Built.PrimaryIndexFile);
  try
    ReadDBParadoxTable(DatabaseName, FileFields, FileRows, RecordSize);
    CheckEquals(1, DiscoverDBParadoxPrimaryKeyFieldIndex(
      FileFields, FileRows, IndexName));
    CheckEquals(1, FileRows[0].BlockNumber);
    CheckEquals(0, FileRows[0].RecordInBlock);
  finally
    DeleteFile(DatabaseName);
    DeleteFile(IndexName);
  end;
end;

procedure TTestDBParadoxPrimaryKeyDiscovery.
  RequiresExplicitMappingForAmbiguousFields;
var
  Fields: TDBParadoxRecordFields;
  FileFields: TDBParadoxFileFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
  FileRows: TDBParadoxFileRows;
  RecordSize: Integer;
  DatabaseName, IndexName: string;
  RaisedExpectedError: Boolean;
begin
  SetLength(Fields, 2);
  Fields[0].Name := 'OtherID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  Fields[1].Name := 'ID';
  Fields[1].TypeCode := $04;
  Fields[1].Length := 4;
  FileFields := nil;
  SetLength(FileFields, 2);
  FileFields[0].Name := Fields[0].Name;
  FileFields[0].FieldType := $04;
  FileFields[0].FieldLength := 4;
  FileFields[0].Offset := 0;
  FileFields[1].Name := Fields[1].Name;
  FileFields[1].FieldType := $04;
  FileFields[1].FieldLength := 4;
  FileFields[1].Offset := 4;
  Rows := nil;
  SetLength(Rows, 2);
  Rows[0] := ['1', '1'];
  Rows[1] := ['9', '2'];
  Built := BuildDBParadoxTableFiles(
    MakeDatabaseTemplate(FileFields, 8, 2),
    MakePrimaryIndexTemplate($04, 4, 2), Fields, 1, Rows);
  DatabaseName := WriteBytes('.DB', Built.DatabaseFile);
  IndexName := WriteBytes('.PX', Built.PrimaryIndexFile);
  try
    ReadDBParadoxTable(DatabaseName, FileFields, FileRows, RecordSize);
    RaisedExpectedError := False;
    try
      DiscoverDBParadoxPrimaryKeyFieldIndex(FileFields, FileRows, IndexName);
    except
      on E: EDBParadoxPrimaryKeyDiscoveryError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError,
      'Ambiguous physical field mapping must not be guessed.');
    CheckEquals(1, DiscoverDBParadoxPrimaryKeyFieldIndex(
      FileFields, FileRows, IndexName, 1));
  finally
    DeleteFile(DatabaseName);
    DeleteFile(IndexName);
  end;
end;

procedure TTestDBParadoxPrimaryKeyDiscovery.
  RejectsNoMatchingIndexBoundary;
var
  Fields: TDBParadoxRecordFields;
  FileFields: TDBParadoxFileFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
  FileRows: TDBParadoxFileRows;
  RecordSize: Integer;
  DatabaseName, IndexName: string;
  RaisedExpectedError: Boolean;
begin
  SetLength(Fields, 1);
  Fields[0].Name := 'ID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  SetLength(FileFields, 1);
  FileFields[0].Name := 'ID';
  FileFields[0].FieldType := $04;
  FileFields[0].FieldLength := 4;
  FileFields[0].Offset := 0;
  Rows := nil;
  SetLength(Rows, 1);
  Rows[0] := ['1'];
  Built := BuildDBParadoxTableFiles(
    MakeDatabaseTemplate(FileFields, 4, 2),
    MakePrimaryIndexTemplate($04, 4, 2), Fields, 0, Rows);
  Built.PrimaryIndexFile[$800 + 6 + 3] := 2;
  DatabaseName := WriteBytes('.DB', Built.DatabaseFile);
  IndexName := WriteBytes('.PX', Built.PrimaryIndexFile);
  try
    ReadDBParadoxTable(DatabaseName, FileFields, FileRows, RecordSize);
    RaisedExpectedError := False;
    try
      DiscoverDBParadoxPrimaryKeyFieldIndex(FileFields, FileRows, IndexName);
    except
      on E: EDBParadoxPrimaryKeyDiscoveryError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError,
      'Index keys that disagree with the database block must be rejected.');
  finally
    DeleteFile(DatabaseName);
    DeleteFile(IndexName);
  end;
end;

procedure TTestDBParadoxPrimaryKeyDiscovery.
  RequiresExplicitMappingForEmptyAmbiguousTable;
var
  Fields: TDBParadoxFileFields;
  IndexTemplate: TBytes;
  IndexName: string;
  RaisedExpectedError: Boolean;
begin
  SetLength(Fields, 2);
  Fields[0].Name := 'FirstID';
  Fields[0].FieldType := $04;
  Fields[0].FieldLength := 4;
  Fields[0].Offset := 0;
  Fields[1].Name := 'SecondID';
  Fields[1].FieldType := $04;
  Fields[1].FieldLength := 4;
  Fields[1].Offset := 4;
  IndexTemplate := MakePrimaryIndexTemplate($04, 4, 2);
  IndexName := WriteBytes('.PX', IndexTemplate);
  try
    RaisedExpectedError := False;
    try
      DiscoverDBParadoxPrimaryKeyFieldIndex(Fields, nil, IndexName);
    except
      on E: EDBParadoxPrimaryKeyDiscoveryError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError,
      'An empty table with indistinguishable keys needs explicit metadata.');
    CheckEquals(1, DiscoverDBParadoxPrimaryKeyFieldIndex(
      Fields, nil, IndexName, 1));
  finally
    DeleteFile(IndexName);
  end;
end;

procedure TTestDBParadoxPrimaryKeyDiscovery.
  ReadsPrimaryIndexTreeAcrossLevels;
var
  Fields: TDBParadoxRecordFields;
  FileFields: TDBParadoxFileFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
  FileRows: TDBParadoxFileRows;
  RecordSize, RowIndex: Integer;
  DatabaseName, IndexName: string;
begin
  SetLength(Fields, 1);
  Fields[0].Name := 'ID';
  Fields[0].TypeCode := $01;
  Fields[0].Length := 100;
  FileFields := nil;
  SetLength(FileFields, 1);
  FileFields[0].Name := 'ID';
  FileFields[0].FieldType := $01;
  FileFields[0].FieldLength := 100;
  FileFields[0].Offset := 0;
  SetLength(Rows, 100);
  for RowIndex := 0 to High(Rows) do
    Rows[RowIndex] := [UnicodeString(Format('ID%.3d', [RowIndex]))];
  Built := BuildDBParadoxTableFiles(
    MakeDatabaseTemplate(FileFields, 100, 1),
    MakePrimaryIndexTemplate($01, 100, 1), Fields, 0, Rows);
  DatabaseName := WriteBytes('.DB', Built.DatabaseFile);
  IndexName := WriteBytes('.PX', Built.PrimaryIndexFile);
  try
    ReadDBParadoxTable(DatabaseName, FileFields, FileRows, RecordSize);
    CheckEquals(0, DiscoverDBParadoxPrimaryKeyFieldIndex(
      FileFields, FileRows, IndexName));
    CheckTrue(FileRows[High(FileRows)].BlockNumber > 1,
      'The test table must span multiple physical database blocks.');
  finally
    DeleteFile(DatabaseName);
    DeleteFile(IndexName);
  end;
end;

initialization
  RegisterTest(TTestDBParadoxPrimaryKeyDiscovery);

end.
