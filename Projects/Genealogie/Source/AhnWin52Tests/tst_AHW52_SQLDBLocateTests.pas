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
  end;

implementation

uses
  BufDataset, DB, SysUtils;

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

initialization
  RegisterTest(TTestAHW52SQLDBLocate);

end.
