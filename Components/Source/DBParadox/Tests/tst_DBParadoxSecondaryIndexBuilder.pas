unit tst_DBParadoxSecondaryIndexBuilder;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  SysUtils, DBParadoxSecondaryIndexBuilder, DBParadoxRecordEncoder,
  DBParadoxSecondaryFamilyAdapter,
  DBParadoxSecondaryIndexValidator, fpcunit, testregistry;

type
  TTestDBParadoxSecondaryIndexBuilder = class(TTestCase)
  private
    function EmptyX02Template: TBytes;
    function EmptyY02Template: TBytes;
    function EmptyXgTemplate(CaseInsensitive: Boolean): TBytes;
    function EmptyYgTemplate: TBytes;
    function Key(const Group, Suffix: AnsiString): TBytes;
    function SingleFieldKey(const Group: AnsiString; ID: Cardinal): TBytes;
    function MakeRecord(const AKey: TBytes;
      DataBlockNumber: Integer): TDBParadoxSecondaryRecord;
  published
    procedure BuildsStableCaseInsensitiveCompositeIndex;
    procedure PreservesCaseOnCaseSensitiveIndex;
    procedure BuildsMultipleSecondaryDataBlocks;
    procedure ChecksWideSecondaryDataCapacity;
    procedure ChecksSecondaryIndexTreeDepthBoundary;
    procedure RejectsNonAsciiCaseFoldingAndInvalidKeys;
    procedure RebuildsBdeEmptyRootBlockTemplates;
    procedure DiscoversTemplatesAndFieldNamesFromPopulatedIndexes;
    procedure RejectsMismatchedDiscoveredIndexMetadata;
    procedure MapsDiscoveredXgAndClassicIndexesToTableFields;
    procedure RebuildsClassicX02Y02Templates;
    procedure RejectsMismatchedSecondaryFileTypes;
    procedure RejectsNonIncrementalTypeThreeFourPair;
    procedure ValidatesGeneratedSecondaryTree;
    procedure RejectsBrokenSecondaryBlockLinks;
    procedure RejectsInvalidSecondaryTreeReferences;
    procedure RejectsIncorrectSecondarySubtreeCounts;
    procedure RejectsOutOfOrderSecondaryKeys;
  end;

implementation

procedure WriteUInt16LE(var Data: TBytes; Offset: SizeInt; Value: Word);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
end;

procedure WriteUInt32LE(var Data: TBytes; Offset: SizeInt; Value: Cardinal);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
  Data[Offset + 2] := Byte(Value shr 16);
  Data[Offset + 3] := Byte(Value shr 24);
end;

procedure WriteAscii(var Data: TBytes; var Offset: SizeInt;
  const Value: AnsiString);
begin
  if Length(Value) > 0 then
    Move(Value[1], Data[Offset], Length(Value));
  Inc(Offset, Length(Value) + 1);
end;

procedure WriteEmptyRootBlock(var Data: TBytes; RecordSize: Word);
var
  Offset: SizeInt;
begin
  SetLength(Data, $1000);
  WriteUInt16LE(Data, $0A, 1);
  WriteUInt16LE(Data, $0C, 1);
  WriteUInt16LE(Data, $0E, 1);
  WriteUInt16LE(Data, $10, 1);
  Offset := $800;
  WriteUInt16LE(Data, Offset, 0);
  WriteUInt16LE(Data, Offset + 2, 0);
  WriteUInt16LE(Data, Offset + 4, Word(-SmallInt(RecordSize)));
end;

function TTestDBParadoxSecondaryIndexBuilder.EmptyXgTemplate(
  CaseInsensitive: Boolean): TBytes;
var
  NamesOffset, FieldMapEnd: SizeInt;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 30);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 8;
  Result[5] := 2;
  WriteUInt16LE(Result, $21, 3);
  WriteUInt16LE(Result, $23, 2);
  Result[$2F] := 0;
  Result[$39] := $0C;
  if CaseInsensitive then
    Result[$55] := 1;
  Result[$78] := $01;
  Result[$79] := 20;
  Result[$7A] := $01;
  Result[$7B] := 8;
  Result[$7C] := $03;
  Result[$7D] := 2;
  NamesOffset := $78 + 3 * 2 + 4 + 3 * 4 + 261;
  WriteAscii(Result, NamesOffset, 'GroupKey');
  WriteAscii(Result, NamesOffset, 'Suffix');
  WriteAscii(Result, NamesOffset, 'Blk Num');
  FieldMapEnd := NamesOffset + 3 * SizeOf(Word);
  WriteAscii(Result, FieldMapEnd, 'DBWINUS0');
  WriteAscii(Result, FieldMapEnd, 'GrpSynthetic');
