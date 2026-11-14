unit DBParadoxPrimaryFamilyAdapter;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxFamilyPublisher, DBParadoxRecordEncoder,
  DBParadoxTableFileBuilder;

type
  EDBParadoxPrimaryFamilyValidationError = class(Exception);

  TDBParadoxPrimaryFamilyStageBuilder = class(TInterfacedObject,
    IDBParadoxFamilyStageBuilder)
  private
    FDatabaseTemplate: TBytes;
    FPrimaryIndexTemplate: TBytes;
    FFields: TDBParadoxRecordFields;
    FPrimaryKeyFieldIndex: SizeInt;
    FRows: TDBParadoxTableRows;
    FBuiltFiles: TDBParadoxBuiltFiles;
    FBuildActive: Boolean;
    FWrittenMembers: array[0..1] of Boolean;
    procedure BuildFiles;
  public
    constructor Create(const ADatabaseTemplate, APrimaryIndexTemplate: TBytes;
      const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
      const ARows: TDBParadoxTableRows);
    procedure BeginBuild(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
    procedure BuildMember(const AStageDirectory, ATableBaseName,
      AMember: string);
    procedure EndBuild;
    procedure AbortBuild;
  end;

  TDBParadoxPrimaryFamilyValidator = class(TInterfacedObject,
    IDBParadoxFamilyValidator)
  private
    FFields: TDBParadoxRecordFields;
    FPrimaryKeyFieldIndex: SizeInt;
    FRows: TDBParadoxTableRows;
  public
    constructor Create(const AFields: TDBParadoxRecordFields;
      APrimaryKeyFieldIndex: SizeInt; const ARows: TDBParadoxTableRows);
    procedure Validate(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
  end;

implementation

uses
  Classes, DBParadoxFileReader;

const
  PrimaryFamilyMembers: array[0..1] of string = ('.DB', '.PX');

function CopyBytes(const ASource: TBytes): TBytes;
begin
  Result := Copy(ASource, 0, Length(ASource));
end;

function IsPrimaryFamily(const AMembers: TDBParadoxFamilyMembers): Boolean;
begin
  Result := (Length(AMembers) = Length(PrimaryFamilyMembers)) and
    SameText(AMembers[0], PrimaryFamilyMembers[0]) and
    SameText(AMembers[1], PrimaryFamilyMembers[1]);
end;

function ReadUInt16LE(const AData: TBytes; AOffset: SizeInt): Word;
begin
  Result := Word(AData[AOffset]) or (Word(AData[AOffset + 1]) shl 8);
end;

function ReadUInt32LE(const AData: TBytes; AOffset: SizeInt): Cardinal;
begin
  Result := Cardinal(AData[AOffset]) or
    (Cardinal(AData[AOffset + 1]) shl 8) or
    (Cardinal(AData[AOffset + 2]) shl 16) or
    (Cardinal(AData[AOffset + 3]) shl 24);
end;

function ReadInt32LE(const AData: TBytes; AOffset: SizeInt): LongInt;
begin
  Result := LongInt(ReadUInt32LE(AData, AOffset));
end;

function LoadFileBytes(const AFileName: string): TBytes;
var
  Stream: TFileStream;
begin
  Result := nil;
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    {$IFDEF CPU32}
    if Stream.Size > High(SizeInt) then
      raise EDBParadoxPrimaryFamilyValidationError.CreateFmt(
        'File "%s" is too large to validate.', [AFileName]);
    {$ENDIF}
    SetLength(Result, SizeInt(Stream.Size));
    if Stream.Size > 0 then
      Stream.ReadBuffer(Result[0], Stream.Size);
  finally
    Stream.Free;
  end;
end;

procedure WriteFileBytes(const AFileName: string; const AData: TBytes);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(AFileName, fmCreate);
  try
    if Length(AData) > 0 then
      Stream.WriteBuffer(AData[0], Length(AData));
  finally
    Stream.Free;
  end;
end;

function SameBytes(const ALeft, ARight: TBytes): Boolean;
begin
  Result := (Length(ALeft) = Length(ARight)) and
    ((Length(ALeft) = 0) or
     (CompareByte(ALeft[0], ARight[0], Length(ALeft)) = 0));
end;

function SameSchema(const AExpected: TDBParadoxRecordFields;
  const AActual: TDBParadoxFileFields): Boolean;
var
  Index: SizeInt;
begin
  if Length(AExpected) <> Length(AActual) then
    Exit(False);
  for Index := 0 to High(AExpected) do
    if not SameText(AExpected[Index].Name, AActual[Index].Name) or
      (AExpected[Index].TypeCode <> AActual[Index].FieldType) or
      (AExpected[Index].Length <> AActual[Index].FieldLength) then
      Exit(False);
  Result := True;
end;

constructor TDBParadoxPrimaryFamilyStageBuilder.Create(
  const ADatabaseTemplate, APrimaryIndexTemplate: TBytes;
  const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
  const ARows: TDBParadoxTableRows);
var
  Index: SizeInt;
begin
  inherited Create;
  FDatabaseTemplate := CopyBytes(ADatabaseTemplate);
  FPrimaryIndexTemplate := CopyBytes(APrimaryIndexTemplate);
  FFields := Copy(AFields, 0, Length(AFields));
  for Index := 0 to High(FFields) do
    FFields[Index].Name := AFields[Index].Name;
  FPrimaryKeyFieldIndex := APrimaryKeyFieldIndex;
  FRows := Copy(ARows, 0, Length(ARows));
  for Index := 0 to High(FRows) do
    FRows[Index] := Copy(ARows[Index], 0, Length(ARows[Index]));
end;

procedure TDBParadoxPrimaryFamilyStageBuilder.BuildFiles;
begin
  FBuiltFiles := BuildDBParadoxTableFiles(FDatabaseTemplate,
    FPrimaryIndexTemplate, FFields, FPrimaryKeyFieldIndex, FRows);
end;

procedure TDBParadoxPrimaryFamilyStageBuilder.BeginBuild(
  const AStageDirectory, ATableBaseName: string;
  const AMembers: TDBParadoxFamilyMembers);
begin
  if FBuildActive then
    raise EDBParadoxPublicationError.Create(
      'A primary-family build is already active.');
  if (Trim(AStageDirectory) = '') or (Trim(ATableBaseName) = '') then
    raise EDBParadoxPublicationError.Create(
      'A staging directory and table base name are required.');
  if not IsPrimaryFamily(AMembers) then
    raise EDBParadoxPublicationError.Create(
      'The primary-family builder only supports .DB/.PX families.');
  FWrittenMembers[0] := False;
  FWrittenMembers[1] := False;
  BuildFiles;
  FBuildActive := True;
end;

procedure TDBParadoxPrimaryFamilyStageBuilder.BuildMember(
  const AStageDirectory, ATableBaseName, AMember: string);
var
  MemberIndex: Integer;
  Data: TBytes;
begin
  if not FBuildActive then
    raise EDBParadoxPublicationError.Create(
      'A primary-family build is not active.');
  if SameText(AMember, '.DB') then
  begin
    MemberIndex := 0;
    Data := FBuiltFiles.DatabaseFile;
  end
  else if SameText(AMember, '.PX') then
  begin
    MemberIndex := 1;
    Data := FBuiltFiles.PrimaryIndexFile;
  end
  else
    raise EDBParadoxPublicationError.CreateFmt(
      'The primary-family builder cannot write member "%s".', [AMember]);
  if FWrittenMembers[MemberIndex] then
    raise EDBParadoxPublicationError.CreateFmt(
      'The primary-family member "%s" was requested more than once.',
      [AMember]);
  WriteFileBytes(IncludeTrailingPathDelimiter(AStageDirectory) +
    ATableBaseName + AMember, Data);
  FWrittenMembers[MemberIndex] := True;
end;

procedure TDBParadoxPrimaryFamilyStageBuilder.EndBuild;
begin
  if not FBuildActive then
    raise EDBParadoxPublicationError.Create(
      'A primary-family build is not active.');
  if not FWrittenMembers[0] or not FWrittenMembers[1] then
    raise EDBParadoxPublicationError.Create(
      'The primary-family build did not write both .DB and .PX members.');
  FBuildActive := False;
end;

procedure TDBParadoxPrimaryFamilyStageBuilder.AbortBuild;
begin
  FBuildActive := False;
end;

constructor TDBParadoxPrimaryFamilyValidator.Create(
  const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
  const ARows: TDBParadoxTableRows);
var
  Index: SizeInt;
begin
  inherited Create;
  FFields := Copy(AFields, 0, Length(AFields));
  for Index := 0 to High(FFields) do
    FFields[Index].Name := AFields[Index].Name;
  FRows := Copy(ARows, 0, Length(ARows));
  for Index := 0 to High(FRows) do
    FRows[Index] := Copy(ARows[Index], 0, Length(ARows[Index]));
  FPrimaryKeyFieldIndex := APrimaryKeyFieldIndex;
end;

procedure TDBParadoxPrimaryFamilyValidator.Validate(
  const AStageDirectory, ATableBaseName: string;
  const AMembers: TDBParadoxFamilyMembers);
var
  Fields: TDBParadoxFileFields;
  Rows: TDBParadoxFileRows;
  RecordSize: Integer;
  PrimaryIndex: TBytes;
  Seen: array of Boolean;
  Encoded: TBytes;
  Index, RowIndex: SizeInt;
  HeaderSize, BlockSize, BlockCount: Int64;
  Found: Boolean;
  DatabaseFileName: string;
  KeyFieldIndex: SizeInt;
  RootBlock: Word;
  Encryption: Cardinal;
begin
  if not IsPrimaryFamily(AMembers) then
    raise EDBParadoxPrimaryFamilyValidationError.Create(
      'The primary-family validator only supports .DB/.PX families.');
  DatabaseFileName := IncludeTrailingPathDelimiter(AStageDirectory) +
    ATableBaseName + '.DB';
  ReadDBParadoxTable(DatabaseFileName, Fields, Rows, RecordSize);
  if not SameSchema(FFields, Fields) then
    raise EDBParadoxPrimaryFamilyValidationError.Create(
      'The staged table schema does not match the expected schema.');
  if Length(Rows) <> Length(FRows) then
    raise EDBParadoxPrimaryFamilyValidationError.CreateFmt(
      'The staged table contains %d rows; expected %d.',
      [Length(Rows), Length(FRows)]);

  if (FPrimaryKeyFieldIndex < 0) or
    (FPrimaryKeyFieldIndex >= Length(FFields)) then
    raise EDBParadoxPrimaryFamilyValidationError.Create(
      'The configured primary-key field index is invalid.');

  Seen := nil;
  SetLength(Seen, Length(FRows));
  for RowIndex := 0 to High(FRows) do
  begin
    Encoded := EncodeDBParadoxRecord(FFields, FRows[RowIndex]);
    Found := False;
    for Index := 0 to High(Rows) do
      if not Seen[Index] and SameBytes(Encoded, Rows[Index].Data) then
      begin
        Seen[Index] := True;
        Found := True;
        Break;
      end;
    if not Found then
      raise EDBParadoxPrimaryFamilyValidationError.CreateFmt(
        'Expected row %d is missing or differs in the staged table.',
        [RowIndex]);
  end;

  PrimaryIndex := LoadFileBytes(IncludeTrailingPathDelimiter(AStageDirectory) +
    ATableBaseName + '.PX');
  if (Length(PrimaryIndex) < $5A) or (PrimaryIndex[4] <> 1) then
    raise EDBParadoxPrimaryFamilyValidationError.Create(
      'The staged primary index header is missing or has an unsupported type.');
  Encryption := ReadUInt32LE(PrimaryIndex, $25);
  if Encryption = $FF00FF00 then
  begin
    if Length(PrimaryIndex) < $60 then
      raise EDBParadoxPrimaryFamilyValidationError.Create(
        'The encrypted primary-index header is truncated.');
    Encryption := ReadUInt32LE(PrimaryIndex, $5C);
  end;
  if Encryption <> 0 then
    raise EDBParadoxPrimaryFamilyValidationError.Create(
      'Encrypted primary indexes are not supported.');
  HeaderSize := ReadUInt16LE(PrimaryIndex, 2);
  BlockSize := Int64(PrimaryIndex[5]) * 1024;
  BlockCount := ReadUInt16LE(PrimaryIndex, $0C);
  RootBlock := ReadUInt16LE(PrimaryIndex, $1E);
  KeyFieldIndex := FPrimaryKeyFieldIndex;
  if (HeaderSize < $5A) or (HeaderSize > Length(PrimaryIndex)) or
    (BlockSize < 1024) or (BlockSize > 32768) or (BlockCount = 0) or
    (ReadInt32LE(PrimaryIndex, 6) <= 0) or
    (ReadUInt16LE(PrimaryIndex, $21) <> 1) or
    (RootBlock = 0) or (RootBlock > BlockCount) or
    (PrimaryIndex[$20] = 0) or
    (PrimaryIndex[$58] <> FFields[KeyFieldIndex].TypeCode) or
    (PrimaryIndex[$59] <> FFields[KeyFieldIndex].Length) or
    (Int64(Length(PrimaryIndex)) <> HeaderSize + BlockCount * BlockSize) then
    raise EDBParadoxPrimaryFamilyValidationError.Create(
      'The staged primary index has invalid block, root, or size metadata.');
end;

end.
