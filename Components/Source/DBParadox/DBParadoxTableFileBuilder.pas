unit DBParadoxTableFileBuilder;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxRecordEncoder;

type
  EDBParadoxTableBuildError = class(Exception);
  EDBParadoxUnsupportedTableFeature = class(EDBParadoxTableBuildError);

  TDBParadoxTableRows = array of TDBParadoxRecordValues;

  TDBParadoxBuiltFiles = record
    DatabaseFile: TBytes;
    PrimaryIndexFile: TBytes;
  end;

function BuildDBParadoxTableFiles(const EmptyDatabaseTemplate,
  EmptyPrimaryIndexTemplate: TBytes;
  const Fields: TDBParadoxRecordFields;
  PrimaryKeyFieldIndex: SizeInt;
  const Rows: TDBParadoxTableRows): TDBParadoxBuiltFiles;

implementation

uses
  DBParadoxIndexFileBuilder;

const
  ParadoxAutoIncrement = $16;
  DataHeaderSize = $78;
  DataBlockHeaderSize = 6;
  AutoIncrementOffset = $49;
  EncryptionMarker = $FF00FF00;

type
  TTableHeader = record
    RecordSize: Integer;
    RecordCount: Integer;
    BlockCount: Integer;
    FirstBlock: Integer;
    LastBlock: Integer;
    MaximumTableSize: Integer;
    FieldCount: Integer;
    PrimaryKeyFieldCount: Integer;
    HeaderSize: Integer;
  end;

  TEncodedRecord = record
    Data: TBytes;
    Key: TBytes;
  end;

  TEncodedRecords = array of TEncodedRecord;

function ReadUInt16LE(const Data: TBytes; Offset: SizeInt): Word;
begin
  Result := Word(Data[Offset]) or (Word(Data[Offset + 1]) shl 8);
end;

function ReadUInt32LE(const Data: TBytes; Offset: SizeInt): Cardinal;
begin
  Result := Cardinal(Data[Offset]) or
    (Cardinal(Data[Offset + 1]) shl 8) or
    (Cardinal(Data[Offset + 2]) shl 16) or
    (Cardinal(Data[Offset + 3]) shl 24);
end;

function ReadInt32LE(const Data: TBytes; Offset: SizeInt): LongInt;
begin
  Result := LongInt(ReadUInt32LE(Data, Offset));
end;

procedure WriteUInt16LE(var Data: TBytes; Offset: SizeInt; Value: Word);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
end;

procedure WriteInt16LE(var Data: TBytes; Offset: SizeInt; Value: SmallInt);
begin
  WriteUInt16LE(Data, Offset, Word(Value));
end;

procedure WriteUInt32LE(var Data: TBytes; Offset: SizeInt; Value: Cardinal);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
  Data[Offset + 2] := Byte(Value shr 16);
  Data[Offset + 3] := Byte(Value shr 24);
end;

procedure WriteInt32LE(var Data: TBytes; Offset: SizeInt; Value: LongInt);
begin
  WriteUInt32LE(Data, Offset, Cardinal(Value));
end;

function ReadEncryption(const Data: TBytes): Cardinal;
begin
  Result := ReadUInt32LE(Data, $25);
  if Result = EncryptionMarker then
    Result := ReadUInt32LE(Data, $5C);
end;

function ReadTableHeader(const Data: TBytes; ExpectedFileType: Byte;
  const Description: string): TTableHeader;
var
  BlockSize: Int64;
  MinimumHeaderSize: Integer;
