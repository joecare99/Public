unit DBParadoxConnection;

{$mode objfpc}{$H+}

interface

uses
  Classes, DB, BufDataset, SQLDB;

type
  EDBParadoxProviderError = class(EDatabaseError);
  EDBParadoxNotImplemented = class(EDBParadoxProviderError);
  EDBParadoxUnsupportedFeature = class(EDBParadoxProviderError);

  TDBParadoxConnection = class(TSQLConnection)
  private
    FOpenDocumentCount: Integer;
    procedure CursorOpened;
    procedure CursorClosed;
  protected
    procedure DoInternalConnect; override;
    procedure DoInternalDisconnect; override;

    function AllocateCursorHandle: TSQLCursor; override;
    procedure DeAllocateCursorHandle(var Cursor: TSQLCursor); override;
    function AllocateTransactionHandle: TSQLHandle; override;

    procedure PrepareStatement(Cursor: TSQLCursor;
      ATransaction: TSQLTransaction; SQL: string;
      AParams: TParams); override;
    procedure UnPrepareStatement(Cursor: TSQLCursor); override;
    procedure Execute(Cursor: TSQLCursor; ATransaction: TSQLTransaction;
      AParams: TParams); override;
    function Fetch(Cursor: TSQLCursor): Boolean; override;
    procedure AddFieldDefs(Cursor: TSQLCursor;
      FieldDefs: TFieldDefs); override;
    function LoadField(Cursor: TSQLCursor; FieldDef: TFieldDef;
      Buffer: Pointer; out CreateBlob: Boolean): Boolean; override;
    procedure LoadBlobIntoBuffer(FieldDef: TFieldDef;
      ABlobBuf: PBufBlobField; Cursor: TSQLCursor;
      ATransaction: TSQLTransaction); override;
    procedure FreeFldBuffers(Cursor: TSQLCursor); override;

    function GetTransactionHandle(AHandle: TSQLHandle): Pointer; override;
    function Commit(AHandle: TSQLHandle): Boolean; override;
    function RollBack(AHandle: TSQLHandle): Boolean; override;
    function StartDBTransaction(AHandle: TSQLHandle;
      AParams: string): Boolean; override;
    procedure CommitRetaining(AHandle: TSQLHandle); override;
    procedure RollBackRetaining(AHandle: TSQLHandle); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  SysUtils, DBParadoxSQLParser, DBParadoxFileReader;

const
  pxfAlpha = $01;
  pxfLong = $04;

type
  TDBParadoxField = TDBParadoxFileField;

  TDBParadoxFieldArray = TDBParadoxFileFields;

  TDBParadoxValue = record
    FieldType: Byte;
    IsNull: Boolean;
    IntegerValue: Int64;
    StringValue: AnsiString;
  end;

  TDBParadoxValueArray = array of TDBParadoxValue;

  TDBParadoxResultRow = record
    RecordNumber: Integer;
    Values: TDBParadoxValueArray;
  end;

  TDBParadoxResultRows = array of TDBParadoxResultRow;

  TDBParadoxCursor = class(TSQLCursor)
  private
    FConnection: TDBParadoxConnection;
    FRecordSize: Integer;
    FRecordCount: Integer;
    FNextRecord: Integer;
    FCurrentRecord: Integer;
    FCurrentRowIndex: Integer;
    FFields: TDBParadoxFieldArray;
    FTableRows: TDBParadoxFileRows;
    FResultFields: array of Integer;
    FRequiredFields: array of Boolean;
    FRows: TDBParadoxResultRows;
    FPlan: TDBParadoxSelectPlan;
    FCursorRegistered: Boolean;
    function FindFieldIndex(const AName: string): Integer;
    procedure ResolvePlanFields;
    procedure BuildResultRows(AParams: TParams);
    function CompareRows(const LeftRow, RightRow: TDBParadoxResultRow): Integer;
    procedure SortRows;
    procedure QuickSortRows(LeftIndex, RightIndex: Integer);
    procedure OpenTable(const ATableName: string);
    procedure CloseTable;
  public
    destructor Destroy; override;
  end;

  TDBParadoxTransactionHandle = class(TSQLHandle)
  public
    Active: Boolean;
  end;

