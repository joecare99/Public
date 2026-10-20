unit DBParadoxConnection;

{$mode objfpc}{$H+}

interface

uses
  Classes, DB, BufDataset, SQLDB, DBParadoxFamilyPublisher;

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
    function RowsAffected(Cursor: TSQLCursor): TRowsCount; override;
    function Commit(AHandle: TSQLHandle): Boolean; override;
    function RollBack(AHandle: TSQLHandle): Boolean; override;
    procedure PublishFamily(const ATableFileName: string;
      const ABuilder: IDBParadoxFamilyStageBuilder;
      const AValidator: IDBParadoxFamilyValidator;
      const AExpectedMembers: TDBParadoxExpectedFamilyMembers); virtual;
    function StartDBTransaction(AHandle: TSQLHandle;
      AParams: string): Boolean; override;
    procedure CommitRetaining(AHandle: TSQLHandle); override;
    procedure RollBackRetaining(AHandle: TSQLHandle); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  SysUtils, DBParadoxSQLParser, DBParadoxFileReader,
  DBParadoxFamilyJournal, DBParadoxFamilyLock, DBParadoxFamilySnapshot,
  DBParadoxRecordEncoder, DBParadoxTableFileBuilder,
  DBParadoxStagedTable, DBParadoxDMLExecutor,
  DBParadoxPrimaryFamilyAdapter,
  DBParadoxSecondaryFamilyAdapter;

const
  pxfAlpha = $01;
  pxfLong = $04;

type
  TDBParadoxCommitOutcome = (
    dcoReady,
    dcoPublishedCleanupPending,
    dcoUncertain
  );

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
    FDMLPlan: TDBParadoxDMLPlan;
    FDMLStatement: Boolean;
    FAffectedRows: Integer;
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
    CommitOutcome: TDBParadoxCommitOutcome;
    Snapshot: TDBParadoxFamilySnapshot;
    StagedTable: TDBParadoxStagedTable;
    HasMutations: Boolean;
    RowsAffected: Integer;
    destructor Destroy; override;
    procedure ClearStagedState;
  end;

procedure RaiseUnsupported(const AFeature: string);
begin
  raise EDBParadoxUnsupportedFeature.CreateFmt(
    'DBParadox does not support %s.', [AFeature]);
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

procedure CheckTransactionCommitOutcome(
  ATransaction: TDBParadoxTransactionHandle);
begin
  case ATransaction.CommitOutcome of
    dcoPublishedCleanupPending:
      raise EDBParadoxProviderError.Create(
        'The DBParadox family was published, but cleanup is pending. Retry Commit to recover and finalize it; Rollback is not valid.');
    dcoUncertain:
      raise EDBParadoxProviderError.Create(
        'The DBParadox publication outcome is uncertain. Stop using this transaction and reopen the table so journal recovery can resolve it.');
  end;
end;

destructor TDBParadoxTransactionHandle.Destroy;
begin
  ClearStagedState;
  inherited Destroy;
end;

procedure TDBParadoxTransactionHandle.ClearStagedState;
begin
  FreeAndNil(StagedTable);
  FreeAndNil(Snapshot);
  HasMutations := False;
  RowsAffected := 0;
  CommitOutcome := dcoReady;
end;

function DecodeFieldValue(const Field: TDBParadoxFileField;
  const RecordData: TBytes; RecordNumber: Integer): TDBParadoxValue; forward;
function ParameterValue(AParam: TParam; const Field: TDBParadoxField;
  const ParameterName: string): TDBParadoxValue; forward;
function CompareValues(const LeftValue, RightValue: TDBParadoxValue;
  NullsFirst: Boolean): Integer; forward;

function ResolveTableFileName(AConnection: TDBParadoxConnection;
  const ATableName: string): string;
var
  TableExtension: string;
begin
  Result := ATableName;
  TableExtension := ExtractFileExt(Result);
  if TableExtension = '' then
    Result := Result + '.DB'
  else if not SameText(TableExtension, '.DB') then
    raise EDBParadoxUnsupportedFeature.CreateFmt(
      'Only .DB Paradox table names are supported, not "%s".',
      [TableExtension]);
  if ExtractFileName(Result) <> Result then
    raise EDBParadoxUnsupportedFeature.Create(
      'Table paths are not allowed in DBParadox statements.');
  Result := ExpandFileName(
    IncludeTrailingPathDelimiter(AConnection.DatabaseName) + Result);