begin
  if ExpectedFileType in [0, 2, 6, 8] then
    MinimumHeaderSize := DataHeaderSize
  else
    MinimumHeaderSize := $58;
  if (Length(Data) < MinimumHeaderSize) or
    (Data[4] <> ExpectedFileType) then
    raise EDBParadoxTableBuildError.CreateFmt(
      'The %s Paradox header is invalid.', [Description]);

  Result.RecordSize := ReadUInt16LE(Data, 0);
  Result.RecordCount := ReadInt32LE(Data, 6);
  Result.BlockCount := ReadUInt16LE(Data, $0C);
  Result.FirstBlock := ReadUInt16LE(Data, $0E);
  Result.LastBlock := ReadUInt16LE(Data, $10);
  Result.MaximumTableSize := Data[5];
  Result.FieldCount := ReadUInt16LE(Data, $21);
  Result.PrimaryKeyFieldCount := ReadUInt16LE(Data, $23);
  Result.HeaderSize := ReadUInt16LE(Data, 2);

  if (Result.RecordSize <= 0) or (Result.RecordCount < 0) or
    (Result.MaximumTableSize < 1) or (Result.MaximumTableSize > 32) or
    (Result.FieldCount <= 0) or (Result.FieldCount > 256) or
    (Result.HeaderSize < MinimumHeaderSize) or
    (Result.HeaderSize > Length(Data)) then
    raise EDBParadoxTableBuildError.CreateFmt(
      'The %s Paradox dimensions are invalid.', [Description]);

  BlockSize := Int64(Result.MaximumTableSize) * 1024;
  if Int64(Result.BlockCount) >
    (Int64(Length(Data)) - Result.HeaderSize) div BlockSize then
    raise EDBParadoxTableBuildError.CreateFmt(
      'The %s Paradox file is missing declared data blocks.', [Description]);
end;

function ReadAsciiFieldName(const Data: TBytes; var Offset: SizeInt;
  HeaderSize: SizeInt): string;
var
  StartOffset: SizeInt;
begin
  Result := '';
  StartOffset := Offset;
  while (Offset < HeaderSize) and (Data[Offset] <> 0) do
  begin
    if Data[Offset] > $7F then
      raise EDBParadoxTableBuildError.Create(
        'The Paradox schema contains a non-ASCII field name.');
    Inc(Offset);
  end;
  if Offset >= HeaderSize then
    raise EDBParadoxTableBuildError.Create(
      'The Paradox schema contains an unterminated field name.');
  SetLength(Result, Offset - StartOffset);
  if Length(Result) > 0 then
    Move(Data[StartOffset], Result[1], Length(Result));
  Inc(Offset);
end;

procedure ValidateTableTemplateFields(const DatabaseTemplate: TBytes;
  const Header: TTableHeader; const Fields: TDBParadoxRecordFields);
var
  Version, StoredLength: Byte;
  DataHeaderOffset, TableNameLength, DescriptorOffset,
    TableNameOffset, FieldNamesOffset, NameOffset: SizeInt;
  FieldIndex, FieldLength: SizeInt;
  FieldName: string;
begin
  Version := DatabaseTemplate[$39];
  if (Version <> $0B) and (Version <> $0C) then
    raise EDBParadoxUnsupportedTableFeature.CreateFmt(
      'Paradox table version 0x%.2x is not supported.',
      [Version]);
  DataHeaderOffset := DataHeaderSize;
  if Version = $0C then
    TableNameLength := 261
  else
    TableNameLength := 79;
  TableNameOffset := DataHeaderOffset + Header.FieldCount * 2 + 4 +
    Header.FieldCount * 4;
  FieldNamesOffset := TableNameOffset + TableNameLength;
  if FieldNamesOffset > Header.HeaderSize then
    raise EDBParadoxTableBuildError.Create(
      'The Paradox field-name table exceeds the database template header.');

  NameOffset := FieldNamesOffset;
  for FieldIndex := 0 to High(Fields) do
  begin
    DescriptorOffset := DataHeaderOffset + FieldIndex * 2;
    StoredLength := DatabaseTemplate[DescriptorOffset + 1];
    if DatabaseTemplate[DescriptorOffset] = $17 then
      FieldLength := 17
    else
      FieldLength := StoredLength;
    if (DatabaseTemplate[DescriptorOffset] <> Fields[FieldIndex].TypeCode) or
      (FieldLength <> Fields[FieldIndex].Length) then
      raise EDBParadoxTableBuildError.CreateFmt(
        'Field %d metadata does not match the database template.',
        [FieldIndex]);

    FieldName := ReadAsciiFieldName(
      DatabaseTemplate, NameOffset, Header.HeaderSize);
    if not SameText(FieldName, Fields[FieldIndex].Name) then
      raise EDBParadoxTableBuildError.CreateFmt(
        'Field %d name "%s" does not match the database template.',
        [FieldIndex, Fields[FieldIndex].Name]);
  end;
end;

function CompareBytes(const Left, Right: TBytes): Integer;
var
  Index, CommonLength: SizeInt;
