unit DBParadoxRecordEncoder;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  EDBParadoxRecordEncodingError = class(Exception);
  EDBParadoxUnsupportedRecordField = class(EDBParadoxRecordEncodingError);

  TDBParadoxRecordField = record
    Name: string;
    TypeCode: Byte;
    Length: SizeInt;
  end;

  TDBParadoxRecordFields = array of TDBParadoxRecordField;
  TDBParadoxRecordValues = array of UnicodeString;

function EncodeDBParadoxRecord(const Fields: TDBParadoxRecordFields;
  const Values: TDBParadoxRecordValues): TBytes;

implementation

const
  ParadoxAlpha = $01;
  ParadoxDate = $02;    { Date: 4-Byte-Tagesnummer }
  ParadoxShort = $03;
  ParadoxLong = $04;
  ParadoxNumber = $06;  { Number: 8-Byte IEEE-Gleitkommazahl }
  ParadoxDateOffset = 693594;
  ParadoxMemo = $0C;
  ParadoxBlob = $0D;
  ParadoxFormattedMemo = $0E;
  ParadoxOle = $0F;
  ParadoxGraphic = $10;
  ParadoxAutoIncrement = $16;

function IsUnicodeWhitespace(const AChar: WideChar): Boolean;
var
  CodePoint: Cardinal;
begin
  CodePoint := Ord(AChar);
  Result := (CodePoint >= $0009) and (CodePoint <= $000D);
  Result := Result or (CodePoint = $0020) or (CodePoint = $0085) or
    (CodePoint = $00A0) or (CodePoint = $1680) or
    ((CodePoint >= $2000) and (CodePoint <= $200A)) or
    (CodePoint = $2028) or (CodePoint = $2029) or
    (CodePoint = $202F) or (CodePoint = $205F) or
    (CodePoint = $3000);
end;

function Windows1252Byte(const AChar: WideChar): Byte;
begin
  if (Ord(AChar) <= $007F) or
    ((Ord(AChar) >= $00A0) and (Ord(AChar) <= $00FF)) then
    Exit(Byte(Ord(AChar)));

  case Ord(AChar) of
    $20AC: Result := $80;
    $0081: Result := $81;
    $201A: Result := $82;
    $0192: Result := $83;
    $201E: Result := $84;
    $2026: Result := $85;
    $2020: Result := $86;
    $2021: Result := $87;
    $02C6: Result := $88;
    $2030: Result := $89;
    $0160: Result := $8A;
    $2039: Result := $8B;
    $0152: Result := $8C;
    $008D: Result := $8D;
    $017D: Result := $8E;
    $008F: Result := $8F;
    $0090: Result := $90;
    $2018: Result := $91;
    $2019: Result := $92;
    $201C: Result := $93;
    $201D: Result := $94;
    $2022: Result := $95;
    $2013: Result := $96;
    $2014: Result := $97;
    $02DC: Result := $98;
    $2122: Result := $99;
    $0161: Result := $9A;
    $203A: Result := $9B;
    $0153: Result := $9C;
    $009D: Result := $9D;
    $017E: Result := $9E;
    $0178: Result := $9F;
  else
    Result := Ord('?');
  end;
end;

function ParseNonNegativeInteger(const AValue: UnicodeString;
  const AFieldName: string;
  const AMaxValue: Int64): Int64;
var
  StartIndex, EndIndex, Index: SizeInt;
  Negative: Boolean;
  Digit: Integer;
  Accumulator: Int64;
begin
  StartIndex := 1;
  EndIndex := Length(AValue);
  while (StartIndex <= EndIndex) and
    IsUnicodeWhitespace(AValue[StartIndex]) do
    Inc(StartIndex);
  while (EndIndex >= StartIndex) and
    IsUnicodeWhitespace(AValue[EndIndex]) do
    Dec(EndIndex);

  if StartIndex > EndIndex then
    Exit(0);

  Negative := False;
  if (AValue[StartIndex] = '+') or (AValue[StartIndex] = '-') then
  begin
    Negative := AValue[StartIndex] = '-';
    Inc(StartIndex);
  end;
  if StartIndex > EndIndex then
    raise EDBParadoxRecordEncodingError.CreateFmt(
      'Value for integer field "%s" is invalid or out of range.',
      [AFieldName]);

  Accumulator := 0;
  for Index := StartIndex to EndIndex do
  begin
    Digit := Ord(AValue[Index]) - Ord('0');
    if (Digit < 0) or (Digit > 9) then
      raise EDBParadoxRecordEncodingError.CreateFmt(
        'Value for integer field "%s" is invalid or out of range.',
        [AFieldName]);
    if Accumulator > (AMaxValue - Digit) div 10 then
      raise EDBParadoxRecordEncodingError.CreateFmt(
        'Value for integer field "%s" is invalid or out of range.',
        [AFieldName]);
    Accumulator := Accumulator * 10 + Digit;
  end;

  if Negative and (Accumulator <> 0) then
    raise EDBParadoxRecordEncodingError.CreateFmt(
      'Value for integer field "%s" is invalid or out of range.',
      [AFieldName]);
  Result := Accumulator;
