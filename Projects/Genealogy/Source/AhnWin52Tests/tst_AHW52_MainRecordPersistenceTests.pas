unit tst_AHW52_MainRecordPersistenceTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52MainRecordPersistence = class(TTestCase)
  published
    procedure TestCaseEmptyRecordDeletion;
    procedure TestCasePersonNumberLookup;
    procedure TestCaseInsertOutcomes;
    procedure TestCaseNilDatasetRejected;
  end;

implementation

uses
  SysUtils, DB, MemDS, MainRecordPersistenceBehavior;

procedure AssertBoolean(const Description: string;
  const Expected, Actual: Boolean);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected %s, got %s.',
      [Description, BoolToStr(Expected, True), BoolToStr(Actual, True)]);
end;

procedure AssertRecordCount(const Description: string;
  const Expected, Actual: Integer);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected %d records, got %d.',
      [Description, Expected, Actual]);
end;

procedure AssertInteger(const Description: string;
  const Expected, Actual: Integer);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected %d, got %d.',
      [Description, Expected, Actual]);
end;

procedure TestEmptyRecordDeletion;
var
  DataSet: TMemDataset;
begin
  DataSet := TMemDataset.Create(nil);
  try
    DataSet.FieldDefs.Add('Nummer', ftInteger);
    DataSet.FieldDefs.Add('Name', ftString, 45);
    DataSet.FieldDefs.Add('Vornamen', ftString, 45);
    DataSet.CreateTable;
    DataSet.Open;

    DataSet.AppendRecord([1, 'Example', 'Ada']);
    DataSet.AppendRecord([2, '', '']);
    AssertBoolean('Empty browse person handled',
      True, DeleteEmptyPersonRecordIfNeeded(DataSet, '', ''));
    AssertRecordCount('Empty browse person deleted', 1,
      DataSet.RecordCount);

    DataSet.Append;
    DataSet.FieldByName('Nummer').AsInteger := 2;
    AssertBoolean('Inserted blank person handled',
      True, DeleteEmptyPersonRecordIfNeeded(DataSet, '', ''));
    AssertRecordCount('Inserted blank person deleted', 1,
      DataSet.RecordCount);

    DataSet.Edit;
    DataSet.FieldByName('Name').AsString := '';
    DataSet.FieldByName('Vornamen').AsString := '';
    AssertBoolean('Edited blank person handled',
      True, DeleteEmptyPersonRecordIfNeeded(DataSet, '', ''));
    AssertRecordCount('Edited blank person deleted', 0,
      DataSet.RecordCount);

    DataSet.Append;
    DataSet.FieldByName('Nummer').AsInteger := 3;
    DataSet.FieldByName('Name').AsString := 'Example';
    AssertBoolean('Named person left untouched',
      False, DeleteEmptyPersonRecordIfNeeded(DataSet, 'Example', ''));
    DataSet.Cancel;
    AssertRecordCount('Existing records preserved', 0, DataSet.RecordCount);
  finally
    DataSet.Free;
  end;
end;

procedure TestPersonNumberLookup;
var
  DataSet: TMemDataset;
begin
  DataSet := TMemDataset.Create(nil);
  try
    DataSet.FieldDefs.Add('Nummer', ftInteger);
    DataSet.CreateTable;
    DataSet.Open;
    DataSet.AppendRecord([41]);
    DataSet.AppendRecord([42]);
    DataSet.First;

    AssertBoolean('Existing person number found',
      True, PersonNumberExists(DataSet, 42));
    AssertInteger('Lookup positions on matching person', 42,
      DataSet.FieldByName('Nummer').AsInteger);
    AssertBoolean('Missing person number rejected',
      False, PersonNumberExists(DataSet, 99));
  finally
    DataSet.Free;
  end;
end;

procedure TestInsertOutcomes;
var
  PersonDataSet, NumberLookupDataSet: TMemDataset;
begin
  PersonDataSet := TMemDataset.Create(nil);
  NumberLookupDataSet := TMemDataset.Create(nil);
  try
    PersonDataSet.FieldDefs.Add('Nummer', ftInteger);
    PersonDataSet.FieldDefs.Add('Name', ftString, 45);
    PersonDataSet.CreateTable;
    PersonDataSet.Open;

    NumberLookupDataSet.FieldDefs.Add('Nummer', ftInteger);
    NumberLookupDataSet.CreateTable;
    NumberLookupDataSet.Open;
    NumberLookupDataSet.AppendRecord([41]);

    PersonDataSet.Append;
    PersonDataSet.FieldByName('Nummer').AsInteger := 41;
    PersonDataSet.FieldByName('Name').AsString := 'Duplicate';
    if PostPersonIfNumberAvailable(PersonDataSet, NumberLookupDataSet, 41) <>
      pioDuplicateNumber then
      raise Exception.Create('Duplicate person number was not rejected.');
    AssertInteger('Duplicate lookup positions on matching number', 41,
      NumberLookupDataSet.FieldByName('Nummer').AsInteger);
    if PersonDataSet.State <> dsInsert then
      raise Exception.Create('Duplicate row was unexpectedly posted.');
    PersonDataSet.Cancel;

    PersonDataSet.Append;
    PersonDataSet.FieldByName('Nummer').AsInteger := 42;
    PersonDataSet.FieldByName('Name').AsString := 'New person';
    if PostPersonIfNumberAvailable(PersonDataSet, NumberLookupDataSet, 42) <>
      pioPosted then
      raise Exception.Create('Unique person number was not posted.');
    AssertRecordCount('Unique person row posted', 1,
      PersonDataSet.RecordCount);

    if PostPersonIfNumberAvailable(PersonDataSet, nil, 43) <> pioNoAction then
      raise Exception.Create('Non-insert dataset was not ignored.');
  finally
    PersonDataSet.Free;
    NumberLookupDataSet.Free;
  end;
end;

procedure TestNilDatasetRejected;
begin
  try
    PersonNumberExists(nil, 1);
    raise Exception.Create('Nil dataset was accepted.');
  except
    on E: EArgumentNilException do
      ;
  end;

  try
    DeleteEmptyPersonRecordIfNeeded(nil, '', '');
    raise Exception.Create('Nil person dataset was accepted.');
  except
    on E: EArgumentNilException do
      ;
  end;

  try
    PostPersonIfNumberAvailable(nil, nil, 1);
    raise Exception.Create('Nil insert dataset was accepted.');
  except
    on E: EArgumentNilException do
      ;
  end;
end;

procedure TTestAHW52MainRecordPersistence.TestCaseEmptyRecordDeletion;
begin
    TestEmptyRecordDeletion;
end;

procedure TTestAHW52MainRecordPersistence.TestCasePersonNumberLookup;
begin
    TestPersonNumberLookup;
end;

procedure TTestAHW52MainRecordPersistence.TestCaseInsertOutcomes;
begin
    TestInsertOutcomes;
end;

procedure TTestAHW52MainRecordPersistence.TestCaseNilDatasetRejected;
begin
    TestNilDatasetRejected;
end;

initialization
  RegisterTest(TTestAHW52MainRecordPersistence);

end.