begin
  CommonLength := Length(Left);
  if Length(Right) < CommonLength then
    CommonLength := Length(Right);
  for Index := 0 to CommonLength - 1 do
    if Left[Index] <> Right[Index] then
      Exit(Integer(Left[Index]) - Integer(Right[Index]));
  Result := Length(Left) - Length(Right);
end;

procedure SortEncodedRecords(var Records: TEncodedRecords;
  Left, Right: SizeInt);
var
  I, J: SizeInt;
  Pivot: TBytes;
  Temporary: TEncodedRecord;
begin
  while Left < Right do
  begin
    I := Left;
    J := Right;
    Pivot := Records[Left + (Right - Left) div 2].Key;
    repeat
      while CompareBytes(Records[I].Key, Pivot) < 0 do
        Inc(I);
      while CompareBytes(Records[J].Key, Pivot) > 0 do
        Dec(J);
      if I <= J then
      begin
        Temporary := Records[I];
        Records[I] := Records[J];
        Records[J] := Temporary;
        Inc(I);
        Dec(J);
      end;
    until I > J;

    if (J - Left) < (Right - I) then
    begin
      if Left < J then
        SortEncodedRecords(Records, Left, J);
      Left := I;
    end
    else
    begin
      if I < Right then
        SortEncodedRecords(Records, I, Right);
      Right := J;
    end;
  end;
end;

function ParseAutoIncrement(const Value, FieldName: UnicodeString): Cardinal;
var
  Index: SizeInt;
  Digit: Integer;
  Number: Cardinal;
begin
  if Value = '' then
    Exit(0);
  Number := 0;
  for Index := 1 to Length(Value) do
  begin
    Digit := Ord(Value[Index]) - Ord('0');
    if (Digit < 0) or (Digit > 9) or
      (Number > (Cardinal(High(LongInt)) - Cardinal(Digit)) div 10) then
      raise EDBParadoxTableBuildError.CreateFmt(
        'Auto-increment field "%s" requires a positive integer.',
        [FieldName]);
    Number := Number * 10 + Cardinal(Digit);
  end;
  if Number = 0 then
    raise EDBParadoxTableBuildError.CreateFmt(
      'Auto-increment field "%s" requires a positive integer.',
      [FieldName]);
  Result := Number;
end;

function ResolveAutoIncrementRows(const Fields: TDBParadoxRecordFields;
  const DatabaseTemplate: TBytes; const Rows: TDBParadoxTableRows;
  out LastIssued: Cardinal): TDBParadoxTableRows;
var
  AutoFieldIndex, FieldIndex, RowIndex: SizeInt;
  Value: UnicodeString;
begin
  AutoFieldIndex := -1;
  for FieldIndex := 0 to High(Fields) do
    if Fields[FieldIndex].TypeCode = ParadoxAutoIncrement then
    begin
      if AutoFieldIndex <> -1 then
        raise EDBParadoxUnsupportedTableFeature.Create(
          'Only one auto-increment field per table is supported.');
      AutoFieldIndex := FieldIndex;
    end;

  LastIssued := ReadUInt32LE(DatabaseTemplate, AutoIncrementOffset);
  Result := nil;
  if AutoFieldIndex = -1 then
    Exit(Copy(Rows, 0, Length(Rows)));

  SetLength(Result, Length(Rows));
  for RowIndex := 0 to High(Rows) do
    Result[RowIndex] := Copy(Rows[RowIndex], 0, Length(Rows[RowIndex]));

  for RowIndex := 0 to High(Result) do
  begin
    Value := Result[RowIndex][AutoFieldIndex];
    if Trim(Value) = '' then
    begin
      if LastIssued >= Cardinal(High(LongInt)) then
        raise EDBParadoxTableBuildError.CreateFmt(
          'Auto-increment field "%s" has exhausted its range.',
          [Fields[AutoFieldIndex].Name]);
      Inc(LastIssued);
      Result[RowIndex][AutoFieldIndex] := UnicodeString(IntToStr(LastIssued));
    end
    else
      ParseAutoIncrement(Value, UnicodeString(Fields[AutoFieldIndex].Name));
  end;
end;

procedure ValidateFields(const Fields: TDBParadoxRecordFields;
  const Header: TTableHeader; PrimaryKeyFieldIndex: SizeInt);
var
  FieldIndex, OtherFieldIndex, RecordSize: SizeInt;
