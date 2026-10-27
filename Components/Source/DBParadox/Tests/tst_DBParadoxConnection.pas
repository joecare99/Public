unit tst_DBParadoxConnection;

{$mode objfpc}{$H+}

interface

uses
  DB, DBParadoxConnection, DBParadoxFileReader, fpcunit, SQLDB, SysUtils,
  testregistry;

type
  TTestDBParadoxConnection = class(TTestCase)
  private
    FFixtureDirectoryToCleanup: string;
    function ConfigureConnection(Connection: TDBParadoxConnection;
      Transaction: TSQLTransaction): Boolean;
    procedure AssertFourRows(DataSet: TDataSet);
    function BuildInternalReaderFixture(DeclaredRecords,
      PhysicalRecords: Word): TBytes;
    function BuildLongSemanticsFixture: TBytes;
    function BuildSQLQueryFixture: TBytes;
    function BuildUnsupportedFieldFixture: TBytes;
    function BuildNumberDateFixture: TBytes;
    function WriteDMLFixture: string;
    function WriteInternalReaderFixture(const Data: TBytes;
      const TableFileName: string = 'Synthetic.DB'): string;
  protected
    procedure TearDown; override;
  published
    procedure ConnectDoesNotRequirePxlibRuntime;
    procedure SQLDBTransactionExposesProviderHandle;
    procedure SQLDBTransactionRejectsRetaining;
    procedure SQLDBStagesDMLAndExposesChangesWithinTransaction;
    procedure SQLQueryReadsInternalFixtureWithoutPxlib;
    procedure SQLQueryRecoversPreparedFamilyBeforeReading;
    procedure SQLQueryReadsBDEAuthoredLiveFixtureWithoutPxlib;
    procedure SQLQueryReadsBDEDeletedFixtureWithoutResurrectingRow;
    procedure SQLQueryRejectsUnsupportedFieldType;
    procedure SQLQueryReadsSyntheticTable;
    procedure SQLQueryReadsBDELongValueEncodings;
    procedure SQLQueryReadsNumberAndDateFields;
    procedure SQLQueryReadsSecondaryIndexFixture;
    procedure SQLQueryRejectsDeletedSlotsUntilSupported;
    procedure SQLQueryProjectsFiltersAndOrders;
    procedure SQLQueryFiltersTextAndSupportsEmptyResults;
    procedure SQLQueryCombinesPredicatesWithAnd;
    procedure SQLQuerySortsStableTies;
    procedure SQLQueryRejectsMismatchedParameterType;
    procedure SQLQueryRejectsUnknownFieldAndCanReuseConnection;
    procedure SQLQueryRejectsTablePath;
  end;

implementation

uses
  Classes, DBParadoxFamilyJournal, DBParadoxFamilyLock,
  DBParadoxFamilyPublisher,
  DBParadoxRecordEncoder, DBParadoxTableFileBuilder;

type
  TDBParadoxTestPublicationFault = class(TInterfacedObject,
    IDBParadoxPublicationFaultInjector)
  private
    FFirstEvent: TDBParadoxPublicationEvent;
    FFirstMember: Integer;
    FSecondEvent: TDBParadoxPublicationEvent;
    FSecondMember: Integer;
    FHasSecondEvent: Boolean;
    FFirstRaised: Boolean;
    FSecondRaised: Boolean;
  public
    constructor Create(AFirstEvent: TDBParadoxPublicationEvent;
      AFirstMember: Integer);
    constructor Create(AFirstEvent: TDBParadoxPublicationEvent;
      AFirstMember: Integer; ASecondEvent: TDBParadoxPublicationEvent;
      ASecondMember: Integer);
    procedure Checkpoint(AEvent: TDBParadoxPublicationEvent;
      AMemberIndex: Integer);
  end;

  TDBParadoxTestConnection = class(TDBParadoxConnection)
  public
    FaultInjector: IDBParadoxPublicationFaultInjector;
  protected
    procedure PublishFamily(const ATableFileName: string;
      const ABuilder: IDBParadoxFamilyStageBuilder;
      const AValidator: IDBParadoxFamilyValidator;
      const AExpectedMembers: TDBParadoxExpectedFamilyMembers); override;
  end;

procedure WriteTestBytesFile(const AFileName: string; const AData: TBytes);
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

function ReadTestBytesFile(const AFileName: string): TBytes;
var
  Stream: TFileStream;
begin
  Result := nil;
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    SetLength(Result, Stream.Size);
    if Length(Result) > 0 then
      Stream.ReadBuffer(Result[0], Length(Result));
  finally
    Stream.Free;
  end;
end;

procedure CopyTestFile(const ASourceFileName, ADestinationFileName: string);
var
  Source, Destination: TFileStream;
begin
  Source := TFileStream.Create(ASourceFileName, fmOpenRead or fmShareDenyNone);
  try
    Destination := TFileStream.Create(ADestinationFileName, fmCreate);
    try
      Destination.CopyFrom(Source, 0);
    finally
      Destination.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure ExportPrimaryBDEOutput(const ATableFileName, AEnvironmentVariable,
  APurpose: string);
const
  Members: array[0..1] of string = ('.DB', '.PX');
var
  OutputDirectory: string;
  MemberIndex: Integer;
begin
  OutputDirectory := GetEnvironmentVariable(AEnvironmentVariable);
  if OutputDirectory = '' then
    Exit;
  if DirectoryExists(OutputDirectory) then
    raise Exception.CreateFmt(
      'The requested SQLDB %s BDE output directory already exists: "%s".',
      [APurpose, OutputDirectory]);
  if not ForceDirectories(OutputDirectory) then
    raise Exception.CreateFmt(
      'Cannot create SQLDB %s BDE output directory "%s".',
      [APurpose, OutputDirectory]);
  for MemberIndex := Low(Members) to High(Members) do
    CopyTestFile(ChangeFileExt(ATableFileName, Members[MemberIndex]),
      IncludeTrailingPathDelimiter(OutputDirectory) +
      'Writable' + Members[MemberIndex]);
end;

constructor TDBParadoxTestPublicationFault.Create(
  AFirstEvent: TDBParadoxPublicationEvent; AFirstMember: Integer);
begin
  inherited Create;
  FFirstEvent := AFirstEvent;
  FFirstMember := AFirstMember;
end;

constructor TDBParadoxTestPublicationFault.Create(
  AFirstEvent: TDBParadoxPublicationEvent; AFirstMember: Integer;
  ASecondEvent: TDBParadoxPublicationEvent; ASecondMember: Integer);
