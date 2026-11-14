unit tst_DBParadoxIndexFileBuilder;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxConformanceVectors, DBParadoxIndexFileBuilder,
  fpcunit, testregistry;

type
  TTestDBParadoxIndexFileBuilder = class(TTestCase)
  private
    function EmptyPrimaryIndexTemplate: TBytes;
    function MakeEntry(Key0, Key1: Byte; BlockNumber, RecordCount: Integer):
      TDBParadoxIndexEntry;
  published
    procedure BuildsSingleLevelPrimaryIndexGoldenVector;
    procedure BuildsMultipleIndexLevels;
    procedure ChecksWideKeyCapacityBoundary;
    procedure RejectsNonEmptyAndEncryptedTemplates;
    procedure RejectsInvalidEntries;
  end;

implementation

function TTestDBParadoxIndexFileBuilder.EmptyPrimaryIndexTemplate: TBytes;
begin
  Result := nil;
  SetLength(Result, $800);
  Result[0] := 8;
  Result[2] := 0;
  Result[3] := 8;
  Result[4] := 1;
  Result[5] := 2;
  Result[$21] := 1;
  Result[$58] := $01;
  Result[$59] := 2;
end;

function TTestDBParadoxIndexFileBuilder.MakeEntry(Key0, Key1: Byte;
  BlockNumber, RecordCount: Integer): TDBParadoxIndexEntry;
begin
  Result.Key := nil;
  SetLength(Result.Key, 2);
  Result.Key[0] := Key0;
  Result.Key[1] := Key1;
  Result.DataBlockNumber := BlockNumber;
  Result.DataRecordCount := RecordCount;
end;

procedure TTestDBParadoxIndexFileBuilder.BuildsSingleLevelPrimaryIndexGoldenVector;
var
  Template, Built: TBytes;
  Entries: TDBParadoxIndexEntries;
  BlockOffset: SizeInt;
  ExpectedFirstRecord, ExpectedSecondRecord: TBytes;
begin
  Template := EmptyPrimaryIndexTemplate;
  Entries := nil;
  SetLength(Entries, 2);
  Entries[0] := MakeEntry($80, $01, 1, 2);
  Entries[1] := MakeEntry($80, $02, 2, 3);
  ExpectedFirstRecord := DecodeDBParadoxHex(
    ReadDBParadoxVector('index-record-one'));
  ExpectedSecondRecord := DecodeDBParadoxHex(
    ReadDBParadoxVector('index-record-two'));

  Built := BuildDBParadoxIndexFile(Template, 1, Entries);

  CheckEquals($1000, Length(Built));
  CheckEquals(2, Built[6]);
  CheckEquals(1, Built[$0A]);
  CheckEquals(1, Built[$0C]);
  CheckEquals(1, Built[$1E]);
  CheckEquals(1, Built[$20]);
  BlockOffset := $800;
  CheckEquals(0, Built[BlockOffset]);
  CheckEquals(0, Built[BlockOffset + 1]);
  CheckEquals(8, Built[BlockOffset + 4]);
  CheckEquals(0, CompareByte(
    Built[BlockOffset + 6], ExpectedFirstRecord[0],
    Length(ExpectedFirstRecord)));
  CheckEquals(0, CompareByte(
    Built[BlockOffset + 14], ExpectedSecondRecord[0],
    Length(ExpectedSecondRecord)));
end;

procedure TTestDBParadoxIndexFileBuilder.BuildsMultipleIndexLevels;
var
  Template, Built: TBytes;
  Entries: TDBParadoxIndexEntries;
  Index: Integer;
  RootOffset: SizeInt;
begin
  Template := EmptyPrimaryIndexTemplate;
  Entries := nil;
  SetLength(Entries, 260);
  for Index := 0 to High(Entries) do
    Entries[Index] := MakeEntry(
      Byte(Index shr 8), Byte(Index), Index + 1, 1);

  Built := BuildDBParadoxIndexFile(Template, 1, Entries);

  CheckEquals($800 + 3 * $800, Length(Built));
  CheckEquals(262, Built[6] + (Built[7] shl 8));
  CheckEquals(3, Built[$0C]);
  CheckEquals(3, Built[$1E]);
  CheckEquals(2, Built[$20]);
  RootOffset := $800 + 2 * $800;
  CheckEquals(0, Built[RootOffset]);
  CheckEquals(2, Built[RootOffset + 2]);
  CheckEquals(8, Built[RootOffset + 4]);
  CheckEquals($80, Built[RootOffset + 6 + 2]);
  CheckEquals($01, Built[RootOffset + 6 + 3]);
  CheckEquals($80, Built[RootOffset + 6 + 4]);
  CheckEquals(130, Built[RootOffset + 6 + 5]);
