unit tst_AHW52_ParentSelectionTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52ParentSelection = class(TTestCase)
  published
    procedure TestCaseUppercaseMAssignsFather;
    procedure TestCaseUppercaseWAssignsMother;
    procedure TestCaseOtherGenderValuesDoNotAssign;
    procedure TestCaseNilDataSetIsRejected;
  end;

implementation

uses
  DB, MemDS, ParentSelectionBehavior, SysUtils;

function CreateSyntheticPerson: TMemDataset;
begin
  Result := TMemDataset.Create(nil);
  Result.FieldDefs.Add('NUMMER', ftInteger);
  Result.FieldDefs.Add('VATER', ftInteger);
  Result.FieldDefs.Add('MUTTER', ftInteger);
  Result.CreateTable;
  Result.Open;
  Result.AppendRecord([1001, 2001, 3001]);
  Result.First;
end;

procedure AssertEqual(const Description: string; const Expected,
  Actual: Integer);
begin
  if Expected <> Actual then
    raise Exception.CreateFmt('%s: expected %d, got %d.',
      [Description, Expected, Actual]);
end;

procedure TestUppercaseMAssignsFather;
var
  DataSet: TMemDataset;
begin
  DataSet := CreateSyntheticPerson;
  try
    if not ApplySelectedParent(DataSet, 'M', 4001) then
      raise Exception.Create('Uppercase M was not recognized.');

    AssertEqual('Father reference', 4001,
      DataSet.FieldByName('VATER').AsInteger);
    AssertEqual('Mother reference remains unchanged', 3001,
      DataSet.FieldByName('MUTTER').AsInteger);
    AssertEqual('Parent edit remains unposted', Ord(dsEdit),
      Ord(DataSet.State));
  finally
    DataSet.Free;
  end;
end;

procedure TestUppercaseWAssignsMother;
var
  DataSet: TMemDataset;
begin
  DataSet := CreateSyntheticPerson;
  try
    if not ApplySelectedParent(DataSet, 'W', 5001) then
      raise Exception.Create('Uppercase W was not recognized.');

    AssertEqual('Father reference remains unchanged', 2001,
      DataSet.FieldByName('VATER').AsInteger);
    AssertEqual('Mother reference', 5001,
      DataSet.FieldByName('MUTTER').AsInteger);
    AssertEqual('Parent edit remains unposted', Ord(dsEdit),
      Ord(DataSet.State));
  finally
    DataSet.Free;
  end;
end;

procedure TestOtherGenderValuesDoNotAssign;
var
  DataSet: TMemDataset;
  Gender: string;
begin
  DataSet := CreateSyntheticPerson;
  try
    for Gender in ['', 'm', 'w', 'X'] do
    begin
      if ApplySelectedParent(DataSet, Gender, 6001) then
        raise Exception.CreateFmt('Unexpectedly accepted gender "%s".',
          [Gender]);
      AssertEqual('Father reference remains unchanged', 2001,
        DataSet.FieldByName('VATER').AsInteger);
      AssertEqual('Mother reference remains unchanged', 3001,
        DataSet.FieldByName('MUTTER').AsInteger);
    end;

    AssertEqual('Edit state matches the listing before role comparison',
      Ord(dsEdit), Ord(DataSet.State));
  finally
    DataSet.Free;
  end;
end;

procedure TestNilDataSetIsRejected;
var
  Raised: Boolean;
begin
  Raised := False;
  try
    ApplySelectedParent(nil, 'M', 4001);
  except
    on E: EArgumentNilException do
      Raised := True;
  end;

  if not Raised then
    raise Exception.Create('Nil current-person dataset was accepted.');
end;

procedure TTestAHW52ParentSelection.TestCaseUppercaseMAssignsFather;
begin
  TestUppercaseMAssignsFather;
end;

procedure TTestAHW52ParentSelection.TestCaseUppercaseWAssignsMother;
begin
  TestUppercaseWAssignsMother;
end;

procedure TTestAHW52ParentSelection.TestCaseOtherGenderValuesDoNotAssign;
begin
  TestOtherGenderValuesDoNotAssign;
end;

procedure TTestAHW52ParentSelection.TestCaseNilDataSetIsRejected;
begin
  TestNilDataSetIsRejected;
end;

initialization
  RegisterTest(TTestAHW52ParentSelection);

end.
