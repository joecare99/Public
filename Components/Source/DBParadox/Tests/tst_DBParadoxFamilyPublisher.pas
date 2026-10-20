unit tst_DBParadoxFamilyPublisher;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestDBParadoxFamilyPublisher = class(TTestCase)
  private
    procedure CheckSourceFamily(const ADirectory, APrefix: string);
    procedure CheckNoStagingDirectories(const ADirectory: string);
  published
    procedure PublishesAllowlistedEightFileFamily;
    procedure PrePublicationFailuresKeepSourceUnchanged;
    procedure ReplacementFailureRestoresPriorFamily;
    procedure CompensationFailurePreservesRecoveryImages;
    procedure UnknownSidecarIsRejectedBeforeBuilding;
    procedure PublisherFailsFastWhenFamilyLockIsContended;
    procedure CleanupFailureReportsPublishedState;
    procedure PrimaryAdapterBuildsAndValidatesPublishedFamily;
    procedure SecondaryAdapterBuildsAndValidatesTwoXgFamily;
    procedure SecondaryAdapterBuildsAndValidatesClassicAndXgFamily;
  end;

implementation

uses
  Classes, SysUtils, DBParadoxFamilyLock, DBParadoxFamilyPublisher,
  DBParadoxPrimaryFamilyAdapter, DBParadoxRecordEncoder,
  DBParadoxTableFileBuilder, DBParadoxFileReader,
  DBParadoxSecondaryFamilyAdapter;

const
  EightFileMembers: array[0..7] of string = (
    '.DB', '.PX', '.XG0', '.YG0', '.XG1', '.YG1', '.X02', '.Y02');