end;

procedure TTestDBParadoxIndexFileBuilder.ChecksWideKeyCapacityBoundary;
const
  WideIndexRecordSize = 40;
  WideKeyLength = WideIndexRecordSize - 6;
  EntriesPerBlock = (2 * 1024 - 6) div WideIndexRecordSize;
var
  Template, Built: TBytes;
  Entries: TDBParadoxIndexEntries;
  Index: Integer;
begin
  Template := EmptyPrimaryIndexTemplate;
  Template[0] := WideIndexRecordSize;
  Template[1] := 0;
  Template[$59] := WideKeyLength;

  Entries := nil;
  SetLength(Entries, EntriesPerBlock);
  for Index := 0 to High(Entries) do
  begin
    Entries[Index].Key := nil;
    SetLength(Entries[Index].Key, WideKeyLength);
    Entries[Index].Key[0] := Byte(Index shr 8);
    Entries[Index].Key[1] := Byte(Index);
    Entries[Index].DataBlockNumber := Index + 1;
    Entries[Index].DataRecordCount := 1;
  end;

  Built := BuildDBParadoxIndexFile(Template, 1, Entries);
  CheckEquals(1, Built[$0C]);
  CheckEquals(1, Built[$20]);
  CheckEquals($1000, Length(Built));

  SetLength(Entries, EntriesPerBlock + 1);
  Index := High(Entries);
  Entries[Index].Key := nil;
  SetLength(Entries[Index].Key, WideKeyLength);
  Entries[Index].Key[0] := Byte(Index shr 8);
  Entries[Index].Key[1] := Byte(Index);
  Entries[Index].DataBlockNumber := Index + 1;
  Entries[Index].DataRecordCount := 1;

  Built := BuildDBParadoxIndexFile(Template, 1, Entries);
  CheckEquals(3, Built[$0C]);
  CheckEquals(2, Built[$20]);
  CheckEquals(3, Built[$1E]);
  CheckEquals(54, Built[6] + (Built[7] shl 8));
  CheckEquals($800 + 3 * $800, Length(Built));
end;

procedure TTestDBParadoxIndexFileBuilder.RejectsNonEmptyAndEncryptedTemplates;
var
  Template: TBytes;
  Entries: TDBParadoxIndexEntries;
begin
  Template := EmptyPrimaryIndexTemplate;
  Entries := nil;
  SetLength(Entries, 1);
  Entries[0] := MakeEntry($80, $01, 1, 1);

  Template[6] := 1;
  try
    BuildDBParadoxIndexFile(Template, 1, Entries);
    Fail('Expected a non-empty template to be rejected.');
  except
    on E: EDBParadoxIndexBuildError do ;
  end;

  Template := EmptyPrimaryIndexTemplate;
  Template[$25] := $01;
  try
    BuildDBParadoxIndexFile(Template, 1, Entries);
    Fail('Expected an encrypted template to be rejected.');
  except
    on E: EDBParadoxUnsupportedIndexFeature do ;
  end;
end;

procedure TTestDBParadoxIndexFileBuilder.RejectsInvalidEntries;
var
  Template: TBytes;
  Entries: TDBParadoxIndexEntries;
begin
  Template := EmptyPrimaryIndexTemplate;
  Entries := nil;
  SetLength(Entries, 1);
  Entries[0] := MakeEntry($80, $01, 0, 1);
  try
    BuildDBParadoxIndexFile(Template, 1, Entries);
    Fail('Expected an invalid data-block number to be rejected.');
  except
    on E: EDBParadoxIndexBuildError do ;
  end;

  Entries[0] := MakeEntry($80, $01, 1, 0);
  try
    BuildDBParadoxIndexFile(Template, 1, Entries);
    Fail('Expected a zero record count to be rejected.');
  except
    on E: EDBParadoxIndexBuildError do ;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxIndexFileBuilder);

end.
