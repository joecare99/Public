program DBParadoxSecondaryIndexFixtureGenerator;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, DBParadoxRecordEncoder, DBParadoxSecondaryIndexBuilder,
  DBParadoxTableFileBuilder;

type
  TFixtureBytes = array[0..7] of TBytes;

const
  FixturePrefix = 'AhnWin52-SecondaryIndex-Pascal-';
  CaseOptionRowCount = 5;
  MultiBlockRowCount = 75;
  CapacityRowCount = 770;
  CapacityGroupWidth = 200;
  CapacitySuffixWidth = 30;

function ReadUInt16LE(const Data: TBytes; Offset: SizeInt): Word;
begin
  Result := Word(Data[Offset]) or (Word(Data[Offset + 1]) shl 8);
end;

procedure WriteUInt16LE(var Data: TBytes; Offset: SizeInt; Value: Word);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
end;

procedure WriteUInt32LE(var Data: TBytes; Offset: SizeInt; Value: Cardinal);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
  Data[Offset + 2] := Byte(Value shr 16);
  Data[Offset + 3] := Byte(Value shr 24);
end;

function LoadTemplate(const Directory, FileName: string;
  ExpectedFileType: Byte): TBytes;
var
  Stream: TFileStream;
  HeaderSize: SizeInt;
begin
  Result := nil;
  Stream := TFileStream.Create(
    IncludeTrailingPathDelimiter(Directory) + FileName, fmOpenRead or fmShareDenyWrite);
  try
    if Stream.Size < $58 then
      raise Exception.CreateFmt('Template "%s" is truncated.', [FileName]);
    SetLength(Result, Stream.Size);
    Stream.ReadBuffer(Result[0], Stream.Size);
  finally
    Stream.Free;
  end;

  if Result[4] <> ExpectedFileType then
    raise Exception.CreateFmt(
      'Template "%s" has file type 0x%.2x, expected 0x%.2x.',
      [FileName, Result[4], ExpectedFileType]);
  HeaderSize := ReadUInt16LE(Result, 2);
  if (HeaderSize < $58) or (HeaderSize > Length(Result)) then
    raise Exception.CreateFmt('Template "%s" has an invalid header size.', [FileName]);

  SetLength(Result, HeaderSize);
  WriteUInt32LE(Result, 6, 0);
  WriteUInt16LE(Result, $0A, 0);
  WriteUInt16LE(Result, $0C, 0);
  WriteUInt16LE(Result, $0E, 0);
  WriteUInt16LE(Result, $10, 0);
  if ExpectedFileType in [4, 7] then
  begin
    WriteUInt16LE(Result, $1E, 0);
    Result[$20] := 0;
  end;
end;

procedure WriteBytes(const Directory, FileName: string; const Data: TBytes);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(
    IncludeTrailingPathDelimiter(Directory) + FileName, fmCreate);
  try
    if Length(Data) > 0 then
      Stream.WriteBuffer(Data[0], Length(Data));
  finally
    Stream.Free;
  end;
end;

function CreateOutputDirectory(MultiBlockFixture,
  CapacityFixture: Boolean): string;
var
  TempDirectory, Candidate, Prefix: string;
  Suffix: Integer;
begin
  TempDirectory := GetEnvironmentVariable('TEMP');
  if TempDirectory = '' then
    raise Exception.Create('TEMP is not set.');
  TempDirectory := IncludeTrailingPathDelimiter(TempDirectory);
  Prefix := FixturePrefix;
  if MultiBlockFixture then
    Prefix := Prefix + 'Multi-';
  if CapacityFixture then
    Prefix := Prefix + 'Capacity-';
  Suffix := 0;
  repeat
    Candidate := TempDirectory + Prefix +
      FormatDateTime('yyyymmddhhnnsszzz', Now);
    if Suffix > 0 then
      Candidate := Candidate + '-' + IntToStr(Suffix);
    Inc(Suffix);
  until not DirectoryExists(Candidate);
  if not ForceDirectories(Candidate) then
    raise Exception.CreateFmt('Cannot create output directory "%s".', [Candidate]);
  Result := Candidate;
end;

function RecordsPerDatabaseBlock(const DatabaseTemplate: TBytes): SizeInt;
var
  BlockSize, RecordSize, PhysicalCapacity: SizeInt;
