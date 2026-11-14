unit DBParadoxSecondaryIndexValidator;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  EDBParadoxSecondaryIndexValidationError = class(Exception);

procedure ValidateDBParadoxSecondaryIndexFiles(const XgTemplate, YgTemplate,
  XgFile, YgFile: TBytes; APrimaryIndexRevision: Byte;
  ATableDataBlockCount: Integer);

implementation

const
  DataHeaderSize = $78;
  IndexHeaderSize = $58;
  DataBlockHeaderSize = 6;
  ClassicDataFileType = 5;
  ClassicIndexFileType = 4;
  XgDataFileType = 8;
  XgIndexFileType = 7;

type
  TSidecarHeader = record
    RecordSize: Integer;
    RecordCount: Integer;
    BlockCount: Integer;
    BlockSize: Integer;
    FieldCount: Integer;
    KeyFieldCount: Integer;
    HeaderSize: Integer;
    RootBlock: Integer;
    TreeLevels: Integer;
  end;

  TSecondaryBlockSummary = record
    FirstKey: TBytes;
    LastKey: TBytes;
    RecordCount: Integer;
  end;

  TSecondaryBlockSummaries = array of TSecondaryBlockSummary;
  TBlockVisited = array of Boolean;

  TSecondaryTreeWalker = class
  private
    FYgFile: TBytes;
    FXgSummaries: TSecondaryBlockSummaries;
    FVisitedYg: TBlockVisited;
    FVisitedXg: TBlockVisited;
    FKeyLength: Integer;
    FYgHeader: TSidecarHeader;
    FXgRecordCount: Integer;
    FYgRecordCount: Integer;
    function WalkNode(ABlockNumber, ALevel: Integer):
      TSecondaryBlockSummary;
  public
    constructor Create(const AYgFile: TBytes;
      const AXgSummaries: TSecondaryBlockSummaries;
      const AYgHeader: TSidecarHeader; AKeyLength, AXgRecordCount: Integer);
    procedure Validate;
  end;

function ReadUInt16LE(const AData: TBytes; AOffset: SizeInt): Word;
begin
  if (AOffset < 0) or (AOffset + 1 >= Length(AData)) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'A secondary-index header or block is truncated.');
  Result := Word(AData[AOffset]) or (Word(AData[AOffset + 1]) shl 8);
end;

function ReadInt16LE(const AData: TBytes; AOffset: SizeInt): SmallInt;
begin
  Result := SmallInt(ReadUInt16LE(AData, AOffset));
end;

function ReadInt32LE(const AData: TBytes; AOffset: SizeInt): LongInt;
begin
  if (AOffset < 0) or (AOffset + 3 >= Length(AData)) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'A secondary-index header is truncated.');
  Result := LongInt(Cardinal(AData[AOffset]) or
    (Cardinal(AData[AOffset + 1]) shl 8) or
    (Cardinal(AData[AOffset + 2]) shl 16) or
    (Cardinal(AData[AOffset + 3]) shl 24));
end;

function ReadUInt32LE(const AData: TBytes; AOffset: SizeInt): Cardinal;
begin
  if (AOffset < 0) or (AOffset + 3 >= Length(AData)) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'A secondary-index header is truncated.');
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

function CompareKeys(const ALeft, ARight: TBytes): Integer;
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

function ReadParadoxShort(const AData: TBytes; AOffset: SizeInt;
  AAllowZero: Boolean; const ADescription: string): Integer;
var
  HighByte: Byte;
begin
  if (AOffset < 0) or (AOffset + 1 >= Length(AData)) then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s value is truncated.', [ADescription]);
  HighByte := AData[AOffset];
  if (HighByte and $80) = 0 then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s value is not a positive Paradox short.', [ADescription]);
  Result := ((HighByte and $7F) shl 8) or AData[AOffset + 1];
  if (Result = 0) and not AAllowZero then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s value must be positive.', [ADescription]);
end;

