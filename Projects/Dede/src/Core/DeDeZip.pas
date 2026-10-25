unit DeDeZip;

interface

uses
  Classes;

procedure ExtractZipEntryToStream(const AArchiveName, AEntryName: string;
  ADestination: TStream);
procedure WriteZipEntryFromStream(const AArchiveName, AEntryName: string;
  ASource: TStream);

implementation

uses
  SysUtils
{$IFDEF FPC}
  , PasZLib
{$ELSE}
  , ZLib
{$ENDIF}
  ;

const
  ZIP_LOCAL_SIGNATURE = $04034B50;
  ZIP_CENTRAL_SIGNATURE = $02014B50;
  ZIP_END_SIGNATURE = $06054B50;
  ZIP_DEFLATED = 8;
  ZIP_STORED = 0;
  ZIP_FLAG_ENCRYPTED = $0001;
  ZIP_FLAG_STRONG_ENCRYPTION = $0040;
  ZIP_FLAG_MASKED_HEADERS = $2000;
  ZIP_BUFFER_SIZE = 32768;
  ZIP_MAX_ENTRY_SIZE = LongWord(High(Integer));

type
  TZipBuffer = array[0..ZIP_BUFFER_SIZE - 1] of Byte;
{$IFDEF FPC}
  TDeDeZStream = TZStream;
{$ELSE}
  TDeDeZStream = TZStreamRec;
{$ENDIF}

  TZipEntryInfo = record
    Flags: Word;
    Method: Word;
    CRC: LongWord;
    CompressedSize: LongWord;
    UncompressedSize: LongWord;
    Name: AnsiString;
    LocalHeaderOffset: LongWord;
  end;

function BufferWord(const ABuffer; AOffset: Integer): Word;
var
  Bytes: array[0..1] of Byte absolute ABuffer;
begin
  Result := Word(Bytes[AOffset]) or (Word(Bytes[AOffset + 1]) shl 8);
end;

function BufferDWord(const ABuffer; AOffset: Integer): LongWord;
var
  Bytes: array[0..3] of Byte absolute ABuffer;
begin
  Result := LongWord(Bytes[AOffset]) or
    (LongWord(Bytes[AOffset + 1]) shl 8) or
    (LongWord(Bytes[AOffset + 2]) shl 16) or
    (LongWord(Bytes[AOffset + 3]) shl 24);
end;

procedure ReadAt(AStream: TStream; AOffset: Int64; var ABuffer;
  ACount: LongInt);
var
  SavedPosition: Int64;
begin
  if (AOffset < 0) or (ACount < 0) or (AOffset > AStream.Size) or
    (Int64(ACount) > AStream.Size - AOffset) then
    raise EReadError.Create('ZIP structure exceeds archive bounds');
  SavedPosition := AStream.Position;
  try
    AStream.Position := AOffset;
    AStream.ReadBuffer(ABuffer, ACount);
  finally
    AStream.Position := SavedPosition;
  end;
end;

function ReadWordAt(AStream: TStream; AOffset: Int64): Word;
var
  Bytes: array[0..1] of Byte;
begin
  ReadAt(AStream, AOffset, Bytes[0], SizeOf(Bytes));
  Result := Word(Bytes[0]) or (Word(Bytes[1]) shl 8);
end;

function ReadDWordAt(AStream: TStream; AOffset: Int64): LongWord;
var
  Bytes: array[0..3] of Byte;
begin
  ReadAt(AStream, AOffset, Bytes[0], SizeOf(Bytes));
  Result := LongWord(Bytes[0]) or
    (LongWord(Bytes[1]) shl 8) or
    (LongWord(Bytes[2]) shl 16) or
    (LongWord(Bytes[3]) shl 24);
end;

procedure WriteWordLE(AStream: TStream; AValue: Word);
var
  Bytes: array[0..1] of Byte;
begin
  Bytes[0] := Byte(AValue);
  Bytes[1] := Byte(AValue shr 8);
  AStream.WriteBuffer(Bytes[0], SizeOf(Bytes));
end;

procedure WriteDWordLE(AStream: TStream; AValue: LongWord);
var
  Bytes: array[0..3] of Byte;