end;

function TTestDBParadoxSecondaryIndexBuilder.EmptyX02Template: TBytes;
var
  NamesOffset, FieldMapEnd: SizeInt;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 26);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 5;
  Result[5] := 2;
  Result[$15] := 1;
  WriteUInt16LE(Result, $21, 3);
  WriteUInt16LE(Result, $23, 2);
  Result[$2F] := 0;
  Result[$39] := $0C;
  Result[$78] := $01;
  Result[$79] := 20;
  Result[$7A] := $04;
  Result[$7B] := 4;
  Result[$7C] := $03;
  Result[$7D] := 2;
  NamesOffset := $78 + 3 * 2 + 4 + 3 * 4 + 261;
  WriteAscii(Result, NamesOffset, 'GroupKey');
  WriteAscii(Result, NamesOffset, 'Sec Key');
  WriteAscii(Result, NamesOffset, 'Hint');
  FieldMapEnd := NamesOffset + 3 * SizeOf(Word);
  WriteAscii(Result, FieldMapEnd, 'DBWINUS0');
  WriteAscii(Result, FieldMapEnd, 'GroupKey');
end;

function TTestDBParadoxSecondaryIndexBuilder.EmptyY02Template: TBytes;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 30);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 4;
  Result[5] := 2;
  WriteUInt16LE(Result, $21, 2);
  Result[$58] := $01;
  Result[$59] := 20;
  Result[$5A] := $04;
  Result[$5B] := 4;
end;

function TTestDBParadoxSecondaryIndexBuilder.EmptyYgTemplate: TBytes;
begin
  Result := nil;
  SetLength(Result, $800);
  WriteUInt16LE(Result, 0, 34);
  WriteUInt16LE(Result, 2, $800);
  Result[4] := 7;
  Result[5] := 2;
  WriteUInt16LE(Result, $21, 2);
  Result[$58] := $01;
  Result[$59] := 20;
  Result[$5A] := $01;
  Result[$5B] := 8;
end;

function TTestDBParadoxSecondaryIndexBuilder.Key(const Group,
  Suffix: AnsiString): TBytes;
var
  Index: SizeInt;
begin
  Result := nil;
  SetLength(Result, 28);
  for Index := 1 to Length(Group) do
    Result[Index - 1] := Byte(Group[Index]);
  for Index := 1 to Length(Suffix) do
    Result[20 + Index - 1] := Byte(Suffix[Index]);
end;

function TTestDBParadoxSecondaryIndexBuilder.SingleFieldKey(
  const Group: AnsiString; ID: Cardinal): TBytes;
var
  Index: SizeInt;
begin
  Result := nil;
  SetLength(Result, 24);
  for Index := 1 to Length(Group) do
    Result[Index - 1] := Byte(Group[Index]);
  WriteUInt32LE(Result, 20, ID);
end;

function TTestDBParadoxSecondaryIndexBuilder.MakeRecord(
  const AKey: TBytes; DataBlockNumber: Integer): TDBParadoxSecondaryRecord;
