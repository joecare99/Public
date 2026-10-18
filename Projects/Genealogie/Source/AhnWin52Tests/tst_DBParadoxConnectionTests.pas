unit tst_DBParadoxConnectionTests;

{$mode objfpc}{$H+}

interface

uses
  Classes, DB, fpcunit, testregistry;

type
  TTestDBParadoxConnection = class(TTestCase)
  private
    function ConfigureConnection(Connection: TComponent;
      Transaction: TComponent): Boolean;
    procedure AssertFourRows(DataSet: TDataSet);
  published
    procedure ConnectRequiresRuntimeConfiguration;
    procedure TSQLQueryReadsSyntheticTable;
    procedure TSQLTableReadsSyntheticTable;
    procedure TSQLTableIndexGeneratesOrderedRead;
    procedure TSQLQueryProjectsSelectedFields;
    procedure TSQLQueryFiltersAllSupportedComparisons;
    procedure TSQLQueryFiltersAsciiTextAndSupportsEmptyResult;
    procedure TSQLQueryCombinesPredicatesWithAnd;
    procedure TSQLQuerySortsAscendingDescendingAndStableTies;
    procedure TSQLQueryRejectsMismatchedParameterTypes;
    procedure TSQLQueryRejectsUnknownFieldAndReleasesCursor;
    procedure TSQLQueryRejectsTablePath;
  end;

implementation

uses
  SysUtils, SQLDB, DBParadoxConnection, cmp_SQLTable;

function TTestDBParadoxConnection.ConfigureConnection(
  Connection: TComponent; Transaction: TComponent): Boolean;
var
  FixtureDirectory: string;
  LibraryName: string;
begin
  FixtureDirectory := GetEnvironmentVariable('DBPARADOX_TEST_FIXTURE_DIR');
  LibraryName := GetEnvironmentVariable('DBPARADOX_TEST_PXLIB');
  if (FixtureDirectory = '') or (LibraryName = '') then
  begin
    Ignore(
      'Set DBPARADOX_TEST_FIXTURE_DIR and DBPARADOX_TEST_PXLIB to run pxlib integration tests.');
    Exit(False);
  end;
  if not (Connection is TDBParadoxConnection) or
    not (Transaction is TSQLTransaction) then
    Fail('Invalid synthetic provider test setup.');

  TDBParadoxConnection(Connection).DatabaseName := FixtureDirectory;
  TDBParadoxConnection(Connection).PxlibLibraryName := LibraryName;
  TDBParadoxConnection(Connection).Transaction :=
    TSQLTransaction(Transaction);
  TSQLTransaction(Transaction).Database := TDBParadoxConnection(Connection);
  Result := True;
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

procedure TTestDBParadoxConnection.ConnectRequiresRuntimeConfiguration;
var
  Connection: TDBParadoxConnection;
  RaisedExpectedError: Boolean;
begin
  Connection := TDBParadoxConnection.Create(nil);
  try
    Connection.DatabaseName := GetCurrentDir;
    RaisedExpectedError := False;
    try
      Connection.Connected := True;
    except
      on E: EDatabaseError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError,
      'A connection without a configured pxlib runtime must fail explicitly.');
    CheckFalse(Connection.Connected);
  finally
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.TSQLQueryReadsSyntheticTable;
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

procedure TTestDBParadoxConnection.TSQLTableReadsSyntheticTable;
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Table: TSQLTable;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Table := TSQLTable.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Table.Database := Connection;
    Table.Transaction := Transaction;
    Table.TableName := 'Table13.DB';
    Table.ReadOnly := True;
    Table.Open;
    try
      AssertFourRows(Table);
    finally
      Table.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Table.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.TSQLTableIndexGeneratesOrderedRead;
const
  ExpectedIDs: array[0..3] of Integer = (4, 3, 2, 1);
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Table: TSQLTable;
  RowIndex: Integer;
begin
  Connection := TDBParadoxConnection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  Table := TSQLTable.Create(nil);
  try
    if not ConfigureConnection(Connection, Transaction) then
      Exit;
    Table.Database := Connection;
    Table.Transaction := Transaction;
    Table.TableName := 'Table13.DB';
    Table.Indexes.Add('PlaceDescending', 'Ort;ID', 'Ort;ID');
    Table.IndexName := 'PlaceDescending';
    Table.ReadOnly := True;
    Table.Open;
    try
      RowIndex := 0;
      while not Table.EOF do
      begin
        CheckEquals(ExpectedIDs[RowIndex],
          Table.FieldByName('ID').AsInteger);
        Inc(RowIndex);
        Table.Next;
      end;
      CheckEquals(Length(ExpectedIDs), RowIndex);
    finally
      Table.Close;
    end;
    if Transaction.Active then
      Transaction.Commit;
    Connection.Connected := False;
  finally
    Table.Free;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestDBParadoxConnection.TSQLQueryProjectsSelectedFields;
