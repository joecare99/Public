unit tst_DBParadoxStagedTable;

{$mode objfpc}{$H+}

interface

uses
  DBParadoxRecordEncoder, DBParadoxStagedTable, DBParadoxTableFileBuilder,
  fpcunit, SysUtils, testregistry;

type
  TTestDBParadoxStagedTable = class(TTestCase)
  private
    function Fields: TDBParadoxRecordFields;
    function ExistingRows: TDBParadoxTableRows;
    function LongKey(Value: LongInt): TBytes;
    procedure AssertStagedWriteRejected(Table: TDBParadoxStagedTable;
      const Values: TDBParadoxRecordValues);
  published
    procedure StagesInsertUpdateDeleteAndReportsRowsAffected;
    procedure RollbackRestoresOriginalRows;
    procedure FailedWritesDoNotChangeStagedRows;
    procedure RejectsDuplicateInitialKeysAndUnsupportedFields;
  end;

implementation

function TTestDBParadoxStagedTable.Fields: TDBParadoxRecordFields;
begin
  Result := nil;
  SetLength(Result, 2);
  Result[0].Name := 'ID';
  Result[0].TypeCode := $04;
  Result[0].Length := 4;
  Result[1].Name := 'Name';
  Result[1].TypeCode := $01;
  Result[1].Length := 12;
end;

function TTestDBParadoxStagedTable.ExistingRows: TDBParadoxTableRows;
begin
  Result := nil;
  SetLength(Result, 2);
  Result[0] := ['1', 'One'];
  Result[1] := ['2', 'Two'];
end;

function TTestDBParadoxStagedTable.LongKey(Value: LongInt): TBytes;
var
  Encoded: TBytes;
begin
  Result := nil;
  Encoded := EncodeDBParadoxRecord(Fields, [IntToStr(Value), '']);
  SetLength(Result, 4);
  Move(Encoded[0], Result[0], Length(Result));
end;

procedure TTestDBParadoxStagedTable.AssertStagedWriteRejected(
  Table: TDBParadoxStagedTable; const Values: TDBParadoxRecordValues);
var
  BeforeRows, AfterRows: TDBParadoxTableRows;
begin
  BeforeRows := Table.Rows;
  try
    Table.Insert(Values);
    Fail('Expected an invalid staged write to be rejected.');
  except
    on E: EDBParadoxStagedTableError do ;
  end;
  AfterRows := Table.Rows;
  CheckEquals(Length(BeforeRows), Length(AfterRows));
  CheckEquals(BeforeRows[0][0], AfterRows[0][0]);
  CheckEquals(BeforeRows[0][1], AfterRows[0][1]);
end;

procedure TTestDBParadoxStagedTable.
  StagesInsertUpdateDeleteAndReportsRowsAffected;
var
  Table: TDBParadoxStagedTable;
  Rows: TDBParadoxTableRows;
begin
  Table := TDBParadoxStagedTable.Create(
    'Synthetic.DB', Fields, 0, ExistingRows);
  try
    CheckEquals(1, Table.Insert(['3', 'Three']));
    CheckEquals(0, Table.UpdateByPrimaryKey(LongKey(99), ['99', 'Missing']));
    CheckEquals(1, Table.UpdateByPrimaryKey(LongKey(2), ['2', 'Updated']));
    CheckEquals(1, Table.DeleteByPrimaryKey(LongKey(1)));
    CheckEquals(0, Table.DeleteByPrimaryKey(LongKey(1)));
    CheckEquals(2, Table.RowCount);

    Rows := Table.Rows;
    CheckEquals('2', Rows[0][0]);
    CheckEquals('Updated', Rows[0][1]);
    CheckEquals('3', Rows[1][0]);
    CheckEquals('Three', Rows[1][1]);

    Rows[0][1] := 'Caller mutation';
    CheckEquals('Updated', Table.Rows[0][1]);
    Table.Commit;
    CheckEquals(Ord(dpstCommitted), Ord(Table.State));
    try
      Table.Insert(['4', 'After commit']);
      Fail('A committed staged table must reject further writes.');
    except
      on E: EDBParadoxStagedTableError do ;
    end;
  finally
    Table.Free;
  end;
