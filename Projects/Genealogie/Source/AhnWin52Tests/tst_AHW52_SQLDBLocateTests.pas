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
    procedure SQLDBLocateUsesCompositeIndexOrderForPrefix;
    procedure SQLTableIndexNameOrdersAndReopensActiveQuery;
    procedure SQLTableCompositePrefixLocateHonorsClientFilter;
    procedure SQLTableLocateCaseSensitivityIsExplicit;
    procedure SQLTableRejectsUnknownIndexWithoutClosing;
  end;

implementation

uses
  BufDataset, cmp_SQLTable, DB, SQLDB, SQLite3Conn, SysUtils;

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

procedure TTestAHW52SQLDBLocate.SQLDBLocateUsesCompositeIndexOrderForPrefix;
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
      'create table people (id integer not null primary key, ' +
      'father integer not null, birth_year varchar(4) not null, ' +
      'birth_month varchar(2) not null, birth_day varchar(2) not null)';
    SetupQuery.ExecSQL;
    SetupQuery.SQL.Text :=
      'create index vat_idx on people ' +
      '(father, birth_year, birth_month, birth_day)';
    SetupQuery.ExecSQL;

    SetupQuery.SQL.Text :=
      'insert into people ' +
      '(id, father, birth_year, birth_month, birth_day) ' +
      'values (:id, :father, :year, :month, :day)';
    SetupQuery.Params.ParamByName('id').AsInteger := 30;
    SetupQuery.Params.ParamByName('father').AsInteger := 100;
    SetupQuery.Params.ParamByName('year').AsString := '1980';
    SetupQuery.Params.ParamByName('month').AsString := '01';
    SetupQuery.Params.ParamByName('day').AsString := '01';
    SetupQuery.ExecSQL;
    SetupQuery.Params.ParamByName('id').AsInteger := 20;
    SetupQuery.Params.ParamByName('father').AsInteger := 100;
    SetupQuery.Params.ParamByName('year').AsString := '1960';
    SetupQuery.Params.ParamByName('month').AsString := '01';
    SetupQuery.Params.ParamByName('day').AsString := '01';
    SetupQuery.ExecSQL;
    SetupQuery.Params.ParamByName('id').AsInteger := 10;
    SetupQuery.Params.ParamByName('father').AsInteger := 200;
    SetupQuery.Params.ParamByName('year').AsString := '1950';
    SetupQuery.Params.ParamByName('month').AsString := '01';
    SetupQuery.Params.ParamByName('day').AsString := '01';
    SetupQuery.ExecSQL;
    Transaction.Commit;

    DataSet.Database := Connection;
    DataSet.Transaction := Transaction;
    DataSet.SQL.Text :=
      'select id, father, birth_year, birth_month, birth_day ' +
      'from people order by father, birth_year, birth_month, birth_day';
    DataSet.Open;

    AssertTrue('The prefix Locate should find matching father rows.',
      DataSet.Locate('father', 100, []));
    AssertEquals('The prefix Locate should return the first row in composite ' +
      'index order.', 20, DataSet.FieldByName('id').AsInteger);

    DataSet.First;
    AssertFalse('A missing father prefix should not be found.',
      DataSet.Locate('father', 999, []));
    AssertEquals('A miss should retain the row that was current before the ' +
      'lookup.', 20, DataSet.FieldByName('id').AsInteger);
    AssertTrue('A miss should set BOF before the retained first row.',
      DataSet.BOF);
    AssertFalse('A miss should not move to EOF.', DataSet.EOF);
  finally
    DataSet.Free;
    SetupQuery.Free;
    Connection.Close;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestAHW52SQLDBLocate.SQLTableIndexNameOrdersAndReopensActiveQuery;
var
  Connection: TSQLite3Connection;
  Transaction: TSQLTransaction;
  SetupQuery: TSQLQuery;
  Table: TSQLTable;
