unit tst_AHW52_DBTablesCompatTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52DBTablesCompat = class(TTestCase)
  published
    procedure TestAllowsQueryConstructionAndSQLConfiguration;
    procedure TestRejectsQueryOpenExplicitly;
    procedure TestRejectsQueryActivationExplicitly;
    procedure TestRejectsQueryExecutionExplicitly;
    procedure TestRejectsQueryPreparationExplicitly;
    procedure TestRejectsTableFindKeyExplicitly;
    procedure TestRejectsTableEmptyTableExplicitly;
  end;

implementation

uses
  SysUtils, DBTables, DBTablesCompatErrors, Cmp_SQLTable;

type
  TQueryOperation = (qoOpen, qoActivate, qoExecute, qoPrepare);

procedure AssertUnsupportedOperation(const ExpectedOperation: string;
  Query: TQuery; Operation: TQueryOperation);
var
  ActualOperation: string;
begin
  try
    case Operation of
      qoOpen: Query.Open;
      qoActivate: Query.Active := True;
      qoExecute: Query.ExecSQL;
      qoPrepare: Query.Prepare;
    end;
  except
    on E: EDBTablesCompatibilityUnsupported do
    begin
      ActualOperation := E.Operation;
    end;
  end;

  if ActualOperation <> ExpectedOperation then
    raise Exception.CreateFmt(
      'Expected unsupported operation "%s", got "%s".',
      [ExpectedOperation, ActualOperation]);
end;

procedure TTestAHW52DBTablesCompat.
  TestAllowsQueryConstructionAndSQLConfiguration;
var
  Query: TQuery;
begin
  Query := TQuery.Create(nil);
  try
    Query.SQL.Text := 'select 1';
    AssertEquals(1, Query.SQL.Count);
    AssertEquals('select 1', Query.SQL[0]);
    AssertFalse(Query.Active);
  finally
    Query.Free;
  end;
end;

procedure TTestAHW52DBTablesCompat.TestRejectsQueryOpenExplicitly;
var
  Query: TQuery;
begin
  Query := TQuery.Create(nil);
  try
    AssertUnsupportedOperation('TQuery.OpenCursor', Query, qoOpen);
  finally
    Query.Free;
  end;
end;

procedure TTestAHW52DBTablesCompat.
  TestRejectsQueryActivationExplicitly;
var
  Query: TQuery;
begin
  Query := TQuery.Create(nil);
  try
    AssertUnsupportedOperation('TQuery.OpenCursor', Query, qoActivate);
    AssertFalse(Query.Active);
  finally
    Query.Free;
  end;
end;

procedure TTestAHW52DBTablesCompat.TestRejectsQueryExecutionExplicitly;
var
  Query: TQuery;
begin
  Query := TQuery.Create(nil);
  try
    AssertUnsupportedOperation('TQuery.ExecSQL', Query, qoExecute);
  finally
    Query.Free;
  end;
end;

procedure TTestAHW52DBTablesCompat.TestRejectsQueryPreparationExplicitly;
var
  Query: TQuery;
begin
  Query := TQuery.Create(nil);
  try
    AssertUnsupportedOperation('TQuery.Prepare', Query, qoPrepare);
  finally
    Query.Free;
  end;
end;

procedure TTestAHW52DBTablesCompat.TestRejectsTableFindKeyExplicitly;
var
  Table: TSQLTable;
  ActualOperation: string;
begin
  Table := TSQLTable.Create(nil);
  try
    try
      Table.FindKey([1001]);
    except
      on E: EDBTablesCompatibilityUnsupported do
        ActualOperation := E.Operation;
    end;

    AssertEquals('TTable.FindKey', ActualOperation);
    AssertFalse(Table.Active);
  finally
    Table.Free;
  end;
end;

procedure TTestAHW52DBTablesCompat.TestRejectsTableEmptyTableExplicitly;
var
  Table: TSQLTable;
  ActualOperation: string;
begin
  Table := TSQLTable.Create(nil);
  try
    try
      Table.EmptyTable;
    except
      on E: EDBTablesCompatibilityUnsupported do
        ActualOperation := E.Operation;
    end;

    AssertEquals('TTable.EmptyTable', ActualOperation);
    AssertFalse(Table.Active);
  finally
    Table.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52DBTablesCompat);

end.