begin
  BlockSize := SizeInt(DatabaseTemplate[5]) * 1024;
  RecordSize := ReadUInt16LE(DatabaseTemplate, 0);
  if (BlockSize <= 6) or (RecordSize <= 0) then
    raise Exception.Create('The BDE table template has invalid block dimensions.');
  PhysicalCapacity := (BlockSize - 6) div RecordSize;
  Result := PhysicalCapacity - 1;
  if Result < 1 then
    raise Exception.Create('The BDE table template cannot hold a data record.');
end;

function BuildIndexRecords(const Rows: TDBParadoxTableRows;
  RecordsPerBlock: SizeInt;
  const Fields: TDBParadoxRecordFields): TDBParadoxSecondaryRecords;
var
  RowIndex: SizeInt;
  Encoded: TBytes;
begin
  Result := nil;
  SetLength(Result, Length(Rows));
  for RowIndex := 0 to High(Rows) do
  begin
    Encoded := EncodeDBParadoxRecord(Fields, Rows[RowIndex]);
    SetLength(Result[RowIndex].Key,
      Fields[1].Length + Fields[2].Length + Fields[0].Length);
    Move(Encoded[Fields[0].Length], Result[RowIndex].Key[0],
      Fields[1].Length);
    Move(Encoded[Fields[0].Length + Fields[1].Length],
      Result[RowIndex].Key[Fields[1].Length], Fields[2].Length);
    Move(Encoded[0],
      Result[RowIndex].Key[Fields[1].Length + Fields[2].Length],
      Fields[0].Length);
    Result[RowIndex].DataBlockNumber := RowIndex div RecordsPerBlock + 1;
  end;
end;

function BuildSingleFieldIndexRecords(const Rows: TDBParadoxTableRows;
  RecordsPerBlock: SizeInt;
  const Fields: TDBParadoxRecordFields): TDBParadoxSecondaryRecords;
var
  RowIndex: SizeInt;
  Encoded: TBytes;
begin
  Result := nil;
  SetLength(Result, Length(Rows));
  for RowIndex := 0 to High(Rows) do
  begin
    Encoded := EncodeDBParadoxRecord(Fields, Rows[RowIndex]);
    SetLength(Result[RowIndex].Key, Fields[1].Length + Fields[0].Length);
    Move(Encoded[Fields[0].Length], Result[RowIndex].Key[0],
      Fields[1].Length);
    Move(Encoded[0], Result[RowIndex].Key[Fields[1].Length],
      Fields[0].Length);
    Result[RowIndex].DataBlockNumber := RowIndex div RecordsPerBlock + 1;
  end;
end;

procedure BuildFixture(const TemplateDirectory: string);
var
  Templates: TFixtureBytes;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  CompositeIndexRecords, SingleFieldIndexRecords: TDBParadoxSecondaryRecords;
  TableFiles: TDBParadoxBuiltFiles;
  CaseSensitiveFiles, CaseInsensitiveFiles,
    CompositeFiles, SingleFieldFiles: TDBParadoxBuiltSecondaryIndex;
  OutputDirectory: string;
  RowIndex, FixtureRowCount: Integer;
  DatabaseRecordsPerBlock: SizeInt;
  IsClassicFixture, IsMultiBlockFixture, IsCapacityFixture: Boolean;