begin
  Result.Key := Copy(AKey, 0, Length(AKey));
  Result.DataBlockNumber := DataBlockNumber;
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  BuildsStableCaseInsensitiveCompositeIndex;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  BlockOffset, RecordOffset: SizeInt;
begin
  SetLength(Records, 5);
  Records[0] := MakeRecord(Key('Alpha', 'B'), 1);
  Records[1] := MakeRecord(Key('Alpha', 'A'), 2);
  Records[2] := MakeRecord(Key('Alpha', 'A'), 3);
  Records[3] := MakeRecord(Key('alpha', 'A'), 4);
  Records[4] := MakeRecord(Key('Beta', 'A'), 5);

  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(True), EmptyYgTemplate, 1, Records);

  CheckEquals($1000, Length(Built.DataFile));
  CheckEquals(5, LongInt(Built.DataFile[6]));
  CheckEquals(1, Built.DataFile[$0C]);
  CheckEquals(1, Built.DataFile[$2F]);
  CheckEquals($1000, Length(Built.IndexFile));
  CheckEquals(1, LongInt(Built.IndexFile[6]));
  CheckEquals(1, Built.IndexFile[$1E]);
  CheckEquals(1, Built.IndexFile[$20]);

  BlockOffset := $800;
  CheckEquals(0, Built.DataFile[BlockOffset]);
  CheckEquals(0, Built.DataFile[BlockOffset + 1]);
  CheckEquals(120, Built.DataFile[BlockOffset + 4]);
  RecordOffset := BlockOffset + 6;
  CheckEquals(Ord('A'), Built.DataFile[RecordOffset]);
  CheckEquals(Ord('A'), Built.DataFile[RecordOffset + 20]);
  CheckEquals($80, Built.DataFile[RecordOffset + 28]);
  CheckEquals(2, Built.DataFile[RecordOffset + 29]);
  RecordOffset := RecordOffset + 30;
  CheckEquals(3, Built.DataFile[RecordOffset + 29]);
  RecordOffset := RecordOffset + 30;
  CheckEquals(4, Built.DataFile[RecordOffset + 29]);
  RecordOffset := RecordOffset + 30;
  CheckEquals(Ord('B'), Built.DataFile[RecordOffset + 20]);
  CheckEquals(Ord('B'), Built.DataFile[RecordOffset + 30]);
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  PreservesCaseOnCaseSensitiveIndex;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  BlockOffset: SizeInt;
begin
  SetLength(Records, 2);
  Records[0] := MakeRecord(Key('alpha', 'A'), 1);
  Records[1] := MakeRecord(Key('Alpha', 'A'), 2);

  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(False), EmptyYgTemplate, 1, Records);

  BlockOffset := $800 + 6;
  CheckEquals(Ord('A'), Built.DataFile[BlockOffset]);
  CheckEquals(Ord('l'), Built.DataFile[BlockOffset + 1]);
  BlockOffset := BlockOffset + 30;
  CheckEquals(Ord('a'), Built.DataFile[BlockOffset]);
  CheckEquals(Ord('l'), Built.DataFile[BlockOffset + 1]);
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  BuildsMultipleSecondaryDataBlocks;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  Index, BlockOffset, RecordOffset, RecordsInBlock: SizeInt;
  BlockNumber1Count, BlockNumber2Count: SizeInt;
begin
  SetLength(Records, 75);
  for Index := 0 to High(Records) do
    Records[Index] := MakeRecord(
      Key('Group' + Format('%.2d', [Index mod 5]),
        Chr(Ord('A') + Index mod 3)), Index div 62 + 1);

  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(False), EmptyYgTemplate, 1, Records);

  CheckEquals(75, LongInt(Built.DataFile[6]));
  CheckEquals(2, Built.DataFile[$0A]);
  CheckEquals($1800, Length(Built.DataFile));
  CheckEquals(2, Built.DataFile[$800]);
  CheckEquals(0, Built.DataFile[$802]);
  CheckEquals(0, Built.DataFile[$803]);
  CheckEquals(10, Built.DataFile[$804]);
  CheckEquals(5, Built.DataFile[$805]);
  CheckEquals(0, Built.DataFile[$1000]);
  CheckEquals(1, Built.DataFile[$1002]);
  CheckEquals(0, Built.DataFile[$1003]);
  CheckEquals($84, Built.DataFile[$1004]);
  CheckEquals(3, Built.DataFile[$1005]);

  BlockNumber1Count := 0;
  BlockNumber2Count := 0;
  for Index := 0 to 1 do
  begin
    BlockOffset := $800 + Index * $800;
    RecordsInBlock := SmallInt(
      Word(Built.DataFile[BlockOffset + 4]) or
      (Word(Built.DataFile[BlockOffset + 5]) shl 8)) div 30 + 1;
    RecordOffset := BlockOffset + 6;
    while RecordsInBlock > 0 do
    begin
      CheckEquals($80, Built.DataFile[RecordOffset + 28]);
      case Built.DataFile[RecordOffset + 29] of
        1: Inc(BlockNumber1Count);
        2: Inc(BlockNumber2Count);
      else
        Fail('Secondary record references an unexpected table data block.');
      end;
      Inc(RecordOffset, 30);
      Dec(RecordsInBlock);
    end;
  end;
  CheckEquals(62, BlockNumber1Count);
  CheckEquals(13, BlockNumber2Count);
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  ChecksSecondaryIndexTreeDepthBoundary;
const
  RecordsPerSecondaryDataBlock = 44;
  SecondaryIndexLeafCapacity = 60;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  Index: SizeInt;
