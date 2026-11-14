unit tst_AHW52_MarriagePairDataModuleAdapterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, GenealogyDataModule, GenealogyDataModuleAccess,
  MarriagePairTransactionContract, SQLite3Conn, SQLDB;

type
  TTestAHW52MarriagePairDataModuleAdapter = class(TTestCase)
  private
    FConnection: TSQLite3Connection;
    FDataModule: TGenealogyDataModule;
    FDataModuleInterface: IGenealogyDataModule;
    FPairTransaction: IMarriagePairTransaction;
    FSetupQuery: TSQLQuery;
    FTransaction: TSQLTransaction;
    function CountPersistedRows: Integer;
    procedure CreateTableSchema;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCommitsTwoReciprocalRowsWithAllDetails;
    procedure TestSecondInsertFailureRollsBackFirstRow;
    procedure TestRejectsNonBrowseTableState;
    procedure TestRejectsInactiveTable;
    procedure TestRejectsMissingRequiredField;
  end;

implementation

uses
  Cmp_SQLTable, DB, Forms, MarriagePairDataModuleAdapter, SysUtils, Variants;

function CreateTestDetails: TMarriageDetails;
begin
  Result.Htag := '01';
  Result.Hmonat := '02';
  Result.Hjahr := '1900';
  Result.Hort := 'Hochzeitsort';
  Result.Trauz := 'Kirche';
  Result.Satag := '03';
  Result.Samonat := '04';
  Result.Sajahr := '1901';
  Result.Saort := 'Standesamt';
  Result.Satrauz := 'Register';
  Result.Verbind := 'Eheschliessung';
  Result.Schtag := '05';
  Result.Schmonat := '06';
  Result.Schjahr := '1902';
  Result.Schort := 'Scheidungsort';
  Result.Hqu := 'Hochzeitsquelle';
  Result.Saqu := 'Standesamtquelle';
  Result.Schqu := 'Scheidungsquelle';
end;

procedure AssertRecordDetails(const DataSet: TDataSet;
  const Details: TMarriageDetails; const TestCase: TTestCase);
begin
  TestCase.AssertEquals(Details.Htag, DataSet.FieldByName('Htag').AsString);
  TestCase.AssertEquals(Details.Hmonat,
    DataSet.FieldByName('Hmonat').AsString);
  TestCase.AssertEquals(Details.Hjahr, DataSet.FieldByName('Hjahr').AsString);
  TestCase.AssertEquals(Details.Hort, DataSet.FieldByName('Hort').AsString);
  TestCase.AssertEquals(Details.Trauz, DataSet.FieldByName('Trauz').AsString);
  TestCase.AssertEquals(Details.Satag, DataSet.FieldByName('Satag').AsString);
  TestCase.AssertEquals(Details.Samonat,
    DataSet.FieldByName('Samonat').AsString);
  TestCase.AssertEquals(Details.Sajahr, DataSet.FieldByName('Sajahr').AsString);
  TestCase.AssertEquals(Details.Saort, DataSet.FieldByName('Saort').AsString);
  TestCase.AssertEquals(Details.Satrauz,
    DataSet.FieldByName('Satrauz').AsString);
  TestCase.AssertEquals(Details.Verbind,
    DataSet.FieldByName('Verbind').AsString);
  TestCase.AssertEquals(Details.Schtag, DataSet.FieldByName('Schtag').AsString);
  TestCase.AssertEquals(Details.Schmonat,
    DataSet.FieldByName('Schmonat').AsString);
  TestCase.AssertEquals(Details.Schjahr, DataSet.FieldByName('Schjahr').AsString);
  TestCase.AssertEquals(Details.Schort, DataSet.FieldByName('Schort').AsString);
  TestCase.AssertEquals(Details.Hqu, DataSet.FieldByName('Hqu').AsString);
  TestCase.AssertEquals(Details.Saqu, DataSet.FieldByName('Saqu').AsString);
  TestCase.AssertEquals(Details.Schqu, DataSet.FieldByName('Schqu').AsString);
end;

