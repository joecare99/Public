unit DBParadoxSecondaryIndexBuilder;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxIndexFileBuilder;

type
  EDBParadoxSecondaryIndexBuildError = class(Exception);
  EDBParadoxUnsupportedSecondaryIndexFeature =
    class(EDBParadoxSecondaryIndexBuildError);

  TDBParadoxSecondaryRecord = record
    Key: TBytes;
    DataBlockNumber: Integer;
  end;

  TDBParadoxSecondaryRecords = array of TDBParadoxSecondaryRecord;

  TDBParadoxBuiltSecondaryIndex = record
    DataFile: TBytes;
    IndexFile: TBytes;
  end;

function BuildDBParadoxSecondaryIndexFiles(const EmptyDataTemplate,
  EmptyIndexTemplate: TBytes; PrimaryIndexRevision: Byte;
  const Records: TDBParadoxSecondaryRecords): TDBParadoxBuiltSecondaryIndex;

implementation

const
  CommonHeaderSize = $58;
  DataHeaderSize = $78;
  DataBlockHeaderSize = 6;
  ClassicSecondaryDataFileType = 5;
  ClassicSecondaryIndexFileType = 4;
  SecondaryDataFileType = 8;
  SecondaryIndexFileType = 7;
  AlphaType = $01;
  ShortType = $03;
  BcdType = $17;
  SecondaryDataBlockFillPercent = 65;
  CaseInsensitiveOptionOffset = $55;

type
  TSecondaryHeader = record
    RecordSize: Integer;
    RecordCount: Integer;
    BlockCount: Integer;
    MaximumTableSize: Integer;
    FieldCount: Integer;
    KeyFieldCount: Integer;
    HeaderSize: Integer;
  end;

  TSecondaryField = record
    TypeCode: Byte;
    FieldLength: Integer;
  end;

  TSecondaryFields = array of TSecondaryField;

  TSortedRecord = record
    Key: TBytes;
    DataBlockNumber: Integer;
  end;

  TSortedRecords = array of TSortedRecord;

function ReadUInt16LE(const Data: TBytes; Offset: SizeInt): Word;
begin
  Result := Word(Data[Offset]) or (Word(Data[Offset + 1]) shl 8);
end;

function ReadInt16LE(const Data: TBytes; Offset: SizeInt): SmallInt;
begin
  Result := SmallInt(ReadUInt16LE(Data, Offset));
end;

function ReadInt32LE(const Data: TBytes; Offset: SizeInt): LongInt;
begin
  Result := LongInt(Cardinal(Data[Offset]) or
    (Cardinal(Data[Offset + 1]) shl 8) or
    (Cardinal(Data[Offset + 2]) shl 16) or
    (Cardinal(Data[Offset + 3]) shl 24));
end;

function ReadUInt32LE(const Data: TBytes; Offset: SizeInt): Cardinal;
begin
  Result := Cardinal(Data[Offset]) or
    (Cardinal(Data[Offset + 1]) shl 8) or
    (Cardinal(Data[Offset + 2]) shl 16) or
    (Cardinal(Data[Offset + 3]) shl 24);
end;

procedure ValidateEmptySidecarTemplate(const Data: TBytes;
  const Header: TSecondaryHeader; const Description: string);
var
  BlockSize: SizeInt;
  BlockOffset: SizeInt;
begin
  if Header.RecordCount <> 0 then
    raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
      'The %s template contains records.', [Description]);

  BlockSize := Header.MaximumTableSize * 1024;
  if Header.BlockCount = 0 then
  begin
    if Length(Data) <> Header.HeaderSize then
      raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
        'The empty %s template has unexpected trailing blocks.', [Description]);
    Exit;
  end;

  if (Header.BlockCount <> 1) or
    (Length(Data) <> Header.HeaderSize + BlockSize) then
    raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
      'The %s template is not an empty header or single-root template.',
      [Description]);

  BlockOffset := Header.HeaderSize;
  if (ReadUInt16LE(Data, BlockOffset) <> 0) or
    (ReadUInt16LE(Data, BlockOffset + 2) <> 0) or
    (ReadInt16LE(Data, BlockOffset + 4) <> -Header.RecordSize) then
    raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
      'The %s template root block is not empty.', [Description]);
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

