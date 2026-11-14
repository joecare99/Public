unit tst_DBParadoxTableFileBuilder;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  SysUtils, DBParadoxRecordEncoder, DBParadoxTableFileBuilder,
  fpcunit, testregistry;

type
  TTestDBParadoxTableFileBuilder = class(TTestCase)
  private
    function EmptyDatabaseTemplate(RecordSize, FieldCount,
      PrimaryKeyFieldCount: Word; const FirstFieldName: string;
      FirstFieldType: Byte): TBytes;
    function EmptyPrimaryIndexTemplate(KeyFieldType: Byte;
      KeyFieldLength: Byte): TBytes;
    function MakeFields: TDBParadoxRecordFields;
  published
    procedure BuildsSortedSingleBlockDatabaseAndPrimaryIndex;
    procedure BuildsLinkedMultipleDataBlocks;
    procedure AllocatesMissingAutoIncrementValues;
    procedure RejectsDuplicateKeysAndInvalidTemplates;
  end;

implementation

function TTestDBParadoxTableFileBuilder.EmptyDatabaseTemplate(
  RecordSize, FieldCount, PrimaryKeyFieldCount: Word;
  const FirstFieldName: string; FirstFieldType: Byte): TBytes;
var
  TableNameOffset, FieldNamesOffset: SizeInt;