end;

procedure EncodeInteger(const AValue: UnicodeString;
  const AFieldName: string;
  const AExpectedLength: SizeInt; const ADestination: TBytes;
  const AOffset: SizeInt);
var
  MaxValue, Number: Int64;
  Index: SizeInt;
begin
  if AExpectedLength = 2 then
    MaxValue := High(SmallInt)
  else
    MaxValue := High(LongInt);
  Number := ParseNonNegativeInteger(AValue, AFieldName, MaxValue);
  if Number = 0 then
    Exit;

  for Index := 0 to AExpectedLength - 1 do
  begin
    ADestination[AOffset + AExpectedLength - Index - 1] :=
      Byte(Number and $FF);
    Number := Number shr 8;
  end;
  ADestination[AOffset] := ADestination[AOffset] or $80;
end;

function ParseParadoxLong(const AValue: UnicodeString;
  const AFieldName: string; out AIsNull: Boolean): LongInt;
var
  StartIndex, EndIndex, Index: SizeInt;
  Negative: Boolean;
  Digit: Integer;
  Magnitude: Int64;
begin
  StartIndex := 1;
  EndIndex := Length(AValue);
  while (StartIndex <= EndIndex) and
    IsUnicodeWhitespace(AValue[StartIndex]) do
    Inc(StartIndex);
  while (EndIndex >= StartIndex) and
    IsUnicodeWhitespace(AValue[EndIndex]) do
    Dec(EndIndex);

  if StartIndex > EndIndex then
  begin
    AIsNull := True;
    Exit(0);
  end;

  AIsNull := False;
  Negative := False;
  if (AValue[StartIndex] = '+') or (AValue[StartIndex] = '-') then
  begin
    Negative := AValue[StartIndex] = '-';
    Inc(StartIndex);
  end;
  if StartIndex > EndIndex then
    raise EDBParadoxRecordEncodingError.CreateFmt(
      'Value for long field "%s" is invalid or out of range.',
      [AFieldName]);

  Magnitude := 0;
  for Index := StartIndex to EndIndex do
  begin
    Digit := Ord(AValue[Index]) - Ord('0');
    if (Digit < 0) or (Digit > 9) or
      (Magnitude > (Int64(High(LongInt)) - Digit) div 10) then
      raise EDBParadoxRecordEncodingError.CreateFmt(
        'Value for long field "%s" is invalid or out of range.',
        [AFieldName]);
    Magnitude := Magnitude * 10 + Digit;
  end;

  if Negative then
    Result := -LongInt(Magnitude)
  else
    Result := LongInt(Magnitude);
end;

procedure EncodeLong(const AValue: UnicodeString;
  const AFieldName: string; const ADestination: TBytes;
  const AOffset: SizeInt);
var
  Value: LongInt;
  EncodedValue: Cardinal;
  ByteIndex: SizeInt;
  IsNull: Boolean;
begin
  Value := ParseParadoxLong(AValue, AFieldName, IsNull);
  if IsNull then
    Exit;

  EncodedValue := Cardinal(Value) xor $80000000;
  for ByteIndex := 0 to 3 do
  begin
    ADestination[AOffset + 3 - ByteIndex] := Byte(EncodedValue and $FF);
    EncodedValue := EncodedValue shr 8;
  end;
end;

procedure EncodeNumber(const AValue: UnicodeString;
  const AFieldName: string; const ADestination: TBytes;
  const AOffset: SizeInt);
var
  Text: string;
  Value: Double;
  Bits: QWord;
  ByteIndex: SizeInt;
begin
  Text := Trim(UTF8Encode(AValue));
  if Text = '' then
    Exit;  { leer = Null (alle Bytes null) }
  try
    Value := StrToFloat(Text);
  except
    on E: EConvertError do
      raise EDBParadoxRecordEncodingError.CreateFmt(
        'Value for number field "%s" is invalid.', [AFieldName]);
  end;
  { Big-endian mit gekipptem Vorzeichenbit (wie die Long-Felder). }
  Bits := 0;
  Move(Value, Bits, SizeOf(Double));
  Bits := Bits xor QWord($8000000000000000);
  for ByteIndex := 0 to 7 do
    ADestination[AOffset + ByteIndex] :=
      Byte((Bits shr ((7 - ByteIndex) * 8)) and $FF);
end;

procedure EncodeDate(const AValue: UnicodeString;
  const AFieldName: string; const ADestination: TBytes;
  const AOffset: SizeInt);
