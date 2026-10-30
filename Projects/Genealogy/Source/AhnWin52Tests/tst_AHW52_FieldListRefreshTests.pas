unit tst_AHW52_FieldListRefreshTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52FieldListRefresh = class(TTestCase)
  published
    procedure TestPositiveValuesPopulateListsAndClearStaleItems;
    procedure TestEmptyDatasetsProduceEmptyLists;
    procedure TestInvalidIntegerValuePropagatesInOrder;
  end;

implementation

uses
  BufDataset, Classes, Controls, DB, Forms, StdCtrls, SysUtils, OrtsfamilienbuchOptionsForm;

type
  TSyntheticValuesDataSet = class(TBufDataset)
  protected
    procedure LoadBlobIntoBuffer(FieldDef: TFieldDef;
      ABlobBuf: PBufBlobField); override;
  end;

procedure TSyntheticValuesDataSet.LoadBlobIntoBuffer(FieldDef: TFieldDef;
  ABlobBuf: PBufBlobField);
begin
  if ABlobBuf = nil then
    raise Exception.Create('The synthetic blob buffer is missing.');
  raise Exception.CreateFmt('Blob field %s is unsupported in this fixture.',
    [FieldDef.Name]);
end;

function CreateSyntheticValues: TSyntheticValuesDataSet;
begin
  Result := TSyntheticValuesDataSet.Create(nil);
  Result.FieldDefs.Add('VALUE', ftString, 20);
  Result.CreateDataset;
end;

procedure AddListBox(FieldListForm: TOrtsfamilienbuchOptionsForm; var ListBox: TListBox);
begin
  ListBox := TListBox.Create(FieldListForm);
  ListBox.Parent := FieldListForm;
end;

function CreateFieldListForm: TOrtsfamilienbuchOptionsForm;
begin
  Result := TOrtsfamilienbuchOptionsForm.CreateNew(nil);
  AddListBox(Result, Result.ListBox1);
  AddListBox(Result, Result.ListBox2);
  AddListBox(Result, Result.ListBox3);
  AddListBox(Result, Result.ListBox4);
  AddListBox(Result, Result.ListBox5);
  AddListBox(Result, Result.ListBox6);
end;

procedure SeedAllLists(FieldListForm: TOrtsfamilienbuchOptionsForm);
begin
  FieldListForm.ListBox1.Items.Add('stale');
  FieldListForm.ListBox2.Items.Add('stale');
  FieldListForm.ListBox3.Items.Add('stale');
  FieldListForm.ListBox4.Items.Add('stale');
  FieldListForm.ListBox5.Items.Add('stale');
  FieldListForm.ListBox6.Items.Add('stale');
end;

procedure TTestAHW52FieldListRefresh.
  TestPositiveValuesPopulateListsAndClearStaleItems;
var
  fieldListForm: TOrtsfamilienbuchOptionsForm;
  nameDataSet: TSyntheticValuesDataSet;
  locationDataSet: TSyntheticValuesDataSet;
  houseNameDataSet: TSyntheticValuesDataSet;
begin
  fieldListForm := CreateFieldListForm;
  nameDataSet := CreateSyntheticValues;
  locationDataSet := CreateSyntheticValues;
  houseNameDataSet := CreateSyntheticValues;
  try
    SeedAllLists(fieldListForm);
    nameDataSet.AppendRecord(['3']);
    nameDataSet.AppendRecord(['0']);
    nameDataSet.AppendRecord(['-2']);
    nameDataSet.AppendRecord(['25']);
    locationDataSet.AppendRecord(['1']);
    locationDataSet.AppendRecord(['44']);
    houseNameDataSet.AppendRecord(['0']);
    houseNameDataSet.AppendRecord(['7']);

    RefreshFieldLists(fieldListForm,
      nameDataSet, nameDataSet.FieldByName('VALUE'),
      locationDataSet, locationDataSet.FieldByName('VALUE'),
      houseNameDataSet, houseNameDataSet.FieldByName('VALUE'));

    AssertEquals(2, fieldListForm.ListBox1.Items.Count);
    AssertEquals('3', fieldListForm.ListBox1.Items[0]);
    AssertEquals('25', fieldListForm.ListBox1.Items[1]);
    AssertEquals(2, fieldListForm.ListBox2.Items.Count);
    AssertEquals('1', fieldListForm.ListBox2.Items[0]);
    AssertEquals('44', fieldListForm.ListBox2.Items[1]);
    AssertEquals(0, fieldListForm.ListBox3.Items.Count);
    AssertEquals(0, fieldListForm.ListBox4.Items.Count);
    AssertEquals(1, fieldListForm.ListBox5.Items.Count);
    AssertEquals('7', fieldListForm.ListBox5.Items[0]);
    AssertEquals(0, fieldListForm.ListBox6.Items.Count);
    AssertTrue(nameDataSet.EOF);
    AssertTrue(locationDataSet.EOF);
    AssertTrue(houseNameDataSet.EOF);
  finally
    fieldListForm.Free;
    nameDataSet.Free;
    locationDataSet.Free;
    houseNameDataSet.Free;
  end;