procedure RaiseUnsupported(const AFeature: string);
begin
  raise EDBParadoxUnsupportedFeature.CreateFmt(
    'DBParadox read-only provider does not support %s.', [AFeature]);
end;

function RequireCursor(ACursor: TSQLCursor): TDBParadoxCursor;
begin
  if not (ACursor is TDBParadoxCursor) then
    raise EDBParadoxProviderError.Create(
      'The SQLDB cursor does not belong to DBParadox.');
  Result := TDBParadoxCursor(ACursor);
end;

function RequireTransaction(AHandle: TSQLHandle): TDBParadoxTransactionHandle;
begin
  if not (AHandle is TDBParadoxTransactionHandle) then
    raise EDBParadoxProviderError.Create(
      'The SQLDB transaction handle does not belong to DBParadox.');
  Result := TDBParadoxTransactionHandle(AHandle);
end;

function DecodeFieldValue(const Field: TDBParadoxFileField;
  const RecordData: TBytes; RecordNumber: Integer): TDBParadoxValue;
var
  ValueLength: SizeInt;
  Index: SizeInt;
  RawValue: LongInt;
begin
  Result.FieldType := Field.FieldType;
  Result.IsNull := True;
  Result.IntegerValue := 0;
  Result.StringValue := '';

  if (Field.Offset < 0) or (Field.FieldLength <= 0) or
    (Field.Offset > Length(RecordData) - Field.FieldLength) then
    raise EDBParadoxProviderError.CreateFmt(
      'Field "%s" has an invalid location in record %d.',
      [Field.Name, RecordNumber]);

  case Field.FieldType of
    pxfAlpha:
      begin
        if RecordData[Field.Offset] = 0 then
          Exit;
        ValueLength := 0;
        while (ValueLength < Field.FieldLength) and
          (RecordData[Field.Offset + ValueLength] <> 0) do
        begin
          if RecordData[Field.Offset + ValueLength] > 127 then
            RaiseUnsupported(
              'non-ASCII alpha text until code-page behavior is verified');
          Inc(ValueLength);
        end;
        while (ValueLength > 0) and
          (RecordData[Field.Offset + ValueLength - 1] = Ord(' ')) do
          Dec(ValueLength);
        SetLength(Result.StringValue, ValueLength);
        for Index := 0 to ValueLength - 1 do
          Result.StringValue[Index + 1] :=
            AnsiChar(RecordData[Field.Offset + Index]);
        Result.IsNull := False;
      end;
    pxfLong:
      begin
        if Field.FieldLength <> 4 then
          raise EDBParadoxProviderError.CreateFmt(
            'Long field "%s" does not have its required four-byte width.',
            [Field.Name]);
        if (RecordData[Field.Offset] = 0) and
          (RecordData[Field.Offset + 1] = 0) and
          (RecordData[Field.Offset + 2] = 0) and
          (RecordData[Field.Offset + 3] = 0) then
          Exit;

        RawValue := (LongInt(RecordData[Field.Offset] and $7F) shl 24) or
          (LongInt(RecordData[Field.Offset + 1]) shl 16) or
          (LongInt(RecordData[Field.Offset + 2]) shl 8) or
          LongInt(RecordData[Field.Offset + 3]);
        if (RecordData[Field.Offset] and $80) = 0 then
          RawValue := RawValue or LongInt($80000000);
        Result.IntegerValue := RawValue;
        Result.IsNull := False;
      end;
  else
    RaiseUnsupported(Format('Paradox field type %d in field "%s"',
      [Field.FieldType, Field.Name]));
  end;
end;

function CompareASCII(const LeftValue, RightValue: AnsiString): Integer;
var
  Index: SizeInt;
  CommonLength: SizeInt;