procedure WriteParadoxShort(var Data: TBytes; Offset: SizeInt;
  Value: SmallInt);
begin
  Data[Offset] := Byte(Word(Value) shr 8) or $80;
  Data[Offset + 1] := Byte(Value);
end;

function ReadSecondaryHeader(const Data: TBytes; ExpectedFileType: Byte;
  const Description: string): TSecondaryHeader;
var
  MinimumHeaderSize: Integer;
  BlockSize: Int64;
begin
  if ExpectedFileType in
    [ClassicSecondaryDataFileType, SecondaryDataFileType] then
    MinimumHeaderSize := DataHeaderSize
  else
    MinimumHeaderSize := CommonHeaderSize;
  if (Length(Data) < MinimumHeaderSize) or
    (Data[4] <> ExpectedFileType) then
    raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
      'The %s Paradox header is invalid.', [Description]);

  Result.RecordSize := ReadUInt16LE(Data, 0);
  Result.HeaderSize := ReadUInt16LE(Data, 2);
  Result.RecordCount := ReadInt32LE(Data, 6);
  Result.BlockCount := ReadUInt16LE(Data, $0C);
  Result.MaximumTableSize := Data[5];
  Result.FieldCount := ReadUInt16LE(Data, $21);
  Result.KeyFieldCount := ReadUInt16LE(Data, $23);

  if (Result.RecordSize <= DataBlockHeaderSize) or
    (Result.RecordCount < 0) or (Result.MaximumTableSize < 1) or
    (Result.MaximumTableSize > 32) or (Result.FieldCount <= 0) or
    (Result.HeaderSize < MinimumHeaderSize) or
    (Result.HeaderSize > Length(Data)) then
    raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
      'The %s Paradox dimensions are invalid.', [Description]);

  BlockSize := Int64(Result.MaximumTableSize) * 1024;
  if Int64(Result.BlockCount) >
    (Int64(Length(Data)) - Result.HeaderSize) div BlockSize then
    raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
      'The %s Paradox file is missing declared data blocks.', [Description]);
end;

function ReadNullTerminatedAscii(const Data: TBytes; var Offset: SizeInt;
  Limit: SizeInt): string;
var
  StartOffset: SizeInt;
begin
  StartOffset := Offset;
  while (Offset < Limit) and (Data[Offset] <> 0) do
  begin
    if Data[Offset] > $7F then
      raise EDBParadoxUnsupportedSecondaryIndexFeature.Create(
        'Non-ASCII secondary-index metadata is not supported.');
    Inc(Offset);
  end;
  if Offset >= Limit then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'A secondary-index header string is not terminated.');
  SetLength(Result, Offset - StartOffset);
  if Length(Result) > 0 then
    Move(Data[StartOffset], Result[1], Length(Result));
  Inc(Offset);
end;

function ReadSecondaryDataFields(const Data: TBytes;
  const Header: TSecondaryHeader): TSecondaryFields;
var
  Version: Byte;
  TableNameLength: SizeInt;
  NamesOffset, FieldIndex, FieldLength: SizeInt;
  SortOrder, IndexName: string;
