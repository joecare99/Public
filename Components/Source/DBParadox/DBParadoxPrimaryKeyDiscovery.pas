unit DBParadoxPrimaryKeyDiscovery;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxFileReader;

type
  EDBParadoxPrimaryKeyDiscoveryError = class(Exception);
  EDBParadoxUnsupportedPrimaryIndex = class(
    EDBParadoxPrimaryKeyDiscoveryError);

function DiscoverDBParadoxPrimaryKeyFieldIndex(
  const Fields: TDBParadoxFileFields; const Rows: TDBParadoxFileRows;
  PrimaryKeyFieldCount: SizeInt;
  const PrimaryIndexFileName: string): SizeInt;

implementation

uses
  Classes;

const
  PrimaryIndexFileType = 1;
  ParadoxAlpha = $01;
  ParadoxLong = $04;
  DataBlockHeaderSize = 6;
  IndexHeaderSize = $58;
  IndexFieldDescriptorOffset = $58;

type
  TPrimaryIndexEntry = record
    Key: TBytes;
    DataBlockNumber: Integer;
    DataRecordCount: Integer;
  end;

  TPrimaryIndexEntries = array of TPrimaryIndexEntry;

  TPrimaryIndexReader = class
  private
    FData: TBytes;
    FHeaderSize: SizeInt;
    FBlockSize: SizeInt;
    FBlockCount: SizeInt;
    FRecordSize: SizeInt;
    FKeyLength: SizeInt;
    FTreeDepth: SizeInt;
    FVisitedBlocks: array of Boolean;
    FIndexRecordCount: SizeInt;
    FEntries: TPrimaryIndexEntries;
    FPreviousKey: TBytes;
    FHasPreviousKey: Boolean;
    function ReadNode(BlockNumber, Level: SizeInt;
      out FirstKey: TBytes): Int64;
    procedure AddEntry(const Key: TBytes; DataBlockNumber,
      DataRecordCount: Integer);
  public
    KeyFieldType: Byte;
    KeyFieldLength: SizeInt;
    procedure ReadFile(const FileName: string);
    property Entries: TPrimaryIndexEntries read FEntries;
  end;

function ReadUInt16LE(const Data: TBytes; Offset: SizeInt): Word;
begin
  if (Offset < 0) or (Offset + 1 >= Length(Data)) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'The primary-index header or block is truncated.');
  Result := Word(Data[Offset]) or (Word(Data[Offset + 1]) shl 8);
end;

function ReadInt16LE(const Data: TBytes; Offset: SizeInt): SmallInt;
begin
  Result := SmallInt(ReadUInt16LE(Data, Offset));
end;

function ReadUInt32LE(const Data: TBytes; Offset: SizeInt): Cardinal;
begin
  if (Offset < 0) or (Offset + 3 >= Length(Data)) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'The primary-index header is truncated.');
  Result := Cardinal(Data[Offset]) or
    (Cardinal(Data[Offset + 1]) shl 8) or
    (Cardinal(Data[Offset + 2]) shl 16) or
    (Cardinal(Data[Offset + 3]) shl 24);
end;

function ReadInt32LE(const Data: TBytes; Offset: SizeInt): LongInt;
begin
  Result := LongInt(ReadUInt32LE(Data, Offset));
end;

function ReadParadoxShort(const Data: TBytes; Offset: SizeInt): SmallInt;
var
  Encoded: Word;
begin
  if (Offset < 0) or (Offset + 1 >= Length(Data)) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'A primary-index pointer is truncated.');
  Encoded := (Word(Data[Offset]) shl 8) or Data[Offset + 1];
  if (Encoded and $8000) <> 0 then
    Result := SmallInt(Encoded and $7FFF)
  else
    Result := SmallInt(Integer(Encoded) - $8000);
end;

function SameBytes(const Left, Right: TBytes): Boolean;
begin
  Result := (Length(Left) = Length(Right)) and
    ((Length(Left) = 0) or
     (CompareByte(Left[0], Right[0], Length(Left)) = 0));
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

procedure TPrimaryIndexReader.AddEntry(const Key: TBytes;
  DataBlockNumber, DataRecordCount: Integer);
var
  EntryIndex: SizeInt;
