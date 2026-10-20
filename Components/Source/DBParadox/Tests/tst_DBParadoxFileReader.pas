unit tst_DBParadoxFileReader;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fpcunit, testregistry;

type
  TTestDBParadoxFileReader = class(TTestCase)
  private
    function BuildFixture(DeclaredRecords, PhysicalRecords: Word): TBytes;
    function WriteFixture(const Data: TBytes): string;
  published
    procedure ReadsUnencryptedVersionSevenTable;
    procedure RejectsPhysicalRecordCountMismatch;
  end;

implementation

uses
  Classes, DBParadoxFileReader;

procedure WriteUInt16LE(var Data: TBytes; Offset: SizeInt; Value: Word);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
end;

procedure WriteInt32LE(var Data: TBytes; Offset: SizeInt; Value: LongInt);
begin
  Data[Offset] := Byte(Value);
  Data[Offset + 1] := Byte(Value shr 8);
  Data[Offset + 2] := Byte(Value shr 16);
  Data[Offset + 3] := Byte(Value shr 24);
end;

function TTestDBParadoxFileReader.BuildFixture(DeclaredRecords,
  PhysicalRecords: Word): TBytes;
const
  HeaderSize = $800;
  BlockSize = $800;
  RecordSize = 5;
  FieldNamesOffset = $78 + 2 * 2 + 4 + 2 * 4 + 261;
var
  BlockOffset: SizeInt;
  RowIndex: Integer;
  RecordOffset: SizeInt;
begin
  Result := nil;
  SetLength(Result, HeaderSize + BlockSize);
  WriteUInt16LE(Result, 0, RecordSize);
  WriteUInt16LE(Result, 2, HeaderSize);
  Result[4] := 0;
  Result[5] := 2;
  WriteInt32LE(Result, 6, DeclaredRecords);
  WriteUInt16LE(Result, $0C, 1);
  WriteUInt16LE(Result, $0E, 1);
  WriteUInt16LE(Result, $10, 1);
  WriteUInt16LE(Result, $21, 2);
  Result[$39] := $0C;

  Result[$78] := $04;
  Result[$79] := 4;
  Result[$7A] := $01;
  Result[$7B] := 1;
  Move('ID'#0, Result[FieldNamesOffset], 3);
  Move('Label'#0, Result[FieldNamesOffset + 3], 6);

  BlockOffset := HeaderSize;
  WriteUInt16LE(Result, BlockOffset, 0);
  WriteUInt16LE(Result, BlockOffset + 2, 0);
  WriteUInt16LE(Result, BlockOffset + 4,
    Word((PhysicalRecords - 1) * RecordSize));
  for RowIndex := 0 to PhysicalRecords - 1 do
  begin
    RecordOffset := BlockOffset + 6 + RowIndex * RecordSize;
    Result[RecordOffset] := $80;
    Result[RecordOffset + 3] := RowIndex + 1;
    Result[RecordOffset + 4] := Ord(Chr(Ord('A') + RowIndex));
  end;
end;

function TTestDBParadoxFileReader.WriteFixture(const Data: TBytes): string;
var
  Stream: TFileStream;
begin
  Result := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'DBParadoxReader-' + IntToStr(GetTickCount64) + '.DB';
  Stream := TFileStream.Create(Result, fmCreate);
  try
    if Length(Data) > 0 then
      Stream.WriteBuffer(Data[0], Length(Data));
  finally
    Stream.Free;
  end;
end;

procedure TTestDBParadoxFileReader.ReadsUnencryptedVersionSevenTable;
var
  FileName: string;
  Fields: TDBParadoxFileFields;
  Rows: TDBParadoxFileRows;
  RecordSize: Integer;
begin
  FileName := WriteFixture(BuildFixture(2, 2));
  try
    ReadDBParadoxTable(FileName, Fields, Rows, RecordSize);
    CheckEquals(5, RecordSize);
    CheckEquals(2, Length(Fields));
    CheckEquals('ID', Fields[0].Name);
    CheckEquals(0, Fields[0].Offset);
    CheckEquals('Label', Fields[1].Name);
    CheckEquals(4, Fields[1].Offset);
    CheckEquals(2, Length(Rows));
    CheckEquals(0, Rows[0].RecordNumber);
    CheckEquals(1, Rows[0].Data[3]);
    CheckEquals(Ord('A'), Rows[0].Data[4]);
    CheckEquals(1, Rows[1].RecordNumber);
    CheckEquals(2, Rows[1].Data[3]);
    CheckEquals(Ord('B'), Rows[1].Data[4]);
  finally
    DeleteFile(FileName);
  end;
end;

procedure TTestDBParadoxFileReader.RejectsPhysicalRecordCountMismatch;
var
  FileName: string;
  Fields: TDBParadoxFileFields;
  Rows: TDBParadoxFileRows;
  RecordSize: Integer;
  RaisedExpectedError: Boolean;
begin
  FileName := WriteFixture(BuildFixture(1, 2));
  try
    RaisedExpectedError := False;
    try
      ReadDBParadoxTable(FileName, Fields, Rows, RecordSize);
    except
      on E: EDBParadoxFileReadError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError,
      'The internal reader must not expose undeclared physical record slots.');
  finally
    DeleteFile(FileName);
  end;
end;

initialization
  RegisterTest(TTestDBParadoxFileReader);

end.
