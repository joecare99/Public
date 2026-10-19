unit DBParadoxSecondaryFamilyAdapter;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxFamilyPublisher, DBParadoxRecordEncoder,
  DBParadoxTableFileBuilder, DBParadoxSecondaryIndexBuilder;

type
  EDBParadoxSecondaryFamilyValidationError = class(Exception);

  TDBParadoxIndexFieldIndexes = array of SizeInt;

  TDBParadoxSecondaryFamilyIndex = record
    DataExtension: string;
    IndexExtension: string;
    DataTemplate: TBytes;
    IndexTemplate: TBytes;
    KeyFieldIndexes: TDBParadoxIndexFieldIndexes;
  end;

  TDBParadoxSecondaryFamilyIndexes = array of
    TDBParadoxSecondaryFamilyIndex;

  TDBParadoxSecondaryFamilyStageBuilder = class(TInterfacedObject,
    IDBParadoxFamilyStageBuilder)
  private
    FDatabaseTemplate: TBytes;
    FPrimaryIndexTemplate: TBytes;
    FFields: TDBParadoxRecordFields;
    FPrimaryKeyFieldIndex: SizeInt;
    FRows: TDBParadoxTableRows;
    FIndexes: TDBParadoxSecondaryFamilyIndexes;
    FDatabaseFile: TBytes;
    FPrimaryIndexFile: TBytes;
    FSecondaryFiles: array of TDBParadoxBuiltSecondaryIndex;
    FBuildActive: Boolean;
    FWrittenMembers: array of Boolean;
    procedure BuildFiles;
  public
    constructor Create(const ADatabaseTemplate, APrimaryIndexTemplate: TBytes;
      const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
      const ARows: TDBParadoxTableRows;
      const AIndexes: TDBParadoxSecondaryFamilyIndexes);
    procedure BeginBuild(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
    procedure BuildMember(const AStageDirectory, ATableBaseName,
      AMember: string);
    procedure EndBuild;
    procedure AbortBuild;
  end;

  TDBParadoxSecondaryFamilyValidator = class(TInterfacedObject,
    IDBParadoxFamilyValidator)
  private
    FDatabaseTemplate: TBytes;
    FPrimaryIndexTemplate: TBytes;
    FFields: TDBParadoxRecordFields;
    FPrimaryKeyFieldIndex: SizeInt;
    FRows: TDBParadoxTableRows;
    FIndexes: TDBParadoxSecondaryFamilyIndexes;
  public
    constructor Create(const ADatabaseTemplate, APrimaryIndexTemplate: TBytes;
      const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
      const ARows: TDBParadoxTableRows;
      const AIndexes: TDBParadoxSecondaryFamilyIndexes);
    procedure Validate(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
  end;

implementation

uses
  Classes, DBParadoxFileReader, DBParadoxSecondaryIndexValidator;

type
  TEncodedSourceRow = record
    Data: TBytes;
    PrimaryKey: TBytes;
    SourceBlock: Integer;
  end;
  TEncodedSourceRows = array of TEncodedSourceRow;

function CopyBytes(const ASource: TBytes): TBytes;
begin
  Result := Copy(ASource, 0, Length(ASource));
end;

function CopyFields(const ASource: TDBParadoxRecordFields):
  TDBParadoxRecordFields;
var
  Index: SizeInt;
begin
  Result := Copy(ASource, 0, Length(ASource));
  for Index := 0 to High(Result) do
    Result[Index].Name := ASource[Index].Name;
end;

function CopyRows(const ASource: TDBParadoxTableRows): TDBParadoxTableRows;
var
  Index: SizeInt;
begin
  Result := Copy(ASource, 0, Length(ASource));
  for Index := 0 to High(Result) do
    Result[Index] := Copy(ASource[Index], 0, Length(ASource[Index]));
end;

function CopyIndexes(const ASource: TDBParadoxSecondaryFamilyIndexes):
  TDBParadoxSecondaryFamilyIndexes;
var
  Index: SizeInt;
begin
  Result := Copy(ASource, 0, Length(ASource));
  for Index := 0 to High(Result) do
  begin
    Result[Index].DataTemplate := CopyBytes(ASource[Index].DataTemplate);
    Result[Index].IndexTemplate := CopyBytes(ASource[Index].IndexTemplate);
    Result[Index].KeyFieldIndexes :=
      Copy(ASource[Index].KeyFieldIndexes, 0,
        Length(ASource[Index].KeyFieldIndexes));
  end;
end;

function ReadUInt16LE(const AData: TBytes; AOffset: SizeInt): Word;
begin
  if (AOffset < 0) or (AOffset + 1 >= Length(AData)) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'A Paradox header field is truncated.');
  Result := Word(AData[AOffset]) or (Word(AData[AOffset + 1]) shl 8);
end;

function ReadUInt32LE(const AData: TBytes; AOffset: SizeInt): Cardinal;
begin
  if (AOffset < 0) or (AOffset + 3 >= Length(AData)) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'A Paradox header field is truncated.');
  Result := Cardinal(AData[AOffset]) or
    (Cardinal(AData[AOffset + 1]) shl 8) or
    (Cardinal(AData[AOffset + 2]) shl 16) or
    (Cardinal(AData[AOffset + 3]) shl 24);