begin
  inherited Create;
  FFirstEvent := AFirstEvent;
  FFirstMember := AFirstMember;
  FSecondEvent := ASecondEvent;
  FSecondMember := ASecondMember;
  FHasSecondEvent := True;
end;

procedure TDBParadoxTestPublicationFault.Checkpoint(
  AEvent: TDBParadoxPublicationEvent; AMemberIndex: Integer);
begin
  if not FFirstRaised and (AEvent = FFirstEvent) and
    (AMemberIndex = FFirstMember) then
  begin
    FFirstRaised := True;
    raise Exception.Create('Injected DBParadox publication fault.');
  end;
  if FHasSecondEvent and FFirstRaised and not FSecondRaised and
    (AEvent = FSecondEvent) and (AMemberIndex = FSecondMember) then
  begin
    FSecondRaised := True;
    raise Exception.Create('Injected DBParadox compensation fault.');
  end;
end;

procedure TDBParadoxTestConnection.PublishFamily(
  const ATableFileName: string;
  const ABuilder: IDBParadoxFamilyStageBuilder;
  const AValidator: IDBParadoxFamilyValidator;
  const AExpectedMembers: TDBParadoxExpectedFamilyMembers);
begin
  TDBParadoxFamilyPublisher.Publish(ATableFileName, ABuilder, AValidator,
    AExpectedMembers, FaultInjector);
end;

procedure WriteTestTextFile(const AFileName, AValue: string);
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

function ReadTestTextFile(const AFileName: string): string;
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

procedure WriteUInt16LE(var Data: TBytes; Offset: SizeInt; Value: Word);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
end;

procedure WriteInt32LE(var Data: TBytes; Offset: SizeInt; Value: LongInt);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
  Data[Offset + 2] := Byte(Value shr 16);
  Data[Offset + 3] := Byte(Value shr 24);
end;

function TTestDBParadoxConnection.BuildInternalReaderFixture(DeclaredRecords,
  PhysicalRecords: Word): TBytes;
const
  HeaderSize = $800;
  BlockSize = $800;
  RecordSize = 28;
  FieldNamesOffset = $78 + 2 * 2 + 4 + 2 * 4 + 261;
var
  BlockOffset: SizeInt;
  RowIndex: Integer;
  RecordOffset: SizeInt;