begin
  Records := nil;
  SetLength(Records, RecordsPerSecondaryDataBlock *
    SecondaryIndexLeafCapacity);
  for Index := 0 to High(Records) do
    Records[Index] := MakeRecord(
      Key('Group' + Format('%.2d', [Index mod 5]), 'A'),
      Index div 62 + 1);

  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(False), EmptyYgTemplate, 1, Records);
  CheckEquals(60, Built.DataFile[$0A]);
  CheckEquals(1, Built.IndexFile[$0C]);
  CheckEquals(1, Built.IndexFile[$20]);

  SetLength(Records, Length(Records) + 1);
  Index := High(Records);
  Records[Index] := MakeRecord(
    Key('Group' + Format('%.2d', [Index mod 5]), 'A'),
    Index div 62 + 1);
  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(False), EmptyYgTemplate, 1, Records);
  CheckEquals(61, Built.DataFile[$0A]);
  CheckEquals(3, Built.IndexFile[$0C]);
  CheckEquals(2, Built.IndexFile[$20]);
  CheckEquals(63, Built.IndexFile[6] + (Built.IndexFile[7] shl 8));
  ValidateDBParadoxSecondaryIndexFiles(EmptyXgTemplate(False),
    EmptyYgTemplate, Built.DataFile, Built.IndexFile, 1, 43);
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  ChecksWideSecondaryDataCapacity;
const
  FirstFieldLength = 40;
  SecondFieldLength = 16;
  KeyLength = FirstFieldLength + SecondFieldLength;
  SecondaryRecordSize = KeyLength + 2;
var
  DataTemplate, IndexTemplate: TBytes;
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  Index: SizeInt;
  GroupName: AnsiString;
begin
  DataTemplate := EmptyXgTemplate(False);
  DataTemplate[0] := SecondaryRecordSize;
  DataTemplate[1] := 0;
  DataTemplate[$79] := FirstFieldLength;
  DataTemplate[$7B] := SecondFieldLength;
  IndexTemplate := EmptyYgTemplate;
  IndexTemplate[0] := KeyLength + 6;
  IndexTemplate[1] := 0;
  IndexTemplate[$59] := FirstFieldLength;
  IndexTemplate[$5B] := SecondFieldLength;

  Records := nil;
  SetLength(Records, 45);
  for Index := 0 to High(Records) do
  begin
    Records[Index].Key := nil;
    SetLength(Records[Index].Key, KeyLength);
    GroupName := AnsiString(Format('Group%.2d', [Index mod 5]));
    Move(GroupName[1], Records[Index].Key[0], Length(GroupName));
    Records[Index].Key[FirstFieldLength] :=
      Byte(Ord('A') + Index mod 3);
    Records[Index].DataBlockNumber := Index div 62 + 1;
  end;

  Built := BuildDBParadoxSecondaryIndexFiles(
    DataTemplate, IndexTemplate, 1, Records);
  CheckEquals(3, Built.DataFile[$0A]);
  CheckEquals($800 + 3 * $800, Length(Built.DataFile));
  CheckEquals(1, Built.IndexFile[$0C]);
  CheckEquals(1, Built.IndexFile[$20]);
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RejectsNonAsciiCaseFoldingAndInvalidKeys;
var
  Records: TDBParadoxSecondaryRecords;
  InvalidTemplate, IndexTemplate: TBytes;
begin
  SetLength(Records, 1);
  Records[0] := MakeRecord(Key('Älpha', 'A'), 1);
  try
    BuildDBParadoxSecondaryIndexFiles(
      EmptyXgTemplate(True), EmptyYgTemplate, 1, Records);
    Fail('Expected unmeasured non-ASCII case folding to be rejected.');
  except
    on E: EDBParadoxUnsupportedSecondaryIndexFeature do ;
  end;

  Records[0] := MakeRecord(Key('Alpha', 'A'), 1);
  SetLength(Records[0].Key, 27);
  try
    BuildDBParadoxSecondaryIndexFiles(
      EmptyXgTemplate(False), EmptyYgTemplate, 1, Records);
    Fail('Expected a malformed key width to be rejected.');
  except
    on E: EDBParadoxSecondaryIndexBuildError do ;
  end;

  InvalidTemplate := EmptyXgTemplate(False);
  InvalidTemplate[$55] := 2;
  IndexTemplate := EmptyYgTemplate;
  Records[0] := MakeRecord(Key('Alpha', 'A'), 1);
  try
    BuildDBParadoxSecondaryIndexFiles(
      InvalidTemplate, IndexTemplate, 1, Records);
    Fail('Expected an unknown XG option to be rejected.');
  except
    on E: EDBParadoxUnsupportedSecondaryIndexFeature do ;
  end;
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RebuildsBdeEmptyRootBlockTemplates;
var
  Records: TDBParadoxSecondaryRecords;
  DataTemplate, IndexTemplate: TBytes;
  Built: TDBParadoxBuiltSecondaryIndex;
