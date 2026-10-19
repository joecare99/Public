unit DBParadoxIndexFileBuilder;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  EDBParadoxIndexBuildError = class(Exception);
  EDBParadoxUnsupportedIndexFeature = class(EDBParadoxIndexBuildError);

  TDBParadoxIndexEntry = record
    Key: TBytes;
    DataBlockNumber: Integer;
    DataRecordCount: Integer;
  end;

  TDBParadoxIndexEntries = array of TDBParadoxIndexEntry;
  TDBParadoxIndexRecords = array of TBytes;

function BuildDBParadoxIndexFile(const TemplateFile: TBytes;
  ExpectedFileType: Byte; const Entries: TDBParadoxIndexEntries): TBytes;

implementation

const
  DataBlockHeaderSize = 6;
  CommonHeaderSize = $58;
  DataHeaderSize = $78;

type
  TIndexNode = record
    BlockNumber: Integer;
    FirstKey: TBytes;
    RecordCount: Integer;
    Records: TDBParadoxIndexRecords;
  end;

  TIndexNodes = array of TIndexNode;
  TIndexLevels = array of TIndexNodes;

  TIndexHeader = record
    RecordSize: Integer;
    RecordCount: Integer;
    BlockCount: Integer;
    MaximumTableSize: Integer;
    FieldCount: Integer;
    HeaderSize: Integer;
  end;

function ReadUInt16LE(const Data: TBytes; Offset: SizeInt): Word;
begin
  Result := Word(Data[Offset]) or (Word(Data[Offset + 1]) shl 8);
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

procedure WriteParadoxShort(var Data: TBytes; Offset: SizeInt; Value: SmallInt);
begin
  Data[Offset] := Byte(Word(Value) shr 8) or $80;
  Data[Offset + 1] := Byte(Value);
end;

function ReadEncryption(const Data: TBytes): Cardinal;
begin
  Result := ReadUInt32LE(Data, $25);
  if Result = $FF00FF00 then
    Result := ReadUInt32LE(Data, $5C);
end;

function ReadIndexHeader(const Data: TBytes; ExpectedFileType: Byte): TIndexHeader;
var
  MinimumHeaderSize: Integer;
  BlockSize: Int64;
begin
  if (Length(Data) < DataHeaderSize) or (Data[4] <> ExpectedFileType) then
    raise EDBParadoxIndexBuildError.Create(
      'The Paradox index template header is invalid.');

  Result.RecordSize := ReadUInt16LE(Data, 0);
  Result.RecordCount := ReadInt32LE(Data, 6);
  Result.BlockCount := ReadUInt16LE(Data, $0C);
  Result.MaximumTableSize := Data[5];
  Result.FieldCount := ReadUInt16LE(Data, $21);
  Result.HeaderSize := ReadUInt16LE(Data, 2);

  if ExpectedFileType in [0, 2, 6, 8] then
    MinimumHeaderSize := DataHeaderSize
  else
    MinimumHeaderSize := CommonHeaderSize;
  if (Result.RecordSize <= DataBlockHeaderSize) or
    (Result.RecordCount < 0) or
    (Result.BlockCount < 0) or
    (Result.MaximumTableSize < 1) or
    (Result.MaximumTableSize > 32) or
    (Result.FieldCount <= 0) or
    (Result.HeaderSize < MinimumHeaderSize) or
    (Result.HeaderSize > Length(Data)) then
    raise EDBParadoxIndexBuildError.Create(
      'The Paradox index template dimensions are invalid.');

  BlockSize := Int64(Result.MaximumTableSize) * 1024;
  if Int64(Result.BlockCount) >
    (Int64(Length(Data)) - Result.HeaderSize) div BlockSize then
    raise EDBParadoxIndexBuildError.Create(
      'The Paradox index template is missing declared data blocks.');
end;

procedure ValidateEntry(const Entry: TDBParadoxIndexEntry;
  KeyLength: SizeInt);