type
  TTestStageBuilder = class(TInterfacedObject, IDBParadoxFamilyStageBuilder)
  private
    FTableFileName: string;
    FBuildCount: Integer;
  public
    constructor Create(const ATableFileName: string);
    procedure BeginBuild(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
    procedure BuildMember(const AStageDirectory, ATableBaseName,
      AMember: string);
    procedure EndBuild;
    procedure AbortBuild;
    property BuildCount: Integer read FBuildCount;
  end;

  TTestValidator = class(TInterfacedObject, IDBParadoxFamilyValidator)
  public
    procedure Validate(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
  end;

  TTestFaultInjector = class(TInterfacedObject,
    IDBParadoxPublicationFaultInjector)
  private
    FEvent: TDBParadoxPublicationEvent;
    FMemberIndex: Integer;
    FSecondEvent: TDBParadoxPublicationEvent;
    FSecondMemberIndex: Integer;
    FHasSecondEvent: Boolean;
    FFiredFirst: Boolean;
    FFiredSecond: Boolean;
  public
    constructor Create(AEvent: TDBParadoxPublicationEvent;
      AMemberIndex: Integer);
    constructor Create(AEvent: TDBParadoxPublicationEvent;
      AMemberIndex: Integer; ASecondEvent: TDBParadoxPublicationEvent;
      ASecondMemberIndex: Integer);
    procedure Checkpoint(AEvent: TDBParadoxPublicationEvent;
      AMemberIndex: Integer);
  end;

function NewScratchDirectory: string;
var
  Guid: TGUID;
begin
  Result := '';
  if CreateGUID(Guid) <> 0 then
    raise Exception.Create('Cannot create unique test directory name.');
  Result := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'DBParadoxFamilyPublisher-' + Copy(GUIDToString(Guid), 2, 36);
  if not ForceDirectories(Result) then
    raise Exception.CreateFmt('Cannot create test directory "%s".', [Result]);
end;

procedure RemoveDirectoryTree(const ADirectory: string);
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
          RemoveDirectoryTree(EntryPath)
        else if not DeleteFile(EntryPath) then
          raise Exception.CreateFmt('Cannot delete test file "%s".',
            [EntryPath]);
      until FindNext(Search) <> 0;
    finally
      FindClose(Search);
    end;
  end;
  if not RemoveDir(ADirectory) then
    raise Exception.CreateFmt('Cannot remove test directory "%s".',
      [ADirectory]);
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

function ReadTextFile(const AFileName: string): string;
var
  Stream: TFileStream;
begin
  Result := '';
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    SetLength(Result, Stream.Size);
    if Stream.Size > 0 then
      Stream.ReadBuffer(Result[1], Stream.Size);
  finally
    Stream.Free;
  end;
end;

procedure CreateSourceFamily(const ADirectory: string);
var
  Index: Integer;
begin
  for Index := Low(EightFileMembers) to High(EightFileMembers) do
    WriteTextFile(IncludeTrailingPathDelimiter(ADirectory) +
      'Synthetic' + EightFileMembers[Index],
      'old:' + EightFileMembers[Index]);
end;

function MakePrimaryDatabaseTemplate: TBytes;
var
  TableNameOffset, FieldNamesOffset: SizeInt;
begin
  Result := nil;
  SetLength(Result, $800);
  Result[0] := 12;
  Result[2] := 0;
  Result[3] := 8;
  Result[4] := 0;
  Result[5] := 2;
  Result[$21] := 2;
  Result[$23] := 1;
  Result[$39] := $0C;
  Result[$78] := $04;
  Result[$79] := 4;
  Result[$7A] := $01;
  Result[$7B] := 8;
  TableNameOffset := $78 + 2 * 2 + 4 + 2 * 4;
  FieldNamesOffset := TableNameOffset + 261;
  Move('Synthetic'#0, Result[TableNameOffset], Length('Synthetic') + 1);
  Move('ID'#0, Result[FieldNamesOffset], Length('ID') + 1);
  Move('Label'#0, Result[FieldNamesOffset + Length('ID') + 1],
    Length('Label') + 1);
end;

function MakePrimaryIndexTemplate: TBytes;
begin
  Result := nil;
  SetLength(Result, $800);
  Result[0] := 10;
  Result[2] := 0;
  Result[3] := 8;
  Result[4] := 1;
  Result[5] := 2;
  Result[$21] := 1;
  Result[$58] := $04;
  Result[$59] := 4;
end;

function MakePrimaryFields: TDBParadoxRecordFields;
begin
  Result := nil;
  SetLength(Result, 2);
  Result[0].Name := 'ID';
  Result[0].TypeCode := $04;
  Result[0].Length := 4;
  Result[1].Name := 'Label';
  Result[1].TypeCode := $01;
  Result[1].Length := 8;
end;

procedure WriteUInt16LE(var Data: TBytes; AOffset: SizeInt; AValue: Word);
begin
  Data[AOffset] := Byte(AValue);
  Data[AOffset + 1] := Byte(AValue shr 8);
end;

procedure WriteAscii(var Data: TBytes; var AOffset: SizeInt;
  const AValue: AnsiString);
begin
  if Length(AValue) > 0 then
    Move(AValue[1], Data[AOffset], Length(AValue));
  Inc(AOffset, Length(AValue) + 1);
end;

function MakeSecondaryDatabaseTemplate: TBytes;
var
  TableNameOffset, FieldNamesOffset: SizeInt;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 32);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 0;
  Result[5] := 2;
  WriteUInt16LE(Result, $21, 3);
  WriteUInt16LE(Result, $23, 1);
  Result[$39] := $0C;
  Result[$78] := $04;
  Result[$79] := 4;
  Result[$7A] := $01;
  Result[$7B] := 20;
  Result[$7C] := $01;
  Result[$7D] := 8;
  TableNameOffset := $78 + 3 * 2 + 4 + 3 * 4;
  FieldNamesOffset := TableNameOffset + 261;
  Move('Synthetic'#0, Result[TableNameOffset], Length('Synthetic') + 1);
  Move('ID'#0, Result[FieldNamesOffset], Length('ID') + 1);
  Move('GroupKey'#0, Result[FieldNamesOffset + 3],
    Length('GroupKey') + 1);
  Move('Suffix'#0, Result[FieldNamesOffset + 12], Length('Suffix') + 1);
end;

function MakeSecondaryPrimaryIndexTemplate: TBytes;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 10);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 1;
  Result[5] := 2;
  WriteUInt16LE(Result, $21, 1);
  Result[$58] := $04;
  Result[$59] := 4;
end;

function MakeXgTemplate(CaseInsensitive: Boolean;
  const AIndexName: AnsiString): TBytes;
var
  NamesOffset, FieldMapEnd: SizeInt;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 34);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 8;
  Result[5] := 2;
  Result[$39] := $0C;
  WriteUInt16LE(Result, $21, 4);
  WriteUInt16LE(Result, $23, 3);
  if CaseInsensitive then
    Result[$55] := 1;
  Result[$78] := $01;
  Result[$79] := 20;
  Result[$7A] := $01;
  Result[$7B] := 8;
  Result[$7C] := $04;
  Result[$7D] := 4;
  Result[$7E] := $03;
  Result[$7F] := 2;
  NamesOffset := $78 + 4 * 2 + 4 + 4 * 4 + 261;
  WriteAscii(Result, NamesOffset, 'GroupKey');
  WriteAscii(Result, NamesOffset, 'Suffix');
  WriteAscii(Result, NamesOffset, 'ID');
  WriteAscii(Result, NamesOffset, 'Blk Num');
  FieldMapEnd := NamesOffset + 4 * SizeOf(Word);
  WriteAscii(Result, FieldMapEnd, 'DBWINUS0');
  WriteAscii(Result, FieldMapEnd, AIndexName);
end;

function MakeYgTemplate: TBytes;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 38);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 7;
  Result[5] := 2;
  WriteUInt16LE(Result, $21, 3);
  WriteUInt16LE(Result, $23, 3);
  Result[$58] := $01;
  Result[$59] := 20;
  Result[$5A] := $01;
  Result[$5B] := 8;
  Result[$5C] := $04;
  Result[$5D] := 4;
end;

function MakeClassicX02Template: TBytes;
var
  NamesOffset, FieldMapEnd: SizeInt;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 26);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 5;
  Result[5] := 2;
  Result[$39] := $0C;
  WriteUInt16LE(Result, $21, 3);
  WriteUInt16LE(Result, $23, 2);
  Result[$78] := $01;
  Result[$79] := 20;
  Result[$7A] := $04;
  Result[$7B] := 4;
  Result[$7C] := $03;
  Result[$7D] := 2;
  NamesOffset := $78 + 3 * 2 + 4 + 3 * 4 + 261;
  WriteAscii(Result, NamesOffset, 'GroupKey');
  WriteAscii(Result, NamesOffset, 'Sec Key');
  WriteAscii(Result, NamesOffset, 'Hint');
  FieldMapEnd := NamesOffset + 3 * SizeOf(Word);
  WriteAscii(Result, FieldMapEnd, 'DBWINUS0');
  WriteAscii(Result, FieldMapEnd, 'GroupKey');
end;

function MakeClassicY02Template: TBytes;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 30);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 4;
  Result[5] := 2;
  WriteUInt16LE(Result, $21, 2);
  WriteUInt16LE(Result, $23, 2);
  Result[$58] := $01;
  Result[$59] := 20;
  Result[$5A] := $04;
  Result[$5B] := 4;
end;

procedure WriteBytesFile(const AFileName: string; const AData: TBytes);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(AFileName, fmCreate);
  try
    if Length(AData) > 0 then
      Stream.WriteBuffer(AData[0], Length(AData));
  finally
    Stream.Free;
  end;
end;

function LoadTestFileBytes(const AFileName: string): TBytes;
var
  Stream: TFileStream;
begin
  Result := nil;
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    SetLength(Result, Stream.Size);
    if Stream.Size > 0 then
      Stream.ReadBuffer(Result[0], Stream.Size);
  finally
    Stream.Free;
  end;
end;

procedure TTestDBParadoxFamilyPublisher.CheckSourceFamily(
  const ADirectory, APrefix: string);
var
  Index: Integer;
begin
  for Index := Low(EightFileMembers) to High(EightFileMembers) do
    CheckEquals(APrefix + EightFileMembers[Index],
      ReadTextFile(IncludeTrailingPathDelimiter(ADirectory) +
        'Synthetic' + EightFileMembers[Index]));
end;

procedure TTestDBParadoxFamilyPublisher.CheckNoStagingDirectories(
  const ADirectory: string);
var
  Search: TSearchRec;
  SearchResult: Integer;
begin
  SearchResult := FindFirst(IncludeTrailingPathDelimiter(ADirectory) +
    '.dbparadox-stage-*', faAnyFile, Search);
  if SearchResult = 0 then
  begin
    FindClose(Search);
    Fail('Publication left a staging directory behind.');
  end;
end;

constructor TTestStageBuilder.Create(const ATableFileName: string);
begin
  inherited Create;
  FTableFileName := ATableFileName;
end;

procedure TTestStageBuilder.BeginBuild(const AStageDirectory,
  ATableBaseName: string;
  const AMembers: TDBParadoxFamilyMembers);
var
  ContendingLock: TDBParadoxFamilyLock;
  LockContentionDetected: Boolean;
begin
  Inc(FBuildCount);
  LockContentionDetected := False;
  ContendingLock := nil;
  try
    try
      ContendingLock := TDBParadoxFamilyLock.Create(FTableFileName);
    except
      on E: EDBParadoxFamilyLockError do
        LockContentionDetected := True;
    end;
    if not LockContentionDetected then
      raise Exception.Create(
        'The publisher did not hold its cooperative family lock.');
  finally
    ContendingLock.Free;
  end;
end;

procedure TTestStageBuilder.BuildMember(const AStageDirectory,
  ATableBaseName, AMember: string);
begin
  WriteTextFile(IncludeTrailingPathDelimiter(AStageDirectory) +
    ATableBaseName + AMember, 'new:' + AMember);
end;

procedure TTestStageBuilder.EndBuild;
begin
end;

procedure TTestStageBuilder.AbortBuild;
begin
end;

procedure TTestValidator.Validate(const AStageDirectory, ATableBaseName: string;
  const AMembers: TDBParadoxFamilyMembers);
var
  Index: Integer;
  FileName: string;
begin
  for Index := 0 to High(AMembers) do
  begin
    FileName := IncludeTrailingPathDelimiter(AStageDirectory) +
      ATableBaseName + AMembers[Index];
    if not FileExists(FileName) or
      (ReadTextFile(FileName) <> 'new:' + AMembers[Index]) then
      raise Exception.CreateFmt('Invalid staged member "%s".', [AMembers[Index]]);
  end;
end;

constructor TTestFaultInjector.Create(AEvent: TDBParadoxPublicationEvent;
  AMemberIndex: Integer);
begin
  inherited Create;
  FEvent := AEvent;
  FMemberIndex := AMemberIndex;
  FHasSecondEvent := False;
end;

constructor TTestFaultInjector.Create(AEvent: TDBParadoxPublicationEvent;
  AMemberIndex: Integer; ASecondEvent: TDBParadoxPublicationEvent;
  ASecondMemberIndex: Integer);
begin
  inherited Create;
  FEvent := AEvent;
  FMemberIndex := AMemberIndex;
  FSecondEvent := ASecondEvent;
  FSecondMemberIndex := ASecondMemberIndex;
  FHasSecondEvent := True;
end;

procedure TTestFaultInjector.Checkpoint(AEvent: TDBParadoxPublicationEvent;
  AMemberIndex: Integer);
begin
  if not FFiredFirst and (AEvent = FEvent) and
    ((FMemberIndex < 0) or (AMemberIndex = FMemberIndex)) then
  begin
    FFiredFirst := True;
    raise Exception.CreateFmt('Injected publication fault at event %d, member %d.',
      [Ord(AEvent), AMemberIndex]);
  end;
  if FHasSecondEvent and not FFiredSecond and (AEvent = FSecondEvent) and
    ((FSecondMemberIndex < 0) or
     (AMemberIndex = FSecondMemberIndex)) then
  begin
    FFiredSecond := True;
    raise Exception.CreateFmt('Injected publication fault at event %d, member %d.',
      [Ord(AEvent), AMemberIndex]);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.PublishesAllowlistedEightFileFamily;
var
  Directory: string;
  TableFileName: string;
  LockFileName: string;
  Index: Integer;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  Search: TSearchRec;
  SearchResult: Integer;
begin
  Directory := NewScratchDirectory;
  TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
  LockFileName := TableFileName + '.dbparadox.lock';
  Builder := TTestStageBuilder.Create(TableFileName);
  Validator := TTestValidator.Create;
  try
    CreateSourceFamily(Directory);
    TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator);
    for Index := Low(EightFileMembers) to High(EightFileMembers) do
      CheckEquals('new:' + EightFileMembers[Index],
        ReadTextFile(IncludeTrailingPathDelimiter(Directory) +
          'Synthetic' + EightFileMembers[Index]));
    CheckTrue(FileExists(LockFileName));
    SearchResult := FindFirst(IncludeTrailingPathDelimiter(Directory) +
      '.dbparadox-stage-*', faAnyFile, Search);
    if SearchResult = 0 then
    begin
      FindClose(Search);
      Fail('Successful publication left a staging directory behind.');
    end;
  finally
    Validator := nil;
    Builder := nil;
    RemoveDirectoryTree(Directory);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.
  PrePublicationFailuresKeepSourceUnchanged;
