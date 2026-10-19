unit DBParadoxStagedTable;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxRecordEncoder, DBParadoxTableFileBuilder;

type
  EDBParadoxStagedTableError = class(Exception);
  TDBParadoxStagedTableState = (dpstActive, dpstCommitted, dpstRolledBack);

  TDBParadoxStagedTable = class
  private
    FTableName: string;
    FFields: TDBParadoxRecordFields;
    FPrimaryKeyFieldIndex: SizeInt;
    FOriginalRows: TDBParadoxTableRows;
    FRows: TDBParadoxTableRows;
    FState: TDBParadoxStagedTableState;
    procedure RequireActive;
    procedure ValidateRow(const AValues: TDBParadoxRecordValues);
    procedure ValidateKey(const AKey: TBytes);
    function EncodeKey(const AValues: TDBParadoxRecordValues): TBytes;
    function FindRowByKey(const AKey: TBytes): SizeInt;
    procedure ValidateUniqueKeys(const ARows: TDBParadoxTableRows);
    function GetRowCount: SizeInt;
  public
    constructor Create(const ATableName: string;
      const AFields: TDBParadoxRecordFields;
      APrimaryKeyFieldIndex: SizeInt; const ARows: TDBParadoxTableRows);
    function Insert(const AValues: TDBParadoxRecordValues): Integer;
    function UpdateByPrimaryKey(const AKey: TBytes;
      const AValues: TDBParadoxRecordValues): Integer;
    function DeleteByPrimaryKey(const AKey: TBytes): Integer;
    function Rows: TDBParadoxTableRows;
    procedure Commit;
    procedure Rollback;
    property TableName: string read FTableName;
    property State: TDBParadoxStagedTableState read FState;
    property RowCount: SizeInt read GetRowCount;
  end;

implementation

const
  ParadoxAlpha = $01;
  ParadoxLong = $04;

function CopyFields(const ASource: TDBParadoxRecordFields):
  TDBParadoxRecordFields;
var
  Index: SizeInt;
begin
  Result := Copy(ASource, 0, Length(ASource));
  for Index := 0 to High(Result) do
    Result[Index].Name := ASource[Index].Name;
end;

function CopyRows(const ASource: TDBParadoxTableRows): TDBParadoxTableRows;
var
  RowIndex: SizeInt;
begin
  Result := Copy(ASource, 0, Length(ASource));
  for RowIndex := 0 to High(Result) do
    Result[RowIndex] := Copy(ASource[RowIndex], 0,
      Length(ASource[RowIndex]));
end;

constructor TDBParadoxStagedTable.Create(const ATableName: string;
  const AFields: TDBParadoxRecordFields; APrimaryKeyFieldIndex: SizeInt;
  const ARows: TDBParadoxTableRows);
var
  FieldIndex, RowIndex: SizeInt;
begin
  inherited Create;
  if Trim(ATableName) = '' then
    raise EDBParadoxStagedTableError.Create(
      'A table name is required for staged writes.');
  if (APrimaryKeyFieldIndex < 0) or
    (APrimaryKeyFieldIndex >= Length(AFields)) then
    raise EDBParadoxStagedTableError.Create(
      'The primary-key field index is outside the table schema.');

  FTableName := ExpandFileName(ATableName);
  FFields := CopyFields(AFields);
  FPrimaryKeyFieldIndex := APrimaryKeyFieldIndex;
  for FieldIndex := 0 to High(FFields) do
    if not (FFields[FieldIndex].TypeCode in [ParadoxAlpha, ParadoxLong]) then
      raise EDBParadoxStagedTableError.CreateFmt(
        'Field "%s" is not Alpha or Long.',
        [FFields[FieldIndex].Name]);

  if not (FFields[FPrimaryKeyFieldIndex].TypeCode in
    [ParadoxAlpha, ParadoxLong]) then
    raise EDBParadoxStagedTableError.Create(
      'The primary key must be an Alpha or Long field.');

  FOriginalRows := CopyRows(ARows);
  for RowIndex := 0 to High(FOriginalRows) do
    ValidateRow(FOriginalRows[RowIndex]);
  ValidateUniqueKeys(FOriginalRows);
  FRows := CopyRows(FOriginalRows);
  FState := dpstActive;
end;