begin
  Bytes[0] := Byte(AValue);
  Bytes[1] := Byte(AValue shr 8);
  Bytes[2] := Byte(AValue shr 16);
  Bytes[3] := Byte(AValue shr 24);
  AStream.WriteBuffer(Bytes[0], SizeOf(Bytes));
end;

function UpdateCRC32(ACRC: LongWord; const ABuffer; ACount: LongInt): LongWord;
var
  Bytes: array[0..ZIP_BUFFER_SIZE - 1] of Byte absolute ABuffer;
  I, Bit: LongInt;
begin
  Result := ACRC;
  for I := 0 to ACount - 1 do
  begin
    Result := Result xor Bytes[I];
    for Bit := 0 to 7 do
      if (Result and 1) <> 0 then
        Result := (Result shr 1) xor $EDB88320
      else
        Result := Result shr 1;
  end;
end;

procedure FindZipEntry(AArchive: TStream; const AExpectedEntry: string;
  out AInfo: TZipEntryInfo; out ADataOffset: Int64);
var
  Tail: array of Byte;
  Header: array[0..45] of Byte;
  LocalHeader: array[0..29] of Byte;
  EntryNameBytes: array of Byte;
  LocalNameBytes: array of Byte;
  TailSize, Index, CommentLength: Integer;
  TailStart, EndOffset, CentralOffset, CentralSize, CentralEnd: Int64;
  NameLength, ExtraLength, EntryCommentLength: Word;
  LocalNameLength, LocalExtraLength: Word;
  ExpectedName: AnsiString;
  Flags, Method: Word;