const
  FailureEvents: array[0..7] of TDBParadoxPublicationEvent = (
    dpeStageDirectoryCreated,
    dpeBeforeImageCopied,
    dpeBeforeStageMember,
    dpeAfterStageMember,
    dpeStageBuilt,
    dpeStageValidated,
    dpeSnapshotRechecked,
    dpeBeforeReplacement);
var
  RootDirectory: string;
  Directory: string;
  TableFileName: string;
  Index: Integer;
  MemberIndex: Integer;
  StageEventIndex: Integer;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  FaultInjector: IDBParadoxPublicationFaultInjector;
  RaisedExpectedError: Boolean;
begin
  RootDirectory := NewScratchDirectory;
  try
    for Index := Low(FailureEvents) to High(FailureEvents) do
    begin
      Directory := IncludeTrailingPathDelimiter(RootDirectory) +
        'Case' + IntToStr(Index);
      if not ForceDirectories(Directory) then
        raise Exception.CreateFmt('Cannot create test directory "%s".',
          [Directory]);
      TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
      Builder := TTestStageBuilder.Create(TableFileName);
      Validator := TTestValidator.Create;
      MemberIndex := -1;
      if FailureEvents[Index] in [dpeBeforeImageCopied,
        dpeBeforeStageMember, dpeAfterStageMember] then
        MemberIndex := 3;
      FaultInjector := TTestFaultInjector.Create(FailureEvents[Index],
        MemberIndex);
      try
        CreateSourceFamily(Directory);
        RaisedExpectedError := False;
        try
          TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator,
            FaultInjector);
        except
          on E: Exception do
            RaisedExpectedError := True;
        end;
        CheckTrue(RaisedExpectedError);
        CheckSourceFamily(Directory, 'old:');
        CheckNoStagingDirectories(Directory);
      finally
        FaultInjector := nil;
        Validator := nil;
        Builder := nil;
      end;
    end;
    for StageEventIndex := 0 to 1 do
      for MemberIndex := Low(EightFileMembers) to High(EightFileMembers) do
      begin
        Directory := IncludeTrailingPathDelimiter(RootDirectory) +
          'Stage' + IntToStr(StageEventIndex) + 'Member' +
          IntToStr(MemberIndex);
        if not ForceDirectories(Directory) then
          raise Exception.CreateFmt('Cannot create test directory "%s".',
            [Directory]);
        TableFileName := IncludeTrailingPathDelimiter(Directory) +
          'Synthetic.DB';
        Builder := TTestStageBuilder.Create(TableFileName);
        Validator := TTestValidator.Create;
        if StageEventIndex = 0 then
          FaultInjector := TTestFaultInjector.Create(dpeBeforeStageMember,
            MemberIndex)
        else
          FaultInjector := TTestFaultInjector.Create(dpeAfterStageMember,
            MemberIndex);
        try
          CreateSourceFamily(Directory);
          RaisedExpectedError := False;
          try
            TDBParadoxFamilyPublisher.Publish(TableFileName, Builder,
              Validator, FaultInjector);
          except
            on E: Exception do
              RaisedExpectedError := True;
          end;
          CheckTrue(RaisedExpectedError);
          CheckSourceFamily(Directory, 'old:');
          CheckNoStagingDirectories(Directory);
        finally
          FaultInjector := nil;
          Validator := nil;
          Builder := nil;
        end;
      end;
  finally
    RemoveDirectoryTree(RootDirectory);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.
  ReplacementFailureRestoresPriorFamily;