begin
  if Length(Entry.Key) <> KeyLength then
    raise EDBParadoxIndexBuildError.Create(
      'An index entry has an unexpected key length.');
  if (Entry.DataBlockNumber <= 0) or
    (Entry.DataBlockNumber > High(Word)) or
    (Entry.DataRecordCount <= 0) or
    (Entry.DataRecordCount > High(SmallInt)) then
    raise EDBParadoxIndexBuildError.Create(
      'An index entry exceeds the supported block or record-count range.');
end;

function CreateIndexRecord(const Key: TBytes; TargetBlock,
  RecordCount, KeyLength, RecordSize: Integer): TBytes;
begin
  if (Length(Key) <> KeyLength) or (TargetBlock <= 0) or
    (TargetBlock > High(Word)) or (RecordCount <= 0) or
    (RecordCount > High(SmallInt)) then
    raise EDBParadoxIndexBuildError.Create(
      'An index node entry exceeds the supported key or block range.');

  Result := nil;
  SetLength(Result, RecordSize);
  Move(Key[0], Result[0], KeyLength);
  WriteParadoxShort(Result, KeyLength, SmallInt(TargetBlock));
  WriteParadoxShort(Result, KeyLength + 2, SmallInt(RecordCount));
  WriteParadoxShort(Result, KeyLength + 4, 0);
end;

function CreateDataBlock(const Header: TIndexHeader; BlockNumber,
  BlockCount: Integer; const Records: TDBParadoxIndexRecords): TBytes;
var
  RecordIndex, Offset, PhysicalCapacity: Integer;
begin
  PhysicalCapacity := (Header.MaximumTableSize * 1024 - DataBlockHeaderSize) div
    Header.RecordSize;
  if (Length(Records) = 0) or (Length(Records) > PhysicalCapacity) then
    raise EDBParadoxIndexBuildError.Create(
      'An index data block has an invalid number of entries.');

  Result := nil;
  SetLength(Result, Header.MaximumTableSize * 1024);
  if BlockNumber < BlockCount then
    WriteUInt16LE(Result, 0, Word(BlockNumber + 1))
  else
    WriteUInt16LE(Result, 0, 0);
  WriteUInt16LE(Result, 2, Word(BlockNumber - 1));
  WriteInt16LE(Result, 4,
    SmallInt((Length(Records) - 1) * Header.RecordSize));

  Offset := DataBlockHeaderSize;
  for RecordIndex := 0 to High(Records) do
  begin
    if Length(Records[RecordIndex]) <> Header.RecordSize then
      raise EDBParadoxIndexBuildError.Create(
        'An index entry has an unexpected physical size.');
    Move(Records[RecordIndex][0], Result[Offset], Header.RecordSize);
    Inc(Offset, Header.RecordSize);
  end;
end;

procedure UpdateMultipleBlockHeader(var Data: TBytes;
  RecordCount, BlockCount: Integer);
var
  FileType: Byte;
  Metadata: Cardinal;
begin
  if (Length(Data) < $4D) or (RecordCount < 0) or
    (BlockCount <= 0) or (BlockCount > High(Word)) then
    raise EDBParadoxIndexBuildError.Create(
      'Paradox header dimensions exceed the supported range.');

  FileType := Data[4];
  WriteInt32LE(Data, 6, RecordCount);
  WriteUInt16LE(Data, $0A, Word(BlockCount));
  WriteUInt16LE(Data, $0C, Word(BlockCount));
  WriteUInt16LE(Data, $0E, 1);
  WriteUInt16LE(Data, $10, Word(BlockCount));
  WriteUInt16LE(Data, $3A, Word(BlockCount));

  if FileType in [0, 6, 8] then
    Data[$2D] := Byte((Integer(Data[$2D]) + 1) and $FF);
  if FileType in [1, 6, 7, 8] then
  begin
    Metadata := ReadUInt32LE(Data, $49);
    WriteUInt32LE(Data, $49, Metadata + 1);
  end;
  if FileType in [1, 7] then
    Data[$2C] := Byte((Integer(Data[$2C]) + 1) and $FF);