begin
  if AArchive.Size < 22 then
    raise EReadError.Create('ZIP end record is missing');

  if AArchive.Size > 22 + 65535 then
    TailSize := 22 + 65535
  else
    TailSize := Integer(AArchive.Size);
  SetLength(Tail, TailSize);
  TailStart := AArchive.Size - TailSize;
  ReadAt(AArchive, TailStart, Tail[0], TailSize);

  EndOffset := -1;
  for Index := TailSize - 22 downto 0 do
    if BufferDWord(Tail[Index], 0) = ZIP_END_SIGNATURE then
    begin
      CommentLength := BufferWord(Tail[Index], 20);
      if Index + 22 + CommentLength = TailSize then
      begin
        EndOffset := TailStart + Index;
        Break;
      end;
    end;
  if EndOffset < 0 then
    raise EReadError.Create('ZIP end record is invalid or truncated');

  if (BufferWord(Tail[EndOffset - TailStart], 4) <> 0) or
    (BufferWord(Tail[EndOffset - TailStart], 6) <> 0) or
    (BufferWord(Tail[EndOffset - TailStart], 8) <> 1) or
    (BufferWord(Tail[EndOffset - TailStart], 10) <> 1) then
    raise EReadError.Create('Only single-disk, single-entry ZIP archives are supported');

  CentralSize := BufferDWord(Tail[EndOffset - TailStart], 12);
  CentralOffset := BufferDWord(Tail[EndOffset - TailStart], 16);
  CentralEnd := CentralOffset + CentralSize;
  if (CentralOffset > EndOffset) or (CentralEnd > EndOffset) or
    (CentralSize < SizeOf(Header)) then
    raise EReadError.Create('ZIP central directory exceeds archive bounds');

  ReadAt(AArchive, CentralOffset, Header[0], SizeOf(Header));
  if BufferDWord(Header[0], 0) <> ZIP_CENTRAL_SIGNATURE then
    raise EReadError.Create('ZIP central directory signature is invalid');
  Flags := BufferWord(Header[0], 8);
  Method := BufferWord(Header[0], 10);
  NameLength := BufferWord(Header[0], 28);
  ExtraLength := BufferWord(Header[0], 30);
  EntryCommentLength := BufferWord(Header[0], 32);
  if Int64(SizeOf(Header)) + NameLength + ExtraLength +
    EntryCommentLength <> CentralSize then
    raise EReadError.Create('ZIP central directory entry length is invalid');

  if (Flags and (ZIP_FLAG_ENCRYPTED or ZIP_FLAG_STRONG_ENCRYPTION or
    ZIP_FLAG_MASKED_HEADERS)) <> 0 then
    raise EReadError.Create('Encrypted ZIP entries are not supported');
  if (Method <> ZIP_STORED) and (Method <> ZIP_DEFLATED) then
    raise EReadError.CreateFmt('Unsupported ZIP compression method: %d',
      [Method]);

  AInfo.Flags := Flags;
  AInfo.Method := Method;
  AInfo.CRC := BufferDWord(Header[0], 16);
  AInfo.CompressedSize := BufferDWord(Header[0], 20);
  AInfo.UncompressedSize := BufferDWord(Header[0], 24);
  AInfo.LocalHeaderOffset := BufferDWord(Header[0], 42);
  if (AInfo.CompressedSize = High(LongWord)) or
    (AInfo.UncompressedSize = High(LongWord)) or
    (AInfo.LocalHeaderOffset = High(LongWord)) then
    raise EReadError.Create('ZIP64 entries are not supported');
  if AInfo.UncompressedSize > ZIP_MAX_ENTRY_SIZE then
    raise EReadError.Create('ZIP entry exceeds the supported stream size');

  SetLength(EntryNameBytes, NameLength);
  if NameLength > 0 then
    ReadAt(AArchive, CentralOffset + SizeOf(Header), EntryNameBytes[0],
      NameLength);
  SetLength(AInfo.Name, NameLength);
  if NameLength > 0 then
    Move(EntryNameBytes[0], AInfo.Name[1], NameLength);
  ExpectedName := AnsiString(ExtractFileName(AExpectedEntry));
  if not SameText(string(AInfo.Name), string(ExpectedName)) then
    raise EReadError.CreateFmt('ZIP entry "%s" does not match "%s"',
      [string(AInfo.Name), string(ExpectedName)]);

  if AInfo.LocalHeaderOffset >= CentralOffset then
    raise EReadError.Create('ZIP local header is outside the file-data area');
  ReadAt(AArchive, AInfo.LocalHeaderOffset, LocalHeader[0],
    SizeOf(LocalHeader));
  if BufferDWord(LocalHeader[0], 0) <> ZIP_LOCAL_SIGNATURE then
    raise EReadError.Create('ZIP local header signature is invalid');
  if BufferWord(LocalHeader[0], 6) <> AInfo.Flags then
    raise EReadError.Create('ZIP local and central flags do not match');
  if BufferWord(LocalHeader[0], 8) <> AInfo.Method then
    raise EReadError.Create('ZIP local and central methods do not match');

  LocalNameLength := BufferWord(LocalHeader[0], 26);
  LocalExtraLength := BufferWord(LocalHeader[0], 28);
  if LocalNameLength <> NameLength then
    raise EReadError.Create('ZIP local and central names do not match');
  SetLength(LocalNameBytes, LocalNameLength);
  if LocalNameLength > 0 then
    ReadAt(AArchive, Int64(AInfo.LocalHeaderOffset) +
      SizeOf(LocalHeader), LocalNameBytes[0], LocalNameLength);
  if (LocalNameLength > 0) and
    not CompareMem(@LocalNameBytes[0], @EntryNameBytes[0], LocalNameLength) then
    raise EReadError.Create('ZIP local and central names do not match');

  ADataOffset := Int64(AInfo.LocalHeaderOffset) + SizeOf(LocalHeader) +
    LocalNameLength + LocalExtraLength;
  if (ADataOffset > CentralOffset) or
    (Int64(AInfo.CompressedSize) > CentralOffset - ADataOffset) then
    raise EReadError.Create('ZIP compressed data exceeds archive bounds');
end;

procedure CopyStoredEntry(AArchive: TStream; ADataOffset: Int64;
  const AInfo: TZipEntryInfo; ADestination: TStream; out ACRC: LongWord);
var
  Buffer: TZipBuffer;
  Remaining: LongWord;
  ChunkSize: LongInt;
  Position: Int64;
begin
  if AInfo.CompressedSize <> AInfo.UncompressedSize then
    raise EReadError.Create('Stored ZIP entry has inconsistent sizes');
  AArchive.Position := ADataOffset;
  Remaining := AInfo.CompressedSize;
  ACRC := $FFFFFFFF;
  while Remaining > 0 do
  begin
    ChunkSize := SizeOf(Buffer);
    if Remaining < LongWord(ChunkSize) then
      ChunkSize := Remaining;
    Position := AArchive.Position;
    ReadAt(AArchive, Position, Buffer[0], ChunkSize);
    AArchive.Position := Position + ChunkSize;
    ADestination.WriteBuffer(Buffer[0], ChunkSize);
    ACRC := UpdateCRC32(ACRC, Buffer[0], ChunkSize);
    Dec(Remaining, ChunkSize);
  end;
  ACRC := not ACRC;