var
  RootDirectory: string;
  Directory: string;
  TableFileName: string;
  MemberIndex: Integer;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  FaultInjector: IDBParadoxPublicationFaultInjector;
  RaisedExpectedError: Boolean;
begin
  RootDirectory := NewScratchDirectory;
  try
    for MemberIndex := Low(EightFileMembers) to High(EightFileMembers) do
    begin
      Directory := IncludeTrailingPathDelimiter(RootDirectory) +
        'Case' + IntToStr(MemberIndex);
      if not ForceDirectories(Directory) then
        raise Exception.CreateFmt('Cannot create test directory "%s".',
          [Directory]);
      TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
      Builder := TTestStageBuilder.Create(TableFileName);
      Validator := TTestValidator.Create;
      FaultInjector := TTestFaultInjector.Create(dpeAfterReplacement,
        MemberIndex);
      try
        CreateSourceFamily(Directory);
        RaisedExpectedError := False;
        try
          TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator,
            FaultInjector);
        except
          on E: EDBParadoxPublicationError do
            RaisedExpectedError := True;
        end;
        CheckTrue(RaisedExpectedError);
        CheckSourceFamily(Directory, 'old:');
        CheckNoStagingDirectories(Directory);
      finally
        FaultInjector := nil;
        Validator := nil;
        Builder := nil;
      end;
    end;
  finally
    RemoveDirectoryTree(RootDirectory);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.
  CompensationFailurePreservesRecoveryImages;
var
  RootDirectory: string;
  Directory: string;
  TableFileName: string;
  RecoveryDirectory: string;
  MemberIndex: Integer;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  FaultInjector: IDBParadoxPublicationFaultInjector;
  RaisedExpectedError: Boolean;
