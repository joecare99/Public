unit DBParadoxFamilyJournal;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxFamilyPublisher;

type
  EDBParadoxFamilyJournalError = class(Exception);

  TDBParadoxRecoveryEvent = (dreBeforeMember, dreAfterMember);

  IDBParadoxRecoveryFaultInjector = interface
    ['{796E8C53-3A12-4773-88C6-63D2BEBA9BD8}']
    procedure Checkpoint(AEvent: TDBParadoxRecoveryEvent;
      AMemberIndex: Integer);
  end;

  TDBParadoxFamilyJournal = class
  public
    class procedure Prepare(const ATableFileName, AStageDirectory,
      ATableBaseName: string; const AMembers: TDBParadoxFamilyMembers);
    class procedure MarkCommitted(const ATableFileName: string);
    class procedure MarkRolledBack(const ATableFileName: string);
    class procedure Recover(const ATableFileName: string;
      const AFaultInjector: IDBParadoxRecoveryFaultInjector = nil);
    class procedure RecoverWhileLocked(const ATableFileName: string;
      const AFaultInjector: IDBParadoxRecoveryFaultInjector = nil);
    class procedure Clear(const ATableFileName: string);
  end;

implementation

uses
  Classes, sha1, DBParadoxFamilyLock
  {$IFDEF MSWINDOWS}
  , Windows
  {$ELSE}
  , BaseUnix
  {$ENDIF};

const
  JournalDirectorySuffix = '.dbparadox-journal';
  ManifestFileName = 'manifest';
  StateFileName = 'state';
  ManifestHeader = 'DBPARADOX-WAL=1';

type
  TJournalMember = record
    Extension: string;
    BeforeHash: string;
    AfterHash: string;
  end;
  TJournalMembers = array of TJournalMember;

function JournalDirectory(const ATableFileName: string): string;
begin
  Result := ExpandFileName(ATableFileName) + JournalDirectorySuffix;
end;

function HashFile(const AFileName: string): string;
begin
  try
    Result := SHA1Print(SHA1File(AFileName));
  except
    on E: Exception do
      raise EDBParadoxFamilyJournalError.CreateFmt(
        'Cannot checksum journal member "%s" (%s: %s).',
        [AFileName, E.ClassName, E.Message]);
  end;
end;

function ReadTextFile(const AFileName: string): string;
var
  Stream: TFileStream;
begin
  Result := '';
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    if Stream.Size > 1024 * 1024 then
      raise EDBParadoxFamilyJournalError.CreateFmt(
        'Journal metadata "%s" is too large.', [AFileName]);
    SetLength(Result, SizeInt(Stream.Size));
    if Stream.Size > 0 then
      Stream.ReadBuffer(Result[1], Stream.Size);
  finally
    Stream.Free;
  end;
end;