end;

function SnapshotFieldsAsRecordFields(
  const AFields: TDBParadoxFileFields): TDBParadoxRecordFields;
var
  Index: SizeInt;
begin
  SetLength(Result, Length(AFields));
  for Index := 0 to High(AFields) do
  begin
    Result[Index].Name := AFields[Index].Name;
    Result[Index].TypeCode := AFields[Index].FieldType;
    Result[Index].Length := AFields[Index].FieldLength;
  end;
end;

function SnapshotRowsAsValues(const AFields: TDBParadoxFileFields;
  const ARows: TDBParadoxFileRows): TDBParadoxTableRows;
var
  RowIndex, FieldIndex: SizeInt;
  Value: TDBParadoxValue;
begin
  SetLength(Result, Length(ARows));
  for RowIndex := 0 to High(ARows) do
  begin
    SetLength(Result[RowIndex], Length(AFields));
    for FieldIndex := 0 to High(AFields) do
    begin
      Value := DecodeFieldValue(AFields[FieldIndex], ARows[RowIndex].Data,
        ARows[RowIndex].RecordNumber);
      if Value.IsNull then
        Result[RowIndex][FieldIndex] := ''
      else if Value.FieldType = pxfAlpha then
        Result[RowIndex][FieldIndex] := UnicodeString(Value.StringValue)
      else
        Result[RowIndex][FieldIndex] := IntToStr(Value.IntegerValue);
    end;
  end;
end;

function ExistingRowValues(const AFields: TDBParadoxFileFields;
  APrimaryKeyFieldIndex: SizeInt;
  const ARows: TDBParadoxTableRows; AParam: TParam): TDBParadoxRecordValues;
var
  KeyValue, RowValue: TDBParadoxValue;
  RowIndex: SizeInt;
begin
  SetLength(Result, Length(AFields));
  if not Assigned(AParam) then
    Exit;
  KeyValue := ParameterValue(AParam, AFields[APrimaryKeyFieldIndex],
    AParam.Name);
  if KeyValue.IsNull then
    Exit;
  for RowIndex := 0 to High(ARows) do
  begin
    if AFields[APrimaryKeyFieldIndex].FieldType = pxfAlpha then
    begin
      RowValue.FieldType := pxfAlpha;
      RowValue.IsNull := ARows[RowIndex][APrimaryKeyFieldIndex] = '';
      RowValue.IntegerValue := 0;
      RowValue.StringValue :=
        AnsiString(ARows[RowIndex][APrimaryKeyFieldIndex]);
    end
    else
    begin
      RowValue.FieldType := pxfLong;
      RowValue.IsNull := ARows[RowIndex][APrimaryKeyFieldIndex] = '';
      RowValue.IntegerValue := 0;
      if not RowValue.IsNull then
        RowValue.IntegerValue := StrToInt64(
          ARows[RowIndex][APrimaryKeyFieldIndex]);
      RowValue.StringValue := '';
    end;
    if CompareValues(RowValue, KeyValue, True) = 0 then
      Exit(Copy(ARows[RowIndex], 0, Length(ARows[RowIndex])));
  end;
end;

function SnapshotRowsAsFileRows(const AFields: TDBParadoxRecordFields;
  const ARows: TDBParadoxTableRows): TDBParadoxFileRows;
var
  RowIndex: SizeInt;
begin
  SetLength(Result, Length(ARows));
  for RowIndex := 0 to High(ARows) do
  begin
    Result[RowIndex].RecordNumber := RowIndex;
    Result[RowIndex].BlockNumber := 0;
    Result[RowIndex].RecordInBlock := RowIndex;
    Result[RowIndex].Data := EncodeDBParadoxRecord(AFields, ARows[RowIndex]);
  end;
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
  TransactionHandle: TDBParadoxTransactionHandle;
  TableFileName: string;
  SnapshotFields: TDBParadoxFileFields;
  SnapshotRows: TDBParadoxFileRows;
  RecordFields: TDBParadoxRecordFields;
  RecordValues: TDBParadoxTableRows;
  HadSnapshot: Boolean;