end;

function BuildDBParadoxIndexFile(const TemplateFile: TBytes;
  ExpectedFileType: Byte; const Entries: TDBParadoxIndexEntries): TBytes;
var
  Header: TIndexHeader;
  KeyLength, PhysicalCapacity, LeafCount: Integer;
  RecordIndexCount: Integer;
  BaseGroupSize, LargerGroups, CurrentGroupSize, EntryOffset: Integer;
  LeafIndex, EntryIndex, ChildStart, ChildCount, LevelIndex, NodeIndex: Integer;
  NextBlockNumber, BlockCount, OutputSize: Int64;
  CurrentLevel, ParentLevel: TIndexNodes;
  Levels: TIndexLevels;
  Node: TIndexNode;
  ChildNode: TIndexNode;
  Block: TBytes;
  Blocks: TDBParadoxIndexRecords;
  LevelNodes: TIndexNodes;
  BlockOffset: SizeInt;
begin
  Result := nil;
  if Length(Entries) = 0 then
    raise EDBParadoxIndexBuildError.Create(
      'An index requires at least one data-block entry.');

  Header := ReadIndexHeader(TemplateFile, ExpectedFileType);
  if (Header.RecordCount <> 0) or (Header.BlockCount <> 0) or
    (Length(TemplateFile) <> Header.HeaderSize) then
    raise EDBParadoxIndexBuildError.Create(
      'The index builder requires a valid empty index template.');
  if ReadEncryption(TemplateFile) <> 0 then
    raise EDBParadoxUnsupportedIndexFeature.Create(
      'Encrypted index templates are not supported by the Pascal index builder.');

  KeyLength := Header.RecordSize - DataBlockHeaderSize;
  PhysicalCapacity := (Header.MaximumTableSize * 1024 -
    DataBlockHeaderSize) div Header.RecordSize;
  if (KeyLength <= 0) or (Header.FieldCount <= 0) or
    (PhysicalCapacity <= 0) then
    raise EDBParadoxIndexBuildError.Create(
      'The empty index schema or data-block capacity is invalid.');

  for EntryIndex := 0 to High(Entries) do
    ValidateEntry(Entries[EntryIndex], KeyLength);

  LeafCount := (Length(Entries) + PhysicalCapacity - 1) div PhysicalCapacity;
  if (LeafCount < 1) or (LeafCount > Length(Entries)) then
    raise EDBParadoxIndexBuildError.Create(
      'The requested index leaf-node count is invalid.');
  if (Length(Entries) > 1) and (PhysicalCapacity < 2) then
    raise EDBParadoxUnsupportedIndexFeature.Create(
      'The Paradox index block cannot reduce the number of nodes at each tree level.');

  CurrentLevel := nil;
  ParentLevel := nil;
  Levels := nil;
  Blocks := nil;
  LevelNodes := nil;
  Node.FirstKey := nil;
  Node.Records := nil;
  SetLength(CurrentLevel, LeafCount);
  BaseGroupSize := Length(Entries) div LeafCount;
  LargerGroups := Length(Entries) mod LeafCount;
  EntryOffset := 0;
  NextBlockNumber := 1;
  RecordIndexCount := 0;
  for LeafIndex := 0 to LeafCount - 1 do
  begin
    CurrentGroupSize := BaseGroupSize;
    if LeafIndex < LargerGroups then
      Inc(CurrentGroupSize);
    SetLength(Node.Records, CurrentGroupSize);
    Node.RecordCount := 0;
    for EntryIndex := 0 to CurrentGroupSize - 1 do
    begin
      Node.Records[EntryIndex] := CreateIndexRecord(
        Entries[EntryOffset].Key,
        Entries[EntryOffset].DataBlockNumber,
        Entries[EntryOffset].DataRecordCount,
        KeyLength,
        Header.RecordSize);
      Inc(Node.RecordCount, Entries[EntryOffset].DataRecordCount);
      Inc(RecordIndexCount);
      Inc(EntryOffset);
    end;
    Node.BlockNumber := NextBlockNumber;
    Node.FirstKey := Copy(
      Entries[EntryOffset - CurrentGroupSize].Key,
      0,
      Length(Entries[EntryOffset - CurrentGroupSize].Key));
    CurrentLevel[LeafIndex] := Node;
    Inc(NextBlockNumber);
  end;

  SetLength(Levels, 1);
  Levels[0] := CurrentLevel;
  while Length(CurrentLevel) > 1 do
  begin
    SetLength(ParentLevel,
      (Length(CurrentLevel) + PhysicalCapacity - 1) div PhysicalCapacity);
    ChildStart := 0;
    for NodeIndex := 0 to High(ParentLevel) do
    begin
      ChildCount := Length(CurrentLevel) - ChildStart;
      if ChildCount > PhysicalCapacity then
        ChildCount := PhysicalCapacity;
      SetLength(Node.Records, ChildCount);
      Node.RecordCount := 0;
      for EntryIndex := 0 to ChildCount - 1 do
      begin
        ChildNode := CurrentLevel[ChildStart + EntryIndex];
        Node.Records[EntryIndex] := CreateIndexRecord(
          ChildNode.FirstKey,
          ChildNode.BlockNumber,
          ChildNode.RecordCount,
          KeyLength,
          Header.RecordSize);
        Inc(Node.RecordCount, ChildNode.RecordCount);
        Inc(RecordIndexCount);
      end;
      Node.BlockNumber := NextBlockNumber;
      Node.FirstKey := Copy(
        CurrentLevel[ChildStart].FirstKey,
        0,
        Length(CurrentLevel[ChildStart].FirstKey));
      ParentLevel[NodeIndex] := Node;
      Inc(NextBlockNumber);
      Inc(ChildStart, ChildCount);
    end;
    CurrentLevel := ParentLevel;
    SetLength(Levels, Length(Levels) + 1);
    Levels[High(Levels)] := CurrentLevel;
  end;

  BlockCount := NextBlockNumber - 1;
  if BlockCount > High(Word) then
    raise EDBParadoxUnsupportedIndexFeature.Create(
      'The Paradox index exceeds the supported block or tree-depth range.');
  OutputSize := Int64(Header.HeaderSize) +
    BlockCount * Header.MaximumTableSize * 1024;

  SetLength(Blocks, Integer(BlockCount));
  for LevelIndex := 0 to High(Levels) do
  begin
    LevelNodes := Levels[LevelIndex];
    for NodeIndex := 0 to High(LevelNodes) do
    begin
      Block := CreateDataBlock(
        Header,
        LevelNodes[NodeIndex].BlockNumber,
        Integer(BlockCount),
        LevelNodes[NodeIndex].Records);
      Blocks[LevelNodes[NodeIndex].BlockNumber - 1] := Block;
    end;
  end;

  SetLength(Result, SizeInt(OutputSize));
  Move(TemplateFile[0], Result[0], Header.HeaderSize);
  for NodeIndex := 0 to High(Blocks) do
  begin
    BlockOffset := Header.HeaderSize +
      NodeIndex * Header.MaximumTableSize * 1024;
    Move(Blocks[NodeIndex][0], Result[BlockOffset], Length(Blocks[NodeIndex]));
  end;

  UpdateMultipleBlockHeader(Result, RecordIndexCount, Integer(BlockCount));
  WriteUInt16LE(Result, $1E, Word(CurrentLevel[0].BlockNumber));
  Result[$20] := Byte(Length(Levels));
end;

end.