begin
  if Length(Fields) <> Header.FieldCount then
    raise EDBParadoxTableBuildError.Create(
      'The field definition count does not match the table template.');
  if (PrimaryKeyFieldIndex < 0) or
    (PrimaryKeyFieldIndex >= Length(Fields)) then
    raise EDBParadoxTableBuildError.Create(
      'The primary-key field index is outside the field definition list.');

  RecordSize := 0;
  for FieldIndex := 0 to High(Fields) do
  begin
    if (Trim(Fields[FieldIndex].Name) = '') or
      (Fields[FieldIndex].Length <= 0) then
      raise EDBParadoxTableBuildError.Create(
        'A table field has an empty name or invalid physical width.');
    for OtherFieldIndex := 0 to FieldIndex - 1 do
      if SameText(Fields[FieldIndex].Name, Fields[OtherFieldIndex].Name) then
        raise EDBParadoxTableBuildError.CreateFmt(
          'The table contains duplicate field name "%s".',
          [Fields[FieldIndex].Name]);
    if ((Fields[FieldIndex].TypeCode = $17) and
      (Fields[FieldIndex].Length <> 17)) or
      ((Fields[FieldIndex].TypeCode <> $17) and
      (Fields[FieldIndex].Length > High(Byte))) then
      raise EDBParadoxTableBuildError.CreateFmt(
        'Field "%s" has a width that cannot be represented in its Paradox descriptor.',
        [Fields[FieldIndex].Name]);
    Inc(RecordSize, Fields[FieldIndex].Length);
  end;
  if RecordSize <> Header.RecordSize then
    raise EDBParadoxTableBuildError.Create(
      'The field widths do not match the table template record size.');
end;

procedure ValidateEmptyTemplates(const DatabaseTemplate,
  PrimaryIndexTemplate: TBytes; const DatabaseHeader,
  PrimaryIndexHeader: TTableHeader; const Fields: TDBParadoxRecordFields;
  PrimaryKeyFieldIndex: SizeInt);
var
  PrimaryField: TDBParadoxRecordField;
begin
  if (DatabaseHeader.RecordCount <> 0) or
    (DatabaseHeader.BlockCount <> 0) or
    (DatabaseHeader.FirstBlock <> 0) or
    (DatabaseHeader.LastBlock <> 0) or
    (Length(DatabaseTemplate) <> DatabaseHeader.HeaderSize) then
    raise EDBParadoxTableBuildError.Create(
      'The writer requires a valid empty table template without data blocks.');
  if DatabaseHeader.PrimaryKeyFieldCount <> 1 then
    raise EDBParadoxUnsupportedTableFeature.Create(
      'Only a single-field primary key is supported.');
  if (PrimaryIndexHeader.RecordCount <> 0) or
    (PrimaryIndexHeader.BlockCount <> 0) or
    (PrimaryIndexHeader.FirstBlock <> 0) or
    (PrimaryIndexHeader.LastBlock <> 0) or
    (Length(PrimaryIndexTemplate) <> PrimaryIndexHeader.HeaderSize) then
    raise EDBParadoxTableBuildError.Create(
      'The writer requires a valid empty primary-index template.');
  if (PrimaryIndexHeader.FieldCount <> 1) or
    (PrimaryIndexHeader.RecordSize <>
      Fields[PrimaryKeyFieldIndex].Length + DataBlockHeaderSize) then
    raise EDBParadoxTableBuildError.Create(
      'The primary-index template does not match the selected key field.');

  PrimaryField := Fields[PrimaryKeyFieldIndex];
  if (PrimaryField.Length > High(Byte)) or
    (PrimaryIndexTemplate[$58] <> PrimaryField.TypeCode) or
    (PrimaryIndexTemplate[$59] <> PrimaryField.Length) then
    raise EDBParadoxTableBuildError.Create(
      'The primary-index field metadata does not match the table schema.');
  if (ReadEncryption(DatabaseTemplate) <> 0) or
    (ReadEncryption(PrimaryIndexTemplate) <> 0) then
    raise EDBParadoxUnsupportedTableFeature.Create(
      'Encrypted table and primary-index templates are not supported.');
end;

procedure UpdateDatabaseHeader(var Data: TBytes; RecordCount,
  BlockCount: Integer);