begin
  ParadoxCursor := RequireCursor(Cursor);
  if not ParadoxCursor.FConnection.Connected then
    raise EDBParadoxProviderError.Create(
      'The DBParadox connection is not initialized.');
  case Cursor.FStatementType of
    stSelect:
      begin
        ParadoxCursor.FDMLStatement := False;
        ParadoxCursor.FPlan := ParseDBParadoxSelect(SQL);
        ParadoxCursor.OpenTable(ParadoxCursor.FPlan.TableName);
        ParadoxCursor.ResolvePlanFields;
      end;
    stInsert, stUpdate, stDelete:
      begin
        if not Assigned(ATransaction) or not ATransaction.Active then
          raise EDBParadoxProviderError.Create(
            'DBParadox DML requires an active explicit SQLDB transaction.');
        if not (stoExplicitStart in ATransaction.Options) then
          raise EDBParadoxProviderError.Create(
            'DBParadox DML requires the SQLDB stoExplicitStart option.');
        TransactionHandle := TDBParadoxTransactionHandle(
          ATransaction.Handle);
        CheckTransactionCommitOutcome(TransactionHandle);
        if not TransactionHandle.Active then
          raise EDBParadoxProviderError.Create(
            'The DBParadox transaction handle is not active.');
        ParadoxCursor.FDMLPlan := ParseDBParadoxDML(SQL);
        case ParadoxCursor.FDMLPlan.StatementType of
          dpdInsert:
            if Cursor.FStatementType <> stInsert then
              raise EDBParadoxProviderError.Create(
                'The SQLDB statement type does not match the parsed INSERT.');
          dpdUpdate:
            if Cursor.FStatementType <> stUpdate then
              raise EDBParadoxProviderError.Create(
                'The SQLDB statement type does not match the parsed UPDATE.');
          dpdDelete:
            if Cursor.FStatementType <> stDelete then
              raise EDBParadoxProviderError.Create(
                'The SQLDB statement type does not match the parsed DELETE.');
        end;
        TableFileName := ResolveTableFileName(Self,
          ParadoxCursor.FDMLPlan.TableName);
        HadSnapshot := Assigned(TransactionHandle.Snapshot);
        try
          if not HadSnapshot then
          begin
            TransactionHandle.Snapshot :=
              TDBParadoxFamilySnapshot.Capture(TableFileName);
            SnapshotFields := TransactionHandle.Snapshot.CopyFields;
            SnapshotRows := TransactionHandle.Snapshot.CopyRows;
            RecordFields := SnapshotFieldsAsRecordFields(SnapshotFields);
            RecordValues := SnapshotRowsAsValues(SnapshotFields, SnapshotRows);
            TransactionHandle.StagedTable := TDBParadoxStagedTable.Create(
              TableFileName, RecordFields,
              TransactionHandle.Snapshot.PrimaryKeyFieldIndex, RecordValues);
          end
          else if not SameText(TransactionHandle.Snapshot.TableFileName,
            TableFileName) then
            raise EDBParadoxUnsupportedFeature.Create(
              'A DBParadox write transaction can modify only one table.');
          if not Assigned(TransactionHandle.StagedTable) then
            raise EDBParadoxProviderError.Create(
              'The DBParadox staged table was not initialized.');
          SnapshotFields := TransactionHandle.Snapshot.CopyFields;
          RecordFields := SnapshotFieldsAsRecordFields(SnapshotFields);
          ValidateDBParadoxDMLPlan(ParadoxCursor.FDMLPlan, RecordFields,
            TransactionHandle.Snapshot.PrimaryKeyFieldIndex, AParams);
        except
          if not HadSnapshot then
            TransactionHandle.ClearStagedState;
          raise;
        end;
        ParadoxCursor.FDMLStatement := True;
        ParadoxCursor.FAffectedRows := 0;
        Cursor.FSelectable := False;
      end;
  else
    raise EDBParadoxUnsupportedFeature.CreateFmt(
      'SQL statement type %d is not supported by DBParadox.',
      [Ord(Cursor.FStatementType)]);
  end;
  Cursor.FPrepared := True;
end;