end;

function SameBytes(const ALeft, ARight: TBytes): Boolean;
begin
  Result := (Length(ALeft) = Length(ARight)) and
    ((Length(ALeft) = 0) or
     (CompareByte(ALeft[0], ARight[0], Length(ALeft)) = 0));
end;

function ReadFileBytes(const AFileName: string): TBytes;
var
  Stream: TFileStream;
begin
  Result := nil;
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    {$IFDEF CPU32}
    if Stream.Size > High(SizeInt) then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
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

function ExpectedMembers(const AIndexes: TDBParadoxSecondaryFamilyIndexes):
  TDBParadoxFamilyMembers;
var
  Index: SizeInt;
begin
  if (Length(AIndexes) <> 2) and (Length(AIndexes) <> 3) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'Exactly two XG indexes, optionally with one classic index, are supported.');
  if not SameText(AIndexes[0].DataExtension, '.XG0') or
    not SameText(AIndexes[0].IndexExtension, '.YG0') or
    not SameText(AIndexes[1].DataExtension, '.XG1') or
    not SameText(AIndexes[1].IndexExtension, '.YG1') then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The XG family must contain the .XG0/.YG0 and .XG1/.YG1 pairs.');
  if (Length(AIndexes) = 3) and
    (not SameText(AIndexes[2].DataExtension, '.X02') or
     not SameText(AIndexes[2].IndexExtension, '.Y02')) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'Only the tested classic .X02/.Y02 pair may accompany two XG pairs.');

  Result := nil;
  SetLength(Result, 2 + Length(AIndexes) * 2);
  Result[0] := '.DB';
  Result[1] := '.PX';
  for Index := 0 to High(AIndexes) do
  begin
    Result[2 + Index * 2] := AIndexes[Index].DataExtension;
    Result[3 + Index * 2] := AIndexes[Index].IndexExtension;
  end;
end;

function SameMembers(const ALeft, ARight: TDBParadoxFamilyMembers): Boolean;
var
  LeftIndex, RightIndex: SizeInt;
  Found: Boolean;
begin
  if Length(ALeft) <> Length(ARight) then
    Exit(False);
  for LeftIndex := 0 to High(ALeft) do
  begin
    Found := False;
    for RightIndex := 0 to High(ARight) do
      if SameText(ALeft[LeftIndex], ARight[RightIndex]) then
      begin
        Found := True;
        Break;
      end;
    if not Found then
      Exit(False);
  end;
  Result := True;
end;

function CompareBytes(const ALeft, ARight: TBytes): Integer;
var
  Index, CommonLength: SizeInt;
begin
  CommonLength := Length(ALeft);
  if Length(ARight) < CommonLength then
    CommonLength := Length(ARight);
  for Index := 0 to CommonLength - 1 do
    if ALeft[Index] <> ARight[Index] then
      Exit(Integer(ALeft[Index]) - Integer(ARight[Index]));
  Result := Length(ALeft) - Length(ARight);
end;

procedure ValidateIndexDefinitions(const AFields: TDBParadoxRecordFields;
  const AIndexes: TDBParadoxSecondaryFamilyIndexes);