end;

procedure TTestAHW52FieldListRefresh.TestEmptyDatasetsProduceEmptyLists;
var
  fieldListForm: TOrtsfamilienbuchOptionsForm;
  nameDataSet: TSyntheticValuesDataSet;
  locationDataSet: TSyntheticValuesDataSet;
  houseNameDataSet: TSyntheticValuesDataSet;
begin
  fieldListForm := CreateFieldListForm;
  nameDataSet := CreateSyntheticValues;
  locationDataSet := CreateSyntheticValues;
  houseNameDataSet := CreateSyntheticValues;
  try
    SeedAllLists(fieldListForm);

    RefreshFieldLists(fieldListForm,
      nameDataSet, nameDataSet.FieldByName('VALUE'),
      locationDataSet, locationDataSet.FieldByName('VALUE'),
      houseNameDataSet, houseNameDataSet.FieldByName('VALUE'));

    AssertEquals(0, fieldListForm.ListBox1.Items.Count);
    AssertEquals(0, fieldListForm.ListBox2.Items.Count);
    AssertEquals(0, fieldListForm.ListBox3.Items.Count);
    AssertEquals(0, fieldListForm.ListBox4.Items.Count);
    AssertEquals(0, fieldListForm.ListBox5.Items.Count);
    AssertEquals(0, fieldListForm.ListBox6.Items.Count);
    AssertTrue(nameDataSet.EOF);
    AssertTrue(locationDataSet.EOF);
    AssertTrue(houseNameDataSet.EOF);
  finally
    fieldListForm.Free;
    nameDataSet.Free;
    locationDataSet.Free;
    houseNameDataSet.Free;
  end;
end;

procedure TTestAHW52FieldListRefresh.TestInvalidIntegerValuePropagatesInOrder;
var
  fieldListForm: TOrtsfamilienbuchOptionsForm;
  nameDataSet: TSyntheticValuesDataSet;
  locationDataSet: TSyntheticValuesDataSet;
  houseNameDataSet: TSyntheticValuesDataSet;
  conversionRejected: Boolean;
begin
  fieldListForm := CreateFieldListForm;
  nameDataSet := CreateSyntheticValues;
  locationDataSet := CreateSyntheticValues;
  houseNameDataSet := CreateSyntheticValues;
  try
    SeedAllLists(fieldListForm);
    nameDataSet.AppendRecord(['not-an-integer']);
    locationDataSet.Close;
    houseNameDataSet.Close;
    conversionRejected := False;

    try
      RefreshFieldLists(fieldListForm,
        nameDataSet, nameDataSet.FieldByName('VALUE'),
        locationDataSet, locationDataSet.FieldByName('VALUE'),
        houseNameDataSet, houseNameDataSet.FieldByName('VALUE'));
    except
      on E: EConvertError do
        conversionRejected := True;
    end;

    AssertTrue('Invalid integer conversion must propagate.', conversionRejected);
    AssertTrue('ListBox1 should have been cleared.',
      fieldListForm.ListBox1.Items.Count = 0);
    AssertTrue('ListBox2 should have been cleared.',
      fieldListForm.ListBox2.Items.Count = 0);
    AssertTrue('ListBox3 should have been cleared.',
      fieldListForm.ListBox3.Items.Count = 0);
    AssertTrue('ListBox4 should have been cleared.',
      fieldListForm.ListBox4.Items.Count = 0);
    AssertTrue('ListBox5 should have been cleared.',
      fieldListForm.ListBox5.Items.Count = 0);
    AssertTrue('ListBox6 should have been cleared.',
      fieldListForm.ListBox6.Items.Count = 0);
    AssertTrue('Failed conversion should leave the source row current.',
      not nameDataSet.EOF);
    AssertTrue('Later datasets must not be opened after the first failure.',
      not locationDataSet.Active and not houseNameDataSet.Active);
  finally
    fieldListForm.Free;
    nameDataSet.Free;
    locationDataSet.Free;
    houseNameDataSet.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52FieldListRefresh);

end.