const
  ExpectedPlaces: array[0..3] of string = (
    'SyntheticDuplicate',
    'SyntheticDuplicate',
    'SyntheticOther',
    'SyntheticOtherCase'
  );
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
    Query.SQL.Text := 'SELECT Ort FROM Table13.DB';
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckEquals(1, Query.FieldCount);
      CheckEquals('Ort', Query.Fields[0].FieldName);
      RowIndex := 0;
      while not Query.EOF do
      begin
        CheckEquals(ExpectedPlaces[RowIndex],
          Query.FieldByName('Ort').AsString);
        Inc(RowIndex);
        Query.Next;
      end;
      CheckEquals(4, RowIndex);
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

procedure TTestDBParadoxConnection.TSQLQueryFiltersAllSupportedComparisons;
const
  SQLStatements: array[0..5] of string = (
    'SELECT ID FROM Table13.DB WHERE ID = :id',
    'SELECT ID FROM Table13.DB WHERE ID <> :id',
    'SELECT ID FROM Table13.DB WHERE ID < :id',
    'SELECT ID FROM Table13.DB WHERE ID <= :id',
    'SELECT ID FROM Table13.DB WHERE ID > :id',
    'SELECT ID FROM Table13.DB WHERE ID >= :id'
  );
  ParameterValues: array[0..5] of Integer = (2, 2, 3, 3, 2, 3);
  ExpectedIDs: array[0..5, 0..3] of Integer = (
    (2, 0, 0, 0),
    (1, 3, 4, 0),
    (1, 2, 0, 0),
    (1, 2, 3, 0),
    (3, 4, 0, 0),
    (3, 4, 0, 0)
  );
  ExpectedCounts: array[0..5] of Integer = (1, 3, 2, 3, 2, 2);
var
  Connection: TDBParadoxConnection;
  Transaction: TSQLTransaction;
  Query: TSQLQuery;
  CaseIndex: Integer;
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
    Query.ReadOnly := True;
    for CaseIndex := Low(SQLStatements) to High(SQLStatements) do
    begin
      Query.SQL.Text := SQLStatements[CaseIndex];
      Query.Params.ParamByName('id').AsInteger := ParameterValues[CaseIndex];
      Query.Open;
      try
        CheckEquals(1, Query.FieldCount);
        CheckEquals('ID', Query.Fields[0].FieldName);
        RowIndex := 0;
        while not Query.EOF do
        begin
          CheckTrue(RowIndex < ExpectedCounts[CaseIndex],
            'The filtered query returned too many rows.');
          CheckEquals(ExpectedIDs[CaseIndex][RowIndex],
            Query.FieldByName('ID').AsInteger);
          Inc(RowIndex);
          Query.Next;
        end;
        CheckEquals(ExpectedCounts[CaseIndex], RowIndex);
      finally
        Query.Close;
      end;
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

procedure TTestDBParadoxConnection.TSQLQueryCombinesPredicatesWithAnd;
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

procedure TTestDBParadoxConnection.TSQLQueryFiltersAsciiTextAndSupportsEmptyResult;
const
  ExpectedIDs: array[0..1] of Integer = (1, 2);
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
        CheckTrue(RowIndex < Length(ExpectedIDs),
          'The text predicate returned too many rows.');
        CheckEquals(ExpectedIDs[RowIndex],
          Query.FieldByName('ID').AsInteger);
        Inc(RowIndex);
        Query.Next;
      end;
      CheckEquals(Length(ExpectedIDs), RowIndex);
    finally
      Query.Close;
    end;

    Query.Params.ParamByName('place').AsString := 'NoSuchSyntheticPlace';
    Query.Open;
    try
      CheckTrue(Query.EOF,
        'A nonmatching predicate must produce an empty result.');
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

procedure TTestDBParadoxConnection.TSQLQuerySortsAscendingDescendingAndStableTies;
const
  ExpectedDescendingIDs: array[0..3] of Integer = (4, 3, 1, 2);
  ExpectedStableIDs: array[0..3] of Integer = (1, 2, 3, 4);
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
    Query.SQL.Text := 'SELECT ID, Ort FROM Table13.DB ORDER BY Ort DESC, ID ASC';
    Query.ReadOnly := True;
    Query.Open;
    try
      CheckEquals(2, Query.FieldCount);
      RowIndex := 0;
      while not Query.EOF do
      begin
        CheckEquals(ExpectedDescendingIDs[RowIndex],
          Query.FieldByName('ID').AsInteger);
        Inc(RowIndex);
        Query.Next;
      end;
      CheckEquals(Length(ExpectedDescendingIDs), RowIndex);
    finally
      Query.Close;
    end;

    Query.SQL.Text := 'SELECT ID FROM Table13.DB ORDER BY Ort ASC';
    Query.Open;
    try
      RowIndex := 0;
      while not Query.EOF do
      begin
        CheckEquals(ExpectedStableIDs[RowIndex],
          Query.FieldByName('ID').AsInteger);
        Inc(RowIndex);
        Query.Next;
      end;
      CheckEquals(Length(ExpectedStableIDs), RowIndex);
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

procedure TTestDBParadoxConnection.TSQLQueryRejectsMismatchedParameterTypes;
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

procedure TTestDBParadoxConnection.TSQLQueryRejectsUnknownFieldAndReleasesCursor;
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
    CheckTrue(RaisedExpectedError,
      'An unknown field must fail explicitly.');

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

procedure TTestDBParadoxConnection.TSQLQueryRejectsTablePath;
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