var
  Index, FieldIndex, OtherFieldIndex, KeyLength, HeaderFieldCount,
    HeaderKeyFieldCount, FieldOffset, KeyFieldCount, IndexFieldCount: SizeInt;
  DataTemplate, IndexTemplate: TBytes;
  Encryption: Cardinal;
begin
  ExpectedMembers(AIndexes);
  for Index := 0 to High(AIndexes) do
  begin
    DataTemplate := AIndexes[Index].DataTemplate;
    IndexTemplate := AIndexes[Index].IndexTemplate;
    if (Length(DataTemplate) < $80) or
      (Length(IndexTemplate) < $58) then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Index template pair %s/%s is truncated.',
        [AIndexes[Index].DataExtension, AIndexes[Index].IndexExtension]);
    Encryption := ReadUInt32LE(DataTemplate, $25);
    if Encryption = $FF00FF00 then
      Encryption := ReadUInt32LE(DataTemplate, $5C);
    if Encryption <> 0 then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Encrypted index template %s is not supported.',
        [AIndexes[Index].DataExtension]);
    Encryption := ReadUInt32LE(IndexTemplate, $25);
    if Encryption = $FF00FF00 then
      Encryption := ReadUInt32LE(IndexTemplate, $5C);
    if Encryption <> 0 then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Encrypted index template %s is not supported.',
        [AIndexes[Index].IndexExtension]);
    HeaderFieldCount := ReadUInt16LE(DataTemplate, $21);
    HeaderKeyFieldCount := ReadUInt16LE(DataTemplate, $23);
    KeyFieldCount := Length(AIndexes[Index].KeyFieldIndexes);
    if (HeaderFieldCount <> KeyFieldCount + 1) or
      (HeaderKeyFieldCount <> KeyFieldCount) then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Index template %s has a different key-field count.',
        [AIndexes[Index].DataExtension]);
    if (DataTemplate[4] = 5) <> SameText(AIndexes[Index].DataExtension, '.X02') or
      ((DataTemplate[4] = 5) and (AIndexes[Index].IndexTemplate[4] <> 4)) or
      ((DataTemplate[4] = 8) and (AIndexes[Index].IndexTemplate[4] <> 7)) or
      ((DataTemplate[4] <> 5) and (DataTemplate[4] <> 8)) then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Index template %s/%s has an unsupported file-type pair.',
        [AIndexes[Index].DataExtension, AIndexes[Index].IndexExtension]);

    KeyLength := 0;
    FieldOffset := $78;
    for FieldIndex := 0 to KeyFieldCount - 1 do
    begin
      if (AIndexes[Index].KeyFieldIndexes[FieldIndex] < 0) or
        (AIndexes[Index].KeyFieldIndexes[FieldIndex] >= Length(AFields)) then
        raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
          'Index %s references an out-of-range table field.',
          [AIndexes[Index].DataExtension]);
      for OtherFieldIndex := 0 to FieldIndex - 1 do
        if AIndexes[Index].KeyFieldIndexes[FieldIndex] =
          AIndexes[Index].KeyFieldIndexes[OtherFieldIndex] then
          raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
            'Index %s repeats a key field.',
            [AIndexes[Index].DataExtension]);
      if (DataTemplate[FieldOffset + FieldIndex * 2] <>
        AFields[AIndexes[Index].KeyFieldIndexes[FieldIndex]].TypeCode) or
        (DataTemplate[FieldOffset + FieldIndex * 2 + 1] <>
        AFields[AIndexes[Index].KeyFieldIndexes[FieldIndex]].Length) then
        raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
          'Index %s key metadata does not match table field %s.',
          [AIndexes[Index].DataExtension,
           AFields[AIndexes[Index].KeyFieldIndexes[FieldIndex]].Name]);
      Inc(KeyLength, AFields[
        AIndexes[Index].KeyFieldIndexes[FieldIndex]].Length);
    end;
    if ReadUInt16LE(IndexTemplate, 0) <>
      KeyLength + 6 then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Index %s YG record width does not match its XG key.',
        [AIndexes[Index].DataExtension]);
    IndexFieldCount := ReadUInt16LE(IndexTemplate, $21);
    if (IndexFieldCount <> KeyFieldCount) or
      (SizeInt($58) + KeyFieldCount * 2 > Length(IndexTemplate)) then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Index %s YG field count does not match its XG key.',
        [AIndexes[Index].DataExtension]);
    FieldOffset := $58;
    for FieldIndex := 0 to KeyFieldCount - 1 do
    begin
      if (IndexTemplate[FieldOffset] <>
        AFields[AIndexes[Index].KeyFieldIndexes[FieldIndex]].TypeCode) or
        (IndexTemplate[FieldOffset + 1] <>
        AFields[AIndexes[Index].KeyFieldIndexes[FieldIndex]].Length) then
        raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
          'Index %s YG field %d does not match its XG key.',
          [AIndexes[Index].DataExtension, FieldIndex]);
      Inc(FieldOffset, 2);
    end;
  end;