end;

procedure InflateEntry(AArchive: TStream; ADataOffset: Int64;
  const AInfo: TZipEntryInfo; ADestination: TStream; out ACRC: LongWord);
var
  ZStream: TDeDeZStream;
  InputBuffer, OutputBuffer: TZipBuffer;
  Remaining, BytesFed: LongWord;
  InputCount, OutputCount: LongInt;
  InitCode, Code: Integer;
  OutputSize: Int64;
{$IFDEF FPC}
  ZVersion: AnsiString;
{$ENDIF}
begin
  FillChar(ZStream, SizeOf(ZStream), 0);
{$IFDEF FPC}
  ZVersion := ZLIB_VERSION;
  InitCode := inflateInit2_(ZStream, -15, PAnsiChar(ZVersion),
    SizeOf(ZStream));
{$ELSE}
  InitCode := InflateInit2_(ZStream, -15, ZLIB_VERSION, SizeOf(ZStream));
{$ENDIF}
  if InitCode <> Z_OK then
    raise EReadError.CreateFmt('Unable to initialize raw ZIP inflate: %d',
      [InitCode]);

  AArchive.Position := ADataOffset;
  Remaining := AInfo.CompressedSize;
  BytesFed := 0;
  OutputSize := 0;
  ACRC := $FFFFFFFF;
  try
    repeat
      if ZStream.avail_in = 0 then
      begin
        if Remaining > 0 then
        begin
          InputCount := SizeOf(InputBuffer);
          if Remaining < LongWord(InputCount) then
            InputCount := Remaining;
          AArchive.ReadBuffer(InputBuffer[0], InputCount);
          Dec(Remaining, InputCount);
          Inc(BytesFed, InputCount);
{$IFDEF FPC}
          ZStream.next_in := @InputBuffer[0];
{$ELSE}
          ZStream.next_in := PAnsiChar(@InputBuffer[0]);
{$ENDIF}
          ZStream.avail_in := InputCount;
        end;
      end;

{$IFDEF FPC}
      ZStream.next_out := @OutputBuffer[0];
{$ELSE}
      ZStream.next_out := PAnsiChar(@OutputBuffer[0]);
{$ENDIF}
      ZStream.avail_out := SizeOf(OutputBuffer);
      if (Remaining = 0) and (ZStream.avail_in = 0) then
        Code := inflate(ZStream, Z_FINISH)
      else
        Code := inflate(ZStream, Z_NO_FLUSH);
      OutputCount := SizeOf(OutputBuffer) - ZStream.avail_out;
      if OutputCount > 0 then
      begin
        Inc(OutputSize, OutputCount);
        if OutputSize > AInfo.UncompressedSize then
          raise EReadError.Create('Inflated ZIP entry exceeds its declared size');
        ADestination.WriteBuffer(OutputBuffer[0], OutputCount);
        ACRC := UpdateCRC32(ACRC, OutputBuffer[0], OutputCount);
      end;
      if (Code = Z_BUF_ERROR) and (Remaining = 0) and
        (ZStream.avail_in = 0) then
        raise EReadError.Create('Raw ZIP deflate stream is truncated');
      if (Code <> Z_OK) and (Code <> Z_STREAM_END) then
        raise EReadError.CreateFmt('Invalid raw ZIP deflate stream: %d', [Code]);
      if (Code = Z_OK) and (Remaining = 0) and
        (ZStream.avail_in = 0) and (OutputCount = 0) then
        raise EReadError.Create('Raw ZIP deflate stream made no progress');
    until Code = Z_STREAM_END;

    if (Remaining <> 0) or (BytesFed - ZStream.avail_in <>
      AInfo.CompressedSize) then
      raise EReadError.Create('ZIP entry has trailing compressed data');
    if OutputSize <> AInfo.UncompressedSize then
      raise EReadError.CreateFmt('Inflated ZIP size mismatch: %d <> %d',
        [OutputSize, AInfo.UncompressedSize]);
    ACRC := not ACRC;
  finally
    inflateEnd(ZStream);
  end;
end;

procedure ExtractZipEntryToStream(const AArchiveName, AEntryName: string;
  ADestination: TStream);