begin
  Result := nil;
  SetLength(Result, HeaderSize + BlockSize);
  WriteUInt16LE(Result, 0, RecordSize);
  WriteUInt16LE(Result, 2, HeaderSize);
  Result[4] := 0;
  Result[5] := 2;
  WriteInt32LE(Result, 6, DeclaredRecords);
  WriteUInt16LE(Result, $0C, 1);
  WriteUInt16LE(Result, $0E, 1);
  WriteUInt16LE(Result, $10, 1);
  WriteUInt16LE(Result, $21, 2);
  Result[$39] := $0C;
  Result[$78] := $04;
  Result[$79] := 4;
  Result[$7A] := $01;
  Result[$7B] := 24;
  Move('ID'#0, Result[FieldNamesOffset], 3);
  Move('OptionalText'#0, Result[FieldNamesOffset + 3], 13);

  BlockOffset := HeaderSize;
  WriteUInt16LE(Result, BlockOffset, 0);
  WriteUInt16LE(Result, BlockOffset + 2, 0);
  WriteUInt16LE(Result, BlockOffset + 4,
    (PhysicalRecords - 1) * RecordSize);
  for RowIndex := 0 to PhysicalRecords - 1 do
  begin
    RecordOffset := BlockOffset + 6 + RowIndex * RecordSize;
    Result[RecordOffset] := $80;
    Result[RecordOffset + 3] := RowIndex + 1;
  end;
  Move('SyntheticLive', Result[BlockOffset + 6 + 4], Length('SyntheticLive'));
end;

function TTestDBParadoxConnection.WriteInternalReaderFixture(
  const Data: TBytes; const TableFileName: string): string;
var
  Stream: TFileStream;
begin
  Result := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'DBParadox-SQLDB-' + IntToStr(GetTickCount64);
  if not ForceDirectories(Result) then
    raise Exception.CreateFmt('Cannot create temporary fixture directory "%s".',
      [Result]);
  Result := IncludeTrailingPathDelimiter(Result) + TableFileName;
  Stream := TFileStream.Create(Result, fmCreate);
  try
    Stream.WriteBuffer(Data[0], Length(Data));
  finally
    Stream.Free;
  end;
end;

function TTestDBParadoxConnection.BuildSQLQueryFixture: TBytes;
const
  HeaderSize = $800;
  BlockSize = $800;
  RecordSize = 36;
  FieldNamesOffset = $78 + 2 * 2 + 4 + 2 * 4 + 261;
  Places: array[0..3] of string = (
    'SyntheticDuplicate',
    'SyntheticDuplicate',
    'SyntheticOther',
    'SyntheticOtherCase'
  );
var
  BlockOffset: SizeInt;
  RowIndex: Integer;
  RecordOffset: SizeInt;
begin
  Result := nil;
  SetLength(Result, HeaderSize + BlockSize);
  WriteUInt16LE(Result, 0, RecordSize);
  WriteUInt16LE(Result, 2, HeaderSize);
  Result[4] := 0;
  Result[5] := 2;
  WriteInt32LE(Result, 6, Length(Places));
  WriteUInt16LE(Result, $0C, 1);
  WriteUInt16LE(Result, $0E, 1);
  WriteUInt16LE(Result, $10, 1);
  WriteUInt16LE(Result, $21, 2);
  Result[$39] := $0C;
  Result[$78] := $04;
  Result[$79] := 4;
  Result[$7A] := $01;
  Result[$7B] := RecordSize - 4;
  Move('ID'#0, Result[FieldNamesOffset], 3);
  Move('Ort'#0, Result[FieldNamesOffset + 3], 4);

  BlockOffset := HeaderSize;
  WriteUInt16LE(Result, BlockOffset, 0);
  WriteUInt16LE(Result, BlockOffset + 2, 0);
  WriteUInt16LE(Result, BlockOffset + 4,
    (Length(Places) - 1) * RecordSize);
  for RowIndex := 0 to High(Places) do
  begin
    RecordOffset := BlockOffset + 6 + RowIndex * RecordSize;
    Result[RecordOffset] := $80;
    Result[RecordOffset + 3] := RowIndex + 1;
    Move(Places[RowIndex][1], Result[RecordOffset + 4],
      Length(Places[RowIndex]));
  end;
end;

function TTestDBParadoxConnection.BuildLongSemanticsFixture: TBytes;
const
  HeaderSize = $800;
  BlockSize = $800;
  RecordSize = 8;
  FieldNamesOffset = $78 + 2 * 2 + 4 + 2 * 4 + 261;
  Values: array[0..5, 0..3] of Byte = (
    (0, 0, 0, 0),
    ($80, 0, 0, 0),
    ($7F, $FF, $FF, $FF),
    (0, 0, 0, 1),
    ($FF, $FF, $FF, $FF),
    ($80, 0, 0, 1)
  );
var
  BlockOffset: SizeInt;
  RecordOffset: SizeInt;
  RowIndex, ByteIndex: Integer;
begin
  Result := nil;
  SetLength(Result, HeaderSize + BlockSize);
  WriteUInt16LE(Result, 0, RecordSize);
  WriteUInt16LE(Result, 2, HeaderSize);
  Result[4] := 0;
  Result[5] := 2;
  WriteInt32LE(Result, 6, Length(Values));
  WriteUInt16LE(Result, $0C, 1);
  WriteUInt16LE(Result, $0E, 1);
  WriteUInt16LE(Result, $10, 1);
  WriteUInt16LE(Result, $21, 2);
  Result[$39] := $0C;
  Result[$78] := $04;
  Result[$79] := 4;
  Result[$7A] := $04;
  Result[$7B] := 4;
  Move('ID'#0'Value'#0, Result[FieldNamesOffset], 10);

  BlockOffset := HeaderSize;
  WriteUInt16LE(Result, BlockOffset, 0);
  WriteUInt16LE(Result, BlockOffset + 2, 0);
  WriteUInt16LE(Result, BlockOffset + 4,
    (Length(Values) - 1) * RecordSize);
  for RowIndex := Low(Values) to High(Values) do
  begin
    RecordOffset := BlockOffset + 6 + RowIndex * RecordSize;
    Result[RecordOffset] := $80;
    Result[RecordOffset + 3] := RowIndex + 1;
    for ByteIndex := 0 to 3 do
      Result[RecordOffset + 4 + ByteIndex] := Values[RowIndex][ByteIndex];
  end;
end;

function TTestDBParadoxConnection.BuildUnsupportedFieldFixture: TBytes;
const
  HeaderSize = $800;
  BlockSize = $800;
  FieldNamesOffset = $78 + 2 + 4 + 4 + 261;
var
  BlockOffset: SizeInt;
begin
  Result := nil;
  SetLength(Result, HeaderSize + BlockSize);
  WriteUInt16LE(Result, 0, 2);
  WriteUInt16LE(Result, 2, HeaderSize);
  Result[4] := 0;
  Result[5] := 2;
  WriteInt32LE(Result, 6, 1);
  WriteUInt16LE(Result, $0C, 1);
  WriteUInt16LE(Result, $0E, 1);
  WriteUInt16LE(Result, $10, 1);
  WriteUInt16LE(Result, $21, 1);
  Result[$39] := $0C;
  Result[$78] := $03;
  Result[$79] := 2;
  Move('Value'#0, Result[FieldNamesOffset], 6);

  BlockOffset := HeaderSize;
  WriteUInt16LE(Result, BlockOffset, 0);
  WriteUInt16LE(Result, BlockOffset + 2, 0);
  WriteUInt16LE(Result, BlockOffset + 4, 0);
  Result[BlockOffset + 6] := $80;
  Result[BlockOffset + 7] := 1;
end;

function TTestDBParadoxConnection.BuildNumberDateFixture: TBytes;
const
  HeaderSize = $800;
  BlockSize = $800;
  RecordSize = 16;
  { Version 0x09: Datenkopf bei $78, Tabellenname-Laenge 79. }
  FieldNamesOffset = $78 + 3 * 2 + 4 + 3 * 4 + 79;
  { ID (Long), Number (Number/Double), Purchased (Date) je Zeile. }
  Rows: array[0..1, 0..15] of Byte = (
    ($80, 0, 0, 1, $C0, $20, 0, 0, 0, 0, 0, 0, $80, $0B, $1D, $7D),
    ($80, 0, 0, 2, $C0, $28, 0, 0, 0, 0, 0, 0, $80, $0B, $1E, $CC)
  );
var
  BlockOffset: SizeInt;
  RecordOffset: SizeInt;
  RowIndex, ByteIndex: Integer;
begin
  Result := nil;
  SetLength(Result, HeaderSize + BlockSize);
  WriteUInt16LE(Result, 0, RecordSize);
  WriteUInt16LE(Result, 2, HeaderSize);
  Result[4] := 0;
  Result[5] := 2;
  WriteInt32LE(Result, 6, Length(Rows));
  WriteUInt16LE(Result, $0C, 1);
  WriteUInt16LE(Result, $0E, 1);
  WriteUInt16LE(Result, $10, 1);
  WriteUInt16LE(Result, $21, 3);
  Result[$39] := $09;
  Result[$78] := $04;
  Result[$79] := 4;
  Result[$7A] := $06;
  Result[$7B] := 8;
  Result[$7C] := $02;
  Result[$7D] := 4;
  Move('ID'#0'Number'#0'Purchased'#0, Result[FieldNamesOffset], 20);

  BlockOffset := HeaderSize;
  WriteUInt16LE(Result, BlockOffset, 0);
  WriteUInt16LE(Result, BlockOffset + 2, 0);
  WriteUInt16LE(Result, BlockOffset + 4,
    (Length(Rows) - 1) * RecordSize);
  for RowIndex := 0 to High(Rows) do
  begin
    RecordOffset := BlockOffset + 6 + RowIndex * RecordSize;
    for ByteIndex := 0 to RecordSize - 1 do
      Result[RecordOffset + ByteIndex] := Rows[RowIndex][ByteIndex];
  end;
end;

function TTestDBParadoxConnection.WriteDMLFixture: string;
var
  Directory, FileName, BdeTemplateDirectory: string;
  DatabaseTemplate, PrimaryTemplate: TBytes;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
  TableNameOffset, FieldNamesOffset: SizeInt;
begin
  Directory := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'DBParadoxDML-' + IntToStr(GetTickCount64);
  if not CreateDir(Directory) then
    raise Exception.CreateFmt('Cannot create DML fixture directory "%s".',
      [Directory]);
  FFixtureDirectoryToCleanup := Directory;
  FileName := IncludeTrailingPathDelimiter(Directory) + 'Writable.DB';

  BdeTemplateDirectory := GetEnvironmentVariable(
    'DBPARADOX_SQLDB_PRIMARY_BDE_TEMPLATE_DIR');
  if BdeTemplateDirectory <> '' then
  begin
    DatabaseTemplate := ReadTestBytesFile(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + 'Writable.DB');
    PrimaryTemplate := ReadTestBytesFile(
      IncludeTrailingPathDelimiter(BdeTemplateDirectory) + 'Writable.PX');
  end
  else
  begin
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
    Move('Writable'#0, DatabaseTemplate[TableNameOffset],
      Length('Writable') + 1);
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
  end;

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
  WriteTestBytesFile(FileName, Built.DatabaseFile);
  WriteTestBytesFile(ChangeFileExt(FileName, '.PX'),
    Built.PrimaryIndexFile);
  Result := FileName;
end;

function TTestDBParadoxConnection.ConfigureConnection(
  Connection: TDBParadoxConnection; Transaction: TSQLTransaction): Boolean;
var
  FixtureDirectory: string;
  FixtureFileName: string;
begin
  FixtureDirectory := GetEnvironmentVariable('DBPARADOX_TEST_FIXTURE_DIR');
  if FixtureDirectory = '' then
  begin
    FixtureFileName := WriteInternalReaderFixture(
      BuildSQLQueryFixture, 'Table13.DB');
    FixtureDirectory := ExtractFileDir(FixtureFileName);
    FFixtureDirectoryToCleanup := FixtureDirectory;
  end;
  Connection.DatabaseName := FixtureDirectory;
  Connection.Transaction := Transaction;
  Transaction.Database := Connection;
  Result := True;
end;

procedure TTestDBParadoxConnection.TearDown;
begin
  if FFixtureDirectoryToCleanup <> '' then
  begin
    DeleteFile(IncludeTrailingPathDelimiter(FFixtureDirectoryToCleanup) +
      'Table13.DB');
    DeleteFile(IncludeTrailingPathDelimiter(FFixtureDirectoryToCleanup) +
      'Writable.DB');
    DeleteFile(IncludeTrailingPathDelimiter(FFixtureDirectoryToCleanup) +
      'Writable.PX');
    DeleteFile(IncludeTrailingPathDelimiter(FFixtureDirectoryToCleanup) +
      'Writable.DB.dbparadox.lock');
    DeleteFile(IncludeTrailingPathDelimiter(FFixtureDirectoryToCleanup) +
      'Table13.DB.dbparadox.lock');
    RemoveDir(FFixtureDirectoryToCleanup);
    FFixtureDirectoryToCleanup := '';
  end;
  inherited TearDown;
end;

procedure TTestDBParadoxConnection.AssertFourRows(DataSet: TDataSet);
const
  ExpectedIDs: array[0..3] of Integer = (1, 2, 3, 4);
  ExpectedPlaces: array[0..3] of string = (
    'SyntheticDuplicate',
    'SyntheticDuplicate',
    'SyntheticOther',
    'SyntheticOtherCase'
  );
var
  RowIndex: Integer;
begin
  CheckEquals(2, DataSet.FieldCount);
  CheckEquals('ID', DataSet.Fields[0].FieldName);
  CheckEquals('Ort', DataSet.Fields[1].FieldName);
  RowIndex := 0;
  while not DataSet.EOF do
  begin
    if RowIndex > High(ExpectedIDs) then
      Fail('The synthetic Paradox table returned too many rows.');
    CheckEquals(ExpectedIDs[RowIndex], DataSet.FieldByName('ID').AsInteger);
    CheckEquals(ExpectedPlaces[RowIndex],
      DataSet.FieldByName('Ort').AsString);
    Inc(RowIndex);
    DataSet.Next;
  end;
  CheckEquals(Length(ExpectedIDs), RowIndex);
end;

procedure TTestDBParadoxConnection.ConnectDoesNotRequirePxlibRuntime;
var
  Connection: TDBParadoxConnection;
begin
  Connection := TDBParadoxConnection.Create(nil);
  try
    Connection.DatabaseName := GetCurrentDir;
    Connection.Connected := True;
    CheckTrue(Connection.Connected);
    Connection.Connected := False;
    CheckFalse(Connection.Connected);
  finally
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLDBTransactionExposesProviderHandle;
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  try
    Connection.DatabaseName := GetCurrentDir;
    Connection.Connected := True;
    Transaction.Database := Connection;
    Transaction.StartTransaction;
    try
      CheckTrue(Transaction.Handle <> nil);
    finally
      Transaction.Rollback;
    end;
  finally
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLDBTransactionRejectsRetaining;
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  try
    Connection.DatabaseName := GetCurrentDir;
    Connection.Connected := True;
    Transaction.Database := Connection;
    Transaction.StartTransaction;
    try
      try
        Transaction.CommitRetaining;
        Fail('Expected DBParadox to reject commit-retaining.');
      except
        on E: EDBParadoxUnsupportedFeature do ;
      end;
      CheckTrue(Transaction.Active);

      try
        Transaction.RollbackRetaining;
        Fail('Expected DBParadox to reject rollback-retaining.');
      except
        on E: EDBParadoxUnsupportedFeature do ;
      end;
      CheckTrue(Transaction.Active);
    finally
      Transaction.Rollback;
    end;
  finally
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.
  SQLDBStagesDMLAndExposesChangesWithinTransaction;
var
  Connection: TDBParadoxTestConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  TableFileName: string;
  Fields: TDBParadoxFileFields;
  Rows: TDBParadoxFileRows;
  RecordSize: Integer;
  SeenRows: Integer;
  FamilyLock: TDBParadoxFamilyLock;
begin
  TableFileName := WriteDMLFixture;
  Connection := TDBParadoxTestConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := ExtractFileDir(TableFileName);
    Connection.Connected := True;
    Transaction.Database := Connection;
    Query.Database := Connection;
    Query.Transaction := Transaction;

    Query.SQL.Text := 'INSERT INTO Writable (ID, Tag) VALUES (:NewID, :NewTag)';
    Query.ParamByName('NewID').AsInteger := 3;
    Query.ParamByName('NewTag').AsString := 'C';
    try
      Query.ExecSQL;
      Fail('DML must reject SQLDB implicit transaction startup.');
    except
      on E: EDBParadoxProviderError do ;
    end;
    if Transaction.Active then
      Transaction.Rollback;

    Transaction.Options := [stoExplicitStart];
    Transaction.StartTransaction;

    Query.SQL.Text := 'INSERT INTO Writable (ID, Tag) VALUES (:NewID, :NewTag)';
    Query.ParamByName('NewID').AsInteger := 3;
    Query.ParamByName('NewTag').AsString := 'C';
    Query.ExecSQL;
    CheckEquals(1, Query.RowsAffected);

    Query.SQL.Text := 'UPDATE Writable SET Tag = :NewTag WHERE ID = :TargetID';
    Query.ParamByName('NewTag').AsString := 'BB';
    Query.ParamByName('TargetID').AsInteger := 2;
    Query.ExecSQL;
    CheckEquals(1, Query.RowsAffected);

    Query.SQL.Text := 'DELETE FROM Writable WHERE ID = :TargetID';
    Query.ParamByName('TargetID').AsInteger := 1;
    Query.ExecSQL;
    CheckEquals(1, Query.RowsAffected);

    Query.SQL.Text := 'SELECT ID, Tag FROM Writable ORDER BY ID';
    Query.Open;
    SeenRows := 0;
    while not Query.EOF do
    begin
      Inc(SeenRows);
      if SeenRows = 1 then
      begin
        CheckEquals(2, Query.FieldByName('ID').AsInteger);
        CheckEquals('BB', Query.FieldByName('Tag').AsString);
      end
      else if SeenRows = 2 then
      begin
        CheckEquals(3, Query.FieldByName('ID').AsInteger);
        CheckEquals('C', Query.FieldByName('Tag').AsString);
      end;
      Query.Next;
    end;
    CheckEquals(2, SeenRows);
    Query.Close;

    FamilyLock := TDBParadoxFamilyLock.Create(TableFileName);
    try
      try
        Transaction.Commit;
        Fail('Commit must fail while another writer holds the family lock.');
      except
        on E: EDBParadoxFamilyLockError do ;
      end;
      CheckTrue(Transaction.Active,
        'A publication lock failure must leave the SQLDB transaction active.');
    finally
      FamilyLock.Free;
    end;

    { Ein Familienmitglied laesst sich nicht ersetzen. Statt einer
      Windows-Dateisperre (die unter Unix wirkungslos ist) wird der Fehler
      portabel ueber die Fault-Injection mitten in der Publikation ausgeloest. }
    Connection.FaultInjector :=
      TDBParadoxTestPublicationFault.Create(dpeAfterReplacement, 0);
    try
      try
        Transaction.Commit;
        Fail('Commit must compensate when replacing a family member.');
      except
        on E: EDBParadoxPublicationError do ;
      end;
      CheckTrue(Transaction.Active,
        'A compensated publication failure must preserve the active transaction.');
      ReadDBParadoxTable(TableFileName, Fields, Rows, RecordSize);
      CheckEquals(2, Length(Rows),
        'The original database image must be restored after partial publication.');
    finally
      Connection.FaultInjector := nil;
    end;

    Transaction.Commit;
    CheckFalse(Transaction.Active);

    Connection.Connected := False;
    ExportPrimaryBDEOutput(TableFileName,
      'DBPARADOX_SQLDB_PRIMARY_BDE_OUTPUT_DIR', 'primary');
    Connection.Connected := True;

    Transaction.StartTransaction;
    Query.SQL.Text := 'SELECT ID, Tag FROM Writable ORDER BY ID';
    Query.Open;
    SeenRows := 0;
    while not Query.EOF do
    begin
      Inc(SeenRows);
      if SeenRows = 1 then
      begin
        CheckEquals(2, Query.FieldByName('ID').AsInteger);
        CheckEquals('BB', Query.FieldByName('Tag').AsString);
      end
      else if SeenRows = 2 then
      begin
        CheckEquals(3, Query.FieldByName('ID').AsInteger);
        CheckEquals('C', Query.FieldByName('Tag').AsString);
      end;
      Query.Next;
    end;
    CheckEquals(2, SeenRows);
    Query.Close;
    Transaction.Rollback;

    Transaction.StartTransaction;
    Query.SQL.Text := 'INSERT INTO Writable (ID, Tag) VALUES (:NewID, :NewTag)';
    Query.ParamByName('NewID').AsInteger := 4;
    Query.ParamByName('NewTag').AsString := 'D';
    Query.ExecSQL;
    Connection.FaultInjector :=
      TDBParadoxTestPublicationFault.Create(dpeBeforeCleanup, -1);
    try
      try
        Transaction.Commit;
        Fail('Expected SQLDB Commit to report post-publication cleanup failure.');
      except
        on E: EDBParadoxPublishedCleanupError do ;
      end;
    finally
      Connection.FaultInjector := nil;
    end;
    CheckTrue(Transaction.Active,
      'A published-cleanup error must retain the pending SQLDB outcome.');
    try
      Transaction.Rollback;
      Fail('Rollback must not misreport a published family as rolled back.');
    except
      on E: EDBParadoxProviderError do ;
    end;
    Transaction.Commit;
    CheckFalse(Transaction.Active,
      'A retry must recover and finalize the already-published family.');

    Connection.Connected := False;
    ExportPrimaryBDEOutput(TableFileName,
      'DBPARADOX_SQLDB_CLEANUP_BDE_OUTPUT_DIR', 'cleanup-recovery');
    Connection.Connected := True;
    Transaction.StartTransaction;
    Query.SQL.Text := 'UPDATE Writable SET Tag = :NewTag WHERE ID = :TargetID';
    Query.ParamByName('NewTag').AsString := 'X';
    Query.ParamByName('TargetID').AsInteger := 2;
    Query.ExecSQL;
    Connection.FaultInjector := TDBParadoxTestPublicationFault.Create(
      dpeAfterReplacement, 0, dpeBeforeCompensation, 0);
    try
      try
        Transaction.Commit;
        Fail('Expected SQLDB Commit to report an uncertain publication.');
      except
        on E: EDBParadoxUncertainPublicationError do ;
      end;
    finally
      Connection.FaultInjector := nil;
    end;
    CheckTrue(Transaction.Active,
      'An uncertain publication must not silently end the SQLDB transaction.');
    Query.SQL.Text := 'SELECT ID, Tag FROM Writable ORDER BY ID';
    try
      Query.Open;
      Fail('SELECT must remain blocked while publication is uncertain.');
    except
      on E: EDBParadoxProviderError do ;
    end;
    FamilyLock := TDBParadoxFamilyLock.Create(TableFileName);
    try
      try
        Transaction.Rollback;
        Fail('Recovery must not finish while another writer holds the family lock.');
      except
        on E: EDBParadoxFamilyLockError do ;
      end;
      CheckTrue(Transaction.Active,
        'A failed recovery must leave the uncertain transaction active.');
    finally
      FamilyLock.Free;
    end;
    Transaction.Rollback;
    CheckFalse(Transaction.Active,
      'Rollback may end an uncertain transaction only after journal recovery verifies the old family.');

    Connection.Connected := False;
    ExportPrimaryBDEOutput(TableFileName,
      'DBPARADOX_SQLDB_UNCERTAIN_BDE_OUTPUT_DIR', 'uncertain-recovery');
    Connection.Connected := True;
    Transaction.StartTransaction;
    Query.SQL.Text := 'SELECT ID, Tag FROM Writable ORDER BY ID';
    Query.Open;
    try
      CheckFalse(Query.EOF);
      CheckEquals(2, Query.FieldByName('ID').AsInteger);
      CheckEquals('BB', Query.FieldByName('Tag').AsString);
      Query.Next;
      CheckFalse(Query.EOF);
      CheckEquals(3, Query.FieldByName('ID').AsInteger);
      CheckEquals('C', Query.FieldByName('Tag').AsString);
      Query.Next;
      CheckFalse(Query.EOF);
      CheckEquals(4, Query.FieldByName('ID').AsInteger);
      CheckEquals('D', Query.FieldByName('Tag').AsString);
      Query.Next;
      CheckTrue(Query.EOF);
    finally
      Query.Close;
    end;
    Transaction.Rollback;

    Transaction.Options := [stoExplicitStart];
    Transaction.StartTransaction;
    Query.SQL.Text := 'INSERT INTO Writable (ID, Tag) VALUES (:NewID, :NewTag)';
    Query.ParamByName('NewID').AsInteger := 5;
    Query.ParamByName('NewTag').AsString := 'E';
    Query.ExecSQL;
    CheckEquals(1, Query.RowsAffected);
    Transaction.Rollback;

    ReadDBParadoxTable(TableFileName, Fields, Rows, RecordSize);
    CheckEquals(3, Length(Rows));
    CheckEquals(8, RecordSize);
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryReadsInternalFixtureWithoutPxlib;
var
  FixtureFileName: string;
  FixtureDirectory: string;
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
begin
  FixtureFileName := WriteInternalReaderFixture(
    BuildInternalReaderFixture(2, 2));
  FixtureDirectory := ExtractFileDir(FixtureFileName);
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := FixtureDirectory;
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text :=
      'SELECT ID, OptionalText FROM Synthetic.DB ORDER BY ID';
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckEquals(2, Query.FieldCount);
      CheckFalse(Query.EOF);
      CheckEquals(1, Query.FieldByName('ID').AsInteger);
      CheckEquals('SyntheticLive',
        Query.FieldByName('OptionalText').AsString);
      Query.Next;
      CheckFalse(Query.EOF);
      CheckEquals(2, Query.FieldByName('ID').AsInteger);
      CheckTrue(Query.FieldByName('OptionalText').IsNull);
      Query.Next;
      CheckTrue(Query.EOF);
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
    DeleteFile(FixtureFileName);
    DeleteFile(FixtureFileName + '.dbparadox.lock');
    RemoveDir(FixtureDirectory);
  end;
end;

procedure TTestDBParadoxConnection.
  SQLQueryRecoversPreparedFamilyBeforeReading;
var
  DatabaseData: TBytes;
  FixtureFileName, FixtureDirectory, StageDirectory, BeforeDirectory: string;
  Members: TDBParadoxFamilyMembers;
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
begin
  DatabaseData := BuildInternalReaderFixture(2, 2);
  FixtureFileName := WriteInternalReaderFixture(DatabaseData, 'Synthetic.DB');
  FixtureDirectory := ExtractFileDir(FixtureFileName);
  StageDirectory := IncludeTrailingPathDelimiter(FixtureDirectory) +
    '.dbparadox-stage-Synthetic-recovery';
  BeforeDirectory := IncludeTrailingPathDelimiter(StageDirectory) + '.before';
  SetLength(Members, 2);
  Members[0] := '.DB';
  Members[1] := '.PX';
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    CheckTrue(CreateDir(StageDirectory));
    CheckTrue(CreateDir(BeforeDirectory));
    WriteTestBytesFile(IncludeTrailingPathDelimiter(BeforeDirectory) +
      '0.snapshot', DatabaseData);
    WriteTestTextFile(IncludeTrailingPathDelimiter(BeforeDirectory) +
      '1.snapshot', 'old PX');
    WriteTestTextFile(IncludeTrailingPathDelimiter(StageDirectory) +
      'Synthetic.DB', 'new broken DB');
    WriteTestTextFile(IncludeTrailingPathDelimiter(StageDirectory) +
      'Synthetic.PX', 'new PX');
    WriteTestTextFile(ChangeFileExt(FixtureFileName, '.PX'), 'old PX');
    TDBParadoxFamilyJournal.Prepare(FixtureFileName, StageDirectory,
      'Synthetic', Members);
    WriteTestTextFile(FixtureFileName, 'new broken DB');
    WriteTestTextFile(ChangeFileExt(FixtureFileName, '.PX'), 'new PX');

    Connection.DatabaseName := FixtureDirectory;
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text := 'SELECT ID FROM Synthetic.DB ORDER BY ID';
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckFalse(Query.EOF);
      CheckEquals(1, Query.FieldByName('ID').AsInteger);
      Query.Next;
      CheckFalse(Query.EOF);
      CheckEquals(2, Query.FieldByName('ID').AsInteger);
      Query.Next;
      CheckTrue(Query.EOF);
    finally
      Query.Close;
    end;
    CheckEquals('old PX',
      ReadTestTextFile(ChangeFileExt(FixtureFileName, '.PX')));
    CheckFalse(DirectoryExists(StageDirectory));
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
    DeleteFile(FixtureFileName + '.dbparadox.lock');
    DeleteFile(ChangeFileExt(FixtureFileName, '.PX'));
    DeleteFile(FixtureFileName);
    RemoveDir(FixtureDirectory);
  end;
end;

procedure TTestDBParadoxConnection.
  SQLQueryReadsBDEAuthoredLiveFixtureWithoutPxlib;
var
  FixtureDirectory: string;
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
begin
  FixtureDirectory := GetEnvironmentVariable('DBPARADOX_BDE_GOLDEN_DIR');
  if FixtureDirectory = '' then
  begin
    Ignore(
      'Set DBPARADOX_BDE_GOLDEN_DIR to run the BDE-authored reader comparison.');
    Exit;
  end;

  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := FixtureDirectory;
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text :=
      'SELECT ID, OptionalText FROM Synthetic.DB ORDER BY ID';
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckEquals(2, Query.FieldCount);
      CheckFalse(Query.EOF);
      CheckEquals(1, Query.FieldByName('ID').AsInteger);
      CheckEquals('SyntheticLive',
        Query.FieldByName('OptionalText').AsString);
      Query.Next;
      CheckFalse(Query.EOF);
      CheckEquals(2, Query.FieldByName('ID').AsInteger);
      CheckTrue(Query.FieldByName('OptionalText').IsNull);
      Query.Next;
      CheckTrue(Query.EOF);
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.
  SQLQueryReadsBDEDeletedFixtureWithoutResurrectingRow;
var
  FixtureDirectory: string;
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
begin
  FixtureDirectory := GetEnvironmentVariable('DBPARADOX_BDE_DELETED_DIR');
  if FixtureDirectory = '' then
  begin
    Ignore(
      'Set DBPARADOX_BDE_DELETED_DIR to run the BDE deleted-row comparison.');
    Exit;
  end;

  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := FixtureDirectory;
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text :=
      'SELECT ID, OptionalText FROM Synthetic.DB ORDER BY ID';
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckFalse(Query.EOF);
      CheckEquals(1, Query.FieldByName('ID').AsInteger);
      CheckEquals('SyntheticLive',
        Query.FieldByName('OptionalText').AsString);
      Query.Next;
      CheckFalse(Query.EOF);
      CheckEquals(2, Query.FieldByName('ID').AsInteger);
      CheckTrue(Query.FieldByName('OptionalText').IsNull);
      Query.Next;
      CheckFalse(Query.EOF);
      CheckEquals(4, Query.FieldByName('ID').AsInteger);
      CheckEquals('SyntheticAfterDelete',
        Query.FieldByName('OptionalText').AsString);
      Query.Next;
      CheckTrue(Query.EOF,
        'The BDE-deleted record must not be resurrected by the reader.');
    finally
      Query.Close;
    end;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryRejectsUnsupportedFieldType;
var
  FixtureFileName: string;
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  Rejected: Boolean;
begin
  FixtureFileName := WriteInternalReaderFixture(
    BuildUnsupportedFieldFixture, 'Unsupported.DB');
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := ExtractFileDir(FixtureFileName);
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text := 'SELECT Value FROM Unsupported.DB';
    Query.ReadOnly := True;
    Rejected := False;
    try
      Query.Open;
    except
      on E: EDBParadoxUnsupportedFeature do
        Rejected := True;
    end;
    CheckTrue(Rejected,
      'Unsupported field types must be rejected explicitly.');
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
    DeleteFile(FixtureFileName);
    DeleteFile(FixtureFileName + '.dbparadox.lock');
    RemoveDir(ExtractFileDir(FixtureFileName));
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryReadsSyntheticTable;
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text := 'SELECT * FROM Table13.DB;';
    Query.ReadOnly := True;
    Query.Open;
    try
      AssertFourRows(Query);
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryReadsBDELongValueEncodings;
var
  FixtureFileName, FixtureDirectory: string;
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
begin
  FixtureFileName := WriteInternalReaderFixture(
    BuildLongSemanticsFixture, 'LongValues.DB');
  FixtureDirectory := ExtractFileDir(FixtureFileName);
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := FixtureDirectory;
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text :=
      'SELECT ID, Value FROM LongValues.DB ORDER BY ID';
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckFalse(Query.EOF);
      CheckEquals(1, Query.FieldByName('ID').AsInteger);
      CheckTrue(Query.FieldByName('Value').IsNull);
      Query.Next;
      CheckFalse(Query.EOF);
      CheckEquals(2, Query.FieldByName('ID').AsInteger);
      CheckFalse(Query.FieldByName('Value').IsNull);
      CheckEquals(0, Query.FieldByName('Value').AsInteger);
      Query.Next;
      CheckEquals(-1, Query.FieldByName('Value').AsInteger);
      Query.Next;
      CheckEquals(-2147483647, Query.FieldByName('Value').AsInteger);
      Query.Next;
      CheckEquals(High(LongInt), Query.FieldByName('Value').AsInteger);
      Query.Next;
      CheckEquals(1, Query.FieldByName('Value').AsInteger);
      Query.Next;
      CheckTrue(Query.EOF);
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
    DeleteFile(FixtureFileName);
    DeleteFile(FixtureFileName + '.dbparadox.lock');
    RemoveDir(FixtureDirectory);
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryReadsNumberAndDateFields;
var
  FixtureFileName: string;
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
begin
  { Version 0x09 mit Feldtyp 6 (Number) und 2 (Date). }
  FixtureFileName := WriteInternalReaderFixture(
    BuildNumberDateFixture, 'NumberDate.DB');
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := ExtractFileDir(FixtureFileName);
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text :=
      'SELECT ID, Number, Purchased FROM NumberDate.DB ORDER BY ID';
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckFalse(Query.EOF);
      CheckEquals(1, Query.FieldByName('ID').AsInteger);
      CheckEquals(8.0, Query.FieldByName('Number').AsFloat, 0.0001);
      CheckEquals(34851, Trunc(Query.FieldByName('Purchased').AsDateTime));
      Query.Next;
      CheckFalse(Query.EOF);
      CheckEquals(2, Query.FieldByName('ID').AsInteger);
      CheckEquals(12.0, Query.FieldByName('Number').AsFloat, 0.0001);
      CheckEquals(35186, Trunc(Query.FieldByName('Purchased').AsDateTime));
      Query.Next;
      CheckTrue(Query.EOF);
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
    DeleteFile(FixtureFileName);
    DeleteFile(FixtureFileName + '.dbparadox.lock');
    RemoveDir(ExtractFileDir(FixtureFileName));
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryReadsSecondaryIndexFixture;
const
  ExpectedIDs: array[0..4] of Integer = (1, 2, 3, 4, 5);
  ExpectedGroups: array[0..4] of string =
    ('Alpha', 'Alpha', 'Alpha', 'alpha', 'Beta');
  ExpectedSuffixes: array[0..4] of string = ('B', 'A', 'A', 'A', 'A');
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  FixtureDirectory: string;
  RowIndex: Integer;
begin
  FixtureDirectory := GetEnvironmentVariable(
    'DBPARADOX_SECONDARY_INDEX_FIXTURE_DIR');
  if FixtureDirectory = '' then
  begin
    Ignore(
      'Set DBPARADOX_SECONDARY_INDEX_FIXTURE_DIR to run the secondary-index fixture test.');
    Exit;
  end;

  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := FixtureDirectory;
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text :=
      'SELECT ID, GroupKey, Suffix FROM Synthetic.DB ORDER BY ID';
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckEquals(3, Query.FieldCount);
      RowIndex := 0;
      while not Query.EOF do
      begin
        CheckTrue(RowIndex < Length(ExpectedIDs),
          'The Pascal secondary-index fixture returned too many rows.');
        CheckEquals(ExpectedIDs[RowIndex],
          Query.FieldByName('ID').AsInteger);
        CheckEquals(ExpectedGroups[RowIndex],
          Query.FieldByName('GroupKey').AsString);
        CheckEquals(ExpectedSuffixes[RowIndex],
          Query.FieldByName('Suffix').AsString);
        Inc(RowIndex);
        Query.Next;
      end;
      CheckEquals(Length(ExpectedIDs), RowIndex);
    finally
      Query.Close;
    end;

    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryRejectsDeletedSlotsUntilSupported;
var
  FixtureFileName: string;
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  Rejected: Boolean;
begin
  FixtureFileName := WriteInternalReaderFixture(
    BuildInternalReaderFixture(2, 3));

  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := ExtractFileDir(FixtureFileName);
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;

    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text := 'SELECT ID FROM Synthetic.DB';
    Query.ReadOnly := True;
    Rejected := False;
    try
      Query.Open;
    except
      on E: EDBParadoxFileReadError do
        Rejected := True;
    end;
    CheckTrue(Rejected,
      'The provider must reject a table with undeclared physical record slots.');
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
    DeleteFile(FixtureFileName);
    DeleteFile(FixtureFileName + '.dbparadox.lock');
    RemoveDir(ExtractFileDir(FixtureFileName));
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryProjectsFiltersAndOrders;
const
  ExpectedIDs: array[0..2] of Integer = (4, 3, 2);
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  RowIndex: Integer;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text :=
      'SELECT ID FROM Table13.DB WHERE ID >= :minimum ORDER BY ID DESC';
    Query.Params.ParamByName('minimum').AsInteger := 2;
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckEquals(1, Query.FieldCount);
      CheckEquals('ID', Query.Fields[0].FieldName);
      RowIndex := 0;
      while not Query.EOF do
      begin
        CheckTrue(RowIndex < Length(ExpectedIDs),
          'The ordered query returned too many rows.');
        CheckEquals(ExpectedIDs[RowIndex], Query.FieldByName('ID').AsInteger);
        Inc(RowIndex);
        Query.Next;
      end;
      CheckEquals(Length(ExpectedIDs), RowIndex);
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.
  SQLQueryFiltersTextAndSupportsEmptyResults;
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  RowIndex: Integer;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text := 'SELECT ID FROM Table13.DB WHERE Ort = :place';
    Query.Params.ParamByName('place').AsString := 'SyntheticDuplicate';
    Query.ReadOnly := True;
    Query.Open;
    try
      RowIndex := 0;
      while not Query.EOF do
      begin
        CheckTrue(RowIndex < 2, 'The text filter returned too many rows.');
        CheckEquals(RowIndex + 1, Query.FieldByName('ID').AsInteger);
        Inc(RowIndex);
        Query.Next;
      end;
      CheckEquals(2, RowIndex);
    finally
      Query.Close;
    end;

    Query.Params.ParamByName('place').AsString := 'SyntheticMissing';
    Query.Open;
    try
      CheckTrue(Query.EOF, 'A nonmatching filter must return no rows.');
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryCombinesPredicatesWithAnd;
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  RowIndex: Integer;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text :=
      'SELECT ID FROM Table13.DB WHERE ID >= :first AND ID <= :last';
    Query.Params.ParamByName('first').AsInteger := 2;
    Query.Params.ParamByName('last').AsInteger := 3;
    Query.ReadOnly := True;
    Query.Open;
    try
      RowIndex := 0;
      while not Query.EOF do
      begin
        CheckTrue(RowIndex < 2, 'The AND filter returned too many rows.');
        CheckEquals(RowIndex + 2, Query.FieldByName('ID').AsInteger);
        Inc(RowIndex);
        Query.Next;
      end;
      CheckEquals(2, RowIndex);
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLQuerySortsStableTies;
const
  ExpectedIDs: array[0..3] of Integer = (1, 2, 3, 4);
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  RowIndex: Integer;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text := 'SELECT ID FROM Table13.DB ORDER BY Ort ASC';
    Query.ReadOnly := True;
    Query.Open;
    try
      RowIndex := 0;
      while not Query.EOF do
      begin
        CheckTrue(RowIndex < Length(ExpectedIDs),
          'The ordered query returned too many rows.');
        CheckEquals(ExpectedIDs[RowIndex], Query.FieldByName('ID').AsInteger);
        Inc(RowIndex);
        Query.Next;
      end;
      CheckEquals(Length(ExpectedIDs), RowIndex);
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryRejectsMismatchedParameterType;
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  RaisedExpectedError: Boolean;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text := 'SELECT ID FROM Table13.DB WHERE ID = :id';
    Query.Params.ParamByName('id').AsString := '1';
    Query.ReadOnly := True;
    RaisedExpectedError := False;
    try
      Query.Open;
    except
      on E: EDBParadoxProviderError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError,
      'A string parameter must not be silently coerced to an integer.');
    if Transaction.Active then
      Transaction.Rollback;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.
  SQLQueryRejectsUnknownFieldAndCanReuseConnection;
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  RaisedExpectedError: Boolean;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text := 'SELECT MissingField FROM Table13.DB';
    Query.ReadOnly := True;
    RaisedExpectedError := False;
    try
      Query.Open;
    except
      on E: EDBParadoxProviderError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError, 'An unknown field must fail explicitly.');

    if Transaction.Active then
      Transaction.Rollback;
    Connection.Connected := False;
    Connection.Connected := True;
    Query.SQL.Text := 'SELECT ID FROM Table13.DB';
    Query.Open;
    try
      CheckEquals(1, Query.FieldByName('ID').AsInteger);
    finally
      Query.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.SQLQueryRejectsTablePath;
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  RaisedExpectedError: Boolean;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Query := TSQLQuery.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Query.SQLConnection := Connection;
    Query.SQLTransaction := Transaction;
    Query.SQL.Text := 'SELECT * FROM ..\Table13.DB';
    Query.ReadOnly := True;
    RaisedExpectedError := False;
    try
      Query.Open;
    except
      on E: EDatabaseError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError,
      'A table path must be rejected instead of resolved outside DatabaseName.');
    if Transaction.Active then
      Transaction.Rollback;
    Connection.Connected := False;
  finally
    Query.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxConnection);

end.