procedure TDBParadoxConnection.UnPrepareStatement(Cursor: TSQLCursor);
begin
  with RequireCursor(Cursor) do
  begin
    CloseTable;
    FDMLStatement := False;
    FAffectedRows := 0;
  end;
  Cursor.FPrepared := False;
end;

procedure TDBParadoxConnection.Execute(Cursor: TSQLCursor;
  ATransaction: TSQLTransaction; AParams: TParams);
var
  ParadoxCursor: TDBParadoxCursor;
  TransactionHandle: TDBParadoxTransactionHandle;
  RecordFields: TDBParadoxRecordFields;
  StagedRows: TDBParadoxTableRows;
  ExistingValues: TDBParadoxRecordValues;
  SnapshotFields: TDBParadoxFileFields;
  Parameter: TParam;
  PreparedDML: TDBParadoxPreparedDML;
  RowIndex: SizeInt;
begin
  ParadoxCursor := RequireCursor(Cursor);
  if not Cursor.FPrepared then
    raise EDBParadoxProviderError.Create(
      'Cannot execute an unprepared DBParadox statement.');
  if ParadoxCursor.FDMLStatement then
  begin
    if not Assigned(ATransaction) or not ATransaction.Active then
      raise EDBParadoxProviderError.Create(
        'DBParadox DML requires an active SQLDB transaction.');
    TransactionHandle := TDBParadoxTransactionHandle(
      ATransaction.Handle);
    if not Assigned(TransactionHandle.StagedTable) or
      not Assigned(TransactionHandle.Snapshot) then
      raise EDBParadoxProviderError.Create(
        'The DBParadox staged table was not initialized.');
    if not TransactionHandle.Snapshot.MatchesCurrentFiles then
      raise EDBParadoxProviderError.Create(
        'The table family changed after the DBParadox transaction snapshot.');
    SnapshotFields := TransactionHandle.Snapshot.CopyFields;
    RecordFields := SnapshotFieldsAsRecordFields(SnapshotFields);
    StagedRows := TransactionHandle.StagedTable.Rows;
    ExistingValues := nil;
    if ParadoxCursor.FDMLPlan.StatementType = dpdUpdate then
    begin
      Parameter := AParams.FindParam(ParadoxCursor.FDMLPlan.WhereParameter);
      ExistingValues := ExistingRowValues(SnapshotFields,
        TransactionHandle.Snapshot.PrimaryKeyFieldIndex, StagedRows,
        Parameter);
    end;
    PreparedDML := PrepareDBParadoxDML(ParadoxCursor.FDMLPlan,
      RecordFields, TransactionHandle.Snapshot.PrimaryKeyFieldIndex,
      AParams, ExistingValues);
    case ParadoxCursor.FDMLPlan.StatementType of
      dpdInsert:
        ParadoxCursor.FAffectedRows :=
          TransactionHandle.StagedTable.Insert(PreparedDML.Values);
      dpdUpdate:
        ParadoxCursor.FAffectedRows :=
          TransactionHandle.StagedTable.UpdateByPrimaryKey(
            PreparedDML.PrimaryKey, PreparedDML.Values);
      dpdDelete:
        ParadoxCursor.FAffectedRows :=
          TransactionHandle.StagedTable.DeleteByPrimaryKey(
            PreparedDML.PrimaryKey);
    end;
    if ParadoxCursor.FAffectedRows > 0 then
      TransactionHandle.HasMutations := True;
    TransactionHandle.RowsAffected := ParadoxCursor.FAffectedRows;
  end
  else
  begin
    if Assigned(ATransaction) and ATransaction.Active then
    begin
      TransactionHandle := TDBParadoxTransactionHandle(
        ATransaction.Handle);
      CheckTransactionCommitOutcome(TransactionHandle);
      if Assigned(TransactionHandle.StagedTable) and
        Assigned(TransactionHandle.Snapshot) and
        SameText(TransactionHandle.Snapshot.TableFileName,
          ResolveTableFileName(Self, ParadoxCursor.FPlan.TableName)) then
      begin
        if not TransactionHandle.Snapshot.MatchesCurrentFiles then
          raise EDBParadoxProviderError.Create(
            'The table family changed after the DBParadox transaction snapshot.');
        SnapshotFields := TransactionHandle.Snapshot.CopyFields;
        ParadoxCursor.FFields := SnapshotFields;
        RecordFields := SnapshotFieldsAsRecordFields(SnapshotFields);
        StagedRows := TransactionHandle.StagedTable.Rows;
        ParadoxCursor.FTableRows := SnapshotRowsAsFileRows(RecordFields,
          StagedRows);
        ParadoxCursor.FRecordSize := TransactionHandle.Snapshot.RecordSize;
        ParadoxCursor.FRecordCount := Length(ParadoxCursor.FTableRows);
      end;
    end;
    ParadoxCursor.BuildResultRows(AParams);
    ParadoxCursor.FCurrentRecord := -1;
    ParadoxCursor.FCurrentRowIndex := -1;
  end;
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
  Result := Pointer(RequireTransaction(AHandle));
