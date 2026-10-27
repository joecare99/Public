unit tst_DBParadoxFamilySnapshot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DBParadoxFamilySnapshot, DBParadoxFileReader,
  DBParadoxFamilyPublisher, DBParadoxRecordEncoder,
  DBParadoxTableFileBuilder, fpcunit, testregistry;

type
  TTestDBParadoxFamilySnapshot = class(TTestCase)
  private
    FDirectory: string;
    function CreatePrimaryFixture: string;
    procedure WriteBytes(const AFileName: string; const AData: TBytes);
  protected
    procedure TearDown; override;
  published
    procedure CapturesValidatedDefensivePrimaryFamilySnapshot;
    procedure RejectsIncompleteAndUnknownFamilyMembers;
    procedure DetectsChangedLiveFamilyMember;
    procedure DetectsFamilyMembershipChanges;
    procedure PublisherRejectsStaleSnapshotBeforeStaging;
  end;

implementation

type
  TSnapshotTestBuilder = class(TInterfacedObject,
    IDBParadoxFamilyStageBuilder)
  public
    BuildStarted: Boolean;
    procedure BeginBuild(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
    procedure BuildMember(const AStageDirectory, ATableBaseName,
      AMember: string);
    procedure EndBuild;
    procedure AbortBuild;
  end;

  TSnapshotTestValidator = class(TInterfacedObject,
    IDBParadoxFamilyValidator)
  public
    procedure Validate(const AStageDirectory, ATableBaseName: string;
      const AMembers: TDBParadoxFamilyMembers);
  end;

procedure TSnapshotTestBuilder.BeginBuild(const AStageDirectory,
  ATableBaseName: string; const AMembers: TDBParadoxFamilyMembers);
begin
  BuildStarted := True;
end;

procedure TSnapshotTestBuilder.BuildMember(const AStageDirectory,
  ATableBaseName, AMember: string);
begin
  BuildStarted := True;
end;

procedure TSnapshotTestBuilder.EndBuild;
begin
end;

procedure TSnapshotTestBuilder.AbortBuild;
begin
end;

procedure TSnapshotTestValidator.Validate(const AStageDirectory,
  ATableBaseName: string; const AMembers: TDBParadoxFamilyMembers);
begin
end;

procedure WriteUInt16LE(var AData: TBytes; AOffset: SizeInt; AValue: Word);
begin
  AData[AOffset] := Byte(AValue);
  AData[AOffset + 1] := Byte(AValue shr 8);
end;

procedure TTestDBParadoxFamilySnapshot.WriteBytes(const AFileName: string;
  const AData: TBytes);
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

function TTestDBParadoxFamilySnapshot.CreatePrimaryFixture: string;
var
  DatabaseTemplate, PrimaryTemplate: TBytes;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
  TableNameOffset, FieldNamesOffset: SizeInt;
begin
  if FDirectory = '' then
  begin
    FDirectory := IncludeTrailingPathDelimiter(GetTempDir(False)) +
      'DBParadoxSnapshot-' + IntToStr(GetTickCount64);
    if not CreateDir(FDirectory) then
      raise Exception.CreateFmt('Cannot create fixture directory "%s".',
        [FDirectory]);
  end;
  Result := IncludeTrailingPathDelimiter(FDirectory) + 'Fixture.DB';

  DatabaseTemplate := nil;
  SetLength(DatabaseTemplate, $800);
  WriteUInt16LE(DatabaseTemplate, 0, 8);
  WriteUInt16LE(DatabaseTemplate, 2, $800);
  DatabaseTemplate[4] := 0;
  DatabaseTemplate[5] := 2;
  WriteUInt16LE(DatabaseTemplate, $21, 2);
  WriteUInt16LE(DatabaseTemplate, $23, 1);
  DatabaseTemplate[$39] := $0C;
  DatabaseTemplate[$78] := $04;
  DatabaseTemplate[$79] := 4;
  DatabaseTemplate[$7A] := $01;
  DatabaseTemplate[$7B] := 4;
  TableNameOffset := $78 + 2 * 2 + 4 + 2 * 4;
  Move('Fixture'#0, DatabaseTemplate[TableNameOffset],
    Length('Fixture') + 1);
  FieldNamesOffset := TableNameOffset + 261;
  Move('ID'#0, DatabaseTemplate[FieldNamesOffset], Length('ID') + 1);
  Move('Tag'#0, DatabaseTemplate[FieldNamesOffset + Length('ID') + 1],
    Length('Tag') + 1);

  PrimaryTemplate := nil;
  SetLength(PrimaryTemplate, $800);
  WriteUInt16LE(PrimaryTemplate, 0, 10);
  WriteUInt16LE(PrimaryTemplate, 2, $800);
  PrimaryTemplate[4] := 1;
  PrimaryTemplate[5] := 2;
  WriteUInt16LE(PrimaryTemplate, $21, 1);
  PrimaryTemplate[$58] := $04;
  PrimaryTemplate[$59] := 4;

  SetLength(Fields, 2);
  Fields[0].Name := 'ID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  Fields[1].Name := 'Tag';
  Fields[1].TypeCode := $01;
  Fields[1].Length := 4;
  SetLength(Rows, 2);
  Rows[0] := ['1', 'A'];
  Rows[1] := ['2', 'B'];
  Built := BuildDBParadoxTableFiles(DatabaseTemplate, PrimaryTemplate,
    Fields, 0, Rows);
  WriteBytes(Result, Built.DatabaseFile);
  WriteBytes(ChangeFileExt(Result, '.PX'), Built.PrimaryIndexFile);
end;

procedure TTestDBParadoxFamilySnapshot.TearDown;
begin
  if FDirectory <> '' then
  begin
    DeleteFile(IncludeTrailingPathDelimiter(FDirectory) + 'Fixture.DB');
    DeleteFile(IncludeTrailingPathDelimiter(FDirectory) + 'Fixture.PX');
    DeleteFile(IncludeTrailingPathDelimiter(FDirectory) + 'Fixture.X01');
    DeleteFile(IncludeTrailingPathDelimiter(FDirectory) +
      'Fixture.DB.dbparadox.lock');
    RemoveDir(FDirectory);
    FDirectory := '';
  end;
  inherited TearDown;
end;

procedure TTestDBParadoxFamilySnapshot.
  CapturesValidatedDefensivePrimaryFamilySnapshot;
var
  FileName: string;
  Snapshot: TDBParadoxFamilySnapshot;
  Member: TDBParadoxSnapshotMember;
  Rows: TDBParadoxFileRows;
  CopiedRows: TDBParadoxFileRows;
  Fields: TDBParadoxFileFields;
  Template: TBytes;
begin
  FileName := CreatePrimaryFixture;
  Snapshot := TDBParadoxFamilySnapshot.Capture(FileName);
  try
    CheckEquals(2, Snapshot.MemberCount);
    CheckEquals(0, Snapshot.PrimaryKeyFieldIndex);
    CheckEquals(1, Snapshot.PrimaryKeyFieldCount);
    CheckEquals(8, Snapshot.RecordSize);
    CheckTrue(Snapshot.MatchesCurrentFiles);
    Fields := Snapshot.CopyFields;
    Rows := Snapshot.CopyRows;
    CheckEquals(2, Length(Fields));
    CheckEquals('ID', Fields[0].Name);
    CheckEquals(2, Length(Rows));
    CheckEquals(1, Rows[0].BlockNumber);
    Template := Snapshot.CopyDatabaseTemplate;
    CheckEquals($800, Length(Template));
    CheckEquals(0, Template[6]);
    Member := Snapshot.CopyMember(0);
    Member.Data[0] := Member.Data[0] xor $FF;
    Rows[0].Data[0] := Rows[0].Data[0] xor $FF;
    CheckTrue(Snapshot.MatchesCurrentFiles);
    CopiedRows := Snapshot.CopyRows;
    CheckEquals($80, CopiedRows[0].Data[0]);
  finally
    Snapshot.Free;
  end;
end;

procedure TTestDBParadoxFamilySnapshot.
  RejectsIncompleteAndUnknownFamilyMembers;
var
  FileName: string;
  Snapshot: TDBParadoxFamilySnapshot;
  Unexpected: TBytes;
begin
  FileName := CreatePrimaryFixture;
  DeleteFile(ChangeFileExt(FileName, '.PX'));
  try
    Snapshot := TDBParadoxFamilySnapshot.Capture(FileName);
    Snapshot.Free;
    Fail('Expected missing primary index to be rejected.');
  except
    on E: EDBParadoxFamilySnapshotError do ;
  end;
  WriteBytes(ChangeFileExt(FileName, '.PX'), [0]);
  Unexpected := [1, 2, 3];
  WriteBytes(ChangeFileExt(FileName, '.X01'), Unexpected);
  try
    Snapshot := TDBParadoxFamilySnapshot.Capture(FileName);
    Snapshot.Free;
    Fail('Expected unknown family member to be rejected.');
  except
    on E: EDBParadoxFamilySnapshotError do ;
  end;
end;

procedure TTestDBParadoxFamilySnapshot.DetectsChangedLiveFamilyMember;
var
  FileName: string;
  Snapshot: TDBParadoxFamilySnapshot;
  Changed: TBytes;
begin
  FileName := CreatePrimaryFixture;
  Snapshot := TDBParadoxFamilySnapshot.Capture(FileName);
  try
    Changed := [0, 1, 2];
    WriteBytes(FileName, Changed);
    CheckFalse(Snapshot.MatchesCurrentFiles);
  finally
    Snapshot.Free;
  end;
end;

procedure TTestDBParadoxFamilySnapshot.DetectsFamilyMembershipChanges;
var
  FileName: string;
  Snapshot: TDBParadoxFamilySnapshot;
begin
  FileName := CreatePrimaryFixture;
  Snapshot := TDBParadoxFamilySnapshot.Capture(FileName);
  try
    WriteBytes(ChangeFileExt(FileName, '.X01'), [1, 2, 3]);
    CheckFalse(Snapshot.MatchesCurrentFiles);
  finally
    Snapshot.Free;
  end;
end;

procedure TTestDBParadoxFamilySnapshot.
  PublisherRejectsStaleSnapshotBeforeStaging;
var
  FileName: string;
  Snapshot: TDBParadoxFamilySnapshot;
  ExpectedMembers: TDBParadoxExpectedFamilyMembers;
  BuilderObject: TSnapshotTestBuilder;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
begin
  FileName := CreatePrimaryFixture;
  Snapshot := TDBParadoxFamilySnapshot.Capture(FileName);
  try
    ExpectedMembers := Snapshot.CopyExpectedFamilyMembers;
    BuilderObject := TSnapshotTestBuilder.Create;
    Builder := BuilderObject;
    Validator := TSnapshotTestValidator.Create;
    WriteBytes(FileName, [1, 2, 3]);
    try
      TDBParadoxFamilyPublisher.Publish(FileName, Builder, Validator,
        ExpectedMembers);
      Fail('Expected stale transaction snapshot to block publication.');
    except
      on E: EDBParadoxPublicationError do ;
    end;
    CheckFalse(BuilderObject.BuildStarted);
  finally
    Validator := nil;
    Builder := nil;
    Snapshot.Free;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxFamilySnapshot);

end.