function ReadSidecarHeader(const AData: TBytes; AExpectedFileType: Byte;
  AIsXg, AAllowEmptyTemplate: Boolean;
  const ADescription: string): TSidecarHeader;
var
  MinimumHeaderSize: Integer;
  DeclaredBlockBytes: Int64;
begin
  if AIsXg then
    MinimumHeaderSize := DataHeaderSize
  else
    MinimumHeaderSize := IndexHeaderSize;
  if (Length(AData) < MinimumHeaderSize) or
    (AData[4] <> AExpectedFileType) then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s file type or header is invalid.', [ADescription]);

  Result.RecordSize := ReadUInt16LE(AData, 0);
  Result.HeaderSize := ReadUInt16LE(AData, 2);
  Result.RecordCount := ReadInt32LE(AData, 6);
  Result.BlockCount := ReadUInt16LE(AData, $0C);
  Result.BlockSize := Integer(AData[5]) * 1024;
  Result.FieldCount := ReadUInt16LE(AData, $21);
  Result.KeyFieldCount := 0;
  Result.RootBlock := 0;
  Result.TreeLevels := 0;
  if not AIsXg then
  begin
    Result.RootBlock := ReadUInt16LE(AData, $1E);
    Result.TreeLevels := AData[$20];
  end
  else
    Result.KeyFieldCount := ReadUInt16LE(AData, $23);

  if (Result.RecordSize <= DataBlockHeaderSize) or
    (Result.RecordCount < 0) or (Result.BlockCount < 0) or
    ((Result.BlockCount = 0) and not AAllowEmptyTemplate) or
    (Result.BlockSize <= DataBlockHeaderSize) or
    (AData[5] > 32) or (Result.FieldCount <= 0) or
    (Result.HeaderSize < MinimumHeaderSize) or
    (Result.HeaderSize > Length(AData)) then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s dimensions are invalid.', [ADescription]);
  DeclaredBlockBytes := Int64(Result.BlockCount) * Result.BlockSize;
  if Int64(Result.HeaderSize) + DeclaredBlockBytes <> Length(AData) then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s file length does not match its declared block count.',
      [ADescription]);
  if (AIsXg and
    (Int64(DataHeaderSize) + Int64(Result.FieldCount) * 2 >
      Result.HeaderSize)) or
    (not AIsXg and
    (Int64(IndexHeaderSize) + Int64(Result.FieldCount) * 2 >
      Result.HeaderSize)) then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s field descriptors exceed its header.', [ADescription]);
  if not AAllowEmptyTemplate and
    ((ReadUInt16LE(AData, $0A) <> Result.BlockCount) or
     (ReadUInt16LE(AData, $0E) <> 1) or
     (ReadUInt16LE(AData, $10) <> Result.BlockCount)) then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s block-count metadata is inconsistent.', [ADescription]);
end;

procedure ValidateBlockChain(const AData: TBytes;
  const AHeader: TSidecarHeader; const ADescription: string);
var
  BlockNumber, BlockOffset, ExpectedNext, ExpectedPrevious: SizeInt;
begin
  for BlockNumber := 1 to AHeader.BlockCount do
  begin
    BlockOffset := AHeader.HeaderSize +
      (BlockNumber - 1) * AHeader.BlockSize;
    if BlockNumber < AHeader.BlockCount then
      ExpectedNext := BlockNumber + 1
    else
      ExpectedNext := 0;
    ExpectedPrevious := BlockNumber - 1;
    if (ReadUInt16LE(AData, BlockOffset) <> ExpectedNext) or
      (ReadUInt16LE(AData, BlockOffset + 2) <> ExpectedPrevious) then
      raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
        'The %s block %d has an invalid forward or backward link.',
        [ADescription, BlockNumber]);
  end;
end;

function ReadBlockRecordCount(const AData: TBytes;
  const AHeader: TSidecarHeader; ABlockNumber: Integer;
  const ADescription: string): Integer;
var
  BlockOffset: SizeInt;
  DataSize: SmallInt;