end;

function BuildSortedSourceRows(const ADatabaseTemplate: TBytes;
  const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
  const ARows: TDBParadoxTableRows): TEncodedSourceRows;
var
  RecordSize, RecordsPerBlock, BlockSize, KeyOffset: SizeInt;
  FieldIndex, RowIndex, InsertAt: SizeInt;
  Encoded: TBytes;
  Item: TEncodedSourceRow;
begin
  if (APrimaryKeyFieldIndex < 0) or
    (APrimaryKeyFieldIndex >= Length(AFields)) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The configured primary-key field index is invalid.');
  if Length(ARows) = 0 then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'A secondary family requires at least one table row.');
  if Length(ADatabaseTemplate) < $7A then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The database template is truncated.');

  RecordSize := ReadUInt16LE(ADatabaseTemplate, 0);
  BlockSize := SizeInt(ADatabaseTemplate[5]) * 1024;
  if (RecordSize <= 0) or (BlockSize <= 6) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The database template has invalid block dimensions.');
  RecordsPerBlock := (BlockSize - 6) div RecordSize - 1;
  if RecordsPerBlock <= 0 then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The database template cannot hold a data record.');
  KeyOffset := 0;
  for FieldIndex := 0 to APrimaryKeyFieldIndex - 1 do
    Inc(KeyOffset, AFields[FieldIndex].Length);

  Result := nil;
  SetLength(Result, Length(ARows));
  for RowIndex := 0 to High(ARows) do
  begin
    Encoded := EncodeDBParadoxRecord(AFields, ARows[RowIndex]);
    if Length(Encoded) <> RecordSize then
      raise EDBParadoxSecondaryFamilyValidationError.Create(
        'Encoded table row width differs from the database template.');
    Result[RowIndex].Data := Encoded;
    Result[RowIndex].PrimaryKey := Copy(Encoded, KeyOffset,
      AFields[APrimaryKeyFieldIndex].Length);
  end;

  for RowIndex := 1 to High(Result) do
  begin
    Item := Result[RowIndex];
    InsertAt := RowIndex;
    while (InsertAt > 0) and
      (CompareBytes(Result[InsertAt - 1].PrimaryKey, Item.PrimaryKey) > 0) do
    begin
      Result[InsertAt] := Result[InsertAt - 1];
      Dec(InsertAt);
    end;
    Result[InsertAt] := Item;
  end;
  for RowIndex := 1 to High(Result) do
    if CompareBytes(Result[RowIndex - 1].PrimaryKey,
      Result[RowIndex].PrimaryKey) = 0 then
      raise EDBParadoxSecondaryFamilyValidationError.Create(
        'Primary-key values must be unique.');
  for RowIndex := 0 to High(Result) do
    Result[RowIndex].SourceBlock := RowIndex div RecordsPerBlock + 1;
end;

function BuildSecondaryRecords(const AFields: TDBParadoxRecordFields;
  const AIndexes: TDBParadoxSecondaryFamilyIndexes;
  const ASourceRows: TEncodedSourceRows;
  AIndexIndex: SizeInt): TDBParadoxSecondaryRecords;
var
  RowIndex, KeyFieldIndex, FieldOffset, KeyLength, Index,
    DestinationOffset: SizeInt;