begin
  Version := Data[$39];
  if (Version <> $0B) and (Version <> $0C) then
    raise EDBParadoxUnsupportedSecondaryIndexFeature.CreateFmt(
      'XG file version 0x%.2x is not supported.', [Version]);
  if (Header.KeyFieldCount <= 0) or
    (Header.KeyFieldCount <> Header.FieldCount - 1) then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'The XG key-field count is inconsistent.');
  if Data[4] = SecondaryDataFileType then
  begin
    if Data[CaseInsensitiveOptionOffset] > 1 then
      raise EDBParadoxUnsupportedSecondaryIndexFeature.CreateFmt(
        'XG index options 0x%.2x are not supported.',
        [Data[CaseInsensitiveOptionOffset]]);
  end
  else if Data[CaseInsensitiveOptionOffset] <> 0 then
    raise EDBParadoxUnsupportedSecondaryIndexFeature.CreateFmt(
      'Classic secondary-index option 0x%.2x is not supported.',
      [Data[CaseInsensitiveOptionOffset]]);

  if Version = $0C then
    TableNameLength := 261
  else
    TableNameLength := 79;
  NamesOffset := DataHeaderSize + Header.FieldCount * 2 + 4 +
    Header.FieldCount * 4 + TableNameLength;
  if NamesOffset >= Header.HeaderSize then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'The XG field-name table exceeds its header.');

  Result := nil;
  SetLength(Result, Header.FieldCount);
  for FieldIndex := 0 to Header.FieldCount - 1 do
  begin
    Result[FieldIndex].TypeCode := Data[DataHeaderSize + FieldIndex * 2];
    if Result[FieldIndex].TypeCode = BcdType then
      FieldLength := 17
    else
      FieldLength := Data[DataHeaderSize + FieldIndex * 2 + 1];
    if FieldLength <= 0 then
      raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
        'XG field %d has an invalid length.', [FieldIndex]);
    Result[FieldIndex].FieldLength := FieldLength;
    ReadNullTerminatedAscii(Data, NamesOffset, Header.HeaderSize);
  end;

  Inc(NamesOffset, Header.FieldCount * SizeOf(Word));
  SortOrder := ReadNullTerminatedAscii(Data, NamesOffset, Header.HeaderSize);
  IndexName := ReadNullTerminatedAscii(Data, NamesOffset, Header.HeaderSize);
  if SortOrder = '' then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'The XG sort order is missing.');
  if not SameText(SortOrder, 'DBWINUS0') then
    raise EDBParadoxUnsupportedSecondaryIndexFeature.CreateFmt(
      'The XG sort order "%s" is not supported by the Pascal writer.',
      [SortOrder]);
  if (Data[4] = SecondaryDataFileType) and (IndexName = '') then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'The XG index label is missing.');

  if (Result[Header.KeyFieldCount].TypeCode <> ShortType) or
    (Result[Header.KeyFieldCount].FieldLength <> SizeOf(SmallInt)) then
    raise EDBParadoxUnsupportedSecondaryIndexFeature.Create(
      'The XG trailing hint field must be a two-byte Paradox short.');
end;

function SumKeyLength(const Fields: TSecondaryFields;
  KeyFieldCount: Integer): SizeInt;
var
  Index: Integer;
begin
  Result := 0;
  for Index := 0 to KeyFieldCount - 1 do
    Inc(Result, Fields[Index].FieldLength);
end;

procedure NormalizeAsciiCaseInsensitiveKey(var Key: TBytes;
  const Fields: TSecondaryFields; KeyFieldCount: Integer);
var
  Offset, FieldIndex, ByteIndex: SizeInt;
begin
  Offset := 0;
  for FieldIndex := 0 to KeyFieldCount - 1 do
  begin
    if Fields[FieldIndex].TypeCode = AlphaType then
      for ByteIndex := Offset to Offset + Fields[FieldIndex].FieldLength - 1 do
      begin
        if Key[ByteIndex] > $7F then
          raise EDBParadoxUnsupportedSecondaryIndexFeature.Create(
            'Non-ASCII case folding is not supported for DBWINUS0.');
        if (Key[ByteIndex] >= Ord('a')) and (Key[ByteIndex] <= Ord('z')) then
          Dec(Key[ByteIndex], Ord('a') - Ord('A'));
      end;
    Inc(Offset, Fields[FieldIndex].FieldLength);
  end;
end;

function CompareKeys(const Left, Right: TBytes): Integer;
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

procedure MergeSort(var Records, Scratch: TSortedRecords;
  First, Last: SizeInt);
