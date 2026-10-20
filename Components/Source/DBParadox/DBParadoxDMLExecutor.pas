unit DBParadoxDMLExecutor;

{$mode objfpc}{$H+}

interface

uses
  DB, DBParadoxRecordEncoder, DBParadoxSQLParser, SysUtils;

type
  EDBParadoxDMLValidationError = class(Exception);

  TDBParadoxPreparedDML = record
    Values: TDBParadoxRecordValues;
    PrimaryKey: TBytes;
  end;

procedure ValidateDBParadoxDMLPlan(const Plan: TDBParadoxDMLPlan;
  const Fields: TDBParadoxRecordFields; PrimaryKeyFieldIndex: SizeInt;
  Params: TParams);

function PrepareDBParadoxDML(const Plan: TDBParadoxDMLPlan;
  const Fields: TDBParadoxRecordFields; PrimaryKeyFieldIndex: SizeInt;
  Params: TParams; const ExistingValues: TDBParadoxRecordValues):
  TDBParadoxPreparedDML;

implementation

const
  ParadoxAlpha = $01;
  ParadoxLong = $04;

function FindField(const Fields: TDBParadoxRecordFields;
  const FieldName: string): SizeInt;
var
  Index: SizeInt;
begin
  for Index := 0 to High(Fields) do
    if SameText(Fields[Index].Name, FieldName) then
      Exit(Index);
  Result := -1;
end;

function FindParameter(Params: TParams;
  const ParameterName: string): TParam;
begin
  if not Assigned(Params) then
    raise EDBParadoxDMLValidationError.CreateFmt(
      'Parameter "%s" was not supplied.', [ParameterName]);
  Result := Params.FindParam(ParameterName);
  if not Assigned(Result) then
    raise EDBParadoxDMLValidationError.CreateFmt(
      'Parameter "%s" was not supplied.', [ParameterName]);
end;

function ValueFromParameter(Param: TParam;
  const Field: TDBParadoxRecordField): UnicodeString;
var
  Index: SizeInt;
  IntegerValue: Int64;
begin
  if Param.IsNull then
    Exit('');
  case Field.TypeCode of
    ParadoxAlpha:
      begin
        if not (Param.DataType in [ftString, ftFixedChar]) then
          raise EDBParadoxDMLValidationError.CreateFmt(
            'Parameter "%s" must be a string for field "%s".',
            [Param.Name, Field.Name]);
        Result := Param.AsString;
        if Length(Result) > Field.Length then
          raise EDBParadoxDMLValidationError.CreateFmt(
            'Parameter "%s" exceeds the physical width of field "%s".',
            [Param.Name, Field.Name]);
        if (Length(Result) > 0) and (Result[Length(Result)] = ' ') then
          raise EDBParadoxDMLValidationError.CreateFmt(
            'Parameter "%s" ends with spaces and cannot be round-tripped.',
            [Param.Name]);
        for Index := 1 to Length(Result) do
          if Ord(Result[Index]) = 0 then
            raise EDBParadoxDMLValidationError.CreateFmt(
              'Parameter "%s" contains an embedded NUL for field "%s".',
              [Param.Name, Field.Name])
          else if Ord(Result[Index]) > $7F then
            raise EDBParadoxDMLValidationError.CreateFmt(
              'Parameter "%s" contains non-ASCII text for field "%s".',
              [Param.Name, Field.Name]);
      end;
    ParadoxLong:
      begin
        if not (Param.DataType in
          [ftSmallint, ftInteger, ftWord, ftLargeInt]) then
          raise EDBParadoxDMLValidationError.CreateFmt(
            'Parameter "%s" must be an integer for field "%s".',
            [Param.Name, Field.Name]);
        IntegerValue := Param.AsLargeInt;
        if (IntegerValue <= Low(LongInt)) or
          (IntegerValue > High(LongInt)) then
          raise EDBParadoxDMLValidationError.CreateFmt(
            'Parameter "%s" is outside the supported non-NULL Long range.',
            [Param.Name]);
        Result := IntToStr(IntegerValue);
      end;
  else
    raise EDBParadoxDMLValidationError.CreateFmt(
      'Field "%s" is not a supported Alpha or Long field.', [Field.Name]);
  end;
end;

procedure CheckNoUnusedParams(Params: TParams;
  const Plan: TDBParadoxDMLPlan);
var
  ParamIndex, ItemIndex: SizeInt;
  Used: Boolean;