begin
  if (DataBlockNumber <= 0) or (DataRecordCount <= 0) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'The primary index contains an invalid data-block reference.');
  if FHasPreviousKey and (CompareBytes(FPreviousKey, Key) >= 0) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'Primary-index leaf keys are not strictly increasing.');
  for EntryIndex := 0 to High(FEntries) do
    if FEntries[EntryIndex].DataBlockNumber = DataBlockNumber then
      raise EDBParadoxPrimaryKeyDiscoveryError.Create(
        'The primary index references a data block more than once.');

  EntryIndex := Length(FEntries);
  SetLength(FEntries, EntryIndex + 1);
  FEntries[EntryIndex].Key := Copy(Key, 0, Length(Key));
  FEntries[EntryIndex].DataBlockNumber := DataBlockNumber;
  FEntries[EntryIndex].DataRecordCount := DataRecordCount;
  FPreviousKey := Copy(Key, 0, Length(Key));
  FHasPreviousKey := True;
end;

function TPrimaryIndexReader.ReadNode(BlockNumber, Level: SizeInt;
  out FirstKey: TBytes): Int64;
var
  BlockOffset, RecordOffset, RecordCount, RecordIndex: SizeInt;
  DataSize: SmallInt;
  MaximumRecordData: SizeInt;
  Key, ChildFirstKey: TBytes;
  TargetBlock, TargetCount: SmallInt;
  ChildRecordCount: Int64;
  TotalRecordCount: Int64;
begin
  if (BlockNumber < 1) or (BlockNumber > FBlockCount) or
    FVisitedBlocks[BlockNumber] then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'The primary-index tree contains an invalid or repeated block.');
  FVisitedBlocks[BlockNumber] := True;
  BlockOffset := FHeaderSize + (BlockNumber - 1) * FBlockSize;
  if (BlockOffset < 0) or (BlockOffset > Length(FData) - FBlockSize) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'A primary-index tree block lies outside the file.');

  DataSize := ReadInt16LE(FData, BlockOffset + 4);
  MaximumRecordData := FBlockSize - DataBlockHeaderSize;
  if (DataSize < -FRecordSize) or
    (DataSize > MaximumRecordData - FRecordSize) or
    ((DataSize < 0) and (DataSize <> -FRecordSize)) or
    ((DataSize >= 0) and (DataSize mod FRecordSize <> 0)) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'A primary-index tree block has an invalid record-data size.');
  if DataSize < 0 then
    RecordCount := 0
  else
    RecordCount := DataSize div FRecordSize + 1;
  if RecordCount = 0 then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'A primary-index tree node is empty.');
  if RecordCount > MaximumRecordData div FRecordSize then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'A primary-index tree node declares too many records.');

  TotalRecordCount := 0;
  FirstKey := nil;
  for RecordIndex := 0 to RecordCount - 1 do
  begin
    RecordOffset := BlockOffset + DataBlockHeaderSize +
      RecordIndex * FRecordSize;
    Key := nil;
    SetLength(Key, FKeyLength);
    Move(FData[RecordOffset], Key[0], FKeyLength);
    if RecordIndex > 0 then
    begin
      if CompareBytes(FirstKey, Key) >= 0 then
        raise EDBParadoxPrimaryKeyDiscoveryError.Create(
          'Primary-index node keys are not strictly increasing.');
    end
    else
      FirstKey := Copy(Key, 0, Length(Key));
    Inc(FIndexRecordCount);

    TargetBlock := ReadParadoxShort(FData, RecordOffset + FKeyLength);
    TargetCount := ReadParadoxShort(FData, RecordOffset + FKeyLength + 2);
    if (TargetBlock <= 0) or (TargetCount <= 0) then
      raise EDBParadoxPrimaryKeyDiscoveryError.CreateFmt(
        'A primary-index entry has an invalid target (%d) or record count (%d).',
        [TargetBlock, TargetCount]);
    if Level = 1 then
    begin
      AddEntry(Key, TargetBlock, TargetCount);
      Inc(TotalRecordCount, TargetCount);
    end
    else
    begin
      ChildRecordCount := ReadNode(TargetBlock, Level - 1, ChildFirstKey);
      if not SameBytes(Key, ChildFirstKey) or
        (ChildRecordCount <> TargetCount) then
        raise EDBParadoxPrimaryKeyDiscoveryError.Create(
          'A primary-index separator does not match its child subtree.');
      Inc(TotalRecordCount, ChildRecordCount);
    end;
  end;
  Result := TotalRecordCount;
end;

procedure TPrimaryIndexReader.ReadFile(const FileName: string);
var
  Stream: TFileStream;
  RootBlock: SizeInt;
  Encryption: Cardinal;
  RootKey: TBytes;
  TotalRecordCount: Int64;