begin
  if (Length(Data) < $4D) or (RecordCount <= 0) or
    (BlockCount <= 0) or (BlockCount > High(Word)) then
    raise EDBParadoxTableBuildError.Create(
      'Paradox table header dimensions exceed the supported range.');

  WriteInt32LE(Data, 6, RecordCount);
  WriteUInt16LE(Data, $0A, Word(BlockCount));
  WriteUInt16LE(Data, $0C, Word(BlockCount));
  WriteUInt16LE(Data, $0E, 1);
  WriteUInt16LE(Data, $10, Word(BlockCount));
  WriteUInt16LE(Data, $3A, Word(BlockCount));
  Data[$2D] := Byte((Integer(Data[$2D]) + 1) and $FF);
end;

function BuildTableBlock(const Records: TEncodedRecords; StartIndex,
  RecordCount, BlockNumber, BlockCount, RecordSize,
  BlockSize: Integer): TBytes;
var
  RecordIndex, Offset: Integer;
begin
  if (RecordCount <= 0) or
    ((RecordCount - 1) * RecordSize > High(SmallInt)) then
    raise EDBParadoxTableBuildError.Create(
      'A table data block has an invalid record count.');
  Result := nil;
  SetLength(Result, BlockSize);
  if BlockNumber < BlockCount then
    WriteUInt16LE(Result, 0, Word(BlockNumber + 1))
  else
    WriteUInt16LE(Result, 0, 0);
  WriteUInt16LE(Result, 2, Word(BlockNumber - 1));
  WriteInt16LE(Result, 4, SmallInt((RecordCount - 1) * RecordSize));

  Offset := DataBlockHeaderSize;
  for RecordIndex := StartIndex to StartIndex + RecordCount - 1 do
  begin
    if Length(Records[RecordIndex].Data) <> RecordSize then
      raise EDBParadoxTableBuildError.Create(
        'An encoded row does not match the table record size.');
    Move(Records[RecordIndex].Data[0], Result[Offset], RecordSize);
    Inc(Offset, RecordSize);
  end;
end;

function BuildDBParadoxTableFiles(const EmptyDatabaseTemplate,
  EmptyPrimaryIndexTemplate: TBytes;
  const Fields: TDBParadoxRecordFields;
  PrimaryKeyFieldIndex: SizeInt;
  const Rows: TDBParadoxTableRows): TDBParadoxBuiltFiles;
var
  DatabaseHeader, PrimaryIndexHeader: TTableHeader;
  ResolvedRows: TDBParadoxTableRows;
  EncodedRecords: TEncodedRecords;
  IndexEntries: TDBParadoxIndexEntries;
  LastIssued: Cardinal;
  FieldIndex, RowIndex, KeyOffset, PhysicalCapacity,
    RecordsPerBlock, BlockCount, BlockIndex, StartIndex,
    RowsInBlock, BlockSize: Integer;
  TableBlock: TBytes;
  OutputSize: Int64;
  BlockOffset: SizeInt;