begin
  RootDirectory := NewScratchDirectory;
  try
    for MemberIndex := Low(EightFileMembers) to High(EightFileMembers) do
    begin
      Directory := IncludeTrailingPathDelimiter(RootDirectory) +
        'Case' + IntToStr(MemberIndex);
      if not ForceDirectories(Directory) then
        raise Exception.CreateFmt('Cannot create test directory "%s".',
          [Directory]);
      TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
      Builder := TTestStageBuilder.Create(TableFileName);
      Validator := TTestValidator.Create;
      FaultInjector := TTestFaultInjector.Create(dpeAfterReplacement,
        MemberIndex, dpeBeforeCompensation, MemberIndex);
      try
        CreateSourceFamily(Directory);
        RaisedExpectedError := False;
        RecoveryDirectory := '';
        try
          TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator,
            FaultInjector);
        except
          on E: EDBParadoxUncertainPublicationError do
          begin
            RaisedExpectedError := True;
            RecoveryDirectory := E.RecoveryDirectory;
          end;
        end;
        CheckTrue(RaisedExpectedError);
        CheckTrue(DirectoryExists(RecoveryDirectory));
        CheckTrue(FileExists(IncludeTrailingPathDelimiter(RecoveryDirectory) +
          '.before' + PathDelim + IntToStr(MemberIndex) + '.snapshot'));
      finally
        FaultInjector := nil;
        Validator := nil;
        Builder := nil;
      end;
    end;
  finally
    RemoveDirectoryTree(RootDirectory);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.
  PublisherFailsFastWhenFamilyLockIsContended;
var
  Directory: string;
  TableFileName: string;
  Lock: TDBParadoxFamilyLock;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  RaisedExpectedError: Boolean;
begin
  Directory := NewScratchDirectory;
  TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
  Lock := nil;
  Builder := TTestStageBuilder.Create(TableFileName);
  Validator := TTestValidator.Create;
  try
    CreateSourceFamily(Directory);
    Lock := TDBParadoxFamilyLock.Create(TableFileName);
    RaisedExpectedError := False;
    try
      TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator);
    except
      on E: EDBParadoxFamilyLockError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError);
    CheckSourceFamily(Directory, 'old:');
    CheckNoStagingDirectories(Directory);
  finally
    Lock.Free;
    Validator := nil;
    Builder := nil;
    RemoveDirectoryTree(Directory);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.CleanupFailureReportsPublishedState;
var
  Directory: string;
  TableFileName: string;
  StageDirectory: string;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  FaultInjector: IDBParadoxPublicationFaultInjector;
  Lock: TDBParadoxFamilyLock;
  RaisedExpectedError: Boolean;
begin
  Directory := NewScratchDirectory;
  TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
  Builder := TTestStageBuilder.Create(TableFileName);
  Validator := TTestValidator.Create;
  FaultInjector := TTestFaultInjector.Create(dpeBeforeCleanup, -1);
  Lock := nil;
  try
    CreateSourceFamily(Directory);
    RaisedExpectedError := False;
    StageDirectory := '';
    try
      TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator,
        FaultInjector);
    except
      on E: EDBParadoxPublishedCleanupError do
      begin
        RaisedExpectedError := True;
        StageDirectory := E.StageDirectory;
      end;
    end;
    CheckTrue(RaisedExpectedError);
    CheckTrue(DirectoryExists(StageDirectory));
    CheckSourceFamily(Directory, 'new:');
    Lock := TDBParadoxFamilyLock.Create(TableFileName);
  finally
    Lock.Free;
    FaultInjector := nil;
    Validator := nil;
    Builder := nil;
    if (StageDirectory <> '') and DirectoryExists(StageDirectory) then
      RemoveDirectoryTree(StageDirectory);
    RemoveDirectoryTree(Directory);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.UnknownSidecarIsRejectedBeforeBuilding;
var
  Directory: string;
  TableFileName: string;
  BuilderObject: TTestStageBuilder;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  RaisedExpectedError: Boolean;
begin
  Directory := NewScratchDirectory;
  TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
  BuilderObject := TTestStageBuilder.Create(TableFileName);
  Builder := BuilderObject;
  Validator := TTestValidator.Create;
  try
    WriteTextFile(TableFileName, 'old:.DB');
    WriteTextFile(ChangeFileExt(TableFileName, '.PX'), 'old:.PX');
    WriteTextFile(ChangeFileExt(TableFileName, '.MB'), 'unsupported');
    RaisedExpectedError := False;
    try
      TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator);
    except
      on E: EDBParadoxPublicationError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError);
    CheckEquals(0, BuilderObject.BuildCount);
  finally
    Validator := nil;
    Builder := nil;
    RemoveDirectoryTree(Directory);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.
  PrimaryAdapterBuildsAndValidatesPublishedFamily;
var
  Directory: string;
  TableFileName: string;
  DatabaseTemplate: TBytes;
  PrimaryIndexTemplate: TBytes;
  Fields: TDBParadoxRecordFields;
  InitialRows, PublishedRows: TDBParadoxTableRows;
  InitialFiles: TDBParadoxBuiltFiles;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  FaultInjector: IDBParadoxPublicationFaultInjector;
  StagingFailureRaised: Boolean;
  ActualFields: TDBParadoxFileFields;
  ActualRows: TDBParadoxFileRows;
  ActualRecordSize: Integer;
  ExpectedRows: array[0..2] of TBytes;
  Index, RowIndex: Integer;
  Found: Boolean;
  BdeOutputDirectory: string;
  BdeTemplateDirectory: string;
  DatabaseFileName: string;