begin
  CommonLength := Length(LeftValue);
  if Length(RightValue) < CommonLength then
    CommonLength := Length(RightValue);
  for Index := 1 to CommonLength do
    if Byte(LeftValue[Index]) <> Byte(RightValue[Index]) then
      Exit(Integer(Byte(LeftValue[Index])) - Integer(Byte(RightValue[Index])));
  if Length(LeftValue) < Length(RightValue) then
    Result := -1
  else if Length(LeftValue) > Length(RightValue) then
    Result := 1
  else
    Result := 0;
end;

function ParameterValue(AParam: TParam; const Field: TDBParadoxField;
  const ParameterName: string): TDBParadoxValue;
var
  Index: SizeInt;
  IntValue: Int64;
begin
  Result.FieldType := Field.FieldType;
  Result.IsNull := AParam.IsNull;
  Result.IntegerValue := 0;
  Result.StringValue := '';
  if Result.IsNull then
    Exit;

  case Field.FieldType of
    pxfAlpha:
      begin
        if not (AParam.DataType in [ftString, ftFixedChar]) then
          raise EDBParadoxProviderError.CreateFmt(
            'Parameter "%s" must be an ASCII string for field "%s".',
            [ParameterName, Field.Name]);
        Result.StringValue := AParam.AsString;
        for Index := 1 to Length(Result.StringValue) do
          if Byte(Result.StringValue[Index]) > 127 then
            RaiseUnsupported(
              'non-ASCII parameter text until code-page behavior is verified');
      end;
    pxfLong:
      begin
        if not (AParam.DataType in
          [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeInt]) then
          raise EDBParadoxProviderError.CreateFmt(
            'Parameter "%s" must be an integer for field "%s".',
            [ParameterName, Field.Name]);
        IntValue := AParam.AsLargeInt;
        if (IntValue < Low(LongInt)) or (IntValue > High(LongInt)) then
          raise EDBParadoxProviderError.CreateFmt(
            'Parameter "%s" is outside the supported Paradox long range.',
            [ParameterName]);
        Result.IntegerValue := IntValue;
      end;
  else
    RaiseUnsupported(Format('parameter comparison for field "%s"',
      [Field.Name]));
  end;
end;

function CompareValues(const LeftValue, RightValue: TDBParadoxValue;
  NullsFirst: Boolean): Integer;
begin
  if LeftValue.IsNull or RightValue.IsNull then
  begin
    if LeftValue.IsNull and RightValue.IsNull then
      Exit(0);
    if LeftValue.IsNull then
      if NullsFirst then
        Exit(-1)
      else
        Exit(1)
    else if NullsFirst then
      Exit(1)
    else
      Exit(-1);
  end;
  if LeftValue.FieldType <> RightValue.FieldType then
    raise EDBParadoxProviderError.Create(
      'Cannot compare values with different Paradox field types.');
  case LeftValue.FieldType of
    pxfAlpha:
      Result := CompareASCII(LeftValue.StringValue, RightValue.StringValue);
    pxfLong:
      if LeftValue.IntegerValue < RightValue.IntegerValue then
        Result := -1
      else if LeftValue.IntegerValue > RightValue.IntegerValue then
        Result := 1
      else
        Result := 0;
  else
    RaiseUnsupported('comparison for this Paradox field type');
    Result := 0;
  end;
end;

constructor TDBParadoxConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOpenDocumentCount := 0;
end;

procedure TDBParadoxConnection.DoInternalConnect;
begin
  inherited DoInternalConnect;
  if not DirectoryExists(DatabaseName) then
    DatabaseErrorFmt('Paradox data directory does not exist: "%s".',
      [DatabaseName], Self);
end;

procedure TDBParadoxConnection.DoInternalDisconnect;
begin
  inherited DoInternalDisconnect;
  if FOpenDocumentCount <> 0 then
    raise EDBParadoxProviderError.CreateFmt(
      'Cannot disconnect while %d Paradox table cursor(s) remain open.',
      [FOpenDocumentCount]);
end;

procedure TDBParadoxConnection.CursorOpened;
begin
  Inc(FOpenDocumentCount);