begin
  FData := nil;
  FEntries := nil;
  FVisitedBlocks := nil;
  FHasPreviousKey := False;
  FIndexRecordCount := 0;
  KeyFieldType := 0;
  KeyFieldLength := 0;
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    if Stream.Size < $5A then
      raise EDBParadoxPrimaryKeyDiscoveryError.Create(
        'The primary-index file has an unsupported size.');
    {$IFDEF CPU32}
    if Stream.Size > High(SizeInt) then
      raise EDBParadoxPrimaryKeyDiscoveryError.Create(
        'The primary-index file exceeds the supported in-memory size.');
    {$ENDIF}
    SetLength(FData, SizeInt(Stream.Size));
    Stream.ReadBuffer(FData[0], Length(FData));
  finally
    Stream.Free;
  end;

  if FData[4] <> PrimaryIndexFileType then
    raise EDBParadoxUnsupportedPrimaryIndex.Create(
      'The file is not a supported Paradox primary index.');
  Encryption := ReadUInt32LE(FData, $25);
  if Encryption = $FF00FF00 then
  begin
    if Length(FData) < $60 then
      raise EDBParadoxPrimaryKeyDiscoveryError.Create(
        'The encrypted primary-index header is truncated.');
    Encryption := ReadUInt32LE(FData, $5C);
  end;
  if Encryption <> 0 then
    raise EDBParadoxUnsupportedPrimaryIndex.Create(
      'Encrypted primary indexes are not supported.');

  FHeaderSize := ReadUInt16LE(FData, 2);
  FBlockSize := SizeInt(FData[5]) * 1024;
  FBlockCount := ReadUInt16LE(FData, $0C);
  FRecordSize := ReadUInt16LE(FData, 0);
  if (FHeaderSize < IndexHeaderSize + 2) or
    (FHeaderSize > Length(FData)) or
    (FBlockSize < 1024) or (FBlockSize > 32768) or
    (ReadUInt16LE(FData, $21) <> 1) or
    (FRecordSize <= DataBlockHeaderSize) then
    raise EDBParadoxUnsupportedPrimaryIndex.Create(
      'The primary-index schema or dimensions are unsupported.');

  KeyFieldType := FData[IndexFieldDescriptorOffset];
  KeyFieldLength := FData[IndexFieldDescriptorOffset + 1];
  FKeyLength := KeyFieldLength;
  if not (KeyFieldType in [ParadoxAlpha, ParadoxLong]) then
    raise EDBParadoxUnsupportedPrimaryIndex.Create(
      'The primary key must be an Alpha or Long field.');
  if (KeyFieldLength <= 0) or
    (FRecordSize <> KeyFieldLength + DataBlockHeaderSize) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'The primary-index key width does not match its record width.');

  if FBlockCount = 0 then
  begin
    if (ReadInt32LE(FData, 6) <> 0) or
      (ReadUInt16LE(FData, $0A) <> 0) or
      (ReadUInt16LE(FData, $0E) <> 0) or
      (ReadUInt16LE(FData, $10) <> 0) or
      (Length(FData) <> FHeaderSize) then
      raise EDBParadoxPrimaryKeyDiscoveryError.Create(
        'An empty primary index has inconsistent header dimensions.');
    Exit;
  end;

  if Int64(Length(FData)) <> Int64(FHeaderSize) +
    Int64(FBlockCount) * FBlockSize then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'The primary-index file length does not match its block count.');
  RootBlock := ReadUInt16LE(FData, $1E);
  FTreeDepth := FData[$20];
  if (RootBlock <= 0) or (RootBlock > FBlockCount) or
    (FTreeDepth <= 0) or (FTreeDepth > FBlockCount) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'The primary-index root or tree depth is invalid.');

  SetLength(FVisitedBlocks, FBlockCount + 1);
  TotalRecordCount := ReadNode(RootBlock, FTreeDepth, RootKey);
  if (TotalRecordCount <= 0) or (Length(FEntries) = 0) or
    (FIndexRecordCount <> ReadInt32LE(FData, 6)) then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'The primary-index tree does not match its declared record count.');
end;

function FieldMatchesEntries(const Field: TDBParadoxFileField;
  const Rows: TDBParadoxFileRows;
  const Entries: TPrimaryIndexEntries): Boolean;