end;

procedure TTestDBParadoxStagedTable.RollbackRestoresOriginalRows;
var
  Table: TDBParadoxStagedTable;
  Rows: TDBParadoxTableRows;
begin
  Table := TDBParadoxStagedTable.Create(
    'Synthetic.DB', Fields, 0, ExistingRows);
  try
    Table.Insert(['3', 'Three']);
    Table.UpdateByPrimaryKey(LongKey(2), ['2', 'Updated']);
    Table.DeleteByPrimaryKey(LongKey(1));
    Table.Rollback;
    CheckEquals(Ord(dpstRolledBack), Ord(Table.State));
    Rows := Table.Rows;
    CheckEquals(2, Length(Rows));
    CheckEquals('1', Rows[0][0]);
    CheckEquals('One', Rows[0][1]);
    CheckEquals('2', Rows[1][0]);
    CheckEquals('Two', Rows[1][1]);
  finally
    Table.Free;
  end;
end;

procedure TTestDBParadoxStagedTable.FailedWritesDoNotChangeStagedRows;
var
  Table: TDBParadoxStagedTable;
begin
  Table := TDBParadoxStagedTable.Create(
    'Synthetic.DB', Fields, 0, ExistingRows);
  try
    AssertStagedWriteRejected(Table, ['1', 'Duplicate']);
    AssertStagedWriteRejected(Table, ['3', 'This name is too long']);
    AssertStagedWriteRejected(Table, ['3', 'Non-ASCII-ä']);
    AssertStagedWriteRejected(Table, ['3', 'Embedded'#0'NUL']);
    try
      Table.UpdateByPrimaryKey(LongKey(2), ['3', 'Duplicate key']);
      Fail('Updating to an existing primary key must be rejected.');
    except
      on E: EDBParadoxStagedTableError do ;
    end;
    CheckEquals('2', Table.Rows[1][0]);
    CheckEquals('Two', Table.Rows[1][1]);
    try
      Table.UpdateByPrimaryKey(LongKey(99), ['100', 'Name too long here']);
      Fail('Invalid update values must be rejected for absent keys too.');
    except
      on E: EDBParadoxStagedTableError do ;
    end;
    try
      Table.DeleteByPrimaryKey([0, 0, 0, 0]);
      Fail('A NULL primary key must be rejected.');
    except
      on E: EDBParadoxStagedTableError do ;
    end;
    try
      Table.DeleteByPrimaryKey([1, 2]);
      Fail('A malformed primary key width must be rejected.');
    except
      on E: EDBParadoxStagedTableError do ;
    end;
    try
      Table.UpdateByPrimaryKey(LongKey(2), ['4', 'Changed key']);
      Fail('Primary-key updates must be rejected.');
    except
      on E: EDBParadoxStagedTableError do ;
    end;
    CheckEquals('2', Table.Rows[1][0]);
  finally
    Table.Free;
  end;
end;

procedure TTestDBParadoxStagedTable.
  RejectsDuplicateInitialKeysAndUnsupportedFields;
var
  DuplicateRows, InvalidRows: TDBParadoxTableRows;
  InvalidFields: TDBParadoxRecordFields;
  Table: TDBParadoxStagedTable;
begin
  DuplicateRows := ExistingRows;
  DuplicateRows[1][0] := '1';
  try
    Table := TDBParadoxStagedTable.Create(
      'Synthetic.DB', Fields, 0, DuplicateRows);
    Table.Free;
    Fail('Duplicate source primary keys must be rejected.');
  except
    on E: EDBParadoxStagedTableError do ;
  end;

  InvalidRows := ExistingRows;
  InvalidFields := Fields;
  InvalidFields[1].TypeCode := $03;
  try
    Table := TDBParadoxStagedTable.Create(
      'Synthetic.DB', InvalidFields, 0, InvalidRows);
    Table.Free;
    Fail('Unsupported field types must be rejected.');
  except
    on E: EDBParadoxStagedTableError do ;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxStagedTable);

end.