var
  Middle, LeftIndex, RightIndex, DestIndex: SizeInt;
begin
  if First >= Last then
    Exit;
  Middle := First + (Last - First) div 2;
  MergeSort(Records, Scratch, First, Middle);
  MergeSort(Records, Scratch, Middle + 1, Last);
  LeftIndex := First;
  RightIndex := Middle + 1;
  for DestIndex := First to Last do
  begin
    if (LeftIndex <= Middle) and
      ((RightIndex > Last) or
       (CompareKeys(Records[LeftIndex].Key, Records[RightIndex].Key) <= 0)) then
    begin
      Scratch[DestIndex] := Records[LeftIndex];
      Inc(LeftIndex);
    end
    else
    begin
      Scratch[DestIndex] := Records[RightIndex];
      Inc(RightIndex);
    end;
  end;
  for DestIndex := First to Last do
    Records[DestIndex] := Scratch[DestIndex];
end;

procedure UpdateSecondaryDataHeader(var Data: TBytes;
  RecordCount, BlockCount: Integer);
var
  Metadata: Cardinal;
begin
  if (RecordCount < 0) or (BlockCount <= 0) or
    (BlockCount > High(Word)) then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'The XG output dimensions exceed the supported range.');

  WriteUInt32LE(Data, 6, Cardinal(RecordCount));
  WriteUInt16LE(Data, $0A, Word(BlockCount));
  WriteUInt16LE(Data, $0C, Word(BlockCount));
  WriteUInt16LE(Data, $0E, 1);
  WriteUInt16LE(Data, $10, Word(BlockCount));
  WriteUInt16LE(Data, $3A, Word(BlockCount));
  if Data[4] = SecondaryDataFileType then
  begin
    Data[$2D] := Byte((Integer(Data[$2D]) + 1) and $FF);
    Metadata := ReadUInt32LE(Data, $49);
    WriteUInt32LE(Data, $49, Metadata + 1);
  end;
end;

function BuildDataFile(const Template: TBytes; const Header: TSecondaryHeader;
  const Fields: TSecondaryFields; PrimaryIndexRevision: Byte;
  const Records: TSortedRecords): TBytes;
var
  KeyLength, RecordCapacity, RecordsPerBlock, BlockCount: Integer;
  BlockIndex, RecordIndex, InBlockCount, RecordOffset, BlockOffset: SizeInt;
  GroupStart: SizeInt;
begin
  KeyLength := SumKeyLength(Fields, Header.KeyFieldCount);
  RecordCapacity := (Header.MaximumTableSize * 1024 - DataBlockHeaderSize) div
    Header.RecordSize;
  if RecordCapacity <= 0 then
    raise EDBParadoxUnsupportedSecondaryIndexFeature.Create(
      'The XG block cannot contain a record.');
  RecordsPerBlock := (RecordCapacity * SecondaryDataBlockFillPercent) div 100;
  if RecordsPerBlock < 1 then
    RecordsPerBlock := 1;
  BlockCount := (Length(Records) + RecordsPerBlock - 1) div RecordsPerBlock;
  if (BlockCount <= 0) or (BlockCount > High(Word)) then
    raise EDBParadoxUnsupportedSecondaryIndexFeature.Create(
      'The XG file requires an unsupported number of data blocks.');
  {$IFDEF CPU32}
  if Int64(Header.HeaderSize) +
    Int64(BlockCount) * Header.MaximumTableSize * 1024 > High(SizeInt) then
    raise EDBParadoxUnsupportedSecondaryIndexFeature.Create(
      'The XG file exceeds the addressable memory range.');
  {$ENDIF}

  if Header.HeaderSize < $30 then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'The XG header does not contain its revision marker.');
  if Template[$2F] <> Byte((Integer(PrimaryIndexRevision) - 1) and $FF) then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'The XG revision does not match the primary-index revision.');

  Result := nil;
  SetLength(Result, Header.HeaderSize +
    BlockCount * Header.MaximumTableSize * 1024);
  Move(Template[0], Result[0], Header.HeaderSize);
  Result[$2F] := PrimaryIndexRevision;
  UpdateSecondaryDataHeader(Result, Length(Records), BlockCount);

  for BlockIndex := 0 to BlockCount - 1 do
  begin
    GroupStart := BlockIndex * RecordsPerBlock;
    InBlockCount := Length(Records) - GroupStart;
    if InBlockCount > RecordsPerBlock then
      InBlockCount := RecordsPerBlock;
    BlockOffset := Header.HeaderSize +
      BlockIndex * Header.MaximumTableSize * 1024;
    if BlockIndex < BlockCount - 1 then
      WriteUInt16LE(Result, BlockOffset, Word(BlockIndex + 2))
    else
      WriteUInt16LE(Result, BlockOffset, 0);
    WriteUInt16LE(Result, BlockOffset + 2, Word(BlockIndex));
    WriteInt16LE(Result, BlockOffset + 4,
      SmallInt((InBlockCount - 1) * Header.RecordSize));
    RecordOffset := BlockOffset + DataBlockHeaderSize;

    for RecordIndex := GroupStart to GroupStart + InBlockCount - 1 do
    begin
      Move(Records[RecordIndex].Key[0], Result[RecordOffset], KeyLength);
      Inc(RecordOffset, KeyLength);
      WriteParadoxShort(Result, RecordOffset,
        SmallInt(Records[RecordIndex].DataBlockNumber));
      Inc(RecordOffset, SizeOf(SmallInt));
    end;
  end;