begin
  SetLength(Records, 2);
  Records[0] := MakeRecord(Key('Alpha', 'A'), 1);
  Records[1] := MakeRecord(Key('Beta', 'A'), 1);
  DataTemplate := EmptyXgTemplate(False);
  IndexTemplate := EmptyYgTemplate;
  WriteEmptyRootBlock(DataTemplate, 30);
  WriteEmptyRootBlock(IndexTemplate, 34);

  Built := BuildDBParadoxSecondaryIndexFiles(
    DataTemplate, IndexTemplate, 1, Records);
  CheckEquals($1000, Length(Built.DataFile));
  CheckEquals($1000, Length(Built.IndexFile));
  CheckEquals(2, LongInt(Built.DataFile[6]));
  CheckEquals(1, LongInt(Built.IndexFile[6]));

  DataTemplate[$800 + 4] := 0;
  DataTemplate[$800 + 5] := 0;
  try
    BuildDBParadoxSecondaryIndexFiles(
      DataTemplate, IndexTemplate, 1, Records);
    Fail('Expected a nonempty XG root block to be rejected.');
  except
    on E: EDBParadoxSecondaryIndexBuildError do ;
  end;
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  DiscoversTemplatesAndFieldNamesFromPopulatedIndexes;
var
  Records: TDBParadoxSecondaryRecords;
  Built, Rebuilt: TDBParadoxBuiltSecondaryIndex;
  EmptyData, EmptyIndex: TBytes;
  KeyFields: TDBParadoxSecondaryIndexFields;
begin
  SetLength(Records, 2);
  Records[0] := MakeRecord(Key('Alpha', 'B'), 1);
  Records[1] := MakeRecord(Key('Beta', 'A'), 2);
  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(True), EmptyYgTemplate, 1, Records);

  DiscoverDBParadoxSecondaryIndexTemplates(
    Built.DataFile, Built.IndexFile, EmptyData, EmptyIndex, KeyFields);
  CheckEquals(2, Length(KeyFields));
  CheckEquals('GroupKey', KeyFields[0].Name);
  CheckEquals(Ord($01), KeyFields[0].TypeCode);
  CheckEquals(20, KeyFields[0].FieldLength);
  CheckEquals('Suffix', KeyFields[1].Name);
  CheckEquals(8, KeyFields[1].FieldLength);
  Rebuilt := BuildDBParadoxSecondaryIndexFiles(
    EmptyData, EmptyIndex, 2, Records);
  CheckEquals(2, Rebuilt.DataFile[$2F]);

  Records[0] := MakeRecord(SingleFieldKey('Alpha', 1), 1);
  Records[1] := MakeRecord(SingleFieldKey('Beta', 2), 2);
  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyX02Template, EmptyY02Template, 1, Records);
  DiscoverDBParadoxSecondaryIndexTemplates(
    Built.DataFile, Built.IndexFile, EmptyData, EmptyIndex, KeyFields);
  CheckEquals(2, Length(KeyFields));
  CheckEquals('GroupKey', KeyFields[0].Name);
  CheckEquals('Sec Key', KeyFields[1].Name);
  Rebuilt := BuildDBParadoxSecondaryIndexFiles(
    EmptyData, EmptyIndex, 2, Records);
  CheckEquals(2, Rebuilt.DataFile[$2F]);
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RejectsMismatchedDiscoveredIndexMetadata;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  EmptyData, EmptyIndex: TBytes;
  KeyFields: TDBParadoxSecondaryIndexFields;