begin
  if not Assigned(Params) then
    Exit;
  for ParamIndex := 0 to Params.Count - 1 do
  begin
    Used := False;
    case Plan.StatementType of
      dpdInsert:
        for ItemIndex := 0 to High(Plan.InsertParameters) do
          if SameText(Params[ParamIndex].Name,
            Plan.InsertParameters[ItemIndex]) then
            Used := True;
      dpdUpdate:
        begin
          for ItemIndex := 0 to High(Plan.Assignments) do
            if SameText(Params[ParamIndex].Name,
              Plan.Assignments[ItemIndex].ParameterName) then
              Used := True;
          if SameText(Params[ParamIndex].Name, Plan.WhereParameter) then
            Used := True;
        end;
      dpdDelete:
        Used := SameText(Params[ParamIndex].Name, Plan.WhereParameter);
    end;
    if not Used then
      raise EDBParadoxDMLValidationError.CreateFmt(
        'Parameter "%s" is not used by the supported statement.',
        [Params[ParamIndex].Name]);
  end;
end;

procedure ValidateDBParadoxDMLPlan(const Plan: TDBParadoxDMLPlan;
  const Fields: TDBParadoxRecordFields; PrimaryKeyFieldIndex: SizeInt;
  Params: TParams);
var
  FieldIndex, Index, OtherIndex: SizeInt;
  Param: TParam;
  UsedFields: array of Boolean;
begin
  if (PrimaryKeyFieldIndex < 0) or
    (PrimaryKeyFieldIndex >= Length(Fields)) then
    raise EDBParadoxDMLValidationError.Create(
      'The table does not have a supported single-field primary key.');
  if Fields[PrimaryKeyFieldIndex].TypeCode = ParadoxLong then
  begin
    if (Fields[PrimaryKeyFieldIndex].Length <> 4) then
      raise EDBParadoxDMLValidationError.Create(
        'The Long primary key does not have its supported four-byte width.');
  end
  else if Fields[PrimaryKeyFieldIndex].TypeCode = ParadoxAlpha then
  begin
    if (Fields[PrimaryKeyFieldIndex].Length <= 0) or
      (Fields[PrimaryKeyFieldIndex].Length > High(Byte)) then
      raise EDBParadoxDMLValidationError.Create(
        'The Alpha primary key has an unsupported width.');
  end
  else
    raise EDBParadoxDMLValidationError.Create(
      'The primary key must be an Alpha or Long field.');

  for Index := 0 to High(Fields) do
    case Fields[Index].TypeCode of
      ParadoxAlpha:
        if (Fields[Index].Length <= 0) or
          (Fields[Index].Length > High(Byte)) then
          raise EDBParadoxDMLValidationError.CreateFmt(
            'Alpha field "%s" has an unsupported width.',
            [Fields[Index].Name]);
      ParadoxLong:
        if Fields[Index].Length <> 4 then
          raise EDBParadoxDMLValidationError.CreateFmt(
            'Long field "%s" does not have its supported four-byte width.',
            [Fields[Index].Name]);
    else
      raise EDBParadoxDMLValidationError.CreateFmt(
        'Field "%s" is not supported for DML.', [Fields[Index].Name]);
    end;

  SetLength(UsedFields, Length(Fields));
  if Length(UsedFields) > 0 then
    FillChar(UsedFields[0], Length(UsedFields) * SizeOf(Boolean), 0);
  case Plan.StatementType of
    dpdInsert:
      begin
        if Length(Plan.InsertFields) <> Length(Fields) then
          raise EDBParadoxDMLValidationError.Create(
            'INSERT must specify every table field exactly once.');
        if Length(Plan.InsertParameters) <> Length(Fields) then
          raise EDBParadoxDMLValidationError.Create(
            'INSERT must provide one value for every table field.');
        for Index := 0 to High(Plan.InsertFields) do
        begin
          FieldIndex := FindField(Fields, Plan.InsertFields[Index]);
          if FieldIndex < 0 then
            raise EDBParadoxDMLValidationError.CreateFmt(
              'INSERT field "%s" does not exist.',
              [Plan.InsertFields[Index]]);
          if UsedFields[FieldIndex] then
            raise EDBParadoxDMLValidationError.CreateFmt(
              'INSERT field "%s" is specified more than once.',
              [Plan.InsertFields[Index]]);
          UsedFields[FieldIndex] := True;
          Param := FindParameter(Params, Plan.InsertParameters[Index]);
          ValueFromParameter(Param, Fields[FieldIndex]);
        end;
      end;
    dpdUpdate:
      begin
        if Length(Plan.Assignments) = 0 then
          raise EDBParadoxDMLValidationError.Create(
            'UPDATE must assign at least one field.');
        for Index := 0 to High(Plan.Assignments) do
        begin
          FieldIndex := FindField(Fields, Plan.Assignments[Index].FieldName);
          if FieldIndex < 0 then
            raise EDBParadoxDMLValidationError.CreateFmt(
              'UPDATE field "%s" does not exist.',
              [Plan.Assignments[Index].FieldName]);
          if FieldIndex = PrimaryKeyFieldIndex then
            raise EDBParadoxDMLValidationError.Create(
              'Updating the primary key is not supported.');
          for OtherIndex := 0 to Index - 1 do
            if SameText(Plan.Assignments[Index].FieldName,
              Plan.Assignments[OtherIndex].FieldName) then
              raise EDBParadoxDMLValidationError.CreateFmt(
                'UPDATE field "%s" is assigned more than once.',
                [Plan.Assignments[Index].FieldName]);
          Param := FindParameter(Params,
            Plan.Assignments[Index].ParameterName);
          ValueFromParameter(Param, Fields[FieldIndex]);
        end;
        if FindField(Fields, Plan.WhereField) <> PrimaryKeyFieldIndex then
          raise EDBParadoxDMLValidationError.Create(
            'UPDATE must target the complete primary key.');
        Param := FindParameter(Params, Plan.WhereParameter);
        if Param.IsNull then
          raise EDBParadoxDMLValidationError.Create(
            'The primary-key parameter cannot be NULL.');
        if ValueFromParameter(Param, Fields[PrimaryKeyFieldIndex]) = '' then
          raise EDBParadoxDMLValidationError.Create(
            'The primary-key parameter cannot be empty.');
      end;
    dpdDelete:
      begin
        if FindField(Fields, Plan.WhereField) <> PrimaryKeyFieldIndex then
          raise EDBParadoxDMLValidationError.Create(
            'DELETE must target the complete primary key.');
        Param := FindParameter(Params, Plan.WhereParameter);
        if Param.IsNull then
          raise EDBParadoxDMLValidationError.Create(
            'The primary-key parameter cannot be NULL.');
        if ValueFromParameter(Param, Fields[PrimaryKeyFieldIndex]) = '' then
          raise EDBParadoxDMLValidationError.Create(
            'The primary-key parameter cannot be empty.');
      end;
  end;
  CheckNoUnusedParams(Params, Plan);