end;

function BuildIndexFile(const Template: TBytes; const Header: TSecondaryHeader;
  const Fields: TSecondaryFields; IndexFileType: Byte;
  RecordsPerDataBlock: Integer;
  const Records: TSortedRecords): TBytes;
var
  KeyLength: Integer;
  BlockCount, BlockIndex, StartIndex, RecordCount: SizeInt;
  Entries: TDBParadoxIndexEntries;
  TrimmedTemplate: TBytes;
  IndexHeader: TSecondaryHeader;
begin
  KeyLength := SumKeyLength(Fields, Header.KeyFieldCount);
  IndexHeader := ReadSecondaryHeader(
    Template, IndexFileType, 'secondary index');
  ValidateEmptySidecarTemplate(Template, IndexHeader, 'YG index');
  if (IndexHeader.RecordSize <> KeyLength + DataBlockHeaderSize) or
    (IndexHeader.FieldCount <> Header.KeyFieldCount) then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'The YG schema does not match the XG key.');

  BlockCount := (Length(Records) + RecordsPerDataBlock - 1) div
    RecordsPerDataBlock;
  SetLength(Entries, BlockCount);
  for BlockIndex := 0 to BlockCount - 1 do
  begin
    StartIndex := BlockIndex * RecordsPerDataBlock;
    RecordCount := Length(Records) - StartIndex;
    if RecordCount > RecordsPerDataBlock then
      RecordCount := RecordsPerDataBlock;
    Entries[BlockIndex].Key := Copy(
      Records[StartIndex].Key, 0, KeyLength);
    Entries[BlockIndex].DataBlockNumber := BlockIndex + 1;
    Entries[BlockIndex].DataRecordCount := RecordCount;
  end;

  SetLength(TrimmedTemplate, IndexHeader.HeaderSize);
  Move(Template[0], TrimmedTemplate[0], IndexHeader.HeaderSize);
  WriteUInt32LE(TrimmedTemplate, 6, 0);
  WriteUInt16LE(TrimmedTemplate, $0A, 0);
  WriteUInt16LE(TrimmedTemplate, $0C, 0);
  WriteUInt16LE(TrimmedTemplate, $0E, 0);
  WriteUInt16LE(TrimmedTemplate, $10, 0);
  WriteUInt16LE(TrimmedTemplate, $1E, 0);
  TrimmedTemplate[$20] := 0;
  Result := BuildDBParadoxIndexFile(
    TrimmedTemplate, IndexFileType, Entries);