begin
  Directory := NewScratchDirectory;
  TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
  BdeTemplateDirectory :=
    GetEnvironmentVariable('DBPARADOX_PUBLISHER_BDE_TEMPLATE_DIR');
  if BdeTemplateDirectory = '' then
  begin
    DatabaseTemplate := MakePrimaryDatabaseTemplate;
    PrimaryIndexTemplate := MakePrimaryIndexTemplate;
  end
  else
  begin
    DatabaseTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + 'Synthetic.DB');
    PrimaryIndexTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + 'Synthetic.PX');
  end;
  Fields := MakePrimaryFields;
  SetLength(InitialRows, 2);
  InitialRows[0] := ['1', 'Old-one'];
  InitialRows[1] := ['2', 'Old-two'];
  SetLength(PublishedRows, 3);
  PublishedRows[0] := ['1', 'Updated'];
  PublishedRows[1] := ['2', 'Old-two'];
  PublishedRows[2] := ['3', 'Added'];
  try
    InitialFiles := BuildDBParadoxTableFiles(DatabaseTemplate,
      PrimaryIndexTemplate, Fields, 0, InitialRows);
    WriteBytesFile(TableFileName, InitialFiles.DatabaseFile);
    WriteBytesFile(ChangeFileExt(TableFileName, '.PX'),
      InitialFiles.PrimaryIndexFile);
    Builder := TDBParadoxPrimaryFamilyStageBuilder.Create(DatabaseTemplate,
      PrimaryIndexTemplate, Fields, 0, PublishedRows);
    Validator := TDBParadoxPrimaryFamilyValidator.Create(Fields, 0,
      PublishedRows);

    FaultInjector := TTestFaultInjector.Create(dpeBeforeStageMember, 0);
    StagingFailureRaised := False;
    try
      try
        TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator,
          FaultInjector);
      except
        on E: Exception do
          StagingFailureRaised := True;
      end;
    finally
      FaultInjector := nil;
    end;
    CheckTrue(StagingFailureRaised);

    TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator);
    ReadDBParadoxTable(TableFileName, ActualFields, ActualRows,
      ActualRecordSize);
    CheckEquals(12, ActualRecordSize);
    CheckEquals(3, Length(ActualRows));
    CheckEquals(2, Length(ActualFields));
    ExpectedRows[0] := EncodeDBParadoxRecord(Fields, PublishedRows[0]);
    ExpectedRows[1] := EncodeDBParadoxRecord(Fields, PublishedRows[1]);
    ExpectedRows[2] := EncodeDBParadoxRecord(Fields, PublishedRows[2]);
    for Index := Low(ExpectedRows) to High(ExpectedRows) do
    begin
      Found := False;
      for RowIndex := 0 to High(ActualRows) do
        if CompareByte(ExpectedRows[Index][0], ActualRows[RowIndex].Data[0],
          Length(ExpectedRows[Index])) = 0 then
          Found := True;
      CheckTrue(Found);
    end;
    BdeOutputDirectory :=
      GetEnvironmentVariable('DBPARADOX_PUBLISHER_BDE_OUTPUT_DIR');
    if BdeOutputDirectory <> '' then
    begin
      if DirectoryExists(BdeOutputDirectory) then
        raise Exception.CreateFmt(
          'The requested BDE output directory already exists: "%s".',
          [BdeOutputDirectory]);
      if not ForceDirectories(BdeOutputDirectory) then
        raise Exception.CreateFmt(
          'Cannot create BDE output directory "%s".', [BdeOutputDirectory]);
      DatabaseFileName := IncludeTrailingPathDelimiter(Directory) +
        'Synthetic.DB';
      WriteBytesFile(IncludeTrailingPathDelimiter(BdeOutputDirectory) +
        'Synthetic.DB', LoadTestFileBytes(DatabaseFileName));
      WriteBytesFile(IncludeTrailingPathDelimiter(BdeOutputDirectory) +
        'Synthetic.PX',
        LoadTestFileBytes(ChangeFileExt(DatabaseFileName, '.PX')));
    end;
  finally
    Validator := nil;
    Builder := nil;
    RemoveDirectoryTree(Directory);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.
  SecondaryAdapterBuildsAndValidatesTwoXgFamily;
var
  Directory, TableFileName: string;
  DatabaseTemplate, PrimaryTemplate, XgTemplate, YgTemplate: TBytes;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  Indexes: TDBParadoxSecondaryFamilyIndexes;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  ActualFields: TDBParadoxFileFields;
  ActualRows: TDBParadoxFileRows;
  RecordSize: Integer;
  MemberIndex, RowIndex: SizeInt;
  Members: array[0..5] of string =
    ('.DB', '.PX', '.XG0', '.YG0', '.XG1', '.YG1');
  ExpectedRecord: TBytes;
  BdeTemplateDirectory, BdeOutputDirectory: string;
  TemplateNames: array[0..5] of string =
    ('Synthetic.DB', 'Synthetic.PX', 'Synthetic.XG0', 'Synthetic.YG0',
     'Synthetic.XG1', 'Synthetic.YG1');
  Found: Boolean;
