unit IndexedSeekContract;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils, Variants;

type
  TIndexedSeekKeyValues = array of Variant;

  TIndexedSeekRequest = record
    IndexName: string;
    /// Values form an ordered leading prefix of the named index.
    KeyValues: TIndexedSeekKeyValues;
  end;

  TIndexedSeekCurrentRowKind = (
    isrkKnownRecordNumber,
    isrkNoCurrentRow,
    isrkIdentityUnavailable
  );

  TIndexedSeekResult = record
    Found: Boolean;
    BOF: Boolean;
    EOF: Boolean;
    CurrentRowKind: TIndexedSeekCurrentRowKind;
    /// Dataset record ordinal (for example RecNo), never a domain key.
    CurrentRecordNumber: Int64;
  end;

  EIndexedSeekContractError = class(Exception);
  EInvalidIndexedSeekRequest = class(EIndexedSeekContractError);
  EInvalidIndexedSeekResult = class(EIndexedSeekContractError);
  /// The dataset or requested index is unavailable; this is not a miss.
  EIndexedSeekUnavailable = class(EIndexedSeekContractError);
  /// The provider cannot honor the requested semantics; this is not a miss.
  EIndexedSeekUnsupported = class(EIndexedSeekContractError);

  /// Cursor-aware lookup boundary. Implementations must not turn unsupported
  /// operations, unavailable datasets, or provider failures into a miss.
  IIndexedSeekProvider = interface
    ['{C60B3954-16F5-46CF-B3B6-F1B58E80BAE4}']
    /// Looks up an ordered leading prefix of the selected named index.
    /// Provider exceptions propagate; this contract does not define BDE or
    /// SQLDB cursor mutation beyond the returned observation.
    function LookupIndexPrefix(
      const Request: TIndexedSeekRequest): TIndexedSeekResult;
  end;

function CreateIndexedSeekRequest(const IndexName: string;
  const KeyValues: array of Variant): TIndexedSeekRequest;
procedure ValidateIndexedSeekRequest(const Request: TIndexedSeekRequest);
procedure ValidateIndexedSeekResult(const ResultValue: TIndexedSeekResult);
function ExecuteIndexedSeek(const Provider: IIndexedSeekProvider;
  const Request: TIndexedSeekRequest): TIndexedSeekResult;

implementation

function IsSupportedKeyValue(const Value: Variant): Boolean;
begin
  case VarType(Value) of
    varSmallint, varInteger, varSingle, varDouble, varCurrency, varDate,
    varBoolean, varShortInt, varByte, varWord, varLongWord, varInt64,
    varQWord, varString, varOleStr, varUString:
      Result := True;
  else
    Result := False;
  end;
end;

function CreateIndexedSeekRequest(const IndexName: string;
  const KeyValues: array of Variant): TIndexedSeekRequest;
var
  Index: LongInt;
begin
  Result.IndexName := IndexName;
  SetLength(Result.KeyValues, Length(KeyValues));
  for Index := 0 to High(KeyValues) do
    Result.KeyValues[Index] := KeyValues[Index];
  ValidateIndexedSeekRequest(Result);
end;

procedure ValidateIndexedSeekRequest(const Request: TIndexedSeekRequest);
var
  Index: LongInt;
begin
  if Trim(Request.IndexName) = '' then
    raise EInvalidIndexedSeekRequest.Create('An index name is required.');
  if Length(Request.KeyValues) = 0 then
    raise EInvalidIndexedSeekRequest.Create(
      'At least one ordered index-key value is required.');

  for Index := 0 to High(Request.KeyValues) do
    if not IsSupportedKeyValue(Request.KeyValues[Index]) then
      raise EInvalidIndexedSeekRequest.CreateFmt(
        'Index-key value %d must be a supported non-null scalar.', [Index]);
end;

procedure ValidateIndexedSeekResult(const ResultValue: TIndexedSeekResult);
begin
  case ResultValue.CurrentRowKind of
    isrkKnownRecordNumber:
      if ResultValue.CurrentRecordNumber <= 0 then
        raise EInvalidIndexedSeekResult.Create(
          'A known current record number must be positive.');
    isrkNoCurrentRow, isrkIdentityUnavailable:
      if ResultValue.CurrentRecordNumber <> 0 then
        raise EInvalidIndexedSeekResult.Create(
          'A current record number is only valid when its identity is known.');
  else
    raise EInvalidIndexedSeekResult.Create(
      'The current-row identity state is invalid.');
  end;

  if ResultValue.Found and
    (ResultValue.CurrentRowKind = isrkNoCurrentRow) then
    raise EInvalidIndexedSeekResult.Create(
      'A successful lookup must identify a current row or mark its identity unavailable.');
end;

function ExecuteIndexedSeek(const Provider: IIndexedSeekProvider;
  const Request: TIndexedSeekRequest): TIndexedSeekResult;
begin
  if not Assigned(Provider) then
    raise EArgumentNilException.Create('Provider');
  ValidateIndexedSeekRequest(Request);
  Result := Provider.LookupIndexPrefix(Request);
  ValidateIndexedSeekResult(Result);
end;

end.
