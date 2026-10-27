unit DBParadoxFamilyPublisher;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DBParadoxFamilyLock;

type
  EDBParadoxPublicationError = class(Exception);
  EDBParadoxUncertainPublicationError = class(EDBParadoxPublicationError)
  private
    FRecoveryDirectory: string;
  public
    constructor Create(const AMessage, ARecoveryDirectory: string);
    property RecoveryDirectory: string read FRecoveryDirectory;
  end;
  EDBParadoxPublishedCleanupError = class(EDBParadoxPublicationError)
  private
    FStageDirectory: string;
  public
    constructor Create(const AMessage, AStageDirectory: string);
    property StageDirectory: string read FStageDirectory;
  end;

  TDBParadoxFamilyMembers = array of string;

  TDBParadoxExpectedFamilyMember = record
    Extension: string;
    Data: TBytes;
  end;

  TDBParadoxExpectedFamilyMembers = array of
    TDBParadoxExpectedFamilyMember;

  TDBParadoxPublicationEvent = (
    dpeStageDirectoryCreated,
    dpeBeforeImageCopied,
    dpeBeforeStageMember,
    dpeAfterStageMember,
    dpeStageBuilt,
    dpeStageValidated,
    dpeSnapshotRechecked,
    dpeBeforeReplacement,
    dpeAfterReplacement,
    dpeJournalPrepared,
    dpeCommitDecisionPersisted,
    dpeBeforeCompensation,
    dpeBeforeCleanup
  );

  IDBParadoxFamilyStageBuilder = interface
    ['{8DCA316F-C1E4-473C-9D2A-89C4BC38593A}']
    procedure BeginBuild(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
    procedure BuildMember(const AStageDirectory, ATableBaseName,
      AMember: string);
    procedure EndBuild;
    procedure AbortBuild;
  end;

  IDBParadoxFamilyValidator = interface
    ['{B191D5C8-664E-49F0-AE9D-BA65DF37CD12}']
    procedure Validate(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
  end;

  IDBParadoxPublicationFaultInjector = interface
    ['{3BF3E1AB-E634-44F7-BC04-B7026C546DD2}']
    procedure Checkpoint(AEvent: TDBParadoxPublicationEvent;
      AMemberIndex: Integer);
  end;

  TDBParadoxFamilyPublisher = class
  private
    class procedure PublishCore(const ATableFileName: string;
      const ABuilder: IDBParadoxFamilyStageBuilder;
      const AValidator: IDBParadoxFamilyValidator;
      const AExpectedMembers: TDBParadoxExpectedFamilyMembers;
      ARequireExpectedMembers: Boolean;
      const AFaultInjector: IDBParadoxPublicationFaultInjector);
  public
    class procedure Publish(const ATableFileName: string;
      const ABuilder: IDBParadoxFamilyStageBuilder;
      const AValidator: IDBParadoxFamilyValidator;
      const AFaultInjector: IDBParadoxPublicationFaultInjector = nil); overload;
    class procedure Publish(const ATableFileName: string;
      const ABuilder: IDBParadoxFamilyStageBuilder;
      const AValidator: IDBParadoxFamilyValidator;
      const AExpectedMembers: TDBParadoxExpectedFamilyMembers;
      const AFaultInjector: IDBParadoxPublicationFaultInjector = nil); overload;
  end;

implementation

uses
  DBParadoxFamilyJournal,
  {$IFDEF MSWINDOWS}
  Windows
  {$ELSE}
  BaseUnix
  {$ENDIF};

const
  DBPARADOX_MOVEFILE_REPLACE_EXISTING = $00000001;
  DBPARADOX_MOVEFILE_WRITE_THROUGH = $00000008;

constructor EDBParadoxUncertainPublicationError.Create(
  const AMessage, ARecoveryDirectory: string);
begin
  inherited Create(AMessage);
  FRecoveryDirectory := ARecoveryDirectory;
end;

constructor EDBParadoxPublishedCleanupError.Create(const AMessage,
  AStageDirectory: string);
begin
  inherited Create(AMessage);
  FStageDirectory := AStageDirectory;
end;

function FamilyMembersFor(const AExtensions: array of string):
  TDBParadoxFamilyMembers;
var
  Index: Integer;
begin
  Result := nil;
  SetLength(Result, Length(AExtensions));
  for Index := 0 to High(AExtensions) do
    Result[Index] := AExtensions[Index];
end;

function MemberSetsEqual(const ALeft, ARight: TDBParadoxFamilyMembers):
  Boolean;
var
  LeftIndex, RightIndex: Integer;
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

function DiscoverFamily(const ADirectory, ABaseName, ATableFileName: string):
  TDBParadoxFamilyMembers;
var
  Search: TSearchRec;
  Files: TDBParadoxFamilyMembers;
  Extension: string;
  SearchPath: string;
  SearchResult: Integer;
  PrimaryOnly, TwoXG, ClassicAndTwoXG: TDBParadoxFamilyMembers;
begin
  Files := nil;
  SearchPath := IncludeTrailingPathDelimiter(ADirectory) + ABaseName + '.*';
  SearchResult := FindFirst(SearchPath, faAnyFile, Search);
  if SearchResult = 0 then
  begin
    try
      repeat
        if SameText(ExpandFileName(IncludeTrailingPathDelimiter(ADirectory) +
          Search.Name), ATableFileName + '.dbparadox.lock') then
          Continue;
        if (Search.Attr and faDirectory) <> 0 then
          raise EDBParadoxPublicationError.CreateFmt(
            'Unexpected directory in the Paradox family: "%s".',
            [Search.Name]);
        begin
          Extension := ExtractFileExt(Search.Name);
          if Extension = '' then
            raise EDBParadoxPublicationError.CreateFmt(
              'Unrecognized file in the Paradox family: "%s".',
              [Search.Name]);
          SetLength(Files, Length(Files) + 1);
          Files[High(Files)] := Extension;
        end;
      until FindNext(Search) <> 0;
    finally
      SysUtils.FindClose(Search);
    end;
  end;
  PrimaryOnly := FamilyMembersFor(['.DB', '.PX']);
  TwoXG := FamilyMembersFor(['.DB', '.PX', '.XG0', '.YG0', '.XG1', '.YG1']);
  ClassicAndTwoXG := FamilyMembersFor(
    ['.DB', '.PX', '.XG0', '.YG0', '.XG1', '.YG1', '.X02', '.Y02']);
  if MemberSetsEqual(Files, PrimaryOnly) then
    Result := PrimaryOnly
  else if MemberSetsEqual(Files, TwoXG) then
    Result := TwoXG
  else if MemberSetsEqual(Files, ClassicAndTwoXG) then
    Result := ClassicAndTwoXG
  else
    raise EDBParadoxPublicationError.CreateFmt(
      'The table family "%s" is incomplete or contains unsupported sidecars.',
      [ATableFileName]);
end;

procedure CheckExactFamily(const ADirectory, ABaseName, ATableFileName: string;
  const AMembers: TDBParadoxFamilyMembers);
var
  ActualMembers: TDBParadoxFamilyMembers;
begin
  ActualMembers := DiscoverFamily(ADirectory, ABaseName, ATableFileName);
  if not MemberSetsEqual(ActualMembers, AMembers) then
    raise EDBParadoxPublicationError.CreateFmt(
      'The file family in "%s" does not match the expected member set.',
      [ADirectory]);
end;

function NewStageDirectory(const AParentDirectory, ATableBaseName: string):
  string;
var
  Guid: TGUID;
  ErrorCode: Integer;
begin
  if CreateGUID(Guid) <> 0 then
    raise EDBParadoxPublicationError.Create(
      'Cannot create a unique staging directory name.');
  if (ATableBaseName = '') or (Pos(PathDelim, ATableBaseName) <> 0) or
    (Pos('/', ATableBaseName) <> 0) or (Pos('\', ATableBaseName) <> 0) then
    raise EDBParadoxPublicationError.Create(
      'The table base name is invalid for a staging directory.');
  Result := IncludeTrailingPathDelimiter(AParentDirectory) +
    '.dbparadox-stage-' + ATableBaseName + '-' +
    Copy(GUIDToString(Guid), 2, 36);
  if not CreateDir(Result) then
  begin
    ErrorCode := GetLastOSError;
    raise EDBParadoxPublicationError.CreateFmt(
      'Cannot create staging directory "%s" (%d: %s).',
      [Result, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
end;

procedure CopyFileStrict(const ASource, ADestination: string);
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

function FilesEqual(const ALeft, ARight: string): Boolean;
var
  LeftStream, RightStream: TFileStream;
  LeftBuffer, RightBuffer: array[0..65535] of Byte;
  LeftRead, RightRead: LongInt;
begin
  LeftStream := TFileStream.Create(ALeft, fmOpenRead or fmShareDenyNone);
  try
    RightStream := TFileStream.Create(ARight, fmOpenRead or fmShareDenyNone);
    try
      FillChar(LeftBuffer, SizeOf(LeftBuffer), 0);
      FillChar(RightBuffer, SizeOf(RightBuffer), 0);
      repeat
        LeftRead := LeftStream.Read(LeftBuffer, SizeOf(LeftBuffer));
        RightRead := RightStream.Read(RightBuffer, SizeOf(RightBuffer));
        if (LeftRead <> RightRead) or
          ((LeftRead > 0) and
           (CompareByte(LeftBuffer, RightBuffer, LeftRead) <> 0)) then
          Exit(False);
      until LeftRead = 0;
      Result := True;
    finally
      RightStream.Free;
    end;
  finally
    LeftStream.Free;
  end;
end;

function FileMatchesBytes(const AFileName: string;
  const AExpected: TBytes): Boolean;
var
  Stream: TFileStream;
  Actual: TBytes;
begin
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    if Stream.Size <> Length(AExpected) then
      Exit(False);
    SetLength(Actual, Length(AExpected));
    if Length(Actual) > 0 then
      Stream.ReadBuffer(Actual[0], Length(Actual));
    Result := (Length(Actual) = 0) or
      (CompareByte(Actual[0], AExpected[0], Length(Actual)) = 0);
  finally
    Stream.Free;
  end;
end;

function ExpectedMemberExtensions(
  const AExpectedMembers: TDBParadoxExpectedFamilyMembers):
  TDBParadoxFamilyMembers;
var
  Index: SizeInt;
begin
  Result := nil;
  SetLength(Result, Length(AExpectedMembers));
  for Index := 0 to High(AExpectedMembers) do
    Result[Index] := AExpectedMembers[Index].Extension;
end;

procedure CheckExpectedSnapshot(const AParentDirectory, ABaseName: string;
  const AActualMembers: TDBParadoxFamilyMembers;
  const AExpectedMembers: TDBParadoxExpectedFamilyMembers);
var
  Index: SizeInt;
  CurrentPath: string;
begin
  if Length(AExpectedMembers) = 0 then
    raise EDBParadoxPublicationError.Create(
      'An expected family snapshot cannot be empty.');
  if not MemberSetsEqual(AActualMembers,
    ExpectedMemberExtensions(AExpectedMembers)) then
    raise EDBParadoxPublicationError.Create(
      'The live table family membership differs from the transaction snapshot.');
  for Index := 0 to High(AExpectedMembers) do
  begin
    if AExpectedMembers[Index].Extension = '' then
      raise EDBParadoxPublicationError.Create(
        'An expected snapshot member has an invalid extension.');
    if AExpectedMembers[Index].Extension[1] <> '.' then
      raise EDBParadoxPublicationError.Create(
        'An expected snapshot member has an invalid extension.');
    CurrentPath := IncludeTrailingPathDelimiter(AParentDirectory) +
      ABaseName + AExpectedMembers[Index].Extension;
    if not FileMatchesBytes(CurrentPath, AExpectedMembers[Index].Data) then
      raise EDBParadoxPublicationError.CreateFmt(
        'Source member "%s" differs from the transaction snapshot.',
        [AExpectedMembers[Index].Extension]);
  end;
end;

procedure ReplaceFileStrict(const AReplacement, ATarget: string);
var
  ErrorCode: Integer;
begin
  {$IFDEF MSWINDOWS}
  if not Windows.MoveFileEx(PChar(AReplacement), PChar(ATarget),
    DBPARADOX_MOVEFILE_REPLACE_EXISTING or
    DBPARADOX_MOVEFILE_WRITE_THROUGH) then
  begin
    ErrorCode := GetLastError;
    raise EDBParadoxPublicationError.CreateFmt(
      'Cannot replace "%s" (%d: %s).',
      [ATarget, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
  {$ELSE}
  if fpRename(PChar(AReplacement), PChar(ATarget)) <> 0 then
  begin
    ErrorCode := GetLastOSError;
    raise EDBParadoxPublicationError.CreateFmt(
      'Cannot replace "%s" (%d: %s).',
      [ATarget, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
  {$ENDIF}
end;

procedure RemoveStageDirectory(const AStageDirectory: string);
var
  Search: TSearchRec;
  SearchResult: Integer;
  EntryPath: string;
begin
  if not DirectoryExists(AStageDirectory) then
    Exit;
  SearchResult := FindFirst(IncludeTrailingPathDelimiter(AStageDirectory) +
    '*', faAnyFile, Search);
  if SearchResult = 0 then
  begin
    try
      repeat
        if (Search.Name = '.') or (Search.Name = '..') then
          Continue;
        EntryPath := IncludeTrailingPathDelimiter(AStageDirectory) +
          Search.Name;
        if (Search.Attr and faDirectory) <> 0 then
          RemoveStageDirectory(EntryPath)
        else if not SysUtils.DeleteFile(EntryPath) then
          raise EDBParadoxPublicationError.CreateFmt(
            'Cannot remove staged file "%s".', [EntryPath]);
      until FindNext(Search) <> 0;
    finally
      SysUtils.FindClose(Search);
    end;
  end;
  if not RemoveDir(AStageDirectory) then
    raise EDBParadoxPublicationError.CreateFmt(
      'Cannot remove staging directory "%s".', [AStageDirectory]);
end;

procedure Notify(const AFaultInjector: IDBParadoxPublicationFaultInjector;
  AEvent: TDBParadoxPublicationEvent; AMemberIndex: Integer);
begin
  if Assigned(AFaultInjector) then
    AFaultInjector.Checkpoint(AEvent, AMemberIndex);
end;

class procedure TDBParadoxFamilyPublisher.Publish(
  const ATableFileName: string;
  const ABuilder: IDBParadoxFamilyStageBuilder;
  const AValidator: IDBParadoxFamilyValidator;
  const AFaultInjector: IDBParadoxPublicationFaultInjector);
var
  NoExpectedMembers: TDBParadoxExpectedFamilyMembers;
begin
  NoExpectedMembers := nil;
  PublishCore(ATableFileName, ABuilder, AValidator, NoExpectedMembers,
    False, AFaultInjector);
end;

class procedure TDBParadoxFamilyPublisher.Publish(
  const ATableFileName: string;
  const ABuilder: IDBParadoxFamilyStageBuilder;
  const AValidator: IDBParadoxFamilyValidator;
  const AExpectedMembers: TDBParadoxExpectedFamilyMembers;
  const AFaultInjector: IDBParadoxPublicationFaultInjector);
begin
  PublishCore(ATableFileName, ABuilder, AValidator, AExpectedMembers,
    True, AFaultInjector);
end;

class procedure TDBParadoxFamilyPublisher.PublishCore(
  const ATableFileName: string;
  const ABuilder: IDBParadoxFamilyStageBuilder;
  const AValidator: IDBParadoxFamilyValidator;
  const AExpectedMembers: TDBParadoxExpectedFamilyMembers;
  ARequireExpectedMembers: Boolean;
  const AFaultInjector: IDBParadoxPublicationFaultInjector);
var
  TablePath, ParentDirectory, BaseName, StageDirectory: string;
  Members: TDBParadoxFamilyMembers;
  Lock: TDBParadoxFamilyLock;
  Index: Integer;
  BeforeDirectory: string;
  SnapshotPath, StagePath, TargetPath, RestorePath: string;
  Applied: array of Boolean;
  CompensationErrors: TStringList;
  OriginalErrorClass, OriginalErrorMessage, UncertainMembers: string;
  Published, PreserveStage: Boolean;
begin
  if not Assigned(ABuilder) then
    raise EDBParadoxPublicationError.Create(
      'A staged-family builder is required.');
  if not Assigned(AValidator) then
    raise EDBParadoxPublicationError.Create(
      'A staged-family validator is required.');
  TablePath := ExpandFileName(ATableFileName);
  if not FileExists(TablePath) or
    not SameText(ExtractFileExt(TablePath), '.DB') then
    raise EDBParadoxPublicationError.CreateFmt(
      'An existing .DB table file is required: "%s".', [ATableFileName]);
  ParentDirectory := ExtractFileDir(TablePath);
  BaseName := ChangeFileExt(ExtractFileName(TablePath), '');

  Lock := TDBParadoxFamilyLock.Create(TablePath);
  StageDirectory := '';
  Published := False;
  PreserveStage := False;
  try
    TDBParadoxFamilyJournal.RecoverWhileLocked(TablePath);
    Members := DiscoverFamily(ParentDirectory, BaseName, TablePath);
    if ARequireExpectedMembers then
      CheckExpectedSnapshot(ParentDirectory, BaseName, Members,
        AExpectedMembers);
    StageDirectory := NewStageDirectory(ParentDirectory, BaseName);
    Notify(AFaultInjector, dpeStageDirectoryCreated, -1);
    BeforeDirectory := IncludeTrailingPathDelimiter(StageDirectory) +
      '.before';
    if not CreateDir(BeforeDirectory) then
      raise EDBParadoxPublicationError.CreateFmt(
        'Cannot create before-image directory "%s".', [BeforeDirectory]);

    Applied := nil;
    SetLength(Applied, Length(Members));
    for Index := 0 to High(Members) do
    begin
      TargetPath := ParentDirectory + PathDelim + BaseName + Members[Index];
      SnapshotPath := IncludeTrailingPathDelimiter(BeforeDirectory) +
        IntToStr(Index) + '.snapshot';
      CopyFileStrict(TargetPath, SnapshotPath);
      Notify(AFaultInjector, dpeBeforeImageCopied, Index);
    end;

    try
      ABuilder.BeginBuild(StageDirectory, BaseName, Members);
      for Index := 0 to High(Members) do
      begin
        Notify(AFaultInjector, dpeBeforeStageMember, Index);
        ABuilder.BuildMember(StageDirectory, BaseName, Members[Index]);
        Notify(AFaultInjector, dpeAfterStageMember, Index);
      end;
      ABuilder.EndBuild;
    finally
      ABuilder.AbortBuild;
    end;
    CheckExactFamily(StageDirectory, BaseName, TablePath, Members);
    Notify(AFaultInjector, dpeStageBuilt, -1);
    AValidator.Validate(StageDirectory, BaseName, Members);
    Notify(AFaultInjector, dpeStageValidated, -1);
    CheckExactFamily(ParentDirectory, BaseName, TablePath, Members);
    for Index := 0 to High(Members) do
    begin
      TargetPath := ParentDirectory + PathDelim + BaseName + Members[Index];
      SnapshotPath := IncludeTrailingPathDelimiter(BeforeDirectory) +
        IntToStr(Index) + '.snapshot';
      if not FilesEqual(TargetPath, SnapshotPath) then
        raise EDBParadoxPublicationError.CreateFmt(
          'Source member "%s" changed while the staged family was built.',
          [Members[Index]]);
    end;
    Notify(AFaultInjector, dpeSnapshotRechecked, -1);
    TDBParadoxFamilyJournal.Prepare(TablePath, StageDirectory, BaseName,
      Members);
    Notify(AFaultInjector, dpeJournalPrepared, -1);

    try
      for Index := 0 to High(Members) do
      begin
        Notify(AFaultInjector, dpeBeforeReplacement, Index);
        StagePath := IncludeTrailingPathDelimiter(StageDirectory) +
          BaseName + Members[Index];
        TargetPath := ParentDirectory + PathDelim + BaseName + Members[Index];
        ReplaceFileStrict(StagePath, TargetPath);
        Applied[Index] := True;
        Notify(AFaultInjector, dpeAfterReplacement, Index);
      end;
      AValidator.Validate(ParentDirectory, BaseName, Members);
      TDBParadoxFamilyJournal.MarkCommitted(TablePath);
      Published := True;
    except
      on E: Exception do
      begin
        OriginalErrorClass := E.ClassName;
        OriginalErrorMessage := E.Message;
        CompensationErrors := TStringList.Create;
        try
          for Index := High(Members) downto 0 do
            if Applied[Index] then
              try
                Notify(AFaultInjector, dpeBeforeCompensation, Index);
                SnapshotPath := IncludeTrailingPathDelimiter(BeforeDirectory) +
                  IntToStr(Index) + '.snapshot';
                RestorePath := IncludeTrailingPathDelimiter(StageDirectory) +
                  'restore-' + IntToStr(Index);
                CopyFileStrict(SnapshotPath, RestorePath);
                TargetPath := ParentDirectory + PathDelim + BaseName +
                  Members[Index];
                ReplaceFileStrict(RestorePath, TargetPath);
                Applied[Index] := False;
              except
                on CompensationError: Exception do
                  CompensationErrors.Add(Members[Index] + ': ' +
                    CompensationError.ClassName + ': ' +
                    CompensationError.Message);
              end;
          if CompensationErrors.Count > 0 then
          begin
            UncertainMembers := StringReplace(
              Trim(CompensationErrors.Text), LineEnding, ', ',
              [rfReplaceAll]);
            PreserveStage := True;
            raise EDBParadoxUncertainPublicationError.Create(
              Format(
                'Publication failed (%s: %s); compensation failed for: %s. ' +
                'Recovery files are preserved in "%s".',
                [OriginalErrorClass, OriginalErrorMessage, UncertainMembers,
                 StageDirectory]), StageDirectory);
          end;
          try
            TDBParadoxFamilyJournal.MarkRolledBack(TablePath);
          except
            on JournalError: Exception do
            begin
              PreserveStage := True;
              raise EDBParadoxUncertainPublicationError.Create(
                Format(
                  'Publication failed (%s: %s); compensation completed, ' +
                  'but the recovery journal could not be finalized (%s: %s). ' +
                  'Recovery files are preserved in "%s".',
                  [OriginalErrorClass, OriginalErrorMessage,
                   JournalError.ClassName, JournalError.Message,
                   StageDirectory]), StageDirectory);
            end;
          end;
          raise EDBParadoxPublicationError.CreateFmt(
            'Publication failed (%s: %s); all replaced members were restored.',
            [OriginalErrorClass, OriginalErrorMessage]);
        finally
          CompensationErrors.Free;
        end;
      end;
    end;
    Notify(AFaultInjector, dpeCommitDecisionPersisted, -1);
  finally
    try
      try
        if (StageDirectory <> '') and not PreserveStage then
        begin
          Notify(AFaultInjector, dpeBeforeCleanup, -1);
          RemoveStageDirectory(StageDirectory);
          TDBParadoxFamilyJournal.Clear(TablePath);
        end;
      except
        on E: Exception do
        begin
          if Published then
            raise EDBParadoxPublishedCleanupError.Create(
              Format('The family was published, but staging cleanup failed ' +
                '(%s: %s). Staging files remain in "%s".',
                [E.ClassName, E.Message, StageDirectory]), StageDirectory);
          raise;
        end;
      end;
    finally
      Lock.Free;
    end;
  end;
end;

end.
