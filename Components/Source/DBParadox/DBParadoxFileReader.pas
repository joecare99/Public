unit DBParadoxFileReader;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  EDBParadoxFileReadError = class(Exception);

  TDBParadoxFileField = record
    Name: string;
    FieldType: Byte;
    FieldLength: Integer;
    Offset: Integer;
  end;

  TDBParadoxFileFields = array of TDBParadoxFileField;

  TDBParadoxFileRow = record
    RecordNumber: Integer;
    Data: TBytes;
  end;

  TDBParadoxFileRows = array of TDBParadoxFileRow;

procedure ReadDBParadoxTable(const FileName: string;
  out Fields: TDBParadoxFileFields; out Rows: TDBParadoxFileRows;
  out RecordSize: Integer);

implementation

uses
  Classes;

const
  CommonHeaderSize = $58;
  DataHeaderSize = $78;
  DataBlockHeaderSize = 6;
  MaximumFieldCount = 256;
  EncryptionMarker = $FF00FF00;

type
  TTableHeader = record
    RecordSize: Integer;
    HeaderSize: Integer;
    MaximumTableSize: Integer;
    RecordCount: Integer;
    BlockCount: Integer;
    FirstBlock: Integer;
    Version: Byte;
    Encryption: Cardinal;
    FieldCount: Integer;
  end;

function ReadUInt16LE(const Data: TBytes; Offset: SizeInt): Word;
begin
  Result := Word(Data[Offset]) or (Word(Data[Offset + 1]) shl 8);
end;

function ReadInt16LE(const Data: TBytes; Offset: SizeInt): SmallInt;
begin
  Result := SmallInt(ReadUInt16LE(Data, Offset));
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

function ReadTableHeader(const Data: TBytes): TTableHeader;
var
  MinimumHeaderSize: Integer;
  AvailableBlocks: Int64;
  BlockSize: Int64;
begin
  if Length(Data) < CommonHeaderSize then
    raise EDBParadoxFileReadError.Create(
      'The file is too small to contain a Paradox table header.');

  if not (Data[4] in [0, 2]) then
    raise EDBParadoxFileReadError.CreateFmt(
      'Paradox file type %d is not a supported .DB table.', [Data[4]]);

  Result.Version := Data[$39];
  if not (Result.Version in [$0B, $0C]) then
    raise EDBParadoxFileReadError.CreateFmt(
      'Paradox file version 0x%.2x is not supported.', [Result.Version]);

  MinimumHeaderSize := DataHeaderSize;

  Result.RecordSize := ReadUInt16LE(Data, 0);
  Result.HeaderSize := ReadUInt16LE(Data, 2);
  Result.MaximumTableSize := Data[5];
  Result.RecordCount := ReadInt32LE(Data, 6);
  Result.BlockCount := ReadUInt16LE(Data, $0C);
  Result.FirstBlock := ReadUInt16LE(Data, $0E);
  Result.FieldCount := ReadUInt16LE(Data, $21);
  Result.Encryption := ReadUInt32LE(Data, $25);
  if Result.Encryption = EncryptionMarker then
  begin
    if Length(Data) < DataHeaderSize then
      raise EDBParadoxFileReadError.Create(
        'The encrypted Paradox data header is truncated.');
    Result.Encryption := ReadUInt32LE(Data, $5C);
  end;

  if (Result.RecordSize <= 0) or (Result.RecordCount < 0) or
    (Result.MaximumTableSize < 1) or (Result.MaximumTableSize > 32) or
    (Result.FieldCount <= 0) or
    (Result.FieldCount > MaximumFieldCount) or
    (Result.HeaderSize < MinimumHeaderSize) or
    (Result.HeaderSize > Length(Data)) then
    raise EDBParadoxFileReadError.Create(
      'The Paradox table header contains invalid dimensions.');
  if Result.Encryption <> 0 then
    raise EDBParadoxFileReadError.Create(
      'Encrypted Paradox tables are not supported by the internal reader.');

  BlockSize := Int64(Result.MaximumTableSize) * 1024;
  AvailableBlocks := (Int64(Length(Data)) - Result.HeaderSize) div BlockSize;
  if Result.BlockCount > AvailableBlocks then
    raise EDBParadoxFileReadError.Create(
      'The Paradox table declares data blocks beyond the end of the file.');
  if (Result.RecordCount > 0) and
    ((Result.BlockCount = 0) or (Result.FirstBlock = 0)) then
    raise EDBParadoxFileReadError.Create(
      'The Paradox table declares records but has no first data block.');
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
      raise EDBParadoxFileReadError.Create(
        'The Paradox schema contains a non-ASCII field name.');
    Inc(Offset);
  end;
  if Offset >= HeaderSize then
    raise EDBParadoxFileReadError.Create(
      'The Paradox schema contains an unterminated field name.');
  SetLength(Result, Offset - StartOffset);
  if Length(Result) > 0 then
    Move(Data[StartOffset], Result[1], Length(Result));
  Inc(Offset);