end;

function TDBParadoxConnection.RowsAffected(
  Cursor: TSQLCursor): TRowsCount;
begin
  if RequireCursor(Cursor).FDMLStatement then
    Exit(RequireCursor(Cursor).FAffectedRows);
  Result := inherited RowsAffected(Cursor);
end;

function TDBParadoxConnection.Commit(AHandle: TSQLHandle): Boolean;
var
  TransactionHandle: TDBParadoxTransactionHandle;
  Fields: TDBParadoxRecordFields;
  Rows: TDBParadoxTableRows;
  DatabaseTemplate, PrimaryIndexTemplate: TBytes;
  SecondaryIndexes: TDBParadoxSecondaryFamilyIndexes;
  ExpectedMembers: TDBParadoxExpectedFamilyMembers;
  Builder: IDBParadoxFamilyStageBuilder;
  Validator: IDBParadoxFamilyValidator;
begin
  TransactionHandle := RequireTransaction(AHandle);
  if not TransactionHandle.Active then
    raise EDBParadoxProviderError.Create(
      'Cannot commit an inactive DBParadox SQLDB transaction.');
  if TransactionHandle.CommitOutcome = dcoPublishedCleanupPending then
  begin
    if not Assigned(TransactionHandle.Snapshot) then
      raise EDBParadoxProviderError.Create(
        'The published DBParadox transaction lost its recovery path.');
    TDBParadoxFamilyJournal.Recover(
      TransactionHandle.Snapshot.TableFileName);
    TransactionHandle.ClearStagedState;
    TransactionHandle.Active := False;
    Exit(True);
  end;
  if TransactionHandle.CommitOutcome = dcoUncertain then
    CheckTransactionCommitOutcome(TransactionHandle);
  if TransactionHandle.HasMutations then
  begin
    if not Assigned(TransactionHandle.Snapshot) or
      not Assigned(TransactionHandle.StagedTable) then
      raise EDBParadoxProviderError.Create(
        'The DBParadox transaction lost its snapshot or staged table.');
    if not TransactionHandle.Snapshot.MatchesCurrentFiles then
      raise EDBParadoxProviderError.Create(
        'The table family changed after the DBParadox transaction snapshot.');

    Fields := SnapshotFieldsAsRecordFields(
      TransactionHandle.Snapshot.CopyFields);
    Rows := TransactionHandle.StagedTable.Rows;
    DatabaseTemplate := TransactionHandle.Snapshot.CopyDatabaseTemplate;
    PrimaryIndexTemplate :=
      TransactionHandle.Snapshot.CopyPrimaryIndexTemplate;
    SecondaryIndexes :=
      TransactionHandle.Snapshot.CopySecondaryIndexes;
    ExpectedMembers :=
      TransactionHandle.Snapshot.CopyExpectedFamilyMembers;

    if Length(SecondaryIndexes) = 0 then
    begin
      if TransactionHandle.Snapshot.MemberCount <> 2 then
        raise EDBParadoxUnsupportedFeature.Create(
          'The captured family has no supported primary-only or secondary-index rebuild adapter.');
      Builder := TDBParadoxPrimaryFamilyStageBuilder.Create(
        DatabaseTemplate, PrimaryIndexTemplate, Fields,
        TransactionHandle.Snapshot.PrimaryKeyFieldIndex, Rows);
      Validator := TDBParadoxPrimaryFamilyValidator.Create(Fields,
        TransactionHandle.Snapshot.PrimaryKeyFieldIndex, Rows);
    end
    else
    begin
      Builder := TDBParadoxSecondaryFamilyStageBuilder.Create(
        DatabaseTemplate, PrimaryIndexTemplate, Fields,
        TransactionHandle.Snapshot.PrimaryKeyFieldIndex, Rows,
        SecondaryIndexes);
      Validator := TDBParadoxSecondaryFamilyValidator.Create(
        DatabaseTemplate, PrimaryIndexTemplate, Fields,
        TransactionHandle.Snapshot.PrimaryKeyFieldIndex, Rows,
        SecondaryIndexes);
    end;
    try
      try
        PublishFamily(
          TransactionHandle.Snapshot.TableFileName, Builder, Validator,
          ExpectedMembers);
      except
        on E: EDBParadoxPublishedCleanupError do
        begin
          TransactionHandle.CommitOutcome := dcoPublishedCleanupPending;
          raise;
        end;
        on E: EDBParadoxUncertainPublicationError do
        begin
          TransactionHandle.CommitOutcome := dcoUncertain;
          raise;
        end;
      end;
    finally
      Validator := nil;
      Builder := nil;
    end;
  end;
  TransactionHandle.ClearStagedState;
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
      'Cannot roll back an inactive DBParadox SQLDB transaction.');
  if TransactionHandle.CommitOutcome = dcoUncertain then
  begin
    if not Assigned(TransactionHandle.Snapshot) then
      raise EDBParadoxProviderError.Create(
        'The uncertain DBParadox transaction lost its recovery path.');
    TDBParadoxFamilyJournal.Recover(
      TransactionHandle.Snapshot.TableFileName);
    if not TransactionHandle.Snapshot.MatchesCurrentFiles then
      raise EDBParadoxProviderError.Create(
        'Journal recovery did not restore the transaction snapshot; the uncertain transaction remains active.');
    TransactionHandle.ClearStagedState;
    TransactionHandle.Active := False;
    Exit(True);
  end;
  CheckTransactionCommitOutcome(TransactionHandle);
  TransactionHandle.ClearStagedState;
  TransactionHandle.Active := False;
  Result := True;