begin
  KeyLength := 0;
  for Index := 0 to High(AIndexes[AIndexIndex].KeyFieldIndexes) do
    Inc(KeyLength,
      AFields[AIndexes[AIndexIndex].KeyFieldIndexes[Index]].Length);
  Result := nil;
  SetLength(Result, Length(ASourceRows));
  for RowIndex := 0 to High(ASourceRows) do
  begin
    SetLength(Result[RowIndex].Key, KeyLength);
    DestinationOffset := 0;
    for Index := 0 to High(AIndexes[AIndexIndex].KeyFieldIndexes) do
    begin
      KeyFieldIndex := AIndexes[AIndexIndex].KeyFieldIndexes[Index];
      FieldOffset := 0;
      for KeyFieldIndex := 0 to AIndexes[AIndexIndex].KeyFieldIndexes[Index] - 1 do
        Inc(FieldOffset, AFields[KeyFieldIndex].Length);
      KeyFieldIndex := AIndexes[AIndexIndex].KeyFieldIndexes[Index];
      Move(ASourceRows[RowIndex].Data[FieldOffset],
        Result[RowIndex].Key[DestinationOffset],
        AFields[KeyFieldIndex].Length);
      Inc(DestinationOffset, AFields[KeyFieldIndex].Length);
    end;
    Result[RowIndex].DataBlockNumber := ASourceRows[RowIndex].SourceBlock;
  end;
end;

procedure BuildFamilyFiles(const ADatabaseTemplate, APrimaryIndexTemplate: TBytes;
  const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
  const ARows: TDBParadoxTableRows;
  const AIndexes: TDBParadoxSecondaryFamilyIndexes;
  out ADatabaseFile, APrimaryIndexFile: TBytes;
  out ASecondaryFiles: array of TDBParadoxBuiltSecondaryIndex);
var
  TableFiles: TDBParadoxBuiltFiles;
  SourceRows: TEncodedSourceRows;
  Records: TDBParadoxSecondaryRecords;
  Index: SizeInt;
begin
  if Length(ASecondaryFiles) <> Length(AIndexes) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'Secondary-family output storage has an invalid size.');
  ValidateIndexDefinitions(AFields, AIndexes);
  TableFiles := BuildDBParadoxTableFiles(ADatabaseTemplate,
    APrimaryIndexTemplate, AFields, APrimaryKeyFieldIndex, ARows);
  SourceRows := BuildSortedSourceRows(ADatabaseTemplate, AFields,
    APrimaryKeyFieldIndex, ARows);
  ADatabaseFile := TableFiles.DatabaseFile;
  APrimaryIndexFile := TableFiles.PrimaryIndexFile;
  if Length(APrimaryIndexFile) <= $2C then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The generated primary index has no revision marker.');
  for Index := 0 to High(AIndexes) do
  begin
    Records := BuildSecondaryRecords(AFields, AIndexes, SourceRows, Index);
    ASecondaryFiles[Index] := BuildDBParadoxSecondaryIndexFiles(
      AIndexes[Index].DataTemplate, AIndexes[Index].IndexTemplate,
      APrimaryIndexFile[$2C], Records);
  end;
end;

procedure ValidateDatabaseRows(const AFileName: string;
  const AFields: TDBParadoxRecordFields; const ARows: TDBParadoxTableRows);
var
  ActualFields: TDBParadoxFileFields;
  ActualRows: TDBParadoxFileRows;
  RecordSize: Integer;
  ExpectedRow, Encoded: TBytes;
  Seen: array of Boolean;
  RowIndex, ActualIndex: SizeInt;
  Found: Boolean;
begin
  ReadDBParadoxTable(AFileName, ActualFields, ActualRows, RecordSize);
  if not SameSchema(AFields, ActualFields) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The staged table schema does not match the expected schema.');
  if Length(ActualRows) <> Length(ARows) then
    raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
      'The staged table contains %d rows; expected %d.',
      [Length(ActualRows), Length(ARows)]);
  Seen := nil;
  SetLength(Seen, Length(ActualRows));
  for RowIndex := 0 to High(ARows) do
  begin
    ExpectedRow := EncodeDBParadoxRecord(AFields, ARows[RowIndex]);
    Found := False;
    for ActualIndex := 0 to High(ActualRows) do
      if not Seen[ActualIndex] then
      begin
        Encoded := ActualRows[ActualIndex].Data;
        if SameBytes(ExpectedRow, Encoded) then
        begin
          Seen[ActualIndex] := True;
          Found := True;
          Break;
        end;
      end;
    if not Found then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Expected table row %d is missing or differs in the staged file.',
        [RowIndex]);
  end;