begin
  if (ABlockNumber < 1) or (ABlockNumber > AHeader.BlockCount) then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s block reference %d is outside the file.',
      [ADescription, ABlockNumber]);
  BlockOffset := AHeader.HeaderSize +
    (ABlockNumber - 1) * AHeader.BlockSize;
  DataSize := ReadInt16LE(AData, BlockOffset + 4);
  if (DataSize < 0) or (DataSize mod AHeader.RecordSize <> 0) then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s block %d has an invalid record-data size.',
      [ADescription, ABlockNumber]);
  Result := DataSize div AHeader.RecordSize + 1;
  if Result >
    (AHeader.BlockSize - DataBlockHeaderSize) div AHeader.RecordSize then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The %s block %d exceeds its physical capacity.',
      [ADescription, ABlockNumber]);
end;

function ValidateXgFile(const ATemplate, AXgFile: TBytes;
  APrimaryIndexRevision, ATableDataBlockCount: Integer;
  out AHeader: TSidecarHeader; out AKeyLength: Integer):
  TSecondaryBlockSummaries;
var
  TemplateHeader: TSidecarHeader;
  BlockNumber, BlockOffset, RecordIndex, RecordOffset: SizeInt;
  BlockRecordCount, TotalRecordCount, KeyField, FieldOffset: SizeInt;
  Key, PreviousKey: TBytes;
  SourceBlock: Integer;
begin
  Result := nil;
  if Length(ATemplate) < DataHeaderSize then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG template is truncated.');
  if not (ATemplate[4] in [ClassicDataFileType, XgDataFileType]) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG template has an unsupported file type.');
  TemplateHeader := ReadSidecarHeader(ATemplate, ATemplate[4], True, True,
    'XG template');
  AHeader := ReadSidecarHeader(AXgFile, ATemplate[4], True, False, 'XG data');
  if (AHeader.KeyFieldCount <= 0) or
    (AHeader.FieldCount <> AHeader.KeyFieldCount + 1) or
    (ATemplate[$39] <> AXgFile[$39]) or
    (ATemplate[$55] <> AXgFile[$55]) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG schema or options do not match the configured template.');
  if ReadUInt32LE(ATemplate, $25) <> ReadUInt32LE(AXgFile, $25) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG encryption metadata differs from its template.');
  if (TemplateHeader.FieldCount <> AHeader.FieldCount) or
    (TemplateHeader.KeyFieldCount <> AHeader.KeyFieldCount) or
    (TemplateHeader.RecordSize <> AHeader.RecordSize) or
    (TemplateHeader.HeaderSize <> AHeader.HeaderSize) or
    (TemplateHeader.BlockSize <> AHeader.BlockSize) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG field counts differ from the configured template.');
  AKeyLength := 0;
  FieldOffset := DataHeaderSize;
  for KeyField := 0 to AHeader.KeyFieldCount - 1 do
  begin
    if (ATemplate[FieldOffset + KeyField * 2] <>
      AXgFile[FieldOffset + KeyField * 2]) or
      (ATemplate[FieldOffset + KeyField * 2 + 1] <>
      AXgFile[FieldOffset + KeyField * 2 + 1]) then
      raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
        'The XG field %d differs from its template.', [KeyField]);
    Inc(AKeyLength, AXgFile[FieldOffset + KeyField * 2 + 1]);
  end;
  if (ATemplate[FieldOffset + AHeader.KeyFieldCount * 2] <>
    AXgFile[FieldOffset + AHeader.KeyFieldCount * 2]) or
    (ATemplate[FieldOffset + AHeader.KeyFieldCount * 2 + 1] <>
    AXgFile[FieldOffset + AHeader.KeyFieldCount * 2 + 1]) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG trailing block-reference field differs from its template.');
  if (AXgFile[FieldOffset + AHeader.KeyFieldCount * 2] <> $03) or
    (AXgFile[FieldOffset + AHeader.KeyFieldCount * 2 + 1] <> 2) or
    (AHeader.RecordSize <> AKeyLength + 2) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG key or trailing block-reference field is invalid.');
  for KeyField := 0 to AHeader.FieldCount - 1 do
  begin
    if AXgFile[FieldOffset + KeyField * 2] = $17 then
      raise EDBParadoxSecondaryIndexValidationError.Create(
        'BCD XG fields are outside the structural validator scope.');
  end;
  if (AXgFile[$2F] <> APrimaryIndexRevision) or
    (ATableDataBlockCount <= 0) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG primary revision or table block count is invalid.');

  ValidateBlockChain(AXgFile, AHeader, 'XG');
  SetLength(Result, AHeader.BlockCount);
  TotalRecordCount := 0;
  Key := nil;
  PreviousKey := nil;
  for BlockNumber := 1 to AHeader.BlockCount do
  begin
    BlockOffset := AHeader.HeaderSize +
      (BlockNumber - 1) * AHeader.BlockSize;
    BlockRecordCount := ReadBlockRecordCount(
      AXgFile, AHeader, BlockNumber, 'XG');
    TotalRecordCount := TotalRecordCount + BlockRecordCount;
    RecordOffset := BlockOffset + DataBlockHeaderSize;
    for RecordIndex := 0 to BlockRecordCount - 1 do
    begin
      SetLength(Key, AKeyLength);
      if AKeyLength > 0 then
        Move(AXgFile[RecordOffset], Key[0], AKeyLength);
      SourceBlock := ReadParadoxShort(AXgFile,
        RecordOffset + AKeyLength, False,
        'XG source block');
      if SourceBlock > ATableDataBlockCount then
        raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
          'The XG record references nonexistent table data block %d.',
          [SourceBlock]);
      if (Length(PreviousKey) > 0) and
        (CompareKeys(PreviousKey, Key) > 0) then
        raise EDBParadoxSecondaryIndexValidationError.Create(
          'The XG records are not in key order.');
      if RecordIndex = 0 then
        Result[BlockNumber - 1].FirstKey := Copy(Key, 0, Length(Key));
      Result[BlockNumber - 1].LastKey := Copy(Key, 0, Length(Key));
      PreviousKey := Copy(Key, 0, Length(Key));
      Inc(RecordOffset, AHeader.RecordSize);
    end;
    Result[BlockNumber - 1].RecordCount := BlockRecordCount;
  end;
  if TotalRecordCount <> AHeader.RecordCount then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG header record count does not match its data blocks.');