begin
  Connection := TSQLite3Connection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  SetupQuery := TSQLQuery.Create(nil);
  Table := TSQLTable.Create(nil);
  try
    Connection.DatabaseName := ':memory:';
    Connection.OpenFlags := [sofReadWrite, sofCreate, sofMemory];
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Connection.Connected := True;

    SetupQuery.Database := Connection;
    SetupQuery.Transaction := Transaction;
    SetupQuery.SQL.Text :=
      'create table people (id integer not null primary key, ' +
      'father integer not null, birth_year varchar(4) not null, ' +
      'birth_month varchar(2) not null, birth_day varchar(2) not null)';
    SetupQuery.ExecSQL;
    SetupQuery.SQL.Text :=
      'insert into people ' +
      '(id, father, birth_year, birth_month, birth_day) ' +
      'values (:id, :father, :year, :month, :day)';
    SetupQuery.Params.ParamByName('id').AsInteger := 30;
    SetupQuery.Params.ParamByName('father').AsInteger := 100;
    SetupQuery.Params.ParamByName('year').AsString := '1980';
    SetupQuery.Params.ParamByName('month').AsString := '01';
    SetupQuery.Params.ParamByName('day').AsString := '01';
    SetupQuery.ExecSQL;
    SetupQuery.Params.ParamByName('id').AsInteger := 20;
    SetupQuery.Params.ParamByName('father').AsInteger := 100;
    SetupQuery.Params.ParamByName('year').AsString := '1960';
    SetupQuery.Params.ParamByName('month').AsString := '01';
    SetupQuery.Params.ParamByName('day').AsString := '01';
    SetupQuery.ExecSQL;
    SetupQuery.Params.ParamByName('id').AsInteger := 10;
    SetupQuery.Params.ParamByName('father').AsInteger := 200;
    SetupQuery.Params.ParamByName('year').AsString := '1950';
    SetupQuery.Params.ParamByName('month').AsString := '01';
    SetupQuery.Params.ParamByName('day').AsString := '01';
    SetupQuery.ExecSQL;
    Transaction.Commit;

    Table.Database := Connection;
    Table.Transaction := Transaction;
    Table.TableName := 'people';
    Table.Indexes.Add('vat',
      'father;birth_year;birth_month;birth_day');
    Table.Indexes.Add('vat_desc',
      'father;birth_year;birth_month;birth_day', 'birth_year');
    Table.IndexName := 'vat';
    Table.Open;

    AssertTrue('The table should be active after opening.', Table.Active);
    AssertTrue('The prefix Locate should find the indexed father.',
      Table.Locate('father', 100, []));
    AssertEquals('Ascending composite order should select the earlier year.',
      20, Table.FieldByName('id').AsInteger);

    Table.IndexName := 'vat_desc';
    AssertTrue('Changing IndexName should reopen an active table.',
      Table.Active);
    Table.First;
    AssertEquals('The active index change should apply descending order to ' +
      'the declared field.', 30, Table.FieldByName('id').AsInteger);
    AssertTrue('Prefix Locate should follow the newly selected order.',
      Table.Locate('father', 100, []));
    AssertEquals('The descending composite order should select the later year.',
      30, Table.FieldByName('id').AsInteger);
  finally
    Table.Free;
    SetupQuery.Free;
    Connection.Close;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestAHW52SQLDBLocate.SQLTableCompositePrefixLocateHonorsClientFilter;
var
  Connection: TSQLite3Connection;
  Transaction: TSQLTransaction;
  SetupQuery: TSQLQuery;
  Table: TSQLTable;
begin
  Connection := TSQLite3Connection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  SetupQuery := TSQLQuery.Create(nil);
  Table := TSQLTable.Create(nil);
  try
    Connection.DatabaseName := ':memory:';
    Connection.OpenFlags := [sofReadWrite, sofCreate, sofMemory];
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Connection.Connected := True;

    SetupQuery.Database := Connection;
    SetupQuery.Transaction := Transaction;
    SetupQuery.SQL.Text :=
      'create table people (id integer not null primary key, ' +
      'father integer not null, birth_year varchar(4) not null, ' +
      'baptism_year varchar(4) not null, birth_month varchar(2) not null, ' +
      'birth_day varchar(2) not null)';
    SetupQuery.ExecSQL;
    SetupQuery.SQL.Text :=
      'insert into people ' +
      '(id, father, birth_year, baptism_year, birth_month, birth_day) ' +
      'values (:id, :father, :birth_year, :baptism_year, :month, :day)';
    SetupQuery.Params.ParamByName('id').AsInteger := 30;
    SetupQuery.Params.ParamByName('father').AsInteger := 100;
    SetupQuery.Params.ParamByName('birth_year').AsString := '1950';
    SetupQuery.Params.ParamByName('baptism_year').AsString := '1980';
    SetupQuery.Params.ParamByName('month').AsString := '01';
    SetupQuery.Params.ParamByName('day').AsString := '01';
    SetupQuery.ExecSQL;
    SetupQuery.Params.ParamByName('id').AsInteger := 20;
    SetupQuery.Params.ParamByName('father').AsInteger := 100;
    SetupQuery.Params.ParamByName('birth_year').AsString := '1960';
    SetupQuery.Params.ParamByName('baptism_year').AsString := '1960';
    SetupQuery.ExecSQL;
    SetupQuery.Params.ParamByName('id').AsInteger := 10;
    SetupQuery.Params.ParamByName('father').AsInteger := 200;
    SetupQuery.Params.ParamByName('birth_year').AsString := '1950';
    SetupQuery.Params.ParamByName('baptism_year').AsString := '1950';
    SetupQuery.ExecSQL;
    Transaction.Commit;

    Table.Database := Connection;
    Table.Transaction := Transaction;
    Table.TableName := 'people';
    Table.Indexes.Add('vat',
      'father;birth_year;birth_month;birth_day');
    Table.IndexName := 'vat';
    Table.Open;
    Table.Filter :=
      'birth_year <= ''1965'' and baptism_year <= ''1965''';
    Table.Filtered := True;

    AssertTrue('The filtered prefix lookup should find an eligible row.',
      Table.Locate('father', 100, []));
    AssertEquals('The filter should skip the earlier-in-order excluded row.',
      20, Table.FieldByName('id').AsInteger);

    Table.First;
    AssertFalse('The filtered prefix lookup should miss an absent key.',
      Table.Locate('father', 999, []));
    AssertEquals('The filtered miss should retain the current visible row.',
      20, Table.FieldByName('id').AsInteger);
    AssertTrue('The filtered miss should set BOF before the current row.',
      Table.BOF);
    AssertFalse('The filtered miss should not set EOF.', Table.EOF);
  finally
    Table.Free;
    SetupQuery.Free;
    Connection.Close;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestAHW52SQLDBLocate.SQLTableLocateCaseSensitivityIsExplicit;