end;

constructor TDBParadoxSecondaryFamilyStageBuilder.Create(
  const ADatabaseTemplate, APrimaryIndexTemplate: TBytes;
  const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
  const ARows: TDBParadoxTableRows;
  const AIndexes: TDBParadoxSecondaryFamilyIndexes);
begin
  inherited Create;
  FDatabaseTemplate := CopyBytes(ADatabaseTemplate);
  FPrimaryIndexTemplate := CopyBytes(APrimaryIndexTemplate);
  FFields := CopyFields(AFields);
  FPrimaryKeyFieldIndex := APrimaryKeyFieldIndex;
  FRows := CopyRows(ARows);
  FIndexes := CopyIndexes(AIndexes);
end;

procedure TDBParadoxSecondaryFamilyStageBuilder.BuildFiles;
begin
  SetLength(FSecondaryFiles, Length(FIndexes));
  BuildFamilyFiles(FDatabaseTemplate, FPrimaryIndexTemplate, FFields,
    FPrimaryKeyFieldIndex, FRows, FIndexes, FDatabaseFile,
    FPrimaryIndexFile, FSecondaryFiles);
end;

procedure TDBParadoxSecondaryFamilyStageBuilder.BeginBuild(
  const AStageDirectory, ATableBaseName: string;
  const AMembers: TDBParadoxFamilyMembers);
var
  Members: TDBParadoxFamilyMembers;
begin
  if FBuildActive then
    raise EDBParadoxPublicationError.Create(
      'A secondary-family build is already active.');
  if (Trim(AStageDirectory) = '') or (Trim(ATableBaseName) = '') then
    raise EDBParadoxPublicationError.Create(
      'A staging directory and table base name are required.');
  Members := ExpectedMembers(FIndexes);
  if not SameMembers(Members, AMembers) then
    raise EDBParadoxPublicationError.Create(
      'The requested family does not match the configured secondary indexes.');
  SetLength(FWrittenMembers, Length(Members));
  FillChar(FWrittenMembers[0], Length(FWrittenMembers) * SizeOf(Boolean), 0);
  BuildFiles;
  FBuildActive := True;
end;

procedure TDBParadoxSecondaryFamilyStageBuilder.BuildMember(
  const AStageDirectory, ATableBaseName, AMember: string);
var
  MemberIndex, Index: SizeInt;
  Data: TBytes;
begin
  if not FBuildActive then
    raise EDBParadoxPublicationError.Create(
      'A secondary-family build is not active.');
  if SameText(AMember, '.DB') then
  begin
    MemberIndex := 0;
    Data := FDatabaseFile;
  end
  else if SameText(AMember, '.PX') then
  begin
    MemberIndex := 1;
    Data := FPrimaryIndexFile;
  end
  else
  begin
    MemberIndex := -1;
    for Index := 0 to High(FIndexes) do
      if SameText(AMember, FIndexes[Index].DataExtension) or
        SameText(AMember, FIndexes[Index].IndexExtension) then
      begin
        MemberIndex := 2 + Index * 2;
        if SameText(AMember, FIndexes[Index].IndexExtension) then
          Inc(MemberIndex);
        Data := FSecondaryFiles[Index].DataFile;
        if SameText(AMember, FIndexes[Index].IndexExtension) then
          Data := FSecondaryFiles[Index].IndexFile;
        Break;
      end;
  end;
  if (MemberIndex < 0) or (MemberIndex >= Length(FWrittenMembers)) then
    raise EDBParadoxPublicationError.CreateFmt(
      'The secondary-family builder cannot write member "%s".', [AMember]);
  if FWrittenMembers[MemberIndex] then
    raise EDBParadoxPublicationError.CreateFmt(
      'The secondary-family member "%s" was requested more than once.',
      [AMember]);
  WriteFileBytes(IncludeTrailingPathDelimiter(AStageDirectory) +
    ATableBaseName + AMember, Data);
  FWrittenMembers[MemberIndex] := True;
end;