procedure TDBParadoxStagedTable.RequireActive;
begin
  if FState <> dpstActive then
    raise EDBParadoxStagedTableError.CreateFmt(
      'The staged table is not active (state %d).', [Ord(FState)]);
end;

procedure TDBParadoxStagedTable.ValidateRow(
  const AValues: TDBParadoxRecordValues);
var
  FieldIndex, CharIndex: SizeInt;
begin
  if Length(AValues) <> Length(FFields) then
    raise EDBParadoxStagedTableError.Create(
      'The value count must match the table schema.');

  for FieldIndex := 0 to High(FFields) do
  begin
    if FFields[FieldIndex].TypeCode = ParadoxAlpha then
    begin
      if Length(AValues[FieldIndex]) > FFields[FieldIndex].Length then
        raise EDBParadoxStagedTableError.CreateFmt(
          'Value for field "%s" exceeds its physical width.',
          [FFields[FieldIndex].Name]);
      if (Length(AValues[FieldIndex]) > 0) and
        (AValues[FieldIndex][Length(AValues[FieldIndex])] = ' ') then
        raise EDBParadoxStagedTableError.CreateFmt(
          'Value for field "%s" ends with spaces and cannot be round-tripped.',
          [FFields[FieldIndex].Name]);
      for CharIndex := 1 to Length(AValues[FieldIndex]) do
        if Ord(AValues[FieldIndex][CharIndex]) = 0 then
          raise EDBParadoxStagedTableError.CreateFmt(
            'Embedded NUL in field "%s" cannot be round-tripped.',
            [FFields[FieldIndex].Name])
        else if Ord(AValues[FieldIndex][CharIndex]) > $7F then
          raise EDBParadoxStagedTableError.CreateFmt(
            'Non-ASCII value for field "%s" is not supported.',
            [FFields[FieldIndex].Name]);
    end;
  end;

  try
    EncodeDBParadoxRecord(FFields, AValues);
  except
    on E: EDBParadoxRecordEncodingError do
      raise EDBParadoxStagedTableError.CreateFmt(
        'The row cannot be encoded: %s: %s', [E.ClassName, E.Message]);
  end;

  if AValues[FPrimaryKeyFieldIndex] = '' then
    raise EDBParadoxStagedTableError.Create(
      'The primary key cannot be NULL or empty.');
end;

procedure TDBParadoxStagedTable.ValidateKey(const AKey: TBytes);
var
  Index: SizeInt;
  IsNullKey: Boolean;
  KeyTerminated: Boolean;
begin
  if Length(AKey) <> FFields[FPrimaryKeyFieldIndex].Length then
    raise EDBParadoxStagedTableError.Create(
      'The primary-key value has an invalid encoded width.');
  IsNullKey := True;
  KeyTerminated := False;
  for Index := 0 to High(AKey) do
    if AKey[Index] <> 0 then
    begin
      IsNullKey := False;
      if (FFields[FPrimaryKeyFieldIndex].TypeCode = ParadoxAlpha) and
        KeyTerminated then
        raise EDBParadoxStagedTableError.Create(
          'An Alpha primary key contains data after its terminator.');
    end
    else if FFields[FPrimaryKeyFieldIndex].TypeCode = ParadoxAlpha then
      KeyTerminated := True;
  if IsNullKey then
    raise EDBParadoxStagedTableError.Create(
      'The NULL primary-key value cannot identify a row.');
end;

function TDBParadoxStagedTable.EncodeKey(
  const AValues: TDBParadoxRecordValues): TBytes;
var
  EncodedRow: TBytes;
  FieldOffset, FieldIndex: SizeInt;
  KeyLength: SizeInt;
begin
  Result := nil;
  EncodedRow := EncodeDBParadoxRecord(FFields, AValues);
  FieldOffset := 0;
  for FieldIndex := 0 to FPrimaryKeyFieldIndex - 1 do
    Inc(FieldOffset, FFields[FieldIndex].Length);
  KeyLength := FFields[FPrimaryKeyFieldIndex].Length;
  SetLength(Result, KeyLength);
  Move(EncodedRow[FieldOffset], Result[0], KeyLength);
end;

function TDBParadoxStagedTable.FindRowByKey(const AKey: TBytes): SizeInt;
var
  RowIndex: SizeInt;
  CandidateKey: TBytes;