end;

procedure TDBParadoxConnection.CursorClosed;
begin
  if FOpenDocumentCount <= 0 then
    raise EDBParadoxProviderError.Create(
      'Internal open-table cursor count is invalid.');
  Dec(FOpenDocumentCount);
end;

function TDBParadoxConnection.AllocateCursorHandle: TSQLCursor;
begin
  Result := TDBParadoxCursor.Create;
  TDBParadoxCursor(Result).FConnection := Self;
end;

procedure TDBParadoxConnection.DeAllocateCursorHandle(
  var Cursor: TSQLCursor);
begin
  if Assigned(Cursor) then
    Cursor.Free;
  Cursor := nil;
end;

function TDBParadoxConnection.AllocateTransactionHandle: TSQLHandle;
begin
  Result := TDBParadoxTransactionHandle.Create;
end;

procedure TDBParadoxConnection.PrepareStatement(Cursor: TSQLCursor;
  ATransaction: TSQLTransaction; SQL: string; AParams: TParams);
var
  ParadoxCursor: TDBParadoxCursor;
begin
  ParadoxCursor := RequireCursor(Cursor);
  if not ParadoxCursor.FConnection.Connected then
    raise EDBParadoxProviderError.Create(
      'The DBParadox connection is not initialized.');
  ParadoxCursor.FPlan := ParseDBParadoxSelect(SQL);
  ParadoxCursor.OpenTable(ParadoxCursor.FPlan.TableName);
  ParadoxCursor.ResolvePlanFields;
  Cursor.FPrepared := True;
  Cursor.FSelectable := True;
  Cursor.FStatementType := stSelect;
end;

procedure TDBParadoxConnection.UnPrepareStatement(Cursor: TSQLCursor);
begin
  RequireCursor(Cursor).CloseTable;
  Cursor.FPrepared := False;
end;

procedure TDBParadoxConnection.Execute(Cursor: TSQLCursor;
  ATransaction: TSQLTransaction; AParams: TParams);
var
  ParadoxCursor: TDBParadoxCursor;
begin
  ParadoxCursor := RequireCursor(Cursor);
  if not Cursor.FPrepared then
    raise EDBParadoxProviderError.Create(
      'Cannot execute an unprepared DBParadox statement.');
  ParadoxCursor.BuildResultRows(AParams);
  ParadoxCursor.FCurrentRecord := -1;
  ParadoxCursor.FCurrentRowIndex := -1;
end;

function TDBParadoxConnection.Fetch(Cursor: TSQLCursor): Boolean;
var
  ParadoxCursor: TDBParadoxCursor;
begin
  ParadoxCursor := RequireCursor(Cursor);
  while ParadoxCursor.FNextRecord < Length(ParadoxCursor.FRows) do
  begin
    ParadoxCursor.FCurrentRowIndex := ParadoxCursor.FNextRecord;
    ParadoxCursor.FCurrentRecord :=
      ParadoxCursor.FRows[ParadoxCursor.FCurrentRowIndex].RecordNumber;
    Inc(ParadoxCursor.FNextRecord);
    Exit(True);
  end;
  ParadoxCursor.FCurrentRecord := -1;
  ParadoxCursor.FCurrentRowIndex := -1;
  Result := False;
end;

procedure TDBParadoxConnection.AddFieldDefs(Cursor: TSQLCursor;
  FieldDefs: TFieldDefs);
var
  ParadoxCursor: TDBParadoxCursor;
  Index: Integer;
  FieldType: TFieldType;
begin
  ParadoxCursor := RequireCursor(Cursor);
  for Index := 0 to High(ParadoxCursor.FResultFields) do
  begin
    case ParadoxCursor.FFields[ParadoxCursor.FResultFields[Index]].FieldType of
      pxfAlpha:
        FieldType := ftString;
      pxfLong:
        FieldType := ftInteger;
    else
      RaiseUnsupported(Format('Paradox field type %d in field "%s"',
        [ParadoxCursor.FFields[ParadoxCursor.FResultFields[Index]].FieldType,
         ParadoxCursor.FFields[ParadoxCursor.FResultFields[Index]].Name]));
    end;
    AddFieldDef(FieldDefs, Index + 1,
      ParadoxCursor.FFields[ParadoxCursor.FResultFields[Index]].Name,
      FieldType,
      ParadoxCursor.FFields[ParadoxCursor.FResultFields[Index]].FieldLength,
      0, False, False, True);
  end;