end;

function BuildDBParadoxSecondaryIndexFiles(const EmptyDataTemplate,
  EmptyIndexTemplate: TBytes; PrimaryIndexRevision: Byte;
  const Records: TDBParadoxSecondaryRecords): TDBParadoxBuiltSecondaryIndex;
var
  DataHeader: TSecondaryHeader;
  Fields: TSecondaryFields;
  Sorted, Scratch: TSortedRecords;
  KeyLength, RecordCapacity, RecordsPerDataBlock: SizeInt;
  Index: SizeInt;
  CaseInsensitive: Boolean;
  DataFileType, IndexFileType: Byte;
begin
  Result.DataFile := nil;
  Result.IndexFile := nil;
  if Length(Records) = 0 then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'A secondary index requires at least one table record.');

  if (Length(EmptyDataTemplate) <= 4) or
    (Length(EmptyIndexTemplate) <= 4) then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'A secondary-index template is truncated.');
  DataFileType := EmptyDataTemplate[4];
  IndexFileType := EmptyIndexTemplate[4];
  if not (((DataFileType = SecondaryDataFileType) and
    (IndexFileType = SecondaryIndexFileType)) or
    ((DataFileType = ClassicSecondaryDataFileType) and
    (IndexFileType = ClassicSecondaryIndexFileType))) then
    raise EDBParadoxUnsupportedSecondaryIndexFeature.CreateFmt(
      'Secondary-index file type pair %d/%d is not supported.',
      [DataFileType, IndexFileType]);

  DataHeader := ReadSecondaryHeader(
    EmptyDataTemplate, DataFileType, 'secondary-index data');
  ValidateEmptySidecarTemplate(EmptyDataTemplate, DataHeader, 'XG data');
  Fields := ReadSecondaryDataFields(EmptyDataTemplate, DataHeader);
  KeyLength := SumKeyLength(Fields, DataHeader.KeyFieldCount);
  if DataHeader.RecordSize <> KeyLength + Fields[DataHeader.KeyFieldCount].FieldLength then
    raise EDBParadoxSecondaryIndexBuildError.Create(
      'The XG record size does not match its field definitions.');
  CaseInsensitive := (DataFileType = SecondaryDataFileType) and
    (EmptyDataTemplate[CaseInsensitiveOptionOffset] = 1);

  SetLength(Sorted, Length(Records));
  SetLength(Scratch, Length(Records));
  for Index := 0 to High(Records) do
  begin
    if Length(Records[Index].Key) <> KeyLength then
      raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
        'Secondary record %d has an unexpected key length.', [Index]);
    if (Records[Index].DataBlockNumber <= 0) or
      (Records[Index].DataBlockNumber > High(SmallInt)) then
      raise EDBParadoxSecondaryIndexBuildError.CreateFmt(
        'Secondary record %d has an unsupported source block number.', [Index]);
    Sorted[Index].Key := Copy(Records[Index].Key, 0, KeyLength);
    Sorted[Index].DataBlockNumber := Records[Index].DataBlockNumber;
    if CaseInsensitive then
      NormalizeAsciiCaseInsensitiveKey(
        Sorted[Index].Key, Fields, DataHeader.KeyFieldCount);
  end;
  MergeSort(Sorted, Scratch, 0, High(Sorted));

  RecordCapacity := (DataHeader.MaximumTableSize * 1024 -
    DataBlockHeaderSize) div DataHeader.RecordSize;
  RecordsPerDataBlock := (RecordCapacity * SecondaryDataBlockFillPercent) div 100;
  if RecordsPerDataBlock < 1 then
    RecordsPerDataBlock := 1;

  Result.DataFile := BuildDataFile(
    EmptyDataTemplate, DataHeader, Fields, PrimaryIndexRevision, Sorted);
  Result.IndexFile := BuildIndexFile(
    EmptyIndexTemplate, DataHeader, Fields, IndexFileType,
    RecordsPerDataBlock, Sorted);
end;

end.
