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
    procedure TestCaseRepeatedParentReferencesRemainOnChildRows;
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

function CreateSyntheticFamily: TMemDataset;
begin
  Result := TMemDataset.Create(nil);
  Result.FieldDefs.Add('NUMMER', ftInteger);
  Result.FieldDefs.Add('VATER', ftInteger);
  Result.FieldDefs.Add('MUTTER', ftInteger);
  Result.CreateTable;
  Result.Open;
  Result.AppendRecord([100, 0, 0]);
  Result.AppendRecord([200, 0, 0]);
  Result.AppendRecord([301, 0, 0]);
  Result.AppendRecord([302, 0, 0]);
  Result.AppendRecord([303, 0, 0]);
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

procedure TTestAHW52ParentSelection.
  TestCaseRepeatedParentReferencesRemainOnChildRows;
var
  DataSet: TMemDataset;
  ChildCount: Integer;
  FatherReferenceCount: Integer;
  MotherReferenceCount: Integer;
begin
  DataSet := CreateSyntheticFamily;
  try
    DataSet.First;
    while not DataSet.EOF do
    begin
      if DataSet.FieldByName('NUMMER').AsInteger >= 301 then
      begin
        ApplySelectedParent(DataSet, 'M', 100);
        DataSet.Post;
        ApplySelectedParent(DataSet, 'W', 200);
        DataSet.Post;
      end;
      DataSet.Next;
    end;

    ChildCount := 0;
    FatherReferenceCount := 0;
    MotherReferenceCount := 0;
    DataSet.First;
    while not DataSet.EOF do
    begin
      if DataSet.FieldByName('NUMMER').AsInteger >= 301 then
      begin
        Inc(ChildCount);
        if DataSet.FieldByName('VATER').AsInteger = 100 then
          Inc(FatherReferenceCount);
        if DataSet.FieldByName('MUTTER').AsInteger = 200 then
          Inc(MotherReferenceCount);
      end
      else if (DataSet.FieldByName('VATER').AsInteger <> 0) or
        (DataSet.FieldByName('MUTTER').AsInteger <> 0) then
        Fail('Parent selection changed a referenced parent row.');
      DataSet.Next;
    end;

    AssertEquals('Synthetic child rows', 3, ChildCount);
    AssertEquals('Children sharing the father reference', 3,
      FatherReferenceCount);
    AssertEquals('Children sharing the mother reference', 3,
      MotherReferenceCount);
  finally
    DataSet.Free;
  end;
end;

procedure TTestAHW52ParentSelection.TestCaseNilDataSetIsRejected;
begin
  TestNilDataSetIsRejected;
end;

initialization
  RegisterTest(TTestAHW52ParentSelection);

end.