begin
  for RowIndex := 0 to High(FRows) do
  begin
    CandidateKey := EncodeKey(FRows[RowIndex]);
    if (Length(CandidateKey) = Length(AKey)) and
      ((Length(AKey) = 0) or
       (CompareByte(CandidateKey[0], AKey[0], Length(AKey)) = 0)) then
      Exit(RowIndex);
  end;
  Result := -1;
end;

procedure TDBParadoxStagedTable.ValidateUniqueKeys(
  const ARows: TDBParadoxTableRows);
var
  RowIndex, OtherIndex: SizeInt;
  Key, OtherKey: TBytes;
begin
  for RowIndex := 0 to High(ARows) do
  begin
    Key := EncodeKey(ARows[RowIndex]);
    for OtherIndex := 0 to RowIndex - 1 do
    begin
      OtherKey := EncodeKey(ARows[OtherIndex]);
      if (Length(Key) = Length(OtherKey)) and
        ((Length(Key) = 0) or
         (CompareByte(Key[0], OtherKey[0], Length(Key)) = 0)) then
        raise EDBParadoxStagedTableError.Create(
          'Primary-key values must be unique.');
    end;
  end;
end;

function TDBParadoxStagedTable.Insert(
  const AValues: TDBParadoxRecordValues): Integer;
var
  Key: TBytes;
  NewRowIndex: SizeInt;
begin
  RequireActive;
  ValidateRow(AValues);
  Key := EncodeKey(AValues);
  if FindRowByKey(Key) >= 0 then
    raise EDBParadoxStagedTableError.Create(
      'Primary-key values must be unique.');
  NewRowIndex := Length(FRows);
  SetLength(FRows, NewRowIndex + 1);
  FRows[NewRowIndex] := Copy(AValues, 0, Length(AValues));
  Result := 1;
end;

function TDBParadoxStagedTable.UpdateByPrimaryKey(const AKey: TBytes;
  const AValues: TDBParadoxRecordValues): Integer;
var
  RowIndex, OtherIndex: SizeInt;
  NewKey, OtherKey: TBytes;
begin
  RequireActive;
  ValidateKey(AKey);
  ValidateRow(AValues);
  RowIndex := FindRowByKey(AKey);
  if RowIndex < 0 then
    Exit(0);

  NewKey := EncodeKey(AValues);
  if (Length(NewKey) <> Length(AKey)) or
    ((Length(AKey) > 0) and
     (CompareByte(NewKey[0], AKey[0], Length(AKey)) <> 0)) then
    raise EDBParadoxStagedTableError.Create(
      'Updating the primary key is not supported.');

  for OtherIndex := 0 to High(FRows) do
    if OtherIndex <> RowIndex then
    begin
      OtherKey := EncodeKey(FRows[OtherIndex]);
      if (Length(NewKey) = Length(OtherKey)) and
        ((Length(NewKey) = 0) or
         (CompareByte(NewKey[0], OtherKey[0], Length(NewKey)) = 0)) then
        raise EDBParadoxStagedTableError.Create(
          'Primary-key values must be unique.');
    end;

  FRows[RowIndex] := Copy(AValues, 0, Length(AValues));
  Result := 1;
end;

function TDBParadoxStagedTable.DeleteByPrimaryKey(
  const AKey: TBytes): Integer;
var
  RowIndex, LastIndex: SizeInt;
begin
  RequireActive;
  ValidateKey(AKey);
  RowIndex := FindRowByKey(AKey);
  if RowIndex < 0 then
    Exit(0);
  LastIndex := High(FRows);
  while RowIndex < LastIndex do
  begin
    FRows[RowIndex] := FRows[RowIndex + 1];
    Inc(RowIndex);
  end;
  SetLength(FRows, LastIndex);
  Result := 1;
end;

function TDBParadoxStagedTable.Rows: TDBParadoxTableRows;
begin
  Result := CopyRows(FRows);
end;

procedure TDBParadoxStagedTable.Commit;
begin
  RequireActive;
  FOriginalRows := nil;
  FState := dpstCommitted;
end;

procedure TDBParadoxStagedTable.Rollback;
begin
  RequireActive;
  FRows := CopyRows(FOriginalRows);
  FState := dpstRolledBack;
end;

function TDBParadoxStagedTable.GetRowCount: SizeInt;
begin
  Result := Length(FRows);
end;

end.