end;

function TDBParadoxConnection.LoadField(Cursor: TSQLCursor;
  FieldDef: TFieldDef; Buffer: Pointer; out CreateBlob: Boolean): Boolean;
var
  ParadoxCursor: TDBParadoxCursor;
  FieldIndex: Integer;
  Field: TDBParadoxField;
  Value: TDBParadoxValue;
  ValueLength: SizeInt;
begin
  ParadoxCursor := RequireCursor(Cursor);
  CreateBlob := False;
  if (ParadoxCursor.FCurrentRecord < 0) or
    (ParadoxCursor.FCurrentRowIndex < 0) then
    raise EDBParadoxProviderError.Create(
      'No current Paradox record is available.');
  FieldIndex := FieldDef.FieldNo - 1;
  if (FieldIndex < 0) or
    (FieldIndex >= Length(ParadoxCursor.FResultFields)) then
    raise EDBParadoxProviderError.CreateFmt(
      'SQLDB field number %d is outside the Paradox row.',
      [FieldDef.FieldNo]);
  Field := ParadoxCursor.FFields[
    ParadoxCursor.FResultFields[FieldIndex]];
  Value := ParadoxCursor.FRows[
    ParadoxCursor.FCurrentRowIndex].Values[
      ParadoxCursor.FResultFields[FieldIndex]];
  if Value.IsNull then
    Exit(False);
  case Field.FieldType of
      pxfAlpha:
        begin
          ValueLength := Length(Value.StringValue);
          if ValueLength > FieldDef.Size then
            ValueLength := FieldDef.Size;
          if ValueLength > 0 then
            Move(Value.StringValue[1], Buffer^, ValueLength);
          PAnsiChar(Buffer)[ValueLength] := #0;
          Result := True;
        end;
      pxfLong:
        begin
          PLongInt(Buffer)^ := Value.IntegerValue;
          Result := True;
        end;
  else
    RaiseUnsupported(Format('Paradox field type %d in field "%s"',
      [Field.FieldType, Field.Name]));
  end;
end;

procedure TDBParadoxConnection.LoadBlobIntoBuffer(FieldDef: TFieldDef;
  ABlobBuf: PBufBlobField; Cursor: TSQLCursor;
  ATransaction: TSQLTransaction);
begin
  RequireCursor(Cursor);
  RaiseUnsupported('memo and blob fields');
end;

procedure TDBParadoxConnection.FreeFldBuffers(Cursor: TSQLCursor);
begin
  RequireCursor(Cursor);
end;

function TDBParadoxConnection.GetTransactionHandle(
  AHandle: TSQLHandle): Pointer;
begin
  RequireTransaction(AHandle);
  Result := nil;
end;

function TDBParadoxConnection.Commit(AHandle: TSQLHandle): Boolean;
var
  TransactionHandle: TDBParadoxTransactionHandle;
begin
  TransactionHandle := RequireTransaction(AHandle);
  if not TransactionHandle.Active then
    raise EDBParadoxProviderError.Create(
      'Cannot commit an inactive read-only SQLDB scope.');
  TransactionHandle.Active := False;
  Result := True;
end;

function TDBParadoxConnection.RollBack(AHandle: TSQLHandle): Boolean;
var
  TransactionHandle: TDBParadoxTransactionHandle;
begin
  TransactionHandle := RequireTransaction(AHandle);
  if not TransactionHandle.Active then
    raise EDBParadoxProviderError.Create(
      'Cannot roll back an inactive read-only SQLDB scope.');
  TransactionHandle.Active := False;
  Result := True;