begin
  SetLength(Records, 1);
  Records[0] := MakeRecord(Key('Alpha', 'A'), 1);
  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(True), EmptyYgTemplate, 1, Records);
  Built.IndexFile[$59] := Built.IndexFile[$59] + 1;

  try
    DiscoverDBParadoxSecondaryIndexTemplates(
      Built.DataFile, Built.IndexFile, EmptyData, EmptyIndex, KeyFields);
    Fail('Expected mismatched XG/YG field metadata to be rejected.');
  except
    on E: EDBParadoxSecondaryIndexBuildError do ;
  end;
  CheckEquals(0, Length(EmptyData));
  CheckEquals(0, Length(EmptyIndex));
  CheckEquals(0, Length(KeyFields));
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  MapsDiscoveredXgAndClassicIndexesToTableFields;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  Fields: TDBParadoxRecordFields;
  Discovered: TDBParadoxSecondaryFamilyIndex;
begin
  SetLength(Fields, 3);
  Fields[0].Name := 'ID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  Fields[1].Name := 'GroupKey';
  Fields[1].TypeCode := $01;
  Fields[1].Length := 20;
  Fields[2].Name := 'Suffix';
  Fields[2].TypeCode := $01;
  Fields[2].Length := 8;
  SetLength(Fields, 4);
  Fields[3].Name := 'Sec Key';
  Fields[3].TypeCode := $04;
  Fields[3].Length := 4;

  SetLength(Records, 2);
  Records[0] := MakeRecord(Key('Alpha', 'B'), 1);
  Records[1] := MakeRecord(Key('Beta', 'A'), 2);
  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(True), EmptyYgTemplate, 1, Records);
  DiscoverDBParadoxSecondaryFamilyIndex(Built.DataFile, Built.IndexFile,
    '.XG0', '.YG0', Fields, 1, 2, Discovered);
  CheckEquals(2, Length(Discovered.KeyFieldIndexes));
  CheckEquals(1, Discovered.KeyFieldIndexes[0]);
  CheckEquals(2, Discovered.KeyFieldIndexes[1]);

  Fields[2].Name := 'SuffixOther';
  try
    DiscoverDBParadoxSecondaryFamilyIndex(Built.DataFile, Built.IndexFile,
      '.XG0', '.YG0', Fields, 1, 2, Discovered);
    Fail('Expected unknown index field to be rejected.');
  except
    on E: EDBParadoxSecondaryFamilyValidationError do ;
  end;
  CheckEquals(0, Length(Discovered.KeyFieldIndexes));

  Fields[2].Name := 'Suffix';
  Records[0] := MakeRecord(SingleFieldKey('Alpha', 1), 1);
  Records[1] := MakeRecord(SingleFieldKey('Beta', 2), 2);
  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyX02Template, EmptyY02Template, 1, Records);
  DiscoverDBParadoxSecondaryFamilyIndex(Built.DataFile, Built.IndexFile,
    '.X02', '.Y02', Fields, 1, 2, Discovered);
  CheckEquals(2, Length(Discovered.KeyFieldIndexes));
  CheckEquals(1, Discovered.KeyFieldIndexes[0]);
  CheckEquals(3, Discovered.KeyFieldIndexes[1]);
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RebuildsClassicX02Y02Templates;
var
  Records: TDBParadoxSecondaryRecords;
  DataTemplate, IndexTemplate: TBytes;
  Built: TDBParadoxBuiltSecondaryIndex;
  BlockOffset, RecordOffset: SizeInt;
begin
  SetLength(Records, 4);
  Records[0] := MakeRecord(SingleFieldKey('Alpha', 1), 1);
  Records[1] := MakeRecord(SingleFieldKey('Alpha', 2), 1);
  Records[2] := MakeRecord(SingleFieldKey('alpha', 3), 1);
  Records[3] := MakeRecord(SingleFieldKey('Beta', 5), 1);
  DataTemplate := EmptyX02Template;
  IndexTemplate := EmptyY02Template;
  WriteEmptyRootBlock(DataTemplate, 26);
  WriteEmptyRootBlock(IndexTemplate, 30);

  Built := BuildDBParadoxSecondaryIndexFiles(
    DataTemplate, IndexTemplate, 1, Records);

  CheckEquals(5, Built.DataFile[4]);
  CheckEquals(4, Built.IndexFile[4]);
  CheckEquals($1000, Length(Built.DataFile));
  CheckEquals($1000, Length(Built.IndexFile));
  CheckEquals(4, LongInt(Built.DataFile[6]));
  CheckEquals(1, Built.DataFile[$0C]);
  CheckEquals(1, Built.DataFile[$2F]);
  CheckEquals(1, LongInt(Built.IndexFile[6]));
  CheckEquals(1, Built.IndexFile[$1E]);
  CheckEquals(1, Built.IndexFile[$20]);

  BlockOffset := $800;
  CheckEquals(0, Built.DataFile[BlockOffset]);
  CheckEquals(0, Built.DataFile[BlockOffset + 1]);
  CheckEquals(78, Built.DataFile[BlockOffset + 4]);
  RecordOffset := BlockOffset + 6;
  CheckEquals(Ord('A'), Built.DataFile[RecordOffset]);
  CheckEquals(1, Built.DataFile[RecordOffset + 20]);
  RecordOffset := RecordOffset + 26;
  CheckEquals(2, Built.DataFile[RecordOffset + 20]);
  RecordOffset := RecordOffset + 26;
  CheckEquals(Ord('B'), Built.DataFile[RecordOffset]);
  CheckEquals(5, Built.DataFile[RecordOffset + 20]);
  RecordOffset := RecordOffset + 26;
  CheckEquals(Ord('a'), Built.DataFile[RecordOffset]);
  CheckEquals(3, Built.DataFile[RecordOffset + 20]);
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RejectsMismatchedSecondaryFileTypes;
var
  Records: TDBParadoxSecondaryRecords;
  DataTemplate, IndexTemplate: TBytes;