procedure WriteTextFile(const AFileName, AValue: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(AFileName, fmCreate);
  try
    if AValue <> '' then
      Stream.WriteBuffer(AValue[1], Length(AValue));
  finally
    Stream.Free;
  end;
end;

procedure ReplaceFile(const ASource, ADestination: string);
var
  ErrorCode: Integer;
begin
  {$IFDEF MSWINDOWS}
  if not Windows.MoveFileEx(PChar(ASource), PChar(ADestination),
    $00000001 or $00000008) then
  begin
    ErrorCode := GetLastError;
    raise EDBParadoxFamilyJournalError.CreateFmt(
      'Cannot update journal state "%s" (%d: %s).',
      [ADestination, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
  {$ELSE}
  if fpRename(PChar(ASource), PChar(ADestination)) <> 0 then
  begin
    ErrorCode := GetLastOSError;
    raise EDBParadoxFamilyJournalError.CreateFmt(
      'Cannot update journal state "%s" (%d: %s).',
      [ADestination, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
  {$ENDIF}
end;

procedure CopyFile(const ASource, ADestination: string);
var
  InputStream, OutputStream: TFileStream;
begin
  InputStream := TFileStream.Create(ASource, fmOpenRead or fmShareDenyNone);
  try
    OutputStream := TFileStream.Create(ADestination, fmCreate);
    try
      OutputStream.CopyFrom(InputStream, 0);
    finally
      OutputStream.Free;
    end;
  finally
    InputStream.Free;
  end;
end;

function IsHexDigest(const AValue: string): Boolean;
var
  Index: SizeInt;
begin
  if Length(AValue) <> 40 then
    Exit(False);
  for Index := 1 to Length(AValue) do
    if not (AValue[Index] in ['0'..'9', 'a'..'f', 'A'..'F']) then
      Exit(False);
  Result := True;
end;

function MemberSetsEqual(const ALeft, ARight: TDBParadoxFamilyMembers):
  Boolean;
var
  LeftIndex, RightIndex: SizeInt;
  Found: Boolean;
  Used: array of Boolean;
begin
  if Length(ALeft) <> Length(ARight) then
    Exit(False);
  SetLength(Used, Length(ARight));
  for LeftIndex := 0 to High(ALeft) do
  begin
    Found := False;
    for RightIndex := 0 to High(ARight) do
      if not Used[RightIndex] and
        SameText(ALeft[LeftIndex], ARight[RightIndex]) then
      begin
        Used[RightIndex] := True;
        Found := True;
        Break;
      end;
    if not Found then
      Exit(False);
  end;
  Result := True;
end;

function IsAllowedFamily(const AMembers: TDBParadoxFamilyMembers): Boolean;
const
  PrimaryOnly: array[0..1] of string = ('.DB', '.PX');
  TwoXG: array[0..5] of string = (
    '.DB', '.PX', '.XG0', '.YG0', '.XG1', '.YG1');
  ClassicAndTwoXG: array[0..7] of string = (
    '.DB', '.PX', '.XG0', '.YG0', '.XG1', '.YG1', '.X02', '.Y02');
var
  Candidate: TDBParadoxFamilyMembers;
  Index: SizeInt;
begin
  Candidate := nil;
  SetLength(Candidate, Length(PrimaryOnly));
  for Index := 0 to High(PrimaryOnly) do
    Candidate[Index] := PrimaryOnly[Index];
  Result := MemberSetsEqual(AMembers, Candidate);
  if Result then
    Exit;
  SetLength(Candidate, Length(TwoXG));
  for Index := 0 to High(TwoXG) do
    Candidate[Index] := TwoXG[Index];
  Result := MemberSetsEqual(AMembers, Candidate);
  if Result then
    Exit;
  SetLength(Candidate, Length(ClassicAndTwoXG));
  for Index := 0 to High(ClassicAndTwoXG) do
    Candidate[Index] := ClassicAndTwoXG[Index];
  Result := MemberSetsEqual(AMembers, Candidate);
end;

procedure CheckLiveFamily(const ATableFileName: string;
  const AMembers: TJournalMembers);
var
  Search: TSearchRec;
  SearchPath, BaseName, Extension: string;
  Actual: TDBParadoxFamilyMembers;
  Expected: TDBParadoxFamilyMembers;
  SearchResult: Integer;
  Index: SizeInt;
  Found: Boolean;
begin
  BaseName := ChangeFileExt(ExtractFileName(ATableFileName), '');
  SearchPath := IncludeTrailingPathDelimiter(ExtractFileDir(
    ExpandFileName(ATableFileName))) + BaseName + '.*';
  Actual := nil;
  Expected := nil;
  SetLength(Expected, Length(AMembers));
  for Index := 0 to High(AMembers) do
    Expected[Index] := AMembers[Index].Extension;

  SearchResult := FindFirst(SearchPath, faAnyFile, Search);
  if SearchResult = 0 then
  begin
    try
      repeat
        if SameText(ExpandFileName(IncludeTrailingPathDelimiter(
          ExtractFileDir(ExpandFileName(ATableFileName))) + Search.Name),
          ExpandFileName(ATableFileName) + '.dbparadox.lock') then
          Continue;
        if SameText(ExpandFileName(IncludeTrailingPathDelimiter(
          ExtractFileDir(ExpandFileName(ATableFileName))) + Search.Name),
          JournalDirectory(ATableFileName)) then
          Continue;
        if (Search.Attr and faDirectory) <> 0 then
          raise EDBParadoxFamilyJournalError.CreateFmt(
            'Unexpected directory in the live Paradox family: "%s".',
            [Search.Name]);
        Extension := ExtractFileExt(Search.Name);
        Found := False;
        for Index := 0 to High(Expected) do
          if SameText(Extension, Expected[Index]) then
          begin
            Found := True;
            Break;
          end;
        if not Found then
          raise EDBParadoxFamilyJournalError.CreateFmt(
            'Unexpected sidecar in the live Paradox family: "%s".',
            [Search.Name]);
        SetLength(Actual, Length(Actual) + 1);
        Actual[High(Actual)] := Extension;
      until FindNext(Search) <> 0;
    finally
      SysUtils.FindClose(Search);
    end;
  end;
  if not MemberSetsEqual(Actual, Expected) then
    raise EDBParadoxFamilyJournalError.Create(
      'The live Paradox family does not match its recovery journal.');
end;

function ManifestBody(const AStageDirectory, ATableBaseName: string;
  const AMembers: TDBParadoxFamilyMembers): string;
var
  Index: SizeInt;
  StageName, StagePrefix, BeforePath, AfterPath: string;
begin
  StageName := ExtractFileName(ExcludeTrailingPathDelimiter(AStageDirectory));
  StagePrefix := '.dbparadox-stage-' + ATableBaseName + '-';
  if (StageName = '') or (Pos(PathDelim, StageName) <> 0) or
    (Pos('/', StageName) <> 0) or (Pos('\', StageName) <> 0) or
    not SameText(Copy(StageName, 1, Length(StagePrefix)), StagePrefix) then
    raise EDBParadoxFamilyJournalError.Create(
      'The journal staging directory name is invalid.');
  if not IsAllowedFamily(AMembers) then
    raise EDBParadoxFamilyJournalError.Create(
      'The journal family is not one of the supported allowlisted shapes.');

  Result := ManifestHeader + #10 +
    'STAGE=' + StageName + #10 +
    'COUNT=' + IntToStr(Length(AMembers)) + #10;
  for Index := 0 to High(AMembers) do
  begin
    BeforePath := IncludeTrailingPathDelimiter(AStageDirectory) +
      '.before' + PathDelim + IntToStr(Index) + '.snapshot';
    AfterPath := IncludeTrailingPathDelimiter(AStageDirectory) +
      ATableBaseName + AMembers[Index];
    if not FileExists(BeforePath) or not FileExists(AfterPath) then
      raise EDBParadoxFamilyJournalError.CreateFmt(
        'The journal image for family member "%s" is missing.',
        [AMembers[Index]]);
    Result := Result + 'MEMBER=' + AMembers[Index] + #9 +
      HashFile(BeforePath) + #9 + HashFile(AfterPath) + #10;
  end;
end;

procedure WriteChecksummedManifest(const AJournalDirectory, ABody: string);
var
  ManifestPath: string;
begin
  ManifestPath := IncludeTrailingPathDelimiter(AJournalDirectory) +
    ManifestFileName;
  WriteTextFile(ManifestPath + '.tmp',
    ABody + 'CHECKSUM=' + SHA1Print(SHA1String(ABody)) + #10);
  ReplaceFile(ManifestPath + '.tmp', ManifestPath);
end;

function ParseManifest(const AJournalDirectory: string;
  out AStageName, ATableBaseName: string;
  out AMembers: TJournalMembers): string;
var
  Manifest, Body, ChecksumLine, Line: string;
  ChecksumPosition, LineEnd: SizeInt;
  Count: Integer;
  Lines, Parts: TStringList;
  Index: SizeInt;
  Family: TDBParadoxFamilyMembers;
begin
  AStageName := '';
  ATableBaseName := '';
  AMembers := nil;
  Manifest := ReadTextFile(IncludeTrailingPathDelimiter(AJournalDirectory) +
    ManifestFileName);
  ChecksumPosition := Pos('CHECKSUM=', Manifest);
  if (ChecksumPosition = 0) or
    (Pos('CHECKSUM=', Copy(Manifest, ChecksumPosition + 1, MaxInt)) > 0) then
    raise EDBParadoxFamilyJournalError.Create(
      'The family journal has no unique checksum.');
  LineEnd := Pos(#10, Copy(Manifest, ChecksumPosition, MaxInt));
  if LineEnd = 0 then
    raise EDBParadoxFamilyJournalError.Create(
      'The family journal checksum line is truncated.');
  LineEnd := ChecksumPosition + LineEnd - 1;
  ChecksumLine := Copy(Manifest, ChecksumPosition,
    LineEnd - ChecksumPosition);
  if Copy(Manifest, LineEnd + 1, MaxInt) <> '' then
    raise EDBParadoxFamilyJournalError.Create(
      'The family journal has unexpected trailing data.');
  Body := Copy(Manifest, 1, ChecksumPosition - 1);
  if not SameText(Copy(ChecksumLine, Length('CHECKSUM=') + 1, MaxInt),
    SHA1Print(SHA1String(Body))) then
    raise EDBParadoxFamilyJournalError.Create(
      'The family journal checksum does not match.');

  Lines := TStringList.Create;
  Parts := TStringList.Create;
  try
    Family := nil;
    ATableBaseName := ChangeFileExt(ExtractFileName(
      Copy(AJournalDirectory, 1,
        Length(AJournalDirectory) - Length(JournalDirectorySuffix))), '');
    Lines.Text := StringReplace(Body, #10, LineEnding, [rfReplaceAll]);
    if (Lines.Count < 3) or (Lines[0] <> ManifestHeader) or
      (Copy(Lines[1], 1, 6) <> 'STAGE=') or
      (Copy(Lines[2], 1, 6) <> 'COUNT=') then
      raise EDBParadoxFamilyJournalError.Create(
        'The family journal header is invalid.');
    AStageName := Copy(Lines[1], 7, MaxInt);
    if (AStageName = '') or (Pos(PathDelim, AStageName) <> 0) or
      (Pos('/', AStageName) <> 0) or (Pos('\', AStageName) <> 0) or
      not SameText(Copy(AStageName, 1,
        Length('.dbparadox-stage-' + ATableBaseName + '-')),
        '.dbparadox-stage-' + ATableBaseName + '-') then
      raise EDBParadoxFamilyJournalError.Create(
        'The family journal staging path is invalid.');
    if not TryStrToInt(Copy(Lines[2], 7, MaxInt), Count) or (Count <= 0) or
      (Count > 8) or (Lines.Count <> Count + 3) then
      raise EDBParadoxFamilyJournalError.Create(
        'The family journal member count is invalid.');
    SetLength(AMembers, Count);
    SetLength(Family, Count);
    for Index := 0 to Count - 1 do
    begin
      Line := Lines[Index + 3];
      if Copy(Line, 1, 7) <> 'MEMBER=' then
        raise EDBParadoxFamilyJournalError.Create(
          'A family journal member entry is invalid.');
      Parts.Clear;
      ExtractStrings([#9], [], PChar(Copy(Line, 8, MaxInt)), Parts);
      if Parts.Count <> 3 then
        raise EDBParadoxFamilyJournalError.Create(
          'A family journal member entry is malformed.');
      AMembers[Index].Extension := Parts[0];
      AMembers[Index].BeforeHash := Parts[1];
      AMembers[Index].AfterHash := Parts[2];
      if (ExtractFileExt('member' + Parts[0]) <> Parts[0]) or
        not IsHexDigest(Parts[1]) or not IsHexDigest(Parts[2]) then
        raise EDBParadoxFamilyJournalError.Create(
          'A family journal member extension or digest is invalid.');
      Family[Index] := Parts[0];
    end;
    if not IsAllowedFamily(Family) then
      raise EDBParadoxFamilyJournalError.Create(
        'The journal contains an unsupported or incomplete file family.');
    Result := Copy(ChecksumLine, Length('CHECKSUM=') + 1, MaxInt);
  finally
    Parts.Free;
    Lines.Free;
  end;
end;

function ReadState(const AJournalDirectory, AManifestChecksum: string): string;
var
  StateText, Expected: string;
begin
  StateText := ReadTextFile(IncludeTrailingPathDelimiter(AJournalDirectory) +
    StateFileName);
  if (Length(StateText) < 9) or (StateText[Length(StateText)] <> #10) then
    raise EDBParadoxFamilyJournalError.Create(
      'The family journal state is truncated.');
  Result := Copy(StateText, 1, Pos(#10, StateText) - 1);
  if not ((Result = 'STATE=PREPARED') or (Result = 'STATE=COMMITTED') or
    (Result = 'STATE=ROLLED_BACK')) then
    raise EDBParadoxFamilyJournalError.Create(
      'The family journal state is unknown.');
  Expected := 'CHECKSUM=' +
    SHA1Print(SHA1String(AManifestChecksum + #10 + Result)) + #10;
  if Copy(StateText, Pos(#10, StateText) + 1, MaxInt) <> Expected then
    raise EDBParadoxFamilyJournalError.Create(
      'The family journal state checksum does not match.');
end;

procedure WriteState(const AJournalDirectory, AManifestChecksum,
  AState: string);
var
  StatePath: string;
begin
  if not ((AState = 'PREPARED') or (AState = 'COMMITTED') or
    (AState = 'ROLLED_BACK')) then
    raise EDBParadoxFamilyJournalError.Create(
      'Cannot write an unknown family journal state.');
  StatePath := IncludeTrailingPathDelimiter(AJournalDirectory) + StateFileName;
  WriteTextFile(StatePath + '.tmp',
    'STATE=' + AState + #10 + 'CHECKSUM=' +
    SHA1Print(SHA1String(AManifestChecksum + #10 + 'STATE=' + AState)) + #10);
  ReplaceFile(StatePath + '.tmp', StatePath);
end;

procedure VerifyLiveHashes(const ATableFileName, AState: string;
  const AMembers: TJournalMembers);
var
  Index: SizeInt;
  TargetPath, ExpectedHash: string;
begin
  CheckLiveFamily(ATableFileName, AMembers);
  for Index := 0 to High(AMembers) do
  begin
    TargetPath := ChangeFileExt(ATableFileName, '') +
      AMembers[Index].Extension;
    if AState = 'COMMITTED' then
      ExpectedHash := AMembers[Index].AfterHash
    else
      ExpectedHash := AMembers[Index].BeforeHash;
    if not FileExists(TargetPath) or
      not SameText(HashFile(TargetPath), ExpectedHash) then
      raise EDBParadoxFamilyJournalError.CreateFmt(
        'The live family member "%s" does not match journal state %s.',
        [AMembers[Index].Extension, AState]);
  end;
end;

procedure RemoveTree(const ADirectory: string);
var
  Search: TSearchRec;
  SearchResult: Integer;
  EntryPath: string;
begin
  if not DirectoryExists(ADirectory) then
    Exit;
  SearchResult := FindFirst(IncludeTrailingPathDelimiter(ADirectory) + '*',
    faAnyFile, Search);
  if SearchResult = 0 then
  begin
    try
      repeat
        if (Search.Name = '.') or (Search.Name = '..') then
          Continue;
        EntryPath := IncludeTrailingPathDelimiter(ADirectory) + Search.Name;
        if (Search.Attr and faDirectory) <> 0 then
          RemoveTree(EntryPath)
        else if not SysUtils.DeleteFile(EntryPath) then
          raise EDBParadoxFamilyJournalError.CreateFmt(
            'Cannot remove journal recovery file "%s".', [EntryPath]);
      until FindNext(Search) <> 0;
    finally
      SysUtils.FindClose(Search);
    end;
  end;
  if not RemoveDir(ADirectory) then
    raise EDBParadoxFamilyJournalError.CreateFmt(
      'Cannot remove journal recovery directory "%s".', [ADirectory]);
end;

procedure RemoveOrphanStages(const ATableFileName: string);
var
  Search: TSearchRec;
  SearchPath, ParentDirectory, BaseName, EntryPath: string;
  SearchResult: Integer;
begin
  ParentDirectory := ExtractFileDir(ExpandFileName(ATableFileName));
  BaseName := ChangeFileExt(ExtractFileName(ATableFileName), '');
  SearchPath := IncludeTrailingPathDelimiter(ParentDirectory) +
    '.dbparadox-stage-' + BaseName + '-*';
  SearchResult := FindFirst(SearchPath, faAnyFile, Search);
  if SearchResult <> 0 then
    Exit;
  try
    repeat
      if (Search.Attr and faDirectory) = 0 then
        raise EDBParadoxFamilyJournalError.CreateFmt(
          'Unexpected file in the table staging namespace: "%s".',
          [Search.Name]);
      EntryPath := IncludeTrailingPathDelimiter(ParentDirectory) +
        Search.Name;
      RemoveTree(EntryPath);
    until FindNext(Search) <> 0;
  finally
    SysUtils.FindClose(Search);
  end;
end;

procedure ApplyImages(const ATableFileName, AStageDirectory,
  ATableBaseName, AState: string; const AMembers: TJournalMembers;
  const AFaultInjector: IDBParadoxRecoveryFaultInjector);
var
  Index: SizeInt;
  TargetPath, ImagePath, RestorePath, ExpectedHash: string;
begin
  for Index := 0 to High(AMembers) do
  begin
    if Assigned(AFaultInjector) then
      AFaultInjector.Checkpoint(dreBeforeMember, Index);
    TargetPath := ChangeFileExt(ATableFileName, '') +
      AMembers[Index].Extension;
    if AState = 'PREPARED' then
    begin
      ImagePath := IncludeTrailingPathDelimiter(AStageDirectory) +
        '.before' + PathDelim + IntToStr(Index) + '.snapshot';
      ExpectedHash := AMembers[Index].BeforeHash;
    end
    else
    begin
      ImagePath := IncludeTrailingPathDelimiter(AStageDirectory) +
        ATableBaseName + AMembers[Index].Extension;
      ExpectedHash := AMembers[Index].AfterHash;
    end;

    if FileExists(TargetPath) and SameText(HashFile(TargetPath), ExpectedHash)
    then
    begin
      if Assigned(AFaultInjector) then
        AFaultInjector.Checkpoint(dreAfterMember, Index);
      Continue;
    end;
    if not FileExists(ImagePath) or
      not SameText(HashFile(ImagePath), ExpectedHash) then
      raise EDBParadoxFamilyJournalError.CreateFmt(
        'Recovery image for "%s" is missing or has an invalid checksum.',
        [AMembers[Index].Extension]);
    RestorePath := IncludeTrailingPathDelimiter(AStageDirectory) +
      'restore-' + IntToStr(Index) + '.tmp';
    CopyFile(ImagePath, RestorePath);
    ReplaceFile(RestorePath, TargetPath);
    if Assigned(AFaultInjector) then
      AFaultInjector.Checkpoint(dreAfterMember, Index);
  end;

  for Index := 0 to High(AMembers) do
  begin
    TargetPath := ChangeFileExt(ATableFileName, '') +
      AMembers[Index].Extension;
    if not FileExists(TargetPath) then
      raise EDBParadoxFamilyJournalError.CreateFmt(
        'Recovered member "%s" is missing.', [AMembers[Index].Extension]);
    if AState = 'PREPARED' then
      ExpectedHash := AMembers[Index].BeforeHash
    else
      ExpectedHash := AMembers[Index].AfterHash;
    if not SameText(HashFile(TargetPath), ExpectedHash) then
      raise EDBParadoxFamilyJournalError.CreateFmt(
        'Recovered member "%s" failed checksum verification.',
        [AMembers[Index].Extension]);
  end;
end;

class procedure TDBParadoxFamilyJournal.Prepare(const ATableFileName,
  AStageDirectory, ATableBaseName: string;
  const AMembers: TDBParadoxFamilyMembers);
var
  Directory, Body: string;
begin
  Directory := JournalDirectory(ATableFileName);
  if DirectoryExists(Directory) or FileExists(Directory) then
    raise EDBParadoxFamilyJournalError.CreateFmt(
      'A prior family journal already exists at "%s".', [Directory]);
  if not CreateDir(Directory) then
    raise EDBParadoxFamilyJournalError.CreateFmt(
      'Cannot create family journal directory "%s".', [Directory]);
  try
    Body := ManifestBody(AStageDirectory, ATableBaseName, AMembers);
    WriteChecksummedManifest(Directory, Body);
    WriteState(Directory, SHA1Print(SHA1String(Body)), 'PREPARED');
  except
    RemoveTree(Directory);
    raise;
  end;
end;

class procedure TDBParadoxFamilyJournal.MarkCommitted(
  const ATableFileName: string);
var
  StageName, BaseName, Checksum, State: string;
  Members: TJournalMembers;
  Directory: string;
begin
  Directory := JournalDirectory(ATableFileName);
  Checksum := ParseManifest(Directory, StageName, BaseName, Members);
  State := ReadState(Directory, Checksum);
  if State <> 'STATE=PREPARED' then
    raise EDBParadoxFamilyJournalError.Create(
      'Only a prepared family journal can be committed.');
  VerifyLiveHashes(ATableFileName, 'COMMITTED', Members);
  WriteState(Directory, Checksum, 'COMMITTED');
end;

class procedure TDBParadoxFamilyJournal.MarkRolledBack(
  const ATableFileName: string);
var
  StageName, BaseName, Checksum, State: string;
  Members: TJournalMembers;
  Directory: string;
begin
  Directory := JournalDirectory(ATableFileName);
  Checksum := ParseManifest(Directory, StageName, BaseName, Members);
  State := ReadState(Directory, Checksum);
  if State <> 'STATE=PREPARED' then
    raise EDBParadoxFamilyJournalError.Create(
      'Only a prepared family journal can be rolled back.');
  VerifyLiveHashes(ATableFileName, 'ROLLED_BACK', Members);
  WriteState(Directory, Checksum, 'ROLLED_BACK');
end;

class procedure TDBParadoxFamilyJournal.Recover(
  const ATableFileName: string;
  const AFaultInjector: IDBParadoxRecoveryFaultInjector);
var
  Lock: TDBParadoxFamilyLock;
begin
  Lock := TDBParadoxFamilyLock.Create(ATableFileName);
  try
    RecoverWhileLocked(ATableFileName, AFaultInjector);
  finally
    Lock.Free;
  end;
end;

class procedure TDBParadoxFamilyJournal.RecoverWhileLocked(
  const ATableFileName: string;
  const AFaultInjector: IDBParadoxRecoveryFaultInjector);
var
  Directory, StageDirectory, StageName, BaseName, Checksum, State: string;
  Members: TJournalMembers;
begin
  Directory := JournalDirectory(ATableFileName);
  if FileExists(Directory) and not DirectoryExists(Directory) then
    raise EDBParadoxFamilyJournalError.CreateFmt(
      'The recovery journal path "%s" is not a directory.', [Directory]);
  if not DirectoryExists(Directory) then
  begin
    RemoveOrphanStages(ATableFileName);
    Exit;
  end;
  if not FileExists(IncludeTrailingPathDelimiter(Directory) +
    ManifestFileName) then
  begin
    if FileExists(IncludeTrailingPathDelimiter(Directory) + StateFileName) or
      FileExists(IncludeTrailingPathDelimiter(Directory) + StateFileName +
        '.tmp') then
      raise EDBParadoxFamilyJournalError.Create(
        'The family journal state exists without its manifest.');
    RemoveTree(Directory);
    RemoveOrphanStages(ATableFileName);
    Exit;
  end;
  Checksum := ParseManifest(Directory, StageName, BaseName, Members);
  if not FileExists(IncludeTrailingPathDelimiter(Directory) + StateFileName)
  then
  begin
    VerifyLiveHashes(ATableFileName, 'ROLLED_BACK', Members);
    StageDirectory := IncludeTrailingPathDelimiter(
      ExtractFileDir(ExpandFileName(ATableFileName))) + StageName;
    RemoveTree(StageDirectory);
    RemoveTree(Directory);
    RemoveOrphanStages(ATableFileName);
    Exit;
  end;
  State := ReadState(Directory, Checksum);
  CheckLiveFamily(ATableFileName, Members);
  StageDirectory := IncludeTrailingPathDelimiter(
    ExtractFileDir(ExpandFileName(ATableFileName))) + StageName;
  if State = 'STATE=PREPARED' then
  begin
    ApplyImages(ATableFileName, StageDirectory, BaseName, 'PREPARED',
      Members, AFaultInjector);
    WriteState(Directory, Checksum, 'ROLLED_BACK');
  end
  else if State = 'STATE=COMMITTED' then
    ApplyImages(ATableFileName, StageDirectory, BaseName, 'COMMITTED',
      Members, AFaultInjector)
  else
    ApplyImages(ATableFileName, StageDirectory, BaseName, 'PREPARED',
      Members, AFaultInjector);
  RemoveTree(StageDirectory);
  RemoveTree(Directory);
  RemoveOrphanStages(ATableFileName);
end;

class procedure TDBParadoxFamilyJournal.Clear(const ATableFileName: string);
var
  Directory: string;
begin
  Directory := JournalDirectory(ATableFileName);
  if DirectoryExists(Directory) then
    RemoveTree(Directory);
end;

end.