begin
  Directory := NewScratchDirectory;
  TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
  BdeTemplateDirectory :=
    GetEnvironmentVariable('DBPARADOX_SECONDARY_PUBLISHER_BDE_TEMPLATE_DIR');
  if BdeTemplateDirectory = '' then
  begin
    DatabaseTemplate := MakeSecondaryDatabaseTemplate;
    PrimaryTemplate := MakeSecondaryPrimaryIndexTemplate;
    XgTemplate := MakeXgTemplate(False, 'GrpC');
    YgTemplate := MakeYgTemplate;
  end
  else
  begin
    DatabaseTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[0]);
    PrimaryTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[1]);
    XgTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[2]);
    YgTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[3]);
  end;
  SetLength(Fields, 3);
  Fields[0].Name := 'ID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  Fields[1].Name := 'GroupKey';
  Fields[1].TypeCode := $01;
  Fields[1].Length := 20;
  Fields[2].Name := 'Suffix';
  Fields[2].TypeCode := $01;
  Fields[2].Length := 8;
  SetLength(Rows, 3);
  Rows[0] := ['1', 'Alpha', 'A'];
  Rows[1] := ['2', 'alpha', 'B'];
  Rows[2] := ['3', 'Beta', 'A'];
  SetLength(Indexes, 2);
  Indexes[0].DataExtension := '.XG0';
  Indexes[0].IndexExtension := '.YG0';
  Indexes[0].DataTemplate := Copy(XgTemplate, 0, Length(XgTemplate));
  Indexes[0].IndexTemplate := Copy(YgTemplate, 0, Length(YgTemplate));
  Indexes[0].KeyFieldIndexes := [1, 2, 0];
  Indexes[1].DataExtension := '.XG1';
  Indexes[1].IndexExtension := '.YG1';
  if BdeTemplateDirectory = '' then
    Indexes[1].DataTemplate := MakeXgTemplate(True, 'GrpI')
  else
    Indexes[1].DataTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[4]);
  Indexes[1].IndexTemplate := Copy(YgTemplate, 0, Length(YgTemplate));
  if BdeTemplateDirectory <> '' then
    Indexes[1].IndexTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[5]);
  Indexes[1].KeyFieldIndexes := [1, 2, 0];
  try
    WriteBytesFile(TableFileName, DatabaseTemplate);
    WriteBytesFile(ChangeFileExt(TableFileName, '.PX'), PrimaryTemplate);
    for MemberIndex := 0 to High(Indexes) do
    begin
      WriteBytesFile(IncludeTrailingPathDelimiter(Directory) +
        'Synthetic' + Indexes[MemberIndex].DataExtension,
        Indexes[MemberIndex].DataTemplate);
      WriteBytesFile(IncludeTrailingPathDelimiter(Directory) +
        'Synthetic' + Indexes[MemberIndex].IndexExtension,
        Indexes[MemberIndex].IndexTemplate);
    end;

    Builder := TDBParadoxSecondaryFamilyStageBuilder.Create(
      DatabaseTemplate, PrimaryTemplate, Fields, 0, Rows, Indexes);
    Validator := TDBParadoxSecondaryFamilyValidator.Create(
      DatabaseTemplate, PrimaryTemplate, Fields, 0, Rows, Indexes);
    TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator);

    ReadDBParadoxTable(TableFileName, ActualFields, ActualRows, RecordSize);
    CheckEquals(32, RecordSize);
    CheckEquals(3, Length(ActualFields));
    CheckEquals(3, Length(ActualRows));
    for RowIndex := 0 to High(Rows) do
    begin
      ExpectedRecord := EncodeDBParadoxRecord(Fields, Rows[RowIndex]);
      Found := False;
      for MemberIndex := 0 to High(ActualRows) do
        if CompareByte(ExpectedRecord[0], ActualRows[MemberIndex].Data[0],
          Length(ExpectedRecord)) = 0 then
          Found := True;
      CheckTrue(Found);
    end;
    for MemberIndex := Low(Members) to High(Members) do
      CheckTrue(FileExists(IncludeTrailingPathDelimiter(Directory) +
        'Synthetic' + Members[MemberIndex]));
    CheckEquals(8, LoadTestFileBytes(
      IncludeTrailingPathDelimiter(Directory) + 'Synthetic.XG0')[4]);
    CheckEquals(7, LoadTestFileBytes(
      IncludeTrailingPathDelimiter(Directory) + 'Synthetic.YG0')[4]);
    CheckEquals(8, LoadTestFileBytes(
      IncludeTrailingPathDelimiter(Directory) + 'Synthetic.XG1')[4]);
    CheckEquals(7, LoadTestFileBytes(
      IncludeTrailingPathDelimiter(Directory) + 'Synthetic.YG1')[4]);
    BdeOutputDirectory := GetEnvironmentVariable(
      'DBPARADOX_SECONDARY_PUBLISHER_BDE_OUTPUT_DIR');
    if BdeOutputDirectory <> '' then
    begin
      if DirectoryExists(BdeOutputDirectory) then
        raise Exception.CreateFmt(
          'The requested secondary BDE output directory already exists: "%s".',
          [BdeOutputDirectory]);
      if not ForceDirectories(BdeOutputDirectory) then
        raise Exception.CreateFmt(
          'Cannot create secondary BDE output directory "%s".',
          [BdeOutputDirectory]);
      for MemberIndex := Low(TemplateNames) to High(TemplateNames) do
        WriteBytesFile(IncludeTrailingPathDelimiter(BdeOutputDirectory) +
          TemplateNames[MemberIndex], LoadTestFileBytes(
            IncludeTrailingPathDelimiter(Directory) + TemplateNames[MemberIndex]));
    end;
  finally
    Validator := nil;
    Builder := nil;
    RemoveDirectoryTree(Directory);
  end;
end;

procedure TTestDBParadoxFamilyPublisher.
  SecondaryAdapterBuildsAndValidatesClassicAndXgFamily;
var
  Directory, TableFileName: string;
  DatabaseTemplate, PrimaryTemplate, XgTemplate, YgTemplate: TBytes;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  Indexes: TDBParadoxSecondaryFamilyIndexes;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
  ActualFields: TDBParadoxFileFields;
  ActualRows: TDBParadoxFileRows;
  RecordSize: Integer;
  MemberIndex, RowIndex: SizeInt;
  Members: array[0..7] of string =
    ('.DB', '.PX', '.XG0', '.YG0', '.XG1', '.YG1', '.X02', '.Y02');
  ExpectedRecord: TBytes;
  BdeTemplateDirectory, BdeOutputDirectory: string;
  TemplateNames: array[0..7] of string =
    ('Synthetic.DB', 'Synthetic.PX', 'Synthetic.XG0', 'Synthetic.YG0',
     'Synthetic.XG1', 'Synthetic.YG1', 'Synthetic.X02', 'Synthetic.Y02');
  Found: Boolean;
