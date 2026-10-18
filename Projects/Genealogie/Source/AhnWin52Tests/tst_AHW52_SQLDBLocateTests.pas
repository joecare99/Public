unit tst_AHW52_SQLDBLocateTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52SQLDBLocate = class(TTestCase)
  published
    procedure LocateMovesToMatchingRecord;
    procedure LocateMissPreservesCurrentRecord;
    procedure NavigationPostsPendingChanges;
    procedure SQLDBLocateMatchesDuplicateValueInQueryOrder;
  end;

implementation

uses
  BufDataset, DB, SQLDB, SQLite3Conn, SysUtils;

type
  TTestableBufDataset = class(TBufDataset)
  protected
    procedure LoadBlobIntoBuffer(FieldDef: TFieldDef;
      ABlobBuf: PBufBlobField); override;
  end;

procedure TTestableBufDataset.LoadBlobIntoBuffer(FieldDef: TFieldDef;
  ABlobBuf: PBufBlobField);
begin
  if ABlobBuf = nil then
    raise Exception.Create('The synthetic blob buffer is missing.');
  raise Exception.CreateFmt('Blob field %s is unsupported in this fixture.',
    [FieldDef.Name]);
end;

function CreateSyntheticPeople: TTestableBufDataset;
begin
  Result := TTestableBufDataset.Create(nil);
  Result.FieldDefs.Add('NUMMER', ftInteger);
  Result.FieldDefs.Add('NAME', ftString, 40);
  Result.CreateDataset;
  Result.AppendRecord([1001, 'Alpha']);
  Result.AppendRecord([1002, 'Beta']);
  Result.First;
end;

procedure TTestAHW52SQLDBLocate.LocateMovesToMatchingRecord;
var
  DataSet: TTestableBufDataset;
begin
  DataSet := CreateSyntheticPeople;
  try
    if not DataSet.Locate('NUMMER', 1002, []) then
      Fail('Locate did not find the matching synthetic person.');

    if DataSet.FieldByName('NUMMER').AsInteger <> 1002 then
      Fail('Locate did not move the cursor to the matching record.');
  finally
    DataSet.Free;
  end;
end;

procedure TTestAHW52SQLDBLocate.LocateMissPreservesCurrentRecord;
var
  DataSet: TTestableBufDataset;
begin
  DataSet := CreateSyntheticPeople;
  try
    if DataSet.Locate('NUMMER', 9999, []) then
      Fail('Locate unexpectedly found a missing synthetic person.');

    if DataSet.FieldByName('NUMMER').AsInteger <> 1001 then
      Fail('Locate moved the cursor after a normal miss.');
  finally
    DataSet.Free;
  end;
end;

procedure TTestAHW52SQLDBLocate.NavigationPostsPendingChanges;
var
  DataSet: TTestableBufDataset;
begin
  DataSet := CreateSyntheticPeople;
  try
    DataSet.Edit;
    DataSet.FieldByName('NAME').AsString := 'Alpha Updated';
    DataSet.Last;

    if DataSet.State <> dsBrowse then
      Fail('Navigation did not leave the dataset in browse state.');
    if not DataSet.Locate('NUMMER', 1001, []) then
      Fail('The edited synthetic person could not be found after navigation.');
    if DataSet.FieldByName('NAME').AsString <> 'Alpha Updated' then
      Fail('Navigation did not post the pending synthetic edit.');
  finally
    DataSet.Free;
  end;
end;

procedure TTestAHW52SQLDBLocate.SQLDBLocateMatchesDuplicateValueInQueryOrder;
var
  Connection: TSQLite3Connection;
  Transaction: TSQLTransaction;
  SetupQuery: TSQLQuery;
  DataSet: TSQLQuery;
begin
  Connection := TSQLite3Connection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  SetupQuery := TSQLQuery.Create(nil);
  DataSet := TSQLQuery.Create(nil);
  try
    Connection.DatabaseName := ':memory:';
    Connection.OpenFlags := [sofReadWrite, sofCreate, sofMemory];
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Connection.Connected := True;

    SetupQuery.Database := Connection;
    SetupQuery.Transaction := Transaction;
    SetupQuery.SQL.Text :=
      'create table places (id integer not null primary key, ' +
      'ort varchar(40) not null)';
    SetupQuery.ExecSQL;
    SetupQuery.SQL.Text := 'create index ort_idx on places (ort)';
    SetupQuery.ExecSQL;

    SetupQuery.SQL.Text :=
      'insert into places (id, ort) values (:id, :ort)';
    SetupQuery.Params.ParamByName('id').AsInteger := 2;
    SetupQuery.Params.ParamByName('ort').AsString := 'Dresden';
    SetupQuery.ExecSQL;
    SetupQuery.Params.ParamByName('id').AsInteger := 1;
    SetupQuery.Params.ParamByName('ort').AsString := 'Dresden';
    SetupQuery.ExecSQL;
    SetupQuery.Params.ParamByName('id').AsInteger := 3;
    SetupQuery.Params.ParamByName('ort').AsString := 'Berlin';
    SetupQuery.ExecSQL;
    Transaction.Commit;

    DataSet.Database := Connection;
    DataSet.Transaction := Transaction;
    DataSet.SQL.Text := 'select id, ort from places order by id';
    DataSet.Open;
    AssertTrue('The SQLDB exact-field lookup should find a duplicate value.',
      DataSet.Locate('ort', 'Dresden', []));
    AssertEquals('Locate returns the first matching row in query order.',
      1, DataSet.FieldByName('id').AsInteger);

    DataSet.First;
    AssertFalse('A missing exact value should not be found.',
      DataSet.Locate('ort', 'Missing', []));
    AssertEquals('A miss should preserve the current record in this query.',
      1, DataSet.FieldByName('id').AsInteger);
    AssertTrue('The query should remain before its first current record.',
      DataSet.BOF);
    AssertFalse('The miss should not move the query to EOF.', DataSet.EOF);
  finally
    DataSet.Free;
    SetupQuery.Free;
    Connection.Close;
    Transaction.Free;
    Connection.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52SQLDBLocate);

end.