var
  Connection: TSQLite3Connection;
  Transaction: TSQLTransaction;
  SetupQuery: TSQLQuery;
  Table: TSQLTable;
begin
  Connection := TSQLite3Connection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  SetupQuery := TSQLQuery.Create(nil);
  Table := TSQLTable.Create(nil);
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
    SetupQuery.SQL.Text :=
      'insert into places (id, ort) values (4, ''SyntheticOtherCase'')';
    SetupQuery.ExecSQL;
    Transaction.Commit;

    Table.Database := Connection;
    Table.Transaction := Transaction;
    Table.TableName := 'places';
    Table.Indexes.Add('by_ort', 'ort');
    Table.IndexName := 'by_ort';
    Table.Open;
    Table.First;

    AssertFalse('Default Locate should be case-sensitive in this fixture.',
      Table.Locate('ort', 'syntheticothercase', []));
    AssertEquals('A case-sensitive miss should retain the current row.',
      4, Table.FieldByName('id').AsInteger);
    AssertTrue('Locate with loCaseInsensitive should find a case variant.',
      Table.Locate('ort', 'syntheticothercase', [loCaseInsensitive]));
    AssertEquals('The insensitive lookup should select the matching row.',
      4, Table.FieldByName('id').AsInteger);
  finally
    Table.Free;
    SetupQuery.Free;
    Connection.Close;
    Transaction.Free;
    Connection.Free;
  end;
end;

procedure TTestAHW52SQLDBLocate.SQLTableRejectsUnknownIndexWithoutClosing;
var
  Connection: TSQLite3Connection;
  Transaction: TSQLTransaction;
  SetupQuery: TSQLQuery;
  Table: TSQLTable;
  Rejected: Boolean;
begin
  Connection := TSQLite3Connection.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  SetupQuery := TSQLQuery.Create(nil);
  Table := TSQLTable.Create(nil);
  try
    Connection.DatabaseName := ':memory:';
    Connection.OpenFlags := [sofReadWrite, sofCreate, sofMemory];
    Connection.Transaction := Transaction;
    Transaction.Database := Connection;
    Connection.Connected := True;

    SetupQuery.Database := Connection;
    SetupQuery.Transaction := Transaction;
    SetupQuery.SQL.Text := 'create table places (id integer primary key)';
    SetupQuery.ExecSQL;
    Transaction.Commit;

    Table.Database := Connection;
    Table.Transaction := Transaction;
    Table.TableName := 'places';
    Table.Indexes.Add('by_id', 'id');
    Table.IndexName := 'by_id';
    Table.Open;

    Rejected := False;
    try
      Table.IndexName := 'missing';
    except
      on E: EDatabaseError do
        Rejected := True;
    end;

    AssertTrue('An unknown index name should raise a database error.',
      Rejected);
    AssertTrue('Rejecting an unknown index must leave the active query open.',
      Table.Active);
    AssertEquals('Rejecting an unknown index must preserve the selection.',
      'by_id', Table.IndexName);

    Table.Indexes.Add('malformed', 'id;id DESC, other');
    Rejected := False;
    try
      Table.IndexName := 'malformed';
    except
      on E: EDatabaseError do
        Rejected := True;
    end;
    AssertTrue('Malformed index fields should raise a database error.',
      Rejected);
    AssertTrue('Rejecting malformed fields must not close the active query.',
      Table.Active);
    AssertEquals('Rejecting malformed fields must preserve the selection.',
      'by_id', Table.IndexName);
  finally
    Table.Free;
    SetupQuery.Free;
    Connection.Close;
    Transaction.Free;
    Connection.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52SQLDBLocate);

end.