begin
  if not DirectoryExists(TemplateDirectory) then
    raise Exception.CreateFmt('Template directory does not exist: %s',
      [TemplateDirectory]);
  if SameText(ExtractFileName(ExcludeTrailingPathDelimiter(
    ExpandFileName(TemplateDirectory))), 'CaseOptionsFixture') then
  begin
    IsClassicFixture := False;
    IsMultiBlockFixture := False;
    IsCapacityFixture := False;
  end
  else if SameText(ExtractFileName(ExcludeTrailingPathDelimiter(
    ExpandFileName(TemplateDirectory))), 'ClassicIndexFixture') then
  begin
    IsClassicFixture := True;
    IsMultiBlockFixture := False;
    IsCapacityFixture := False;
  end
  else if SameText(ExtractFileName(ExcludeTrailingPathDelimiter(
    ExpandFileName(TemplateDirectory))), 'MultiBlockFixture') then
  begin
    IsClassicFixture := False;
    IsMultiBlockFixture := True;
    IsCapacityFixture := False;
  end
  else if SameText(ExtractFileName(ExcludeTrailingPathDelimiter(
    ExpandFileName(TemplateDirectory))), 'CapacityFixture') then
  begin
    IsClassicFixture := False;
    IsMultiBlockFixture := False;
    IsCapacityFixture := True;
  end
  else
    raise Exception.Create(
      'Only the named synthetic CaseOptionsFixture, ClassicIndexFixture, MultiBlockFixture, or CapacityFixture directory is accepted.');

  Templates[0] := LoadTemplate(TemplateDirectory, 'Synthetic.DB', 0);
  Templates[1] := LoadTemplate(TemplateDirectory, 'Synthetic.PX', 1);
  if IsClassicFixture then
  begin
    Templates[2] := LoadTemplate(TemplateDirectory, 'Synthetic.X02', 5);
    Templates[3] := LoadTemplate(TemplateDirectory, 'Synthetic.Y02', 4);
    Templates[4] := LoadTemplate(TemplateDirectory, 'Synthetic.XG0', 8);
    Templates[5] := LoadTemplate(TemplateDirectory, 'Synthetic.YG0', 7);
    Templates[6] := LoadTemplate(TemplateDirectory, 'Synthetic.XG1', 8);
    Templates[7] := LoadTemplate(TemplateDirectory, 'Synthetic.YG1', 7);
  end
  else
  begin
    Templates[2] := LoadTemplate(TemplateDirectory, 'Synthetic.XG0', 8);
    Templates[3] := LoadTemplate(TemplateDirectory, 'Synthetic.YG0', 7);
    Templates[4] := LoadTemplate(TemplateDirectory, 'Synthetic.XG1', 8);
    Templates[5] := LoadTemplate(TemplateDirectory, 'Synthetic.YG1', 7);
  end;

  SetLength(Fields, 3);
  Fields[0].Name := 'ID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  Fields[1].Name := 'GroupKey';
  Fields[1].TypeCode := $01;
  Fields[1].Length := 20;
  Fields[2].Name := 'Suffix';
  Fields[2].TypeCode := $01;
  Fields[2].Length := 8;

  if IsCapacityFixture then
  begin
    Fields[1].Length := CapacityGroupWidth;
    Fields[2].Length := CapacitySuffixWidth;
    FixtureRowCount := CapacityRowCount;
  end
  else if IsMultiBlockFixture then
    FixtureRowCount := MultiBlockRowCount
  else
    FixtureRowCount := CaseOptionRowCount;
  SetLength(Rows, FixtureRowCount);
  for RowIndex := 0 to High(Rows) do
    SetLength(Rows[RowIndex], Length(Fields));
  DatabaseRecordsPerBlock := RecordsPerDatabaseBlock(Templates[0]);
  if IsMultiBlockFixture or IsCapacityFixture then
    for RowIndex := 0 to High(Rows) do
    begin
      Rows[RowIndex][0] := UnicodeString(IntToStr(RowIndex + 1));
      if IsCapacityFixture then
      begin
        Rows[RowIndex][1] :=
          UnicodeString('Group' + Format('%.2d', [RowIndex mod 17]));
        Rows[RowIndex][2] :=
          UnicodeString('Suffix' + Format('%.2d', [RowIndex mod 11]));
      end
      else
      begin
        Rows[RowIndex][1] :=
          UnicodeString('Group' + Format('%.2d', [RowIndex mod 5]));
        Rows[RowIndex][2] :=
          UnicodeString(Chr(Ord('A') + RowIndex mod 3));
      end;
    end
  else
  begin
    Rows[0][0] := '1';
    Rows[0][1] := 'Alpha';
    Rows[0][2] := 'B';
    Rows[1][0] := '2';
    Rows[1][1] := 'Alpha';
    Rows[1][2] := 'A';
    Rows[2][0] := '3';
    Rows[2][1] := 'Alpha';
    Rows[2][2] := 'A';
    Rows[3][0] := '4';
    Rows[3][1] := 'alpha';
    Rows[3][2] := 'A';
    Rows[4][0] := '5';
    Rows[4][1] := 'Beta';
    Rows[4][2] := 'A';
  end;

  TableFiles := BuildDBParadoxTableFiles(
    Templates[0], Templates[1], Fields, 0, Rows);
  CompositeIndexRecords := BuildIndexRecords(
    Rows, DatabaseRecordsPerBlock, Fields);
  if IsClassicFixture then
  begin
    SingleFieldIndexRecords := BuildSingleFieldIndexRecords(
      Rows, DatabaseRecordsPerBlock, Fields);
    SingleFieldFiles := BuildDBParadoxSecondaryIndexFiles(
      Templates[2], Templates[3], TableFiles.PrimaryIndexFile[$2C],
      SingleFieldIndexRecords);
    CaseInsensitiveFiles := BuildDBParadoxSecondaryIndexFiles(
      Templates[4], Templates[5], TableFiles.PrimaryIndexFile[$2C],
      SingleFieldIndexRecords);
    CompositeFiles := BuildDBParadoxSecondaryIndexFiles(
      Templates[6], Templates[7], TableFiles.PrimaryIndexFile[$2C],
      CompositeIndexRecords);
  end
  else
  begin
    CaseSensitiveFiles := BuildDBParadoxSecondaryIndexFiles(
      Templates[2], Templates[3], TableFiles.PrimaryIndexFile[$2C],
      CompositeIndexRecords);
    CaseInsensitiveFiles := BuildDBParadoxSecondaryIndexFiles(
      Templates[4], Templates[5], TableFiles.PrimaryIndexFile[$2C],
      CompositeIndexRecords);
  end;

  OutputDirectory := CreateOutputDirectory(
    IsMultiBlockFixture, IsCapacityFixture);
  WriteBytes(OutputDirectory, 'Synthetic.DB', TableFiles.DatabaseFile);
  WriteBytes(OutputDirectory, 'Synthetic.PX', TableFiles.PrimaryIndexFile);
  if IsClassicFixture then
  begin
    WriteBytes(OutputDirectory, 'Synthetic.X02', SingleFieldFiles.DataFile);
    WriteBytes(OutputDirectory, 'Synthetic.Y02', SingleFieldFiles.IndexFile);
    WriteBytes(OutputDirectory, 'Synthetic.XG0', CaseInsensitiveFiles.DataFile);
    WriteBytes(OutputDirectory, 'Synthetic.YG0', CaseInsensitiveFiles.IndexFile);
    WriteBytes(OutputDirectory, 'Synthetic.XG1', CompositeFiles.DataFile);
    WriteBytes(OutputDirectory, 'Synthetic.YG1', CompositeFiles.IndexFile);
  end
  else
  begin
    WriteBytes(OutputDirectory, 'Synthetic.XG0', CaseSensitiveFiles.DataFile);
    WriteBytes(OutputDirectory, 'Synthetic.YG0', CaseSensitiveFiles.IndexFile);
    WriteBytes(OutputDirectory, 'Synthetic.XG1', CaseInsensitiveFiles.DataFile);
    WriteBytes(OutputDirectory, 'Synthetic.YG1', CaseInsensitiveFiles.IndexFile);
  end;

  WriteLn('RESULT=FIXTURE_CREATED');
  WriteLn('FIXTURE=', OutputDirectory);
  WriteLn('ROWS=', FixtureRowCount);
  if IsClassicFixture then
    WriteLn('INDEX_FAMILY=CLASSIC_AND_XG_8_FILES');
  if IsMultiBlockFixture then
    WriteLn('INDEX_FAMILY=CASE_OPTIONS_MULTIBLOCK');
  if IsCapacityFixture then
    WriteLn('INDEX_FAMILY=WIDE_KEY_CAPACITY');
  WriteLn('PRIMARY_REVISION=', TableFiles.PrimaryIndexFile[$2C]);
end;

begin
  try
    if (ParamCount <> 2) or not SameText(ParamStr(1), '--templates') then
      raise Exception.Create(
        'Use --templates <CaseOptionsFixture-or-ClassicIndexFixture-or-MultiBlockFixture-directory>');
    BuildFixture(ExpandFileName(ParamStr(2)));
  except
    on E: Exception do
    begin
      WriteLn('ERROR=', E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