end;

constructor TSecondaryTreeWalker.Create(const AYgFile: TBytes;
  const AXgSummaries: TSecondaryBlockSummaries;
  const AYgHeader: TSidecarHeader; AKeyLength, AXgRecordCount: Integer);
begin
  inherited Create;
  FYgFile := AYgFile;
  FXgSummaries := AXgSummaries;
  FYgHeader := AYgHeader;
  FKeyLength := AKeyLength;
  FXgRecordCount := AXgRecordCount;
  FYgRecordCount := 0;
  SetLength(FVisitedYg, FYgHeader.BlockCount + 1);
  SetLength(FVisitedXg, Length(FXgSummaries) + 1);
end;

function TSecondaryTreeWalker.WalkNode(ABlockNumber, ALevel: Integer):
  TSecondaryBlockSummary;
var
  BlockOffset, EntryIndex, EntryOffset, EntryCount: SizeInt;
  ChildBlockNumber, DeclaredRecordCount, CalculatedCount: Integer;
  ChildSummary: TSecondaryBlockSummary;
  Key, PreviousKey: TBytes;
  IsLeaf: Boolean;
begin
  if (ABlockNumber < 1) or (ABlockNumber > FYgHeader.BlockCount) then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The YG tree references nonexistent block %d.', [ABlockNumber]);
  if FVisitedYg[ABlockNumber] then
    raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
      'The YG tree references block %d more than once or contains a cycle.',
      [ABlockNumber]);
  FVisitedYg[ABlockNumber] := True;
  BlockOffset := FYgHeader.HeaderSize +
    (ABlockNumber - 1) * FYgHeader.BlockSize;
  EntryCount := ReadBlockRecordCount(FYgFile, FYgHeader,
    ABlockNumber, 'YG');
  EntryOffset := BlockOffset + DataBlockHeaderSize;
  PreviousKey := nil;
  Result.FirstKey := nil;
  Result.LastKey := nil;
  Result.RecordCount := 0;
  Key := nil;
  IsLeaf := ALevel = 1;
  for EntryIndex := 0 to EntryCount - 1 do
  begin
    SetLength(Key, FKeyLength);
    if FKeyLength > 0 then
      Move(FYgFile[EntryOffset], Key[0], FKeyLength);
    ChildBlockNumber := ReadParadoxShort(
      FYgFile, EntryOffset + FKeyLength, False, 'YG child block');
    DeclaredRecordCount := ReadParadoxShort(
      FYgFile, EntryOffset + FKeyLength + 2, False,
      'YG subtree record count');
    if ReadParadoxShort(FYgFile, EntryOffset + FKeyLength + 4, True,
      'YG reserved field') <> 0 then
      raise EDBParadoxSecondaryIndexValidationError.Create(
        'The YG reserved record field is not zero.');
    if (Length(PreviousKey) > 0) and (CompareKeys(PreviousKey, Key) > 0) then
      raise EDBParadoxSecondaryIndexValidationError.Create(
        'The YG node keys are not in key order.');

    if IsLeaf then
    begin
      if (ChildBlockNumber < 1) or
        (ChildBlockNumber > Length(FXgSummaries)) then
        raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
          'The YG leaf references nonexistent XG block %d.',
          [ChildBlockNumber]);
      if FVisitedXg[ChildBlockNumber] then
        raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
          'The YG tree references XG block %d more than once.',
          [ChildBlockNumber]);
      FVisitedXg[ChildBlockNumber] := True;
      ChildSummary := FXgSummaries[ChildBlockNumber - 1];
      CalculatedCount := ChildSummary.RecordCount;
    end
    else
    begin
      ChildSummary := WalkNode(ChildBlockNumber, ALevel - 1);
      CalculatedCount := ChildSummary.RecordCount;
    end;
    if (not SameBytes(Key, ChildSummary.FirstKey)) or
      (DeclaredRecordCount <> CalculatedCount) then
      raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
        'The YG entry for block %d has an incorrect boundary key or record count.',
        [ChildBlockNumber]);
    if EntryIndex = 0 then
      Result.FirstKey := Copy(ChildSummary.FirstKey, 0,
        Length(ChildSummary.FirstKey));
    if (EntryIndex > 0) and
      (CompareKeys(Result.LastKey, ChildSummary.FirstKey) > 0) then
      raise EDBParadoxSecondaryIndexValidationError.Create(
        'Adjacent YG child ranges overlap out of key order.');
    Result.LastKey := Copy(ChildSummary.LastKey, 0,
      Length(ChildSummary.LastKey));
    Inc(Result.RecordCount, CalculatedCount);
    PreviousKey := Copy(Key, 0, Length(Key));
    Inc(FYgRecordCount);
    Inc(EntryOffset, FYgHeader.RecordSize);
  end;