procedure TDBParadoxSecondaryFamilyStageBuilder.EndBuild;
var
  Index: SizeInt;
begin
  if not FBuildActive then
    raise EDBParadoxPublicationError.Create(
      'A secondary-family build is not active.');
  for Index := 0 to High(FWrittenMembers) do
    if not FWrittenMembers[Index] then
      raise EDBParadoxPublicationError.Create(
        'The secondary-family build did not write every member.');
  FBuildActive := False;
end;

procedure TDBParadoxSecondaryFamilyStageBuilder.AbortBuild;
begin
  FBuildActive := False;
end;

constructor TDBParadoxSecondaryFamilyValidator.Create(
  const ADatabaseTemplate, APrimaryIndexTemplate: TBytes;
  const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
  const ARows: TDBParadoxTableRows;
  const AIndexes: TDBParadoxSecondaryFamilyIndexes);
begin
  inherited Create;
  FDatabaseTemplate := CopyBytes(ADatabaseTemplate);
  FPrimaryIndexTemplate := CopyBytes(APrimaryIndexTemplate);
  FFields := CopyFields(AFields);
  FPrimaryKeyFieldIndex := APrimaryKeyFieldIndex;
  FRows := CopyRows(ARows);
  FIndexes := CopyIndexes(AIndexes);
end;

procedure TDBParadoxSecondaryFamilyValidator.Validate(
  const AStageDirectory, ATableBaseName: string;
  const AMembers: TDBParadoxFamilyMembers);
var
  Expected: TDBParadoxFamilyMembers;
  ExpectedDatabase, ExpectedPrimary: TBytes;
  ActualIndex: TBytes;
  ExpectedSecondary: array of TDBParadoxBuiltSecondaryIndex;
  Index: SizeInt;
  BasePath: string;
  Actual: TBytes;
  PrimaryRevision: Byte;
  TableDataBlockCount: Integer;
begin
  Expected := ExpectedMembers(FIndexes);
  if not SameMembers(Expected, AMembers) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The staged member set does not match the configured secondary indexes.');
  ValidateDatabaseRows(IncludeTrailingPathDelimiter(AStageDirectory) +
    ATableBaseName + '.DB', FFields, FRows);
  SetLength(ExpectedSecondary, Length(FIndexes));
  BuildFamilyFiles(FDatabaseTemplate, FPrimaryIndexTemplate, FFields,
    FPrimaryKeyFieldIndex, FRows, FIndexes, ExpectedDatabase,
    ExpectedPrimary, ExpectedSecondary);
  if Length(ExpectedPrimary) <= $2C then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The generated primary index does not contain a revision marker.');
  PrimaryRevision := ExpectedPrimary[$2C];
  TableDataBlockCount := ReadUInt16LE(ExpectedDatabase, $0C);
  BasePath := IncludeTrailingPathDelimiter(AStageDirectory) + ATableBaseName;
  Actual := ReadFileBytes(BasePath + '.DB');
  if not SameBytes(ExpectedDatabase, Actual) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The staged .DB differs from the expected table build.');
  Actual := ReadFileBytes(BasePath + '.PX');
  if not SameBytes(ExpectedPrimary, Actual) then
    raise EDBParadoxSecondaryFamilyValidationError.Create(
      'The staged .PX differs from the expected primary-index build.');
  for Index := 0 to High(FIndexes) do
  begin
    Actual := ReadFileBytes(BasePath + FIndexes[Index].DataExtension);
    ActualIndex := ReadFileBytes(BasePath + FIndexes[Index].IndexExtension);
    ValidateDBParadoxSecondaryIndexFiles(FIndexes[Index].DataTemplate,
      FIndexes[Index].IndexTemplate, Actual, ActualIndex, PrimaryRevision,
      TableDataBlockCount);
    if not SameBytes(ExpectedSecondary[Index].DataFile, Actual) then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Staged member %s differs from the expected secondary-index build.',
        [FIndexes[Index].DataExtension]);
    if not SameBytes(ExpectedSecondary[Index].IndexFile, ActualIndex) then
      raise EDBParadoxSecondaryFamilyValidationError.CreateFmt(
        'Staged member %s differs from the expected secondary-index build.',
        [FIndexes[Index].IndexExtension]);
  end;
end;

end.
