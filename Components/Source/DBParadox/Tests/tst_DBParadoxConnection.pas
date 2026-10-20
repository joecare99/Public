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
    function WriteInternalReaderFixture(const Data: TBytes;
      const TableFileName: string = 'Synthetic.DB'): string;
  protected
    procedure TearDown; override;
  published
    procedure ConnectDoesNotRequirePxlibRuntime;
    procedure SQLQueryReadsInternalFixtureWithoutPxlib;
    procedure SQLQueryRecoversPreparedFamilyBeforeReading;
    procedure SQLQueryReadsBDEAuthoredLiveFixtureWithoutPxlib;
    procedure SQLQueryReadsBDEDeletedFixtureWithoutResurrectingRow;
    procedure SQLQueryRejectsUnsupportedFieldType;
    procedure SQLQueryReadsSyntheticTable;
    procedure SQLQueryReadsBDELongValueEncodings;
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
  Classes, DBParadoxFamilyJournal, DBParadoxFamilyPublisher;

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