begin
  Result := nil;
  SetLength(Result, $800);
  Result[0] := Byte(RecordSize);
  Result[1] := Byte(RecordSize shr 8);
  Result[2] := 0;
  Result[3] := 8;
  Result[4] := 0;
  Result[5] := 2;
  Result[$21] := Byte(FieldCount);
  Result[$22] := Byte(FieldCount shr 8);
  Result[$23] := Byte(PrimaryKeyFieldCount);
  Result[$24] := Byte(PrimaryKeyFieldCount shr 8);
  Result[$39] := $0C;
  TableNameOffset := $78 + FieldCount * 2 + 4 + FieldCount * 4;
  Move('Synthetic'#0, Result[TableNameOffset], Length('Synthetic') + 1);
  FieldNamesOffset := TableNameOffset + 261;
  if FieldCount = 2 then
  begin
    Result[$78] := FirstFieldType;
    Result[$79] := 4;
    Result[$7A] := $01;
    Result[$7B] := 4;
    Move(FirstFieldName[1], Result[FieldNamesOffset],
      Length(FirstFieldName));
    Result[FieldNamesOffset + Length(FirstFieldName)] := 0;
    Move('Label'#0, Result[FieldNamesOffset + Length(FirstFieldName) + 1],
      Length('Label') + 1);
  end;
end;

function TTestDBParadoxTableFileBuilder.EmptyPrimaryIndexTemplate(
  KeyFieldType, KeyFieldLength: Byte): TBytes;
var
  RecordSize: Word;
begin
  Result := nil;
  SetLength(Result, $800);
  RecordSize := KeyFieldLength + 6;
  Result[0] := Byte(RecordSize);
  Result[1] := Byte(RecordSize shr 8);
  Result[2] := 0;
  Result[3] := 8;
  Result[4] := 1;
  Result[5] := 2;
  Result[$21] := 1;
  Result[$58] := KeyFieldType;
  Result[$59] := KeyFieldLength;
end;

function TTestDBParadoxTableFileBuilder.MakeFields:
  TDBParadoxRecordFields;
begin
  Result := nil;
  SetLength(Result, 2);
  Result[0].Name := 'ID';
  Result[0].TypeCode := $04;
  Result[0].Length := 4;
  Result[1].Name := 'Label';
  Result[1].TypeCode := $01;
  Result[1].Length := 4;
end;

procedure TTestDBParadoxTableFileBuilder.
  BuildsSortedSingleBlockDatabaseAndPrimaryIndex;
var
  DatabaseTemplate, PrimaryIndexTemplate: TBytes;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
  BlockOffset: SizeInt;
const
  FirstDatabaseRecord: array[0..7] of Byte =
    ($80, $00, $00, $01, Ord('A'), 0, 0, 0);
  SecondDatabaseRecord: array[0..7] of Byte =
    ($80, $00, $00, $02, Ord('B'), 0, 0, 0);
  FirstIndexRecord: array[0..9] of Byte =
    ($80, $00, $00, $01, $80, $01, $80, $02, $80, $00);
begin
  Fields := MakeFields;
  DatabaseTemplate := EmptyDatabaseTemplate(8, 2, 1, 'ID', $04);
  PrimaryIndexTemplate := EmptyPrimaryIndexTemplate($04, 4);
  Rows := nil;
  SetLength(Rows, 2);
  Rows[0] := ['2', 'B'];
  Rows[1] := ['1', 'A'];

  Built := BuildDBParadoxTableFiles(
    DatabaseTemplate, PrimaryIndexTemplate, Fields, 0, Rows);

  CheckEquals($1000, Length(Built.DatabaseFile));
  CheckEquals(2, Built.DatabaseFile[6]);
  CheckEquals(1, Built.DatabaseFile[$0C]);
  BlockOffset := $800;
  CheckEquals(0, Built.DatabaseFile[BlockOffset]);
  CheckEquals(0, Built.DatabaseFile[BlockOffset + 1]);
  CheckEquals(8, Built.DatabaseFile[BlockOffset + 4]);
  CheckEquals(0, CompareByte(
    Built.DatabaseFile[BlockOffset + 6],
    FirstDatabaseRecord[0],
    SizeOf(FirstDatabaseRecord)));
  CheckEquals(0, CompareByte(
    Built.DatabaseFile[BlockOffset + 14],
    SecondDatabaseRecord[0],
    SizeOf(SecondDatabaseRecord)));

  CheckEquals($1000, Length(Built.PrimaryIndexFile));
  CheckEquals(1, Built.PrimaryIndexFile[6]);
  CheckEquals(1, Built.PrimaryIndexFile[$1E]);
  CheckEquals(1, Built.PrimaryIndexFile[$20]);
  CheckEquals(0, CompareByte(
    Built.PrimaryIndexFile[$800 + 6],
    FirstIndexRecord[0],
    SizeOf(FirstIndexRecord)));
end;

procedure TTestDBParadoxTableFileBuilder.BuildsLinkedMultipleDataBlocks;
var
  DatabaseTemplate, PrimaryIndexTemplate: TBytes;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
  RowIndex: Integer;
  Value: Integer;
begin
  Fields := MakeFields;
  DatabaseTemplate := EmptyDatabaseTemplate(8, 2, 1, 'ID', $04);
  PrimaryIndexTemplate := EmptyPrimaryIndexTemplate($04, 4);
  Rows := nil;
  SetLength(Rows, 255);
  for RowIndex := 0 to High(Rows) do
  begin
    Value := High(Rows) - RowIndex + 1;
    Rows[RowIndex] := [UnicodeString(IntToStr(Value)), 'X'];
  end;

  Built := BuildDBParadoxTableFiles(
    DatabaseTemplate, PrimaryIndexTemplate, Fields, 0, Rows);

  CheckEquals($1800, Length(Built.DatabaseFile));
  CheckEquals(2, Built.DatabaseFile[$0C]);
  CheckEquals(2, Built.DatabaseFile[$10]);
  CheckEquals(2, Built.DatabaseFile[$800]);
  CheckEquals(0, Built.DatabaseFile[$801]);
  CheckEquals(0, Built.DatabaseFile[$802]);
  CheckEquals(0, Built.DatabaseFile[$803]);
  CheckEquals((254 - 1) * 8, Built.DatabaseFile[$804] +
    (Built.DatabaseFile[$805] shl 8));
  CheckEquals(0, Built.DatabaseFile[$1000]);
  CheckEquals(0, Built.DatabaseFile[$1001]);
  CheckEquals(1, Built.DatabaseFile[$1002]);
  CheckEquals(0, Built.DatabaseFile[$1003]);
  CheckEquals(0, Built.DatabaseFile[$1004]);
  CheckEquals(0, Built.DatabaseFile[$1005]);
end;

procedure TTestDBParadoxTableFileBuilder.AllocatesMissingAutoIncrementValues;
var
  DatabaseTemplate, PrimaryIndexTemplate: TBytes;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  Built: TDBParadoxBuiltFiles;
begin
  Fields := MakeFields;
  Fields[0].Name := 'Auto';
  Fields[0].TypeCode := $16;
  DatabaseTemplate := EmptyDatabaseTemplate(8, 2, 1, 'Auto', $16);
  DatabaseTemplate[$49] := 10;
  PrimaryIndexTemplate := EmptyPrimaryIndexTemplate($16, 4);
  Rows := nil;
  SetLength(Rows, 2);
  Rows[0] := ['', 'A'];
  Rows[1] := ['20', 'B'];

  Built := BuildDBParadoxTableFiles(
    DatabaseTemplate, PrimaryIndexTemplate, Fields, 0, Rows);

  CheckEquals(11, Built.DatabaseFile[$49]);
  CheckEquals($80, Built.DatabaseFile[$800 + 6]);
  CheckEquals(11, Built.DatabaseFile[$800 + 9]);
  CheckEquals(20, Built.DatabaseFile[$800 + 17]);
end;

procedure TTestDBParadoxTableFileBuilder.
  RejectsDuplicateKeysAndInvalidTemplates;
var
  DatabaseTemplate, PrimaryIndexTemplate: TBytes;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
begin
  Fields := MakeFields;
  DatabaseTemplate := EmptyDatabaseTemplate(8, 2, 1, 'ID', $04);
  PrimaryIndexTemplate := EmptyPrimaryIndexTemplate($04, 4);
  Rows := nil;
  SetLength(Rows, 2);
  Rows[0] := ['1', 'A'];
  Rows[1] := ['1', 'B'];
  try
    BuildDBParadoxTableFiles(
      DatabaseTemplate, PrimaryIndexTemplate, Fields, 0, Rows);
    Fail('Expected duplicate primary-key values to be rejected.');
  except
    on E: EDBParadoxTableBuildError do ;
  end;

  DatabaseTemplate[6] := 1;
  Rows := nil;
  SetLength(Rows, 1);
  Rows[0] := ['1', 'A'];
  try
    BuildDBParadoxTableFiles(
      DatabaseTemplate, PrimaryIndexTemplate, Fields, 0, Rows);
    Fail('Expected a nonempty database template to be rejected.');
  except
    on E: EDBParadoxTableBuildError do ;
  end;

  DatabaseTemplate := EmptyDatabaseTemplate(8, 2, 1, 'ID', $04);
  Rows[0] := ['1'];
  try
    BuildDBParadoxTableFiles(
      DatabaseTemplate, PrimaryIndexTemplate, Fields, 0, Rows);
    Fail('Expected a mismatched row value count to be rejected.');
  except
    on E: EDBParadoxRecordEncodingError do ;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxTableFileBuilder);

end.
