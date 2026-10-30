unit tst_AHW52_Unit3RegisterRowsTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit3RegisterRows = class(TTestCase)
  published
    procedure TestNameRegisterFiltersNNAndGroupsMatchingKeys;
    procedure TestPlaceRegisterKeepsNNAndComparesRawKeys;
    procedure TestEmptyOrMalformedEntriesProduceNoRows;
    procedure TestNilEntriesAreRejected;
  end;

implementation

uses
  Classes, SysUtils, DB, BufDataset, Unit3RegisterRows,
  Unit15Table22Rows;

procedure TTestAHW52Unit3RegisterRows.
  TestNameRegisterFiltersNNAndGroupsMatchingKeys;
var
  entries: TStringList;
  rows: TBufDataset;
  reportRows: TBufDataset;
begin
  entries := TStringList.Create;
  rows := nil;
  reportRows := nil;
  try
    entries.Add('A' + #15 + ' Alpha ');
    entries.Add('A' + #15 + 'Beta');
    entries.Add('NN' + #15 + 'Ignored number');
    entries.Add('B' + #15 + 'Bravo');
    entries.Add('  ' + #15 + 'Blank key');
    entries.Add('B' + #15 + '   ');
    entries.Add('No separator');

    rows := CreateUnit3RegisterRows(entries, urkNameRegister);
    AssertEquals('The skipped entries do not create output rows.', 2,
      rows.RecordCount);
    AssertEquals('The first key is retained.', 'A',
      rows.FieldByName('No').AsString);
    AssertEquals('Matching keys append trimmed text in order.',
      'Alpha, Beta', rows.FieldByName('Zus').AsString);
    rows.Next;
    AssertEquals('The next distinct key starts the next output row.', 'B',
      rows.FieldByName('No').AsString);
    AssertEquals('The next row retains its own text.', 'Bravo',
      rows.FieldByName('Zus').AsString);
    AssertEquals('The table schema matches streamed Table22 fields.',
      Ord(ftMemo), Ord(rows.FieldByName('Zus').DataType));
    reportRows := CreateUnit15Table22Rows(rows);
    AssertEquals('The register output maps into the Unit15 memo field.',
      'Alpha, Beta', reportRows.FieldByName('QRDBText1').AsString);
    AssertEquals('The register key maps into the second report field.',
      'A', reportRows.FieldByName('QRDBText2').AsString);
  finally
    reportRows.Free;
    rows.Free;
    entries.Free;
  end;
end;

procedure TTestAHW52Unit3RegisterRows.
  TestPlaceRegisterKeepsNNAndComparesRawKeys;
var
  entries: TStringList;
  rows: TBufDataset;
begin
  entries := TStringList.Create;
  rows := nil;
  try
    entries.Add('NN' + #15 + 'Unknown number');
    entries.Add('X' + #15 + 'First X');
    entries.Add('X' + #15 + 'Second X');
    entries.Add(' X' + #15 + 'Leading-space key');
    entries.Add('X' + #15 + 'Third X');

    rows := CreateUnit3RegisterRows(entries, urkPlaceRegister);
    AssertEquals('The place register does not filter NN.', 4,
      rows.RecordCount);
    AssertEquals('NN is kept as the first key.', 'NN',
      rows.FieldByName('No').AsString);
    rows.Next;
    AssertEquals('The raw X key begins a separate row.', 'X',
      rows.FieldByName('No').AsString);
    AssertEquals('Only contiguous identical raw keys are combined.',
      'First X, Second X', rows.FieldByName('Zus').AsString);
    rows.Next;
    AssertEquals('Leading spaces are retained in the key value.', ' X',
      rows.FieldByName('No').AsString);
    rows.Next;
    AssertEquals('A later X after another key starts a new group.', 'X',
      rows.FieldByName('No').AsString);
    AssertEquals('The later X starts a fresh value group.', 'Third X',
      rows.FieldByName('Zus').AsString);
  finally
    rows.Free;
    entries.Free;
  end;
end;

procedure TTestAHW52Unit3RegisterRows.
  TestEmptyOrMalformedEntriesProduceNoRows;
var
  entries: TStringList;
  rows: TBufDataset;
begin
  entries := TStringList.Create;
  rows := nil;
  try
    entries.Add('No separator');
    entries.Add(#15 + 'No key');
    entries.Add('No value' + #15 + '   ');

    rows := CreateUnit3RegisterRows(entries, urkNameRegister);
    AssertEquals('No valid register entries produce no rows.', 0,
      rows.RecordCount);
    AssertEquals('The empty dataset keeps both Table22 fields.', 2,
      rows.FieldCount);
  finally
    rows.Free;
    entries.Free;
  end;
end;

procedure TTestAHW52Unit3RegisterRows.TestNilEntriesAreRejected;
var
  rejected: Boolean;
begin
  rejected := False;
  try
    CreateUnit3RegisterRows(nil, urkNameRegister).Free;
  except
    on E: EArgumentNilException do
      rejected := E.Message = 'AEntries';
  end;
  AssertTrue('A nil string list is rejected explicitly.', rejected);
end;

initialization
  RegisterTest(TTestAHW52Unit3RegisterRows);

end.