begin
  Directory := NewScratchDirectory;
  TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
  BdeTemplateDirectory :=
    GetEnvironmentVariable('DBPARADOX_CLASSIC_PUBLISHER_BDE_TEMPLATE_DIR');
  if BdeTemplateDirectory = '' then
  begin
    DatabaseTemplate := MakeSecondaryDatabaseTemplate;
    PrimaryTemplate := MakeSecondaryPrimaryIndexTemplate;
    XgTemplate := MakeXgTemplate(False, 'GrpC');
    YgTemplate := MakeYgTemplate;
  end
  else
  begin
    DatabaseTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[0]);
    PrimaryTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[1]);
  end;
  SetLength(Fields, 3);
  Fields[0].Name := 'ID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  Fields[1].Name := 'GroupKey';
  Fields[1].TypeCode := $01;
  Fields[1].Length := 20;
  Fields[2].Name := 'Suffix';
  Fields[2].TypeCode := $01;
  Fields[2].Length := 8;
  SetLength(Rows, 3);
  Rows[0] := ['1', 'Alpha', 'A'];
  Rows[1] := ['2', 'alpha', 'B'];
  Rows[2] := ['3', 'Beta', 'A'];
  SetLength(Indexes, 3);
  Indexes[0].DataExtension := '.XG0';
  Indexes[0].IndexExtension := '.YG0';
  if BdeTemplateDirectory = '' then
  begin
    Indexes[0].DataTemplate := Copy(XgTemplate, 0, Length(XgTemplate));
    Indexes[0].IndexTemplate := Copy(YgTemplate, 0, Length(YgTemplate));
    Indexes[0].KeyFieldIndexes := [1, 2, 0];
  end
  else
  begin
    Indexes[0].DataTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[2]);
    Indexes[0].IndexTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[3]);
    Indexes[0].KeyFieldIndexes := [1, 0];
  end;
  Indexes[1].DataExtension := '.XG1';
  Indexes[1].IndexExtension := '.YG1';
  if BdeTemplateDirectory = '' then
  begin
    Indexes[1].DataTemplate := MakeXgTemplate(True, 'GrpI');
    Indexes[1].IndexTemplate := Copy(YgTemplate, 0, Length(YgTemplate));
    Indexes[1].KeyFieldIndexes := [1, 2, 0];
  end
  else
  begin
    Indexes[1].DataTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[4]);
    Indexes[1].IndexTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[5]);
    Indexes[1].KeyFieldIndexes := [1, 2, 0];
  end;
  Indexes[2].DataExtension := '.X02';
  Indexes[2].IndexExtension := '.Y02';
  if BdeTemplateDirectory = '' then
  begin
    Indexes[2].DataTemplate := MakeClassicX02Template;
    Indexes[2].IndexTemplate := MakeClassicY02Template;
  end
  else
  begin
    Indexes[2].DataTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[6]);
    Indexes[2].IndexTemplate := LoadTestFileBytes(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + TemplateNames[7]);
  end;
  Indexes[2].KeyFieldIndexes := [1, 0];
  try
    WriteBytesFile(TableFileName, DatabaseTemplate);
    WriteBytesFile(ChangeFileExt(TableFileName, '.PX'), PrimaryTemplate);
    for MemberIndex := 0 to High(Indexes) do
    begin
      WriteBytesFile(IncludeTrailingPathDelimiter(Directory) +
        'Synthetic' + Indexes[MemberIndex].DataExtension,
        Indexes[MemberIndex].DataTemplate);
      WriteBytesFile(IncludeTrailingPathDelimiter(Directory) +
        'Synthetic' + Indexes[MemberIndex].IndexExtension,
        Indexes[MemberIndex].IndexTemplate);
    end;

    Builder := TDBParadoxSecondaryFamilyStageBuilder.Create(
      DatabaseTemplate, PrimaryTemplate, Fields, 0, Rows, Indexes);
    Validator := TDBParadoxSecondaryFamilyValidator.Create(
      DatabaseTemplate, PrimaryTemplate, Fields, 0, Rows, Indexes);
    TDBParadoxFamilyPublisher.Publish(TableFileName, Builder, Validator);

    ReadDBParadoxTable(TableFileName, ActualFields, ActualRows, RecordSize);
    CheckEquals(32, RecordSize);
    CheckEquals(3, Length(ActualFields));
    CheckEquals(3, Length(ActualRows));
    for RowIndex := 0 to High(Rows) do
    begin
      ExpectedRecord := EncodeDBParadoxRecord(Fields, Rows[RowIndex]);
      Found := False;
      for MemberIndex := 0 to High(ActualRows) do
        if CompareByte(ExpectedRecord[0], ActualRows[MemberIndex].Data[0],
          Length(ExpectedRecord)) = 0 then
          Found := True;
      CheckTrue(Found);
    end;
    for MemberIndex := Low(Members) to High(Members) do
      CheckTrue(FileExists(IncludeTrailingPathDelimiter(Directory) +
        'Synthetic' + Members[MemberIndex]));
    CheckEquals(5, LoadTestFileBytes(
      IncludeTrailingPathDelimiter(Directory) + 'Synthetic.X02')[4]);
    CheckEquals(4, LoadTestFileBytes(
      IncludeTrailingPathDelimiter(Directory) + 'Synthetic.Y02')[4]);
    BdeOutputDirectory := GetEnvironmentVariable(
      'DBPARADOX_CLASSIC_PUBLISHER_BDE_OUTPUT_DIR');
    if BdeOutputDirectory <> '' then
    begin
      if DirectoryExists(BdeOutputDirectory) then
        raise Exception.CreateFmt(
          'The requested classic BDE output directory already exists: "%s".',
          [BdeOutputDirectory]);
      if not ForceDirectories(BdeOutputDirectory) then
        raise Exception.CreateFmt(
          'Cannot create classic BDE output directory "%s".',
          [BdeOutputDirectory]);
      for MemberIndex := Low(TemplateNames) to High(TemplateNames) do
        WriteBytesFile(IncludeTrailingPathDelimiter(BdeOutputDirectory) +
          TemplateNames[MemberIndex], LoadTestFileBytes(
            IncludeTrailingPathDelimiter(Directory) + TemplateNames[MemberIndex]));
    end;
  finally
    Validator := nil;
    Builder := nil;
    RemoveDirectoryTree(Directory);
  end;
end;

initialization
  RegisterTest(TTestDBParadoxFamilyPublisher);

end.