var
  Archive: TFileStream;
  Temporary: TMemoryStream;
  Info: TZipEntryInfo;
  DataOffset: Int64;
  ActualCRC: LongWord;
begin
  if ADestination = nil then
    raise EArgumentNilException.Create('ADestination');
  Archive := TFileStream.Create(AArchiveName, fmOpenRead or fmShareDenyWrite);
  Temporary := TMemoryStream.Create;
  try
    FindZipEntry(Archive, AEntryName, Info, DataOffset);
    if Info.Method = ZIP_STORED then
      CopyStoredEntry(Archive, DataOffset, Info, Temporary, ActualCRC)
    else
      InflateEntry(Archive, DataOffset, Info, Temporary, ActualCRC);
    if ActualCRC <> Info.CRC then
      raise EReadError.CreateFmt('ZIP CRC mismatch for "%s"', [string(Info.Name)]);
    Temporary.Position := 0;
    ADestination.CopyFrom(Temporary, 0);
  finally
    Temporary.Free;
    Archive.Free;
  end;
end;

procedure CompressEntry(ASource: TStream; ACompressed: TStream;
  out ACRC, AUncompressedSize: LongWord);
var
  ZStream: TDeDeZStream;
  InputBuffer, OutputBuffer: TZipBuffer;
  ReadCount, OutputCount: LongInt;
  InitCode, Code: Integer;
  OriginalPosition: Int64;
  TotalInput: Int64;
  CRCValue: LongWord;
{$IFDEF FPC}
  ZVersion: AnsiString;
{$ENDIF}
begin
  OriginalPosition := ASource.Position;
  ASource.Position := 0;
  FillChar(ZStream, SizeOf(ZStream), 0);
{$IFDEF FPC}
  ZVersion := ZLIB_VERSION;
  InitCode := deflateInit2_(ZStream, Z_DEFAULT_COMPRESSION, Z_DEFLATED,
    -15, 8, Z_DEFAULT_STRATEGY, PAnsiChar(ZVersion), SizeOf(ZStream));
{$ELSE}
  InitCode := DeflateInit2_(ZStream, Z_DEFAULT_COMPRESSION, Z_DEFLATED,
    -15, 8, Z_DEFAULT_STRATEGY, ZLIB_VERSION, SizeOf(ZStream));
{$ENDIF}
  if InitCode <> Z_OK then
  begin
    ASource.Position := OriginalPosition;
    raise EWriteError.CreateFmt('Unable to initialize raw ZIP deflate: %d',
      [InitCode]);
  end;

  TotalInput := 0;
  CRCValue := $FFFFFFFF;
  try
    repeat
      ReadCount := ASource.Read(InputBuffer[0], SizeOf(InputBuffer));
      if ReadCount > 0 then
      begin
        Inc(TotalInput, ReadCount);
        if TotalInput > ZIP_MAX_ENTRY_SIZE then
          raise EWriteError.Create('ZIP entry exceeds the supported size');
        CRCValue := UpdateCRC32(CRCValue, InputBuffer[0], ReadCount);
{$IFDEF FPC}
        ZStream.next_in := @InputBuffer[0];
{$ELSE}
        ZStream.next_in := PAnsiChar(@InputBuffer[0]);
{$ENDIF}
        ZStream.avail_in := ReadCount;
        repeat
{$IFDEF FPC}
          ZStream.next_out := @OutputBuffer[0];
{$ELSE}
          ZStream.next_out := PAnsiChar(@OutputBuffer[0]);
{$ENDIF}
          ZStream.avail_out := SizeOf(OutputBuffer);
          Code := deflate(ZStream, Z_NO_FLUSH);
          if Code <> Z_OK then
            raise EWriteError.CreateFmt('Raw ZIP deflate failed: %d', [Code]);
          OutputCount := SizeOf(OutputBuffer) - ZStream.avail_out;
          if OutputCount > 0 then
            ACompressed.WriteBuffer(OutputBuffer[0], OutputCount);
        until (ZStream.avail_in = 0) and (ZStream.avail_out > 0);
      end;
    until ReadCount = 0;

    repeat
{$IFDEF FPC}
      ZStream.next_out := @OutputBuffer[0];
{$ELSE}
      ZStream.next_out := PAnsiChar(@OutputBuffer[0]);
{$ENDIF}
      ZStream.avail_out := SizeOf(OutputBuffer);
      Code := deflate(ZStream, Z_FINISH);
      OutputCount := SizeOf(OutputBuffer) - ZStream.avail_out;
      if OutputCount > 0 then
        ACompressed.WriteBuffer(OutputBuffer[0], OutputCount);
      if (Code <> Z_OK) and (Code <> Z_STREAM_END) then
        raise EWriteError.CreateFmt('Raw ZIP deflate finalization failed: %d',
          [Code]);
    until Code = Z_STREAM_END;

    if ACompressed.Size > ZIP_MAX_ENTRY_SIZE then
      raise EWriteError.Create('Compressed ZIP entry exceeds the supported size');
    ACRC := not CRCValue;
    AUncompressedSize := LongWord(TotalInput);
  finally
    deflateEnd(ZStream);
    ASource.Position := OriginalPosition;
  end;