begin
  Result.DatabaseFile := nil;
  Result.PrimaryIndexFile := nil;
  if Length(Rows) = 0 then
    raise EDBParadoxTableBuildError.Create(
      'At least one row is required to build a Paradox table.');
  if Length(Rows) > High(Integer) then
    raise EDBParadoxUnsupportedTableFeature.Create(
      'The table record count exceeds the supported header range.');

  DatabaseHeader := ReadTableHeader(
    EmptyDatabaseTemplate, 0, 'database template');
  PrimaryIndexHeader := ReadTableHeader(
    EmptyPrimaryIndexTemplate, 1, 'primary-index template');
  ValidateFields(Fields, DatabaseHeader, PrimaryKeyFieldIndex);
  ValidateTableTemplateFields(
    EmptyDatabaseTemplate, DatabaseHeader, Fields);
  ValidateEmptyTemplates(
    EmptyDatabaseTemplate,
    EmptyPrimaryIndexTemplate,
    DatabaseHeader,
    PrimaryIndexHeader,
    Fields,
    PrimaryKeyFieldIndex);

  for RowIndex := 0 to High(Rows) do
    if Length(Rows[RowIndex]) <> Length(Fields) then
      raise EDBParadoxRecordEncodingError.Create(
        'The value count must match the field count.');

  ResolvedRows := ResolveAutoIncrementRows(
    Fields, EmptyDatabaseTemplate, Rows, LastIssued);
  EncodedRecords := nil;
  IndexEntries := nil;
  SetLength(EncodedRecords, Length(ResolvedRows));
  KeyOffset := 0;
  for FieldIndex := 0 to PrimaryKeyFieldIndex - 1 do
    Inc(KeyOffset, Fields[FieldIndex].Length);

  for RowIndex := 0 to High(ResolvedRows) do
  begin
    EncodedRecords[RowIndex].Data :=
      EncodeDBParadoxRecord(Fields, ResolvedRows[RowIndex]);
    EncodedRecords[RowIndex].Key := Copy(
      EncodedRecords[RowIndex].Data,
      KeyOffset,
      Fields[PrimaryKeyFieldIndex].Length);
  end;
  SortEncodedRecords(EncodedRecords, 0, High(EncodedRecords));
  for RowIndex := 1 to High(EncodedRecords) do
    if CompareBytes(
      EncodedRecords[RowIndex - 1].Key,
      EncodedRecords[RowIndex].Key) = 0 then
      raise EDBParadoxTableBuildError.Create(
        'Primary-key values must be unique.');

  BlockSize := DatabaseHeader.MaximumTableSize * 1024;
  PhysicalCapacity :=
    (BlockSize - DataBlockHeaderSize) div DatabaseHeader.RecordSize;
  if PhysicalCapacity <= 0 then
    raise EDBParadoxTableBuildError.Create(
      'A Paradox data block cannot contain one record.');
  RecordsPerBlock := PhysicalCapacity - 1;
  if RecordsPerBlock < 1 then
    RecordsPerBlock := 1;
  BlockCount := (Length(EncodedRecords) + RecordsPerBlock - 1) div
    RecordsPerBlock;
  if BlockCount > High(Word) then
    raise EDBParadoxUnsupportedTableFeature.Create(
      'The table requires more physical data blocks than Paradox can address.');

  SetLength(IndexEntries, BlockCount);
  StartIndex := 0;
  for BlockIndex := 0 to BlockCount - 1 do
  begin
    RowsInBlock := Length(EncodedRecords) - StartIndex;
    if RowsInBlock > RecordsPerBlock then
      RowsInBlock := RecordsPerBlock;
    IndexEntries[BlockIndex].Key := Copy(
      EncodedRecords[StartIndex].Key,
      0,
      Length(EncodedRecords[StartIndex].Key));
    IndexEntries[BlockIndex].DataBlockNumber := BlockIndex + 1;
    IndexEntries[BlockIndex].DataRecordCount := RowsInBlock;
    Inc(StartIndex, RowsInBlock);
  end;

  OutputSize := Int64(DatabaseHeader.HeaderSize) +
    Int64(BlockCount) * BlockSize;
  {$IFDEF CPU32}
  if OutputSize > High(SizeInt) then
    raise EDBParadoxUnsupportedTableFeature.Create(
      'The table file exceeds the addressable file size.');
  {$ENDIF}
  SetLength(Result.DatabaseFile, SizeInt(OutputSize));
  Move(EmptyDatabaseTemplate[0], Result.DatabaseFile[0],
    DatabaseHeader.HeaderSize);
  UpdateDatabaseHeader(Result.DatabaseFile, Length(EncodedRecords), BlockCount);
  WriteUInt32LE(Result.DatabaseFile, AutoIncrementOffset, LastIssued);

  for BlockIndex := 0 to BlockCount - 1 do
  begin
    StartIndex := BlockIndex * RecordsPerBlock;
    RowsInBlock := Length(EncodedRecords) - StartIndex;
    if RowsInBlock > RecordsPerBlock then
      RowsInBlock := RecordsPerBlock;
    BlockSize := DatabaseHeader.MaximumTableSize * 1024;
    TableBlock := BuildTableBlock(
      EncodedRecords,
      StartIndex,
      RowsInBlock,
      BlockIndex + 1,
      BlockCount,
      DatabaseHeader.RecordSize,
      BlockSize);
    BlockOffset := DatabaseHeader.HeaderSize +
      SizeInt(BlockIndex) * BlockSize;
    Move(
      TableBlock[0],
      Result.DatabaseFile[BlockOffset],
      Length(TableBlock));
  end;

  Result.PrimaryIndexFile := BuildDBParadoxIndexFile(
    EmptyPrimaryIndexTemplate, 1, IndexEntries);
end;

end.
