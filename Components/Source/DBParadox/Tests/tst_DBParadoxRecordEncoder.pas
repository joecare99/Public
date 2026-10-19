unit tst_DBParadoxRecordEncoder;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  fpcunit, testregistry;

type
  TTestDBParadoxRecordEncoder = class(TTestCase)
  published
    procedure MatchesCrossImplementationGoldenVector;
    procedure EncodesWindows1252AlphaAndZeroPadding;
    procedure EncodesParadoxShortLongAndAutoIncrement;
    procedure EncodesNullAndEmptyValuesAsZeroes;
    procedure RejectsInvalidIntegerAndFieldWidth;
    procedure RejectsNonEmptyMemoAndUnsupportedTypes;
    procedure RejectsMismatchedValueCount;
  end;

implementation

uses
  SysUtils, DBParadoxConformanceVectors, DBParadoxRecordEncoder;

procedure TTestDBParadoxRecordEncoder.MatchesCrossImplementationGoldenVector;
var
  Fields: TDBParadoxRecordFields;
  Values: TDBParadoxRecordValues;
  Encoded: TBytes;
  Expected: TBytes;
begin
  Fields := nil;
  SetLength(Fields, 4);
  Fields[0].Name := 'Label';
  Fields[0].TypeCode := $01;
  Fields[0].Length := 7;
  Fields[1].Name := 'Small';
  Fields[1].TypeCode := $03;
  Fields[1].Length := 2;
  Fields[2].Name := 'Large';
  Fields[2].TypeCode := $04;
  Fields[2].Length := 4;
  Fields[3].Name := 'Auto';
  Fields[3].TypeCode := $16;
  Fields[3].Length := 4;
  Values := ['Ä€漢', '32767', '91041', '91042'];
  Expected := DecodeDBParadoxHex(ReadDBParadoxVector('record-mixed-types'));

  Encoded := EncodeDBParadoxRecord(Fields, Values);

  CheckEquals(Length(Expected), Length(Encoded));
  CheckEquals(0, CompareByte(Encoded[0], Expected[0], Length(Expected)));
end;

procedure TTestDBParadoxRecordEncoder.EncodesWindows1252AlphaAndZeroPadding;
var
  Fields: TDBParadoxRecordFields;
  Values: TDBParadoxRecordValues;
  Encoded: TBytes;
begin
  Fields := nil;
  SetLength(Fields, 1);
  Fields[0].Name := 'Label';
  Fields[0].TypeCode := $01;
  Fields[0].Length := 7;
  Values := ['Ä€漢'];

  Encoded := EncodeDBParadoxRecord(Fields, Values);

  CheckEquals(7, Length(Encoded));
  CheckEquals($C4, Encoded[0]);
  CheckEquals($80, Encoded[1]);
  CheckEquals(Ord('?'), Encoded[2]);
  CheckEquals(0, Encoded[3]);
  CheckEquals(0, Encoded[6]);
end;

procedure TTestDBParadoxRecordEncoder.EncodesParadoxShortLongAndAutoIncrement;
var
  Fields: TDBParadoxRecordFields;
  Values: TDBParadoxRecordValues;
  Encoded: TBytes;
begin
  Fields := nil;
  SetLength(Fields, 3);
  Fields[0].Name := 'Small';
  Fields[0].TypeCode := $03;
  Fields[0].Length := 2;
  Fields[1].Name := 'Large';
  Fields[1].TypeCode := $04;
  Fields[1].Length := 4;
  Fields[2].Name := 'Auto';
  Fields[2].TypeCode := $16;
  Fields[2].Length := 4;
  Values := ['32767', '91041', '91042'];

  Encoded := EncodeDBParadoxRecord(Fields, Values);

  CheckEquals($FF, Encoded[0]);
  CheckEquals($FF, Encoded[1]);
  CheckEquals($80, Encoded[2]);
  CheckEquals($01, Encoded[3]);
  CheckEquals($63, Encoded[4]);
  CheckEquals($A1, Encoded[5]);
  CheckEquals($80, Encoded[6]);
  CheckEquals($01, Encoded[7]);
  CheckEquals($63, Encoded[8]);
  CheckEquals($A2, Encoded[9]);
end;

procedure TTestDBParadoxRecordEncoder.EncodesNullAndEmptyValuesAsZeroes;
var
  Fields: TDBParadoxRecordFields;
  Values: TDBParadoxRecordValues;
  Encoded: TBytes;
  Index: SizeInt;
begin
  Fields := nil;
  SetLength(Fields, 3);
  Fields[0].Name := 'Text';
  Fields[0].TypeCode := $01;
  Fields[0].Length := 3;
  Fields[1].Name := 'Integer';
  Fields[1].TypeCode := $04;
  Fields[1].Length := 4;
  Fields[2].Name := 'Memo';
  Fields[2].TypeCode := $0C;
  Fields[2].Length := 4;
  Values := ['', '', ''];

  Encoded := EncodeDBParadoxRecord(Fields, Values);

  for Index := 0 to High(Encoded) do
    CheckEquals(0, Encoded[Index]);
end;

procedure TTestDBParadoxRecordEncoder.RejectsInvalidIntegerAndFieldWidth;
var
  Fields: TDBParadoxRecordFields;
  Values: TDBParadoxRecordValues;
begin
  Fields := nil;
  SetLength(Fields, 1);
  Fields[0].Name := 'ID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  Values := ['2147483648'];
  try
    EncodeDBParadoxRecord(Fields, Values);
    Fail('Expected an out-of-range integer to be rejected.');
  except
    on E: EDBParadoxRecordEncodingError do ;
  end;

  Fields[0].Length := 3;
  Values := ['1'];
  try
    EncodeDBParadoxRecord(Fields, Values);
    Fail('Expected a malformed integer field width to be rejected.');
  except
    on E: EDBParadoxRecordEncodingError do ;
  end;
end;

procedure TTestDBParadoxRecordEncoder.RejectsNonEmptyMemoAndUnsupportedTypes;
var
  Fields: TDBParadoxRecordFields;
  Values: TDBParadoxRecordValues;
begin
  Fields := nil;
  SetLength(Fields, 1);
  Fields[0].Name := 'Memo';
  Fields[0].TypeCode := $0C;
  Fields[0].Length := 4;
  Values := ['not empty'];
  try
    EncodeDBParadoxRecord(Fields, Values);
    Fail('Expected non-empty memo content to be rejected.');
  except
    on E: EDBParadoxUnsupportedRecordField do ;
  end;

  Values := [' '];
  try
    EncodeDBParadoxRecord(Fields, Values);
    Fail('Expected whitespace-only memo content to be rejected.');
  except
    on E: EDBParadoxUnsupportedRecordField do ;
  end;

  Fields[0].Name := 'Date';
  Fields[0].TypeCode := $05;
  Fields[0].Length := 4;
  Values := [''];
  try
    EncodeDBParadoxRecord(Fields, Values);
    Fail('Expected an unsupported field type to be rejected.');
  except
    on E: EDBParadoxUnsupportedRecordField do ;
  end;
end;

procedure TTestDBParadoxRecordEncoder.RejectsMismatchedValueCount;
var
  Fields: TDBParadoxRecordFields;
  Values: TDBParadoxRecordValues;
begin
  Fields := nil;
  SetLength(Fields, 1);
  Fields[0].Name := 'ID';
  Fields[0].TypeCode := $04;
  Fields[0].Length := 4;
  Values := [];
  try
    EncodeDBParadoxRecord(Fields, Values);
    Fail('Expected a value-count mismatch to be rejected.');
  except
    on E: EDBParadoxRecordEncodingError do ;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxRecordEncoder);

end.
