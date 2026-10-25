program ZipArchiveTests;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, DeDeZip
{$IFNDEF FPC}
  , DeDeBPL, DeDeDUF, DeDeOffsInf, DeDeConstants, DeDeAnsiStream
{$ENDIF}
  ;

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

procedure CheckCorruptCRCRejected(const AArchiveName: string);
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
      ExtractZipEntryToStream(CorruptName,
        ExtractFileName(AArchiveName), Destination);
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

procedure TestArchive(const AFixtureDirectory, AOutputDirectory,
  AFileName: string);
var
  InputPath, OutputPath: string;
  Extracted, RoundTrip: TMemoryStream;
  SourcePosition: Int64;
begin
  InputPath := IncludeTrailingPathDelimiter(AFixtureDirectory) + AFileName;
  OutputPath := IncludeTrailingPathDelimiter(AOutputDirectory) + AFileName;
  Check(FileExists(InputPath), 'Missing ZIP fixture: ' + InputPath);

  Extracted := TMemoryStream.Create;
  RoundTrip := TMemoryStream.Create;
  try
    ExtractZipEntryToStream(InputPath, AFileName, Extracted);
    Check(Extracted.Size > 0, 'ZIP member is empty: ' + AFileName);

    SourcePosition := 7;
    Extracted.Position := SourcePosition;
    WriteZipEntryFromStream(OutputPath, AFileName, Extracted);
    Check(Extracted.Position = SourcePosition,
      'ZIP writer did not restore input stream position');

    ExtractZipEntryToStream(OutputPath, AFileName, RoundTrip);
    Check(Extracted.Size = RoundTrip.Size,
      'Round-trip member size changed: ' + AFileName);
    Check(CompareMem(Extracted.Memory, RoundTrip.Memory, Extracted.Size),
      'Round-trip member bytes changed: ' + AFileName);
    CheckWrongEntryRejected(InputPath);
    CheckCorruptCRCRejected(OutputPath);
    Writeln(AFileName, ': ', Extracted.Size, ' bytes round-tripped');
  finally
    RoundTrip.Free;
    Extracted.Free;
  end;
end;

{$IFNDEF FPC}
procedure TestBPLConsumer(const AOutputDirectory: string);
var
  Bytes, Names, LoadedBytes, LoadedNames: TMemoryStream;
  ArchiveName, Comment: string;
  Pattern: LongWord;
  Mode, PatternSize: Byte;
  RecordCount: LongInt;
  Indexes: TBoundArray;
  NameLength: Byte;
begin
  ArchiveName := IncludeTrailingPathDelimiter(AOutputDirectory) + 'adapter.dsf';
  Bytes := TMemoryStream.Create;
  Names := TMemoryStream.Create;
  LoadedBytes := TMemoryStream.Create;
  LoadedNames := TMemoryStream.Create;
  try
    Pattern := $12345678;
    Bytes.WriteBuffer(Pattern, SizeOf(Pattern));
    NameLength := 4;
    Names.WriteBuffer(NameLength, SizeOf(NameLength));
    WriteAnsiString(Names, 'Test');

    SaveBPLSymbolFile(Bytes, Names, ArchiveName, 4, 4, 1, 'adapter test');
    Mode := 0;
    PatternSize := 0;
    RecordCount := 0;
    Comment := '';
    Check(LoadBPLSymbolFile(LoadedBytes, LoadedNames, ArchiveName, Mode,
      PatternSize, RecordCount, Comment, Indexes),
      'BPL archive consumer failed to read its own output');
    Check((Mode = 4) and (PatternSize = 4) and (RecordCount = 1),
      'BPL archive header changed during round-trip');
    Check(Comment = 'adapter test', 'BPL comment changed during round-trip');
    Check((LoadedBytes.Size = Bytes.Size) and
      CompareMem(LoadedBytes.Memory, Bytes.Memory, Bytes.Size),
      'BPL pattern data changed during round-trip');
    Check((LoadedNames.Size = Names.Size) and
      CompareMem(LoadedNames.Memory, Names.Memory, Names.Size),
      'BPL name data changed during round-trip');
    Check((Length(Indexes) = 1) and (Indexes[0] = 0),
      'BPL name index changed during round-trip');
  finally
    LoadedNames.Free;
    LoadedBytes.Free;
    Names.Free;
    Bytes.Free;
  end;
end;

procedure TestDUFConsumer(const AOutputDirectory: string);
var
  Source, Loaded: TDUFFile;
  ArchiveName: string;
begin
  ArchiveName := IncludeTrailingPathDelimiter(AOutputDirectory) + 'adapter.duf';
  Source := TDUFFile.Create;
  Loaded := TDUFFile.Create;
  try
    Source.DUFVersion := CURR_DUFF_VERSION;
    Source.SaveToFile(ArchiveName);
    Loaded.LoadFromFile(ArchiveName);
    Check((Loaded.DUFVersion = CURR_DUFF_VERSION) and
      (Loaded.ExpressionCount = 0) and (Loaded.CommentsCount = 0) and
      (Loaded.EmulationCount = 0), 'DUF archive round-trip failed');
  finally
    Loaded.Free;
    Source.Free;
  end;
end;

procedure TestDOIConsumer(const AOutputDirectory: string);
var
  Source, Loaded: TOffsInfArchive;
  ArchiveName: string;
begin
  ArchiveName := IncludeTrailingPathDelimiter(AOutputDirectory) + 'adapter.doi';
  Source := TOffsInfArchive.Create;
  Loaded := TOffsInfArchive.Create;
  try
    Source.mode := $10;
    Source.reserved := 1;
    Source.Save(ArchiveName);
    Loaded.Extract(ArchiveName);
    Check((Loaded.mode = Source.mode) and
      (Loaded.reserved = Source.reserved) and
      (Loaded.classes_count = 0), 'DOI archive round-trip failed');
  finally
    Loaded.Free;
    Source.Free;
  end;
  {$ENDIF}
end;

begin
  try
    if ParamCount <> 2 then
      raise Exception.Create(
        'Usage: ZipArchiveTests <fixture-directory> <output-directory>');
    if not ForceDirectories(ParamStr(2)) then
      raise Exception.Create('Unable to create test output directory');
    TestArchive(ParamStr(1), ParamStr(2), 'd2.doi');
    TestArchive(ParamStr(1), ParamStr(2), 'D6.DOI');
    TestArchive(ParamStr(1), ParamStr(2), 'VCL7.dsf');
{$IFNDEF FPC}
    TestBPLConsumer(ParamStr(2));
    TestDUFConsumer(ParamStr(2));
    TestDOIConsumer(ParamStr(2));
{$ENDIF}
    Writeln('ZIP archive adapter tests passed');
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