var
  Text: string;
  Value: Double;
  Days: Cardinal;
begin
  Text := Trim(UTF8Encode(AValue));
  if Text = '' then
    Exit;  { leer = Null (alle Bytes null) }
  { Je nach Herkunft liegt ein TDateTime als Zahl oder als Datumsstring vor. }
  try
    Value := StrToFloat(Text);
  except
    on E: EConvertError do
    begin
      try
        Value := StrToDate(Text);
      except
        on E2: EConvertError do
          raise EDBParadoxRecordEncodingError.CreateFmt(
            'Value for date field "%s" is invalid.', [AFieldName]);
      end;
    end;
  end;
  { Big-endian mit gekipptem Vorzeichenbit (wie die Long-Felder). }
  Days := Cardinal(Trunc(Value) + ParadoxDateOffset) xor $80000000;
  ADestination[AOffset] := Byte((Days shr 24) and $FF);
  ADestination[AOffset + 1] := Byte((Days shr 16) and $FF);
  ADestination[AOffset + 2] := Byte((Days shr 8) and $FF);
  ADestination[AOffset + 3] := Byte(Days and $FF);
end;

function EncodeDBParadoxRecord(const Fields: TDBParadoxRecordFields;
  const Values: TDBParadoxRecordValues): TBytes;
var
  FieldIndex, Offset, ValueIndex: SizeInt;
  Field: TDBParadoxRecordField;
  Value: UnicodeString;
  EncodedLength: SizeInt;
begin
  if Length(Fields) <> Length(Values) then
    raise EDBParadoxRecordEncodingError.Create(
      'The value count must match the field count.');

  EncodedLength := 0;
  Result := nil;
  for FieldIndex := 0 to High(Fields) do
  begin
    if Fields[FieldIndex].Length <= 0 then
      raise EDBParadoxRecordEncodingError.CreateFmt(
        'Field "%s" has an invalid physical width.',
        [Fields[FieldIndex].Name]);
    Inc(EncodedLength, Fields[FieldIndex].Length);
  end;
  SetLength(Result, EncodedLength);

  Offset := 0;
  for FieldIndex := 0 to High(Fields) do
  begin
    Field := Fields[FieldIndex];
    Value := Values[FieldIndex];
    case Field.TypeCode of
      ParadoxAlpha:
        begin
          if Length(Value) > Field.Length then
            raise EDBParadoxRecordEncodingError.CreateFmt(
              'Value for field "%s" exceeds its %d-byte Paradox width.',
              [Field.Name, Field.Length]);
          for ValueIndex := 1 to Length(Value) do
            Result[Offset + ValueIndex - 1] := Windows1252Byte(Value[ValueIndex]);
        end;
      ParadoxDate:
        begin
          if Field.Length <> 4 then
            raise EDBParadoxRecordEncodingError.CreateFmt(
              'Date field "%s" has an unsupported physical size.',
              [Field.Name]);
          EncodeDate(Value, Field.Name, Result, Offset);
        end;
      ParadoxShort:
        begin
          if Field.Length <> 2 then
            raise EDBParadoxRecordEncodingError.CreateFmt(
              'Integer field "%s" has an unsupported physical size.',
              [Field.Name]);
          EncodeInteger(Value, Field.Name, 2, Result, Offset);
        end;
      ParadoxLong:
        begin
          if Field.Length <> 4 then
            raise EDBParadoxRecordEncodingError.CreateFmt(
              'Long field "%s" has an unsupported physical size.',
              [Field.Name]);
          EncodeLong(Value, Field.Name, Result, Offset);
        end;
      ParadoxNumber:
        begin
          if Field.Length <> 8 then
            raise EDBParadoxRecordEncodingError.CreateFmt(
              'Number field "%s" has an unsupported physical size.',
              [Field.Name]);
          EncodeNumber(Value, Field.Name, Result, Offset);
        end;
      ParadoxAutoIncrement:
        begin
          if Field.Length <> 4 then
            raise EDBParadoxRecordEncodingError.CreateFmt(
              'Auto-increment field "%s" has an unsupported physical size.',
              [Field.Name]);
          EncodeInteger(Value, Field.Name, 4, Result, Offset);
        end;
      ParadoxMemo, ParadoxFormattedMemo, ParadoxBlob, ParadoxOle,
      ParadoxGraphic:
        if Value <> '' then
          raise EDBParadoxUnsupportedRecordField.CreateFmt(
            'No memo/blob writer is configured for field "%s".',
            [Field.Name]);
    else
      raise EDBParadoxUnsupportedRecordField.CreateFmt(
        'Field type 0x%.2x is not supported for field "%s".',
        [Field.TypeCode, Field.Name]);
    end;
    Inc(Offset, Field.Length);
  end;
end;

end.