end;

procedure WriteZipEntryFromStream(const AArchiveName, AEntryName: string;
  ASource: TStream);
var
  EntryName: AnsiString;
  Compressed, Archive: TMemoryStream;
  OutputFile: TFileStream;
  CRC, CompressedSize, UncompressedSize: LongWord;
  CentralOffset, CentralSize: LongWord;
begin
  if ASource = nil then
    raise EArgumentNilException.Create('ASource');
  EntryName := AnsiString(ExtractFileName(AEntryName));
  if (EntryName = '') or (Length(EntryName) > High(Word)) then
    raise EArgumentException.Create('Invalid ZIP entry name');

  Compressed := TMemoryStream.Create;
  Archive := TMemoryStream.Create;
  try
    CompressEntry(ASource, Compressed, CRC, UncompressedSize);
    CompressedSize := LongWord(Compressed.Size);

    WriteDWordLE(Archive, ZIP_LOCAL_SIGNATURE);
    WriteWordLE(Archive, 20);
    WriteWordLE(Archive, 0);
    WriteWordLE(Archive, ZIP_DEFLATED);
    WriteWordLE(Archive, 0);
    WriteWordLE(Archive, $0021);
    WriteDWordLE(Archive, CRC);
    WriteDWordLE(Archive, CompressedSize);
    WriteDWordLE(Archive, UncompressedSize);
    WriteWordLE(Archive, Length(EntryName));
    WriteWordLE(Archive, 0);
    Archive.WriteBuffer(EntryName[1], Length(EntryName));
    Compressed.Position := 0;
    Archive.CopyFrom(Compressed, 0);

    CentralOffset := LongWord(Archive.Size);
    WriteDWordLE(Archive, ZIP_CENTRAL_SIGNATURE);
    WriteWordLE(Archive, $0014);
    WriteWordLE(Archive, 20);
    WriteWordLE(Archive, 0);
    WriteWordLE(Archive, ZIP_DEFLATED);
    WriteWordLE(Archive, 0);
    WriteWordLE(Archive, $0021);
    WriteDWordLE(Archive, CRC);
    WriteDWordLE(Archive, CompressedSize);
    WriteDWordLE(Archive, UncompressedSize);
    WriteWordLE(Archive, Length(EntryName));
    WriteWordLE(Archive, 0);
    WriteWordLE(Archive, 0);
    WriteWordLE(Archive, 0);
    WriteWordLE(Archive, 0);
    WriteDWordLE(Archive, 0);
    WriteDWordLE(Archive, 0);
    Archive.WriteBuffer(EntryName[1], Length(EntryName));
    CentralSize := LongWord(Archive.Size) - CentralOffset;

    WriteDWordLE(Archive, ZIP_END_SIGNATURE);
    WriteWordLE(Archive, 0);
    WriteWordLE(Archive, 0);
    WriteWordLE(Archive, 1);
    WriteWordLE(Archive, 1);
    WriteDWordLE(Archive, CentralSize);
    WriteDWordLE(Archive, CentralOffset);
    WriteWordLE(Archive, 0);

    OutputFile := TFileStream.Create(AArchiveName, fmCreate);
    try
      Archive.Position := 0;
      OutputFile.CopyFrom(Archive, 0);
    finally
      OutputFile.Free;
    end;
  finally
    Archive.Free;
    Compressed.Free;
  end;
end;

end.