end;

procedure ReadFields(const Data: TBytes; const Header: TTableHeader;
  out Fields: TDBParadoxFileFields);
var
  DataHeaderOffset: SizeInt;
  DescriptorEnd: SizeInt;
  TableNameLength: SizeInt;
  FieldNamesOffset: SizeInt;
  NameOffset: SizeInt;
  Index: Integer;
  FieldLength: Integer;
  CalculatedRecordSize: Int64;
begin
  Fields := nil;
  if Header.Version >= $0B then
    DataHeaderOffset := DataHeaderSize
  else
    DataHeaderOffset := CommonHeaderSize;
  if DataHeaderOffset > Header.HeaderSize then
    raise EDBParadoxFileReadError.Create(
      'The Paradox data header is truncated.');

  DescriptorEnd := DataHeaderOffset + Header.FieldCount * 2;
  if Header.Version = $0C then
    TableNameLength := 261
  else
    TableNameLength := 79;
  FieldNamesOffset := DescriptorEnd + 4 + Header.FieldCount * 4 +
    TableNameLength;
  if FieldNamesOffset > Header.HeaderSize then
    raise EDBParadoxFileReadError.Create(
      'The Paradox field-name table exceeds the header.');

  SetLength(Fields, Header.FieldCount);
  NameOffset := FieldNamesOffset;
  CalculatedRecordSize := 0;
  for Index := 0 to Header.FieldCount - 1 do
  begin
    Fields[Index].FieldType := Data[DataHeaderOffset + Index * 2];
    FieldLength := Data[DataHeaderOffset + Index * 2 + 1];
    if Fields[Index].FieldType = $0A then
      FieldLength := 17;
    Fields[Index].Name := ReadAsciiFieldName(
      Data, NameOffset, Header.HeaderSize);
    if (Fields[Index].Name = '') or (FieldLength <= 0) then
      raise EDBParadoxFileReadError.CreateFmt(
        'The Paradox field %d has an invalid name or physical width.',
        [Index]);
    Fields[Index].FieldLength := FieldLength;
    Fields[Index].Offset := CalculatedRecordSize;
    Inc(CalculatedRecordSize, FieldLength);
  end;
  if CalculatedRecordSize <> Header.RecordSize then
    raise EDBParadoxFileReadError.CreateFmt(
      'Paradox fields occupy %d bytes but the header declares %d bytes per record.',
      [CalculatedRecordSize, Header.RecordSize]);
end;

procedure AppendBlockRows(const Data: TBytes; const Header: TTableHeader;
  BlockNumber: Integer; var Rows: TDBParadoxFileRows);
var
  BlockOffset: SizeInt;
  BlockSize: SizeInt;
  DataSize: SmallInt;
  MaximumRecordData: SizeInt;
  RecordsInBlock: Integer;
  RecordIndex: Integer;
  RowIndex: SizeInt;
  SourceOffset: SizeInt;