end;

procedure TSecondaryTreeWalker.Validate;
var
  RootSummary: TSecondaryBlockSummary;
  BlockNumber: SizeInt;
begin
  if (FYgHeader.RootBlock < 1) or
    (FYgHeader.RootBlock > FYgHeader.BlockCount) or
    (FYgHeader.TreeLevels < 1) or
    (FYgHeader.TreeLevels > FYgHeader.BlockCount) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The YG root block or tree level count is invalid.');
  ValidateBlockChain(FYgFile, FYgHeader, 'YG');
  RootSummary := WalkNode(FYgHeader.RootBlock, FYgHeader.TreeLevels);
  for BlockNumber := 1 to FYgHeader.BlockCount do
    if not FVisitedYg[BlockNumber] then
      raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
        'The YG block %d is unreachable from the root.', [BlockNumber]);
  for BlockNumber := 1 to Length(FXgSummaries) do
    if not FVisitedXg[BlockNumber] then
      raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
        'The YG tree does not reference XG block %d.', [BlockNumber]);
  if (FYgRecordCount <> FYgHeader.RecordCount) or
    (RootSummary.RecordCount <> FXgRecordCount) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The YG header or root record count is inconsistent.');
end;

procedure ValidateDBParadoxSecondaryIndexFiles(const XgTemplate, YgTemplate,
  XgFile, YgFile: TBytes; APrimaryIndexRevision: Byte;
  ATableDataBlockCount: Integer);