var
  EntryIndex, RowIndex, BlockNumber, MaximumBlockNumber: SizeInt;
  FirstRowIndexes, RowsInBlocks: array of SizeInt;
  IndexedBlocks: array of Boolean;
  Entry: TPrimaryIndexEntry;
begin
  if (Field.FieldLength <= 0) then
    Exit(False);
  if Length(Entries) = 0 then
    Exit(True);

  MaximumBlockNumber := 0;
  for RowIndex := 0 to High(Rows) do
  begin
    if Rows[RowIndex].BlockNumber <= 0 then
      Exit(False);
    if Rows[RowIndex].BlockNumber > MaximumBlockNumber then
      MaximumBlockNumber := Rows[RowIndex].BlockNumber;
  end;
  for EntryIndex := 0 to High(Entries) do
  begin
    if Entries[EntryIndex].DataBlockNumber > MaximumBlockNumber then
      MaximumBlockNumber := Entries[EntryIndex].DataBlockNumber;
  end;
  SetLength(FirstRowIndexes, MaximumBlockNumber + 1);
  SetLength(RowsInBlocks, MaximumBlockNumber + 1);
  SetLength(IndexedBlocks, MaximumBlockNumber + 1);
  for BlockNumber := 0 to MaximumBlockNumber do
    FirstRowIndexes[BlockNumber] := -1;
  for RowIndex := 0 to High(Rows) do
  begin
    BlockNumber := Rows[RowIndex].BlockNumber;
    if FirstRowIndexes[BlockNumber] < 0 then
    begin
      if Rows[RowIndex].RecordInBlock <> 0 then
        Exit(False);
      FirstRowIndexes[BlockNumber] := RowIndex;
    end
    else if Rows[RowIndex].RecordInBlock <> RowsInBlocks[BlockNumber] then
      Exit(False);
    Inc(RowsInBlocks[BlockNumber]);
  end;

  for EntryIndex := 0 to High(Entries) do
  begin
    Entry := Entries[EntryIndex];
    BlockNumber := Entry.DataBlockNumber;
    if (BlockNumber > MaximumBlockNumber) or
      (FirstRowIndexes[BlockNumber] < 0) or
      IndexedBlocks[BlockNumber] or
      (RowsInBlocks[BlockNumber] <> Entry.DataRecordCount) or
      (Field.Offset < 0) or
      (Field.Offset > Length(Rows[FirstRowIndexes[BlockNumber]].Data) -
        Field.FieldLength) or
      (Length(Entry.Key) <> Field.FieldLength) or
      (CompareByte(
        Rows[FirstRowIndexes[BlockNumber]].Data[Field.Offset], Entry.Key[0],
        Field.FieldLength) <> 0) then
      Exit(False);
    IndexedBlocks[BlockNumber] := True;
  end;

  for BlockNumber := 1 to MaximumBlockNumber do
    if (RowsInBlocks[BlockNumber] > 0) and not IndexedBlocks[BlockNumber] then
      Exit(False);
  Result := True;
end;

function DiscoverDBParadoxPrimaryKeyFieldIndex(
  const Fields: TDBParadoxFileFields; const Rows: TDBParadoxFileRows;
  PrimaryKeyFieldCount: SizeInt;
  const PrimaryIndexFileName: string): SizeInt;
var
  Reader: TPrimaryIndexReader;
  Entries: TPrimaryIndexEntries;
begin
  if Length(Fields) = 0 then
    raise EDBParadoxPrimaryKeyDiscoveryError.Create(
      'The table schema has no fields.');
  if PrimaryKeyFieldCount <> 1 then
    raise EDBParadoxUnsupportedPrimaryIndex.CreateFmt(
      'The first DML slice supports one primary-key field; the DB header declares %d.',
      [PrimaryKeyFieldCount]);

  Reader := TPrimaryIndexReader.Create;
  try
    Reader.ReadFile(PrimaryIndexFileName);
    Entries := Reader.Entries;
    { BDE and pxlib map the DB primary-key count to the leading fields. }
    if (Fields[0].FieldType <> Reader.KeyFieldType) or
      (Fields[0].FieldLength <> Reader.KeyFieldLength) or
      not FieldMatchesEntries(Fields[0], Rows, Entries) then
      raise EDBParadoxPrimaryKeyDiscoveryError.Create(
        'The primary-index descriptor or block keys do not match the leading DB field.');
    Result := 0;
  finally
    Reader.Free;
  end;
end;

end.