end;

function TDBParadoxConnection.StartDBTransaction(AHandle: TSQLHandle;
  AParams: string): Boolean;
var
  TransactionHandle: TDBParadoxTransactionHandle;
begin
  TransactionHandle := RequireTransaction(AHandle);
  if TransactionHandle.Active then
    raise EDBParadoxProviderError.Create(
      'The DBParadox read-only SQLDB scope is already active.');
  TransactionHandle.Active := True;
  Result := True;
end;

procedure TDBParadoxConnection.CommitRetaining(AHandle: TSQLHandle);
var
  TransactionHandle: TDBParadoxTransactionHandle;
begin
  TransactionHandle := RequireTransaction(AHandle);
  if not TransactionHandle.Active then
    raise EDBParadoxProviderError.Create(
      'Cannot commit-retaining an inactive read-only SQLDB scope.');
end;

procedure TDBParadoxConnection.RollBackRetaining(AHandle: TSQLHandle);
var
  TransactionHandle: TDBParadoxTransactionHandle;
begin
  TransactionHandle := RequireTransaction(AHandle);
  if not TransactionHandle.Active then
    raise EDBParadoxProviderError.Create(
      'Cannot rollback-retaining an inactive read-only SQLDB scope.');
end;

function TDBParadoxCursor.FindFieldIndex(const AName: string): Integer;
var
  Index: Integer;
begin
  for Index := 0 to High(FFields) do
    if SameText(FFields[Index].Name, AName) then
      Exit(Index);
  Result := -1;
end;

procedure TDBParadoxCursor.ResolvePlanFields;
var
  Index: Integer;
  FieldIndex: Integer;
  OtherIndex: Integer;
begin
  SetLength(FResultFields, 0);
  SetLength(FRequiredFields, Length(FFields));
  if FPlan.SelectAll then
  begin
    SetLength(FResultFields, Length(FFields));
    for Index := 0 to High(FFields) do
    begin
      FResultFields[Index] := Index;
      FRequiredFields[Index] := True;
    end;
  end
  else
  begin
    SetLength(FResultFields, Length(FPlan.Fields));
    for Index := 0 to High(FPlan.Fields) do
    begin
      FieldIndex := FindFieldIndex(FPlan.Fields[Index]);
      if FieldIndex < 0 then
        raise EDBParadoxProviderError.CreateFmt(
          'Selected field "%s" does not exist in the Paradox table.',
          [FPlan.Fields[Index]]);
      for OtherIndex := 0 to Index - 1 do
        if FResultFields[OtherIndex] = FieldIndex then
          raise EDBParadoxUnsupportedFeature.CreateFmt(
            'Selecting field "%s" more than once is not supported.',
            [FPlan.Fields[Index]]);
      FResultFields[Index] := FieldIndex;
      FRequiredFields[FieldIndex] := True;
    end;
  end;

  for Index := 0 to High(FPlan.Predicates) do
  begin
    FieldIndex := FindFieldIndex(FPlan.Predicates[Index].FieldName);
    if FieldIndex < 0 then
      raise EDBParadoxProviderError.CreateFmt(
        'Predicate field "%s" does not exist in the Paradox table.',
        [FPlan.Predicates[Index].FieldName]);
    FRequiredFields[FieldIndex] := True;
  end;
  for Index := 0 to High(FPlan.OrderBy) do
  begin
    FieldIndex := FindFieldIndex(FPlan.OrderBy[Index].FieldName);
    if FieldIndex < 0 then
      raise EDBParadoxProviderError.CreateFmt(
        'ORDER BY field "%s" does not exist in the Paradox table.',
        [FPlan.OrderBy[Index].FieldName]);
    FRequiredFields[FieldIndex] := True;
  end;
end;

procedure TDBParadoxCursor.BuildResultRows(AParams: TParams);
var
  RowNumber: Integer;
  FieldIndex: Integer;
  PredicateIndex: Integer;
  ParamIndex: Integer;
  Parameter: TParam;
  PredicateValues: array of TDBParadoxValue;
  Values: TDBParadoxValueArray;
  Matches: Boolean;
  Comparison: Integer;
  ParamIsUsed: Boolean;
  ResultIndex: Integer;