begin
  SetLength(Records, 1);
  Records[0] := MakeRecord(SingleFieldKey('Alpha', 1), 1);
  try
    BuildDBParadoxSecondaryIndexFiles(
      EmptyX02Template, EmptyYgTemplate, 1, Records);
    Fail('Expected an unsupported X02/YG file-type pair to be rejected.');
  except
    on E: EDBParadoxUnsupportedSecondaryIndexFeature do ;
  end;

  DataTemplate := EmptyX02Template;
  IndexTemplate := EmptyY02Template;
  DataTemplate[$55] := 1;
  try
    BuildDBParadoxSecondaryIndexFiles(
      DataTemplate, IndexTemplate, 1, Records);
    Fail('Expected an unmeasured classic-index option to be rejected.');
  except
    on E: EDBParadoxUnsupportedSecondaryIndexFeature do ;
  end;
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RejectsNonIncrementalTypeThreeFourPair;
var
  Records: TDBParadoxSecondaryRecords;
  DataTemplate, IndexTemplate: TBytes;
begin
  SetLength(Records, 1);
  Records[0] := MakeRecord(SingleFieldKey('Alpha', 1), 1);
  DataTemplate := EmptyX02Template;
  DataTemplate[4] := 3;
  IndexTemplate := EmptyY02Template;

  try
    BuildDBParadoxSecondaryIndexFiles(
      DataTemplate, IndexTemplate, 1, Records);
    Fail('Expected the unverified type-3/type-4 index pair to be rejected.');
  except
    on E: EDBParadoxUnsupportedSecondaryIndexFeature do
      Check(Pos('3/4', E.Message) > 0,
        'The rejection should identify the unsupported 3/4 pair.');
  end;
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  ValidatesGeneratedSecondaryTree;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  Index: SizeInt;
begin
  SetLength(Records, 75);
  for Index := 0 to High(Records) do
    Records[Index] := MakeRecord(
      Key('Group' + Format('%.2d', [Index mod 5]),
        Chr(Ord('A') + Index mod 3)), Index div 62 + 1);
  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(False), EmptyYgTemplate, 1, Records);
  ValidateDBParadoxSecondaryIndexFiles(EmptyXgTemplate(False),
    EmptyYgTemplate, Built.DataFile, Built.IndexFile, 1, 2);
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RejectsBrokenSecondaryBlockLinks;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  Index: SizeInt;
begin
  SetLength(Records, 75);
  for Index := 0 to High(Records) do
    Records[Index] := MakeRecord(
      Key('Group' + Format('%.2d', [Index mod 5]),
        Chr(Ord('A') + Index mod 3)), Index div 62 + 1);
  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(False), EmptyYgTemplate, 1, Records);
  Built.DataFile[$800] := 0;
  Built.DataFile[$801] := 0;
  try
    ValidateDBParadoxSecondaryIndexFiles(EmptyXgTemplate(False),
      EmptyYgTemplate, Built.DataFile, Built.IndexFile, 1, 2);
    Fail('Expected a broken XG block link to be rejected.');
  except
    on E: EDBParadoxSecondaryIndexValidationError do ;
  end;
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RejectsInvalidSecondaryTreeReferences;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  DataTemplate, IndexTemplate: TBytes;
begin
  SetLength(Records, 1);
  Records[0] := MakeRecord(Key('Alpha', 'A'), 2);
  DataTemplate := EmptyXgTemplate(False);
  IndexTemplate := EmptyYgTemplate;
  Built := BuildDBParadoxSecondaryIndexFiles(
    DataTemplate, IndexTemplate, 1, Records);
  try
    ValidateDBParadoxSecondaryIndexFiles(DataTemplate, IndexTemplate,
      Built.DataFile, Built.IndexFile, 1, 1);
    Fail('Expected a nonexistent source DB block to be rejected.');
  except
    on E: EDBParadoxSecondaryIndexValidationError do ;
  end;

  Records[0] := MakeRecord(Key('Alpha', 'A'), 1);
  Built := BuildDBParadoxSecondaryIndexFiles(
    DataTemplate, IndexTemplate, 1, Records);
  Built.IndexFile[$800 + 6 + 28 + 1] := 2;
  try
    ValidateDBParadoxSecondaryIndexFiles(DataTemplate, IndexTemplate,
      Built.DataFile, Built.IndexFile, 1, 1);
    Fail('Expected a nonexistent XG block reference to be rejected.');
  except
    on E: EDBParadoxSecondaryIndexValidationError do ;
  end;

  Built := BuildDBParadoxSecondaryIndexFiles(
    DataTemplate, IndexTemplate, 1, Records);
  Built.IndexFile[$1E] := 0;
  Built.IndexFile[$1F] := 0;
  try
    ValidateDBParadoxSecondaryIndexFiles(DataTemplate, IndexTemplate,
      Built.DataFile, Built.IndexFile, 1, 1);
    Fail('Expected an invalid YG root block to be rejected.');
  except
    on E: EDBParadoxSecondaryIndexValidationError do ;
  end;
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RejectsIncorrectSecondarySubtreeCounts;
const
  RecordsPerSecondaryDataBlock = 44;
  SecondaryIndexLeafCapacity = 60;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  Index, RootOffset: SizeInt;
