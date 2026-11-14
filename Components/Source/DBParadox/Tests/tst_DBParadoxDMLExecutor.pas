unit tst_DBParadoxDMLExecutor;

{$mode objfpc}{$H+}

interface

uses
  DB, DBParadoxRecordEncoder, fpcunit, testregistry;

type
  TTestDBParadoxDMLExecutor = class(TTestCase)
  private
    function Fields: TDBParadoxRecordFields;
    function NewParams: TParams;
  published
    procedure PreparesCompleteInsertWithNullAndZero;
    procedure PreparesPrimaryKeyUpdateAndDelete;
    procedure RejectsIncompleteInsertAndKeyUpdate;
    procedure RejectsWrongTypesUnusedParamsAndMalformedFields;
  end;

implementation

uses
  SysUtils, DBParadoxDMLExecutor, DBParadoxSQLParser;

function TTestDBParadoxDMLExecutor.Fields: TDBParadoxRecordFields;
begin
  Result := nil;
  SetLength(Result, 3);
  Result[0].Name := 'ID';
  Result[0].TypeCode := $04;
  Result[0].Length := 4;
  Result[1].Name := 'Name';
  Result[1].TypeCode := $01;
  Result[1].Length := 12;
  Result[2].Name := 'Count';
  Result[2].TypeCode := $04;
  Result[2].Length := 4;
end;

function TTestDBParadoxDMLExecutor.NewParams: TParams;
begin
  Result := TParams.Create(nil);
end;

procedure TTestDBParadoxDMLExecutor.
  PreparesCompleteInsertWithNullAndZero;
var
  Params: TParams;
  Plan: TDBParadoxDMLPlan;
  Prepared: TDBParadoxPreparedDML;
  FieldsValue: TDBParadoxRecordFields;
begin
  FieldsValue := Fields;
  Params := NewParams;
  try
    Params.CreateParam(ftInteger, 'id', ptInput).AsInteger := 1;
    Params.CreateParam(ftString, 'name', ptInput).AsString := '';
    Params.CreateParam(ftInteger, 'count', ptInput).AsInteger := 0;
    Plan := ParseDBParadoxDML(
      'INSERT INTO T (ID, Name, Count) VALUES (:id, :name, :count)');
    Prepared := PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, nil);
    CheckEquals('1', Prepared.Values[0]);
    CheckEquals('', Prepared.Values[1]);
    CheckEquals('0', Prepared.Values[2]);
    CheckEquals(4, Length(Prepared.PrimaryKey));
    CheckEquals($80, Prepared.PrimaryKey[0]);
    CheckEquals(1, Prepared.PrimaryKey[3]);
  finally
    Params.Free;
  end;
end;

procedure TTestDBParadoxDMLExecutor.
  PreparesPrimaryKeyUpdateAndDelete;
var
  Params: TParams;
  Plan: TDBParadoxDMLPlan;
  Prepared: TDBParadoxPreparedDML;
  FieldsValue: TDBParadoxRecordFields;
begin
  FieldsValue := Fields;
  Params := NewParams;
  try
    Params.CreateParam(ftInteger, 'id', ptInput).AsInteger := 2;
    Params.CreateParam(ftString, 'name', ptInput).AsString := 'Updated';
    Plan := ParseDBParadoxDML(
      'UPDATE T SET Name = :name WHERE ID = :id');
    Prepared := PrepareDBParadoxDML(Plan, FieldsValue, 0, Params,
      ['2', 'Before', '7']);
    CheckEquals('2', Prepared.Values[0]);
    CheckEquals('Updated', Prepared.Values[1]);
    CheckEquals('7', Prepared.Values[2]);
    CheckEquals(4, Length(Prepared.PrimaryKey));
    CheckEquals($80, Prepared.PrimaryKey[0]);
    CheckEquals(2, Prepared.PrimaryKey[3]);

    Params.Clear;
    Params.CreateParam(ftInteger, 'id', ptInput).AsInteger := -1;
    Plan := ParseDBParadoxDML('DELETE FROM T WHERE ID = :id');
    Prepared := PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, nil);
    CheckEquals($7F, Prepared.PrimaryKey[0]);
    CheckEquals($FF, Prepared.PrimaryKey[1]);
    CheckEquals($FF, Prepared.PrimaryKey[2]);
    CheckEquals($FF, Prepared.PrimaryKey[3]);
  finally
    Params.Free;
  end;