begin
  SetLength(FRows, 0);
  PredicateValues := nil;
  SetLength(PredicateValues, Length(FPlan.Predicates));
  for PredicateIndex := 0 to High(FPlan.Predicates) do
  begin
    if not Assigned(AParams) then
      raise EDBParadoxProviderError.CreateFmt(
        'Parameter "%s" was not supplied.',
        [FPlan.Predicates[PredicateIndex].ParameterName]);
    Parameter := AParams.FindParam(
      FPlan.Predicates[PredicateIndex].ParameterName);
    if not Assigned(Parameter) then
      raise EDBParadoxProviderError.CreateFmt(
        'Parameter "%s" was not supplied.',
        [FPlan.Predicates[PredicateIndex].ParameterName]);
    FieldIndex := FindFieldIndex(
      FPlan.Predicates[PredicateIndex].FieldName);
    PredicateValues[PredicateIndex] := ParameterValue(Parameter,
      FFields[FieldIndex], FPlan.Predicates[PredicateIndex].ParameterName);
  end;

  if Assigned(AParams) then
    for ParamIndex := 0 to AParams.Count - 1 do
    begin
      ParamIsUsed := False;
      for PredicateIndex := 0 to High(FPlan.Predicates) do
        if SameText(AParams[ParamIndex].Name,
          FPlan.Predicates[PredicateIndex].ParameterName) then
          ParamIsUsed := True;
      if not ParamIsUsed then
        raise EDBParadoxProviderError.CreateFmt(
          'Parameter "%s" is not used by the supported SELECT.',
          [AParams[ParamIndex].Name]);
    end;

  Values := nil;
  SetLength(Values, Length(FFields));
  for RowNumber := 0 to Length(FTableRows) - 1 do
  begin
    for FieldIndex := 0 to High(FFields) do
      if FRequiredFields[FieldIndex] then
        Values[FieldIndex] := DecodeFieldValue(FFields[FieldIndex],
          FTableRows[RowNumber].Data, FTableRows[RowNumber].RecordNumber)
      else
      begin
        Values[FieldIndex].FieldType := FFields[FieldIndex].FieldType;
        Values[FieldIndex].IsNull := True;
        Values[FieldIndex].IntegerValue := 0;
        Values[FieldIndex].StringValue := '';
      end;

    Matches := True;
    for PredicateIndex := 0 to High(FPlan.Predicates) do
    begin
      FieldIndex := FindFieldIndex(FPlan.Predicates[PredicateIndex].FieldName);
      if Values[FieldIndex].IsNull or
        PredicateValues[PredicateIndex].IsNull then
      begin
        Matches := False;
        Break;
      end;
      Comparison := CompareValues(Values[FieldIndex],
        PredicateValues[PredicateIndex], True);
      case FPlan.Predicates[PredicateIndex].Comparison of
        dpcEqual:
          Matches := Comparison = 0;
        dpcNotEqual:
          Matches := Comparison <> 0;
        dpcLess:
          Matches := Comparison < 0;
        dpcLessOrEqual:
          Matches := Comparison <= 0;
        dpcGreater:
          Matches := Comparison > 0;
        dpcGreaterOrEqual:
          Matches := Comparison >= 0;
      end;
      if not Matches then
        Break;
    end;

    if Matches then
    begin
      ResultIndex := Length(FRows);
      SetLength(FRows, ResultIndex + 1);
      FRows[ResultIndex].RecordNumber := RowNumber;
      FRows[ResultIndex].Values := Copy(Values, 0, Length(Values));
    end;
  end;
  SortRows;
  FNextRecord := 0;
  FCurrentRowIndex := -1;
end;

function TDBParadoxCursor.CompareRows(const LeftRow,
  RightRow: TDBParadoxResultRow): Integer;
var
  OrderIndex: Integer;
  FieldIndex: Integer;