procedure TTestAHW52MarriagePairDataModuleAdapter.SetUp;
begin
  inherited SetUp;
  Application.Initialize;
  FConnection := TSQLite3Connection.Create(nil);
  FTransaction := TSQLTransaction.Create(nil);
  FSetupQuery := TSQLQuery.Create(nil);
  FDataModule := TGenealogyDataModule.Create(nil);
  try
    FConnection.DatabaseName := ':memory:';
    FConnection.OpenFlags := [sofReadWrite, sofCreate, sofMemory];
    FConnection.Transaction := FTransaction;
    FTransaction.Database := FConnection;
    FConnection.Connected := True;

    FSetupQuery.Database := FConnection;
    FSetupQuery.Transaction := FTransaction;
    CreateTableSchema;

    FDataModule.Table5.MasterSource := nil;
    FDataModule.Table5.MasterFields := '';
    FDataModule.Table5.Database := FConnection;
    FDataModule.Table5.Transaction := FTransaction;
    FDataModule.Table5.TableName := 'marriages';
    FDataModule.Table5.Open;

    FDataModuleInterface := CreateGenealogyDataModuleAdapter(FDataModule);
    FPairTransaction := CreateMarriagePairDataModuleAdapter(
      FDataModuleInterface);
  except
    TearDown;
    raise;
  end;
end;

procedure TTestAHW52MarriagePairDataModuleAdapter.TearDown;
begin
  FPairTransaction := nil;
  FDataModuleInterface := nil;
  if Assigned(FDataModule) then
  begin
    if FDataModule.Table5.Active then
      FDataModule.Table5.Close;
    FDataModule.Table5.Transaction := nil;
    FDataModule.Table5.Database := nil;
    FDataModule.Free;
  end;
  if Assigned(FSetupQuery) then
    FSetupQuery.Free;
  if Assigned(FTransaction) then
  begin
    if FTransaction.Active then
      FTransaction.Rollback;
    FTransaction.Free;
  end;
  if Assigned(FConnection) then
  begin
    FConnection.Close;
    FConnection.Free;
  end;
  FDataModule := nil;
  FSetupQuery := nil;
  FTransaction := nil;
  FConnection := nil;
  inherited TearDown;
end;

procedure TTestAHW52MarriagePairDataModuleAdapter.CreateTableSchema;
var
  Query: TSQLQuery;
begin
  Query := TSQLQuery(FSetupQuery);
  Query.SQL.Text :=
    'create table marriages (' +
    'Numr integer primary key autoincrement, ' +
    'Nummer integer not null, Epnum integer not null, ' +
    'Htag varchar(2), Hmonat varchar(2), Hjahr varchar(4), ' +
    'Hort varchar(40), Trauz varchar(120), ' +
    'Satag varchar(2), Samonat varchar(2), Sajahr varchar(4), ' +
    'Saort varchar(40), Satrauz varchar(120), Verbind varchar(40), ' +
    'Schtag varchar(2), Schmonat varchar(2), Schjahr varchar(4), ' +
    'Schort varchar(40), Hqu varchar(150), Saqu varchar(150), ' +
    'Schqu varchar(150), Indj varchar(4), Indm varchar(2))';
  Query.ExecSQL;
  TSQLTransaction(FTransaction).Commit;
end;

function TTestAHW52MarriagePairDataModuleAdapter.CountPersistedRows: Integer;
var
  Query: TSQLQuery;
  Transaction: TSQLTransaction;
begin
  Query := TSQLQuery(FSetupQuery);
  Transaction := TSQLTransaction(FTransaction);
  if Query.Active then
    Query.Close;
  if not Transaction.Active then
    Transaction.StartTransaction;
  Query.SQL.Text := 'select count(*) as row_count from marriages';
  Query.Open;
  Result := Query.FieldByName('row_count').AsInteger;
  Query.Close;
  Transaction.Rollback;
end;

procedure TTestAHW52MarriagePairDataModuleAdapter.
  TestCommitsTwoReciprocalRowsWithAllDetails;
var
  DataSet: TSQLTable;
  Details: TMarriageDetails;
begin
  Details := CreateTestDetails;
  WriteMarriagePairAtomically(
    IMarriagePairTransaction(FPairTransaction),
    CreateMarriagePairRequest(101, 202, Details));

  AssertEquals(2, CountPersistedRows);
  DataSet := TGenealogyDataModule(FDataModule).Table5;
  DataSet.Close;
  DataSet.Open;
  AssertTrue(DataSet.Locate('Nummer;Epnum', VarArrayOf([101, 202]), []));
  AssertRecordDetails(DataSet, Details, Self);
  AssertTrue(DataSet.Locate('Nummer;Epnum', VarArrayOf([202, 101]), []));
  AssertRecordDetails(DataSet, Details, Self);