begin
  BlockSize := Header.MaximumTableSize * 1024;
  BlockOffset := Header.HeaderSize + (BlockNumber - 1) * BlockSize;
  if (BlockOffset < 0) or (BlockOffset > Length(Data) - BlockSize) then
    raise EDBParadoxFileReadError.CreateFmt(
      'Paradox data block %d is outside the file.', [BlockNumber]);

  DataSize := ReadInt16LE(Data, BlockOffset + 4);
  MaximumRecordData := BlockSize - DataBlockHeaderSize;
  if (DataSize < -Header.RecordSize) or
    (DataSize > MaximumRecordData - Header.RecordSize) or
    ((DataSize < 0) and (DataSize <> -Header.RecordSize)) or
    ((DataSize >= 0) and (DataSize mod Header.RecordSize <> 0)) then
    raise EDBParadoxFileReadError.CreateFmt(
      'Paradox data block %d has an invalid record-data size.', [BlockNumber]);
  if DataSize < 0 then
    RecordsInBlock := 0
  else
    RecordsInBlock := DataSize div Header.RecordSize + 1;
  if RecordsInBlock > MaximumRecordData div Header.RecordSize then
    raise EDBParadoxFileReadError.CreateFmt(
      'Paradox data block %d declares too many records.', [BlockNumber]);

  for RecordIndex := 0 to RecordsInBlock - 1 do
  begin
    if Length(Rows) >= Header.RecordCount then
      raise EDBParadoxFileReadError.Create(
        'Deleted Paradox record slots are not yet supported by the internal reader.');
    RowIndex := Length(Rows);
    SetLength(Rows, RowIndex + 1);
    Rows[RowIndex].RecordNumber := RowIndex;
    Rows[RowIndex].Data := nil;
    SetLength(Rows[RowIndex].Data, Header.RecordSize);
    SourceOffset := BlockOffset + DataBlockHeaderSize +
      RecordIndex * Header.RecordSize;
    Move(Data[SourceOffset], Rows[RowIndex].Data[0], Header.RecordSize);
  end;
end;

procedure ReadDBParadoxTable(const FileName: string;
  out Fields: TDBParadoxFileFields; out Rows: TDBParadoxFileRows;
  out RecordSize: Integer);
var
  Stream: TFileStream;
  Data: TBytes;
  Header: TTableHeader;
  BlockNumber: Integer;
  NextBlock: Integer;
  VisitedBlocks: array of Boolean;
  BlockOffset: SizeInt;
  BlockSize: SizeInt;
begin
  Fields := nil;
  Rows := nil;
  Data := nil;
  VisitedBlocks := nil;
  RecordSize := 0;
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    if (Stream.Size - Int64(High(SizeInt))) > 0 then
      raise EDBParadoxFileReadError.Create(
        'The Paradox table exceeds the supported in-memory file size.');
    SetLength(Data, Stream.Size);
    if Length(Data) > 0 then
      Stream.ReadBuffer(Data[0], Length(Data));
  finally
    Stream.Free;
  end;

  Header := ReadTableHeader(Data);
  ReadFields(Data, Header, Fields);
  RecordSize := Header.RecordSize;
  SetLength(VisitedBlocks, Header.BlockCount + 1);
  BlockSize := Header.MaximumTableSize * 1024;
  BlockNumber := Header.FirstBlock;
  while BlockNumber <> 0 do
  begin
    if (BlockNumber < 1) or (BlockNumber > Header.BlockCount) or
      VisitedBlocks[BlockNumber] then
      raise EDBParadoxFileReadError.Create(
        'The Paradox data-block chain contains an invalid or repeated block number.');
    VisitedBlocks[BlockNumber] := True;
    AppendBlockRows(Data, Header, BlockNumber, Rows);
    BlockOffset := Header.HeaderSize + (BlockNumber - 1) * BlockSize;
    NextBlock := ReadUInt16LE(Data, BlockOffset);
    BlockNumber := NextBlock;
  end;

  if Length(Rows) <> Header.RecordCount then
    raise EDBParadoxFileReadError.CreateFmt(
      'The Paradox header declares %d records but %d physical records were found.',
      [Header.RecordCount, Length(Rows)]);
end;

end.
