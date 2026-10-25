program ZipArchiveTests;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeZip;

procedure Check(ACondition: Boolean; const AMessage: string);
begin
  if not ACondition then
    raise Exception.Create(AMessage);
end;

function ReadDWordLE(AStream: TStream): LongWord;
var
  Bytes: array[0..3] of Byte;
begin
  AStream.ReadBuffer(Bytes[0], SizeOf(Bytes));
  Result := LongWord(Bytes[0]) or
    (LongWord(Bytes[1]) shl 8) or
    (LongWord(Bytes[2]) shl 16) or
    (LongWord(Bytes[3]) shl 24);
end;

procedure CheckWrongEntryRejected(const AArchiveName: string);
var
  Destination: TMemoryStream;
  Raised: Boolean;
begin
  Destination := TMemoryStream.Create;
  try
    Raised := False;
    try
      ExtractZipEntryToStream(AArchiveName, 'wrong-entry-name', Destination);
    except
      on EReadError do
        Raised := True;
    end;
    Check(Raised, 'A mismatched ZIP entry name was accepted');
    Check(Destination.Size = 0,
      'A failed ZIP extraction wrote partial output');
  finally
    Destination.Free;
  end;
end;

procedure CheckMultiEntryArchiveRejected(const AArchiveName: string);
var
  Destination: TMemoryStream;
  Raised: Boolean;
begin
  Destination := TMemoryStream.Create;
  try
    Raised := False;
    try
      ExtractZipEntryToStream(AArchiveName, 'first.bin', Destination);
    except
      on EReadError do
        Raised := True;
    end;
    Check(Raised, 'A multi-entry ZIP archive was accepted');
    Check(Destination.Size = 0,
      'A rejected multi-entry archive wrote partial output');
  finally
    Destination.Free;
  end;
end;

procedure CheckCorruptCRCRejected(const AArchiveName, AEntryName: string);
var
  Archive, Destination: TMemoryStream;
  CorruptName: string;
  EndOffset, CentralOffset: Int64;
  I: Integer;
  Signature: LongWord;
  Raised: Boolean;
  Value: Byte;
begin
  Archive := TMemoryStream.Create;
  Destination := TMemoryStream.Create;
  CorruptName := AArchiveName + '.corrupt';
  try
    Archive.LoadFromFile(AArchiveName);
    EndOffset := -1;
    for I := Archive.Size - 22 downto 0 do
    begin
      Archive.Position := I;
      Signature := ReadDWordLE(Archive);
      if Signature = $06054B50 then
      begin
        EndOffset := I;
        Break;
      end;
    end;
    Check(EndOffset >= 0, 'Generated ZIP has no end record');
    Archive.Position := EndOffset + 16;
    CentralOffset := ReadDWordLE(Archive);
    Archive.Position := CentralOffset + 16;
    Archive.ReadBuffer(Value, SizeOf(Value));
    Value := Value xor $01;
    Archive.Position := CentralOffset + 16;
    Archive.WriteBuffer(Value, SizeOf(Value));
    Archive.SaveToFile(CorruptName);

    Raised := False;
    try
      ExtractZipEntryToStream(CorruptName, AEntryName, Destination);
    except
      on EReadError do
        Raised := True;
    end;
    Check(Raised, 'A ZIP member with an incorrect CRC was accepted');
    Check(Destination.Size = 0,
      'A CRC failure wrote partial output');
  finally
    DeleteFile(CorruptName);
    Destination.Free;
    Archive.Free;
  end;
end;

procedure TestArchiveFile(const AInputPath, AOutputDirectory, AOutputName,
  AEntryName: string);
var
  OutputPath: string;
  Extracted, RoundTrip: TMemoryStream;
  SourcePosition: Int64;
begin
  OutputPath := IncludeTrailingPathDelimiter(AOutputDirectory) + AOutputName;
  Check(FileExists(AInputPath), 'Missing ZIP fixture: ' + AInputPath);

  Extracted := TMemoryStream.Create;
  RoundTrip := TMemoryStream.Create;
  try
    ExtractZipEntryToStream(AInputPath, AEntryName, Extracted);
    if AEntryName <> 'empty.bin' then
      Check(Extracted.Size > 0, 'ZIP member is empty: ' + AEntryName);

    SourcePosition := 7;
    Extracted.Position := SourcePosition;
    WriteZipEntryFromStream(OutputPath, AEntryName, Extracted);
    Check(Extracted.Position = SourcePosition,
      'ZIP writer did not restore input stream position');

    ExtractZipEntryToStream(OutputPath, AEntryName, RoundTrip);
    Check(Extracted.Size = RoundTrip.Size,
      'Round-trip member size changed: ' + AEntryName);
    Check(CompareMem(Extracted.Memory, RoundTrip.Memory, Extracted.Size),
      'Round-trip member bytes changed: ' + AEntryName);
    CheckWrongEntryRejected(AInputPath);
    CheckCorruptCRCRejected(OutputPath, AEntryName);
    Writeln(AEntryName, ': ', Extracted.Size, ' bytes round-tripped');
  finally
    RoundTrip.Free;
    Extracted.Free;
  end;
end;

begin
  try
    if ParamCount <> 3 then
      raise Exception.Create(
        'Usage: ZipArchiveTests <fixture-directory> <output-directory> <extra-fixture-directory>');
    if not ForceDirectories(ParamStr(2)) then
      raise Exception.Create('Unable to create test output directory');
    TestArchiveFile(IncludeTrailingPathDelimiter(ParamStr(1)) + 'd2.doi',
      ParamStr(2), 'd2.doi', 'd2.doi');
    TestArchiveFile(IncludeTrailingPathDelimiter(ParamStr(1)) + 'D6.DOI',
      ParamStr(2), 'D6.DOI', 'D6.DOI');
    TestArchiveFile(IncludeTrailingPathDelimiter(ParamStr(1)) + 'VCL7.dsf',
      ParamStr(2), 'VCL7.dsf', 'VCL7.dsf');
    TestArchiveFile(IncludeTrailingPathDelimiter(ParamStr(3)) + 'stored.zip',
      ParamStr(2), 'stored.zip', 'stored.bin');
    TestArchiveFile(
      IncludeTrailingPathDelimiter(ParamStr(3)) + 'descriptor.zip',
      ParamStr(2), 'descriptor.zip', 'descriptor.bin');
    TestArchiveFile(IncludeTrailingPathDelimiter(ParamStr(3)) + 'empty.zip',
      ParamStr(2), 'empty.zip', 'empty.bin');
    CheckMultiEntryArchiveRejected(
      IncludeTrailingPathDelimiter(ParamStr(3)) + 'multi.zip');
    Writeln('ZIP archive adapter tests passed');
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