end;

function PrepareDBParadoxDML(const Plan: TDBParadoxDMLPlan;
  const Fields: TDBParadoxRecordFields; PrimaryKeyFieldIndex: SizeInt;
  Params: TParams; const ExistingValues: TDBParadoxRecordValues):
  TDBParadoxPreparedDML;
var
  Index, FieldIndex, KeyOffset: SizeInt;
  Param: TParam;
  KeyField: TDBParadoxRecordField;
  KeyValues: TDBParadoxRecordValues;
  EncodedRow: TBytes;
begin
  ValidateDBParadoxDMLPlan(Plan, Fields, PrimaryKeyFieldIndex, Params);
  Result.Values := nil;
  Result.PrimaryKey := nil;

  case Plan.StatementType of
    dpdInsert:
      begin
        SetLength(Result.Values, Length(Fields));
        for Index := 0 to High(Plan.InsertFields) do
        begin
          FieldIndex := FindField(Fields, Plan.InsertFields[Index]);
          Param := FindParameter(Params, Plan.InsertParameters[Index]);
          Result.Values[FieldIndex] :=
            ValueFromParameter(Param, Fields[FieldIndex]);
        end;
      end;
    dpdUpdate:
      begin
        if Length(ExistingValues) <> Length(Fields) then
          raise EDBParadoxDMLValidationError.Create(
            'The existing row does not match the table schema.');
        Result.Values := Copy(ExistingValues, 0, Length(ExistingValues));
        for Index := 0 to High(Plan.Assignments) do
        begin
          FieldIndex := FindField(Fields, Plan.Assignments[Index].FieldName);
          Param := FindParameter(Params, Plan.Assignments[Index].ParameterName);
          Result.Values[FieldIndex] := ValueFromParameter(Param, Fields[FieldIndex]);
        end;
      end;
    dpdDelete:
      if Length(ExistingValues) <> 0 then
        raise EDBParadoxDMLValidationError.Create(
          'DELETE does not accept row-value assignments.');
  end;

  if Plan.StatementType <> dpdInsert then
  begin
    Param := FindParameter(Params, Plan.WhereParameter);
    KeyField := Fields[PrimaryKeyFieldIndex];
    KeyValues := [ValueFromParameter(Param, KeyField)];
    Result.PrimaryKey := EncodeDBParadoxRecord([KeyField], KeyValues);
  end
  else
  begin
    KeyOffset := 0;
    for Index := 0 to PrimaryKeyFieldIndex - 1 do
      Inc(KeyOffset, Fields[Index].Length);
    SetLength(Result.PrimaryKey, Fields[PrimaryKeyFieldIndex].Length);
    EncodedRow := EncodeDBParadoxRecord(Fields, Result.Values);
    Move(EncodedRow[KeyOffset], Result.PrimaryKey[0],
      Length(Result.PrimaryKey));
  end;
end;

end.