end;

procedure TDBParadoxConnection.PublishFamily(const ATableFileName: string;
  const ABuilder: IDBParadoxFamilyStageBuilder;
  const AValidator: IDBParadoxFamilyValidator;
  const AExpectedMembers: TDBParadoxExpectedFamilyMembers);
begin
  TDBParadoxFamilyPublisher.Publish(ATableFileName, ABuilder, AValidator,
    AExpectedMembers);
end;

function TDBParadoxConnection.StartDBTransaction(AHandle: TSQLHandle;
  AParams: string): Boolean;
var
  TransactionHandle: TDBParadoxTransactionHandle;
begin
  TransactionHandle := RequireTransaction(AHandle);
  if TransactionHandle.Active then
    raise EDBParadoxProviderError.Create(
      'The DBParadox SQLDB transaction is already active.');
  TransactionHandle.ClearStagedState;
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
      'Cannot commit-retaining an inactive DBParadox transaction.');
  raise EDBParadoxUnsupportedFeature.Create(
    'Commit-retaining is not supported by DBParadox.');
end;

procedure TDBParadoxConnection.RollBackRetaining(AHandle: TSQLHandle);
var
  TransactionHandle: TDBParadoxTransactionHandle;
begin
  TransactionHandle := RequireTransaction(AHandle);
  if not TransactionHandle.Active then
    raise EDBParadoxProviderError.Create(
      'Cannot rollback-retaining an inactive DBParadox transaction.');
  raise EDBParadoxUnsupportedFeature.Create(
    'Rollback-retaining is not supported by DBParadox.');
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
  FDMLStatement := False;
  FAffectedRows := 0;
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
  FamilyLock: TDBParadoxFamilyLock;
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

  FamilyLock := nil;
  try
    FamilyLock := TDBParadoxFamilyLock.Create(TableFileName);
    try
      TDBParadoxFamilyJournal.RecoverWhileLocked(TableFileName);
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
  finally
    FamilyLock.Free;
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