end;

procedure TTestDBParadoxDMLExecutor.
  RejectsIncompleteInsertAndKeyUpdate;
var
  Params: TParams;
  Plan: TDBParadoxDMLPlan;
  FieldsValue: TDBParadoxRecordFields;
begin
  FieldsValue := Fields;
  Params := NewParams;
  try
    Params.CreateParam(ftInteger, 'id', ptInput).AsInteger := 1;
    Params.CreateParam(ftString, 'name', ptInput).AsString := 'Name';
    Plan := ParseDBParadoxDML(
      'INSERT INTO T (ID, Name) VALUES (:id, :name)');
    try
      PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, nil);
      Fail('INSERT must provide every table field.');
    except
      on E: EDBParadoxDMLValidationError do ;
    end;

    Params.Clear;
    Params.CreateParam(ftInteger, 'id', ptInput).AsInteger := 1;
    Plan := ParseDBParadoxDML('UPDATE T SET ID = :id WHERE ID = :id');
    try
      PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, ['1', '', '0']);
      Fail('UPDATE must reject primary-key assignments.');
    except
      on E: EDBParadoxDMLValidationError do ;
    end;

    Plan := ParseDBParadoxDML('DELETE FROM T WHERE Count = :id');
    try
      PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, nil);
      Fail('DELETE must target the primary-key field.');
    except
      on E: EDBParadoxDMLValidationError do ;
    end;
  finally
    Params.Free;
  end;
end;

procedure TTestDBParadoxDMLExecutor.
  RejectsWrongTypesUnusedParamsAndMalformedFields;
var
  Params: TParams;
  Plan: TDBParadoxDMLPlan;
  FieldsValue: TDBParadoxRecordFields;
begin
  FieldsValue := Fields;
  Params := NewParams;
  try
    Params.CreateParam(ftString, 'id', ptInput).AsString := '1';
    Params.CreateParam(ftString, 'name', ptInput).AsString := 'Name';
    Params.CreateParam(ftInteger, 'count', ptInput).AsInteger := 0;
    Plan := ParseDBParadoxDML(
      'INSERT INTO T (ID, Name, Count) VALUES (:id, :name, :count)');
    try
      PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, nil);
      Fail('A Long field must reject string parameters.');
    except
      on E: EDBParadoxDMLValidationError do ;
    end;

    Params.Clear;
    Params.CreateParam(ftInteger, 'id', ptInput).AsInteger := 1;
    Params.CreateParam(ftString, 'name', ptInput).AsString := 'Name';
    Params.CreateParam(ftInteger, 'count', ptInput).AsInteger := 0;
    Params.CreateParam(ftInteger, 'unused', ptInput).AsInteger := 99;
    try
      PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, nil);
      Fail('Unused parameters must be rejected.');
    except
      on E: EDBParadoxDMLValidationError do ;
    end;

    Params.Clear;
    Params.CreateParam(ftInteger, 'id', ptInput).AsLargeInt :=
      Int64(High(LongInt)) + 1;
    Params.CreateParam(ftString, 'name', ptInput).AsString := 'Name';
    Params.CreateParam(ftInteger, 'count', ptInput).AsInteger := 0;
    try
      PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, nil);
      Fail('Out-of-range Long values must be rejected.');
    except
      on E: EDBParadoxDMLValidationError do ;
    end;

    Params.Clear;
    Params.CreateParam(ftInteger, 'id', ptInput).AsInteger := 1;
    Params.CreateParam(ftString, 'name', ptInput).AsString := 'Name ';
    Params.CreateParam(ftInteger, 'count', ptInput).AsInteger := 0;
    try
      PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, nil);
      Fail('Alpha values with trailing spaces must be rejected.');
    except
      on E: EDBParadoxDMLValidationError do ;
    end;

    Params.Clear;
    Params.CreateParam(ftInteger, 'id', ptInput).AsInteger := 1;
    Params.CreateParam(ftString, 'name', ptInput).AsString := 'Name';
    Params.CreateParam(ftInteger, 'count', ptInput).AsInteger := 0;
    FieldsValue[2].TypeCode := $03;
    try
      PrepareDBParadoxDML(Plan, FieldsValue, 0, Params, nil);
      Fail('Unsupported field types must be rejected.');
    except
      on E: EDBParadoxDMLValidationError do ;
    end;
  finally
    Params.Free;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxDMLExecutor);

end.