var
  XgHeader, YgHeader, YgTemplateHeader: TSidecarHeader;
  XgSummaries: TSecondaryBlockSummaries;
  KeyLength: Integer;
  FieldIndex, YgFieldOffset: SizeInt;
  Walker: TSecondaryTreeWalker;
begin
  if Length(XgTemplate) < DataHeaderSize then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG template is truncated.');
  if XgTemplate[4] = ClassicDataFileType then
    YgHeader := ReadSidecarHeader(YgFile, ClassicIndexFileType, False, False,
      'YG')
  else if XgTemplate[4] = XgDataFileType then
    YgHeader := ReadSidecarHeader(YgFile, XgIndexFileType, False, False,
      'YG')
  else
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The XG/YG file-type pair is unsupported.');
  YgTemplateHeader := ReadSidecarHeader(YgTemplate, YgFile[4], False, True,
    'YG template');
  if (YgHeader.RecordSize <> YgTemplateHeader.RecordSize) or
    (YgHeader.FieldCount <> YgTemplateHeader.FieldCount) or
    (YgHeader.HeaderSize <> YgTemplateHeader.HeaderSize) or
    (YgHeader.BlockSize <> YgTemplateHeader.BlockSize) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The YG header schema differs from its configured template.');

  XgSummaries := ValidateXgFile(XgTemplate, XgFile,
    APrimaryIndexRevision, ATableDataBlockCount, XgHeader, KeyLength);
  if (YgHeader.RecordSize <> KeyLength + DataBlockHeaderSize) or
    (YgHeader.FieldCount <> XgHeader.KeyFieldCount) or
    (YgHeader.TreeLevels = 0) then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The YG record schema or tree metadata does not match the XG file.');
  if YgHeader.FieldCount <> XgHeader.KeyFieldCount then
    raise EDBParadoxSecondaryIndexValidationError.Create(
      'The YG field descriptor count differs from its key.');
  YgFieldOffset := IndexHeaderSize;
  for FieldIndex := 0 to XgHeader.KeyFieldCount - 1 do
    if (YgTemplate[YgFieldOffset + FieldIndex * 2] <>
      YgFile[YgFieldOffset + FieldIndex * 2]) or
      (YgTemplate[YgFieldOffset + FieldIndex * 2 + 1] <>
      YgFile[YgFieldOffset + FieldIndex * 2 + 1]) or
      (YgTemplate[YgFieldOffset + FieldIndex * 2] <>
      XgTemplate[DataHeaderSize + FieldIndex * 2]) or
      (YgTemplate[YgFieldOffset + FieldIndex * 2 + 1] <>
      XgTemplate[DataHeaderSize + FieldIndex * 2 + 1]) or
      (XgTemplate[DataHeaderSize + FieldIndex * 2] <>
      YgFile[YgFieldOffset + FieldIndex * 2]) or
      (XgTemplate[DataHeaderSize + FieldIndex * 2 + 1] <>
      YgFile[YgFieldOffset + FieldIndex * 2 + 1]) then
      raise EDBParadoxSecondaryIndexValidationError.CreateFmt(
        'The YG key field %d differs from the configured XG schema.',
        [FieldIndex]);

  Walker := TSecondaryTreeWalker.Create(YgFile, XgSummaries, YgHeader,
    KeyLength, XgHeader.RecordCount);
  try
    Walker.Validate;
  finally
    Walker.Free;
  end;
end;

end.