end;

procedure TTestAHW52MarriagePairDataModuleAdapter.
  TestSecondInsertFailureRollsBackFirstRow;
var
  RaisedFailure: Boolean;
  Query: TSQLQuery;
begin
  Query := TSQLQuery(FSetupQuery);
  Query.SQL.Text :=
    'create trigger fail_second_pair_row before insert on marriages ' +
    'when new.Nummer = 202 and new.Epnum = 101 begin ' +
    'select raise(abort, ''synthetic second-row failure''); end';
  Query.ExecSQL;
  TSQLTransaction(FTransaction).Commit;
  TSQLTable(TGenealogyDataModule(FDataModule).Table5).Open;

  RaisedFailure := False;
  try
    WriteMarriagePairAtomically(
      IMarriagePairTransaction(FPairTransaction),
      CreateMarriagePairRequest(101, 202, CreateTestDetails));
  except
    on E: EMarriagePairRollbackFailure do
      raise Exception.CreateFmt(
        'SQLDB rollback unexpectedly failed after trigger error: %s',
        [E.Message]);
    on E: Exception do
    begin
      RaisedFailure := True;
      AssertTrue(
        'The failure must come from the injected second-row trigger; received: ' +
        E.Message,
        Pos('synthetic second-row failure', LowerCase(E.Message)) > 0);
    end;
  end;
  AssertTrue('The trigger must fail the second SQLDB row insertion.',
    RaisedFailure);
  AssertFalse('The pair coordinator should finish with no active transaction.',
    TSQLTransaction(FTransaction).Active);
  AssertEquals('The first post must be rolled back with the failed second row.',
    0, CountPersistedRows);
end;

procedure TTestAHW52MarriagePairDataModuleAdapter.
  TestRejectsNonBrowseTableState;
var
  RaisedExpectedError: Boolean;
  DataSet: TSQLTable;
begin
  DataSet := TSQLTable(TGenealogyDataModule(FDataModule).Table5);
  DataSet.Edit;
  RaisedExpectedError := False;
  try
    IMarriagePairTransaction(FPairTransaction).AppendMarriageRecord(
      101, 202, CreateTestDetails);
  except
    on EDataModuleWriteState do
      RaisedExpectedError := True;
  end;
  AssertTrue('Writes must reject a Table5 dataset already being edited.',
    RaisedExpectedError);
  DataSet.Cancel;
end;

procedure TTestAHW52MarriagePairDataModuleAdapter.TestRejectsInactiveTable;
var
  RaisedExpectedError: Boolean;
  DataSet: TSQLTable;
begin
  DataSet := TSQLTable(TGenealogyDataModule(FDataModule).Table5);
  DataSet.Close;
  RaisedExpectedError := False;
  try
    IMarriagePairTransaction(FPairTransaction).AppendMarriageRecord(
      101, 202, CreateTestDetails);
  except
    on EDataModuleWriteUnavailable do
      RaisedExpectedError := True;
  end;
  AssertTrue('Writes must reject an inactive Table5 dataset.',
    RaisedExpectedError);
end;

procedure TTestAHW52MarriagePairDataModuleAdapter.
  TestRejectsMissingRequiredField;
var
  RaisedExpectedError: Boolean;
  DataSet: TSQLTable;
  Query: TSQLQuery;
begin
  DataSet := TSQLTable(TGenealogyDataModule(FDataModule).Table5);
  DataSet.Close;
  Query := TSQLQuery(FSetupQuery);
  Query.SQL.Text := 'drop table marriages';
  Query.ExecSQL;
  Query.SQL.Text :=
    'create table marriages (Nummer integer not null, Epnum integer not null)';
  Query.ExecSQL;
  TSQLTransaction(FTransaction).Commit;

  RaisedExpectedError := False;
  try
    DataSet.Open;
  except
    on EDatabaseError do
      RaisedExpectedError := True;
  end;
  AssertTrue('An incomplete Table5 schema must fail explicitly on open.',
    RaisedExpectedError);
  AssertEquals(0, CountPersistedRows);
end;

initialization
  RegisterTest(TTestAHW52MarriagePairDataModuleAdapter);

end.