begin
  for OrderIndex := 0 to High(FPlan.OrderBy) do
  begin
    FieldIndex := FindFieldIndex(FPlan.OrderBy[OrderIndex].FieldName);
    Result := CompareValues(LeftRow.Values[FieldIndex],
      RightRow.Values[FieldIndex], True);
    if FPlan.OrderBy[OrderIndex].Descending then
      Result := -Result;
    if Result <> 0 then
      Exit;
  end;
  if LeftRow.RecordNumber < RightRow.RecordNumber then
    Result := -1
  else if LeftRow.RecordNumber > RightRow.RecordNumber then
    Result := 1
  else
    Result := 0;
end;

procedure TDBParadoxCursor.SortRows;
begin
  if (Length(FRows) > 1) and (Length(FPlan.OrderBy) > 0) then
    QuickSortRows(0, High(FRows));
end;

procedure TDBParadoxCursor.QuickSortRows(LeftIndex, RightIndex: Integer);
var
  I: Integer;
  J: Integer;
  Pivot: TDBParadoxResultRow;
  SwapRow: TDBParadoxResultRow;
begin
  I := LeftIndex;
  J := RightIndex;
  Pivot := FRows[(LeftIndex + RightIndex) div 2];
  repeat
    while CompareRows(FRows[I], Pivot) < 0 do
      Inc(I);
    while CompareRows(FRows[J], Pivot) > 0 do
      Dec(J);
    if I <= J then
    begin
      SwapRow := FRows[I];
      FRows[I] := FRows[J];
      FRows[J] := SwapRow;
      Inc(I);
      Dec(J);
    end;
  until I > J;
  if LeftIndex < J then
    QuickSortRows(LeftIndex, J);
  if I < RightIndex then
    QuickSortRows(I, RightIndex);
end;

procedure TDBParadoxCursor.OpenTable(const ATableName: string);
var
  TableFileName: string;
  TableExtension: string;
begin
  if Length(FFields) <> 0 then
    raise EDBParadoxProviderError.Create(
      'A Paradox table is already open on this SQLDB cursor.');
  TableFileName := ATableName;
  TableExtension := ExtractFileExt(TableFileName);
  if TableExtension = '' then
    TableFileName := TableFileName + '.DB'
  else if not SameText(TableExtension, '.DB') then
    raise EDBParadoxUnsupportedFeature.CreateFmt(
      'Only .DB Paradox table names are supported, not "%s".',
      [TableExtension]);
  if ExtractFileName(TableFileName) <> TableFileName then
    raise EDBParadoxUnsupportedFeature.Create(
      'Table paths are not allowed in SELECT statements.');
  TableFileName := ExpandFileName(
    IncludeTrailingPathDelimiter(FConnection.DatabaseName) + TableFileName);
  if not FileExists(TableFileName) then
    raise EDBParadoxProviderError.CreateFmt(
      'Paradox table does not exist: "%s".', [TableFileName]);

  try
    ReadDBParadoxTable(TableFileName, FFields, FTableRows, FRecordSize);
    FRecordCount := Length(FTableRows);
    FConnection.CursorOpened;
    FCursorRegistered := True;
    FNextRecord := 0;
    FCurrentRecord := -1;
    FCurrentRowIndex := -1;
  except
    CloseTable;
    raise;
  end;
end;

procedure TDBParadoxCursor.CloseTable;
begin
  if FCursorRegistered then
  begin
    FConnection.CursorClosed;
    FCursorRegistered := False;
  end;
  SetLength(FFields, 0);
  SetLength(FTableRows, 0);
  SetLength(FResultFields, 0);
  SetLength(FRequiredFields, 0);
  SetLength(FRows, 0);
  FRecordSize := 0;
  FRecordCount := 0;
  FNextRecord := 0;
  FCurrentRecord := -1;
  FCurrentRowIndex := -1;
end;

destructor TDBParadoxCursor.Destroy;
begin
  CloseTable;
  inherited Destroy;
end;

initialization
end.