begin
  SetLength(Records, RecordsPerSecondaryDataBlock *
    SecondaryIndexLeafCapacity + 1);
  for Index := 0 to High(Records) do
    Records[Index] := MakeRecord(
      Key('Group' + Format('%.2d', [Index mod 5]), 'A'),
      Index div 62 + 1);
  Built := BuildDBParadoxSecondaryIndexFiles(
    EmptyXgTemplate(False), EmptyYgTemplate, 1, Records);
  RootOffset := $800 +
    ((Built.IndexFile[$1E] or (Built.IndexFile[$1F] shl 8)) - 1) * $800;
  Built.IndexFile[RootOffset + 6 + 28 + 3] :=
    Built.IndexFile[RootOffset + 6 + 28 + 3] xor 1;
  try
    ValidateDBParadoxSecondaryIndexFiles(EmptyXgTemplate(False),
      EmptyYgTemplate, Built.DataFile, Built.IndexFile, 1, 43);
    Fail('Expected an incorrect YG subtree record count to be rejected.');
  except
    on E: EDBParadoxSecondaryIndexValidationError do ;
  end;
end;

procedure TTestDBParadoxSecondaryIndexBuilder.
  RejectsOutOfOrderSecondaryKeys;
var
  Records: TDBParadoxSecondaryRecords;
  Built: TDBParadoxBuiltSecondaryIndex;
  DataTemplate, IndexTemplate: TBytes;
  Index: SizeInt;
begin
  SetLength(Records, 75);
  for Index := 0 to High(Records) do
    Records[Index] := MakeRecord(
      Key('Group' + Format('%.2d', [Index mod 5]),
        Chr(Ord('A') + Index mod 3)), Index div 62 + 1);
  DataTemplate := EmptyXgTemplate(False);
  IndexTemplate := EmptyYgTemplate;
  Built := BuildDBParadoxSecondaryIndexFiles(
    DataTemplate, IndexTemplate, 1, Records);
  Built.IndexFile[$800 + 6 + 34] := Ord('0');
  try
    ValidateDBParadoxSecondaryIndexFiles(DataTemplate, IndexTemplate,
      Built.DataFile, Built.IndexFile, 1, 2);
    Fail('Expected an out-of-order YG key to be rejected.');
  except
    on E: EDBParadoxSecondaryIndexValidationError do
      Check(Pos('key order', E.Message) > 0,
        'The rejection should identify invalid key order.');
  end;
end;

initialization
  RegisterTest(TTestDBParadoxSecondaryIndexBuilder);

end.
