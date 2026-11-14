unit tst_AHW52_IndexedSeekContractTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52IndexedSeekContract = class(TTestCase)
  published
    procedure TestRequestPreservesIndexPrefixAndTypedValues;
    procedure TestRejectsEmptyIndexName;
    procedure TestRejectsEmptyKeyPrefix;
    procedure TestRejectsNullKeyValue;
    procedure TestRejectsEmptyVariantKeyValue;
    procedure TestRejectsArrayKeyValue;
    procedure TestValidHitMayReportKnownRecordNumber;
    procedure TestValidMissMayRetainCurrentRow;
    procedure TestValidMissMayHaveNoCurrentRow;
    procedure TestValidResultMayMarkIdentityUnavailable;
    procedure TestRejectsKnownRecordNumberWithoutPositiveOrdinal;
    procedure TestRejectsRecordNumberWithoutKnownIdentity;
    procedure TestRejectsHitWithoutCurrentRow;
    procedure TestExecutePassesRequestAndReturnsExplicitState;
    procedure TestExecuteRejectsMissingProvider;
    procedure TestProviderFailurePropagates;
    procedure TestUnsupportedSemanticsDoNotBecomeMisses;
    procedure TestCandidateListContractRemainsSeparate;
  end;

implementation

uses
  SysUtils, Variants, IndexedSeekContract, IndexedLookupContract;

type
  EInjectedIndexedSeekFailure = class(Exception);

  TRecordingIndexedSeekProvider = class(TInterfacedObject,
    IIndexedSeekProvider)
  private
    FLastRequest: TIndexedSeekRequest;
    FResult: TIndexedSeekResult;
    FFailLookup: Boolean;
    FUnsupported: Boolean;
  public
    function LookupIndexPrefix(
      const Request: TIndexedSeekRequest): TIndexedSeekResult;
    property LastRequest: TIndexedSeekRequest read FLastRequest;
    property ResultValue: TIndexedSeekResult read FResult write FResult;
    property FailLookup: Boolean read FFailLookup write FFailLookup;
    property Unsupported: Boolean read FUnsupported write FUnsupported;
  end;

function TRecordingIndexedSeekProvider.LookupIndexPrefix(
  const Request: TIndexedSeekRequest): TIndexedSeekResult;
var
  Index: LongInt;
begin
  if FFailLookup then
    raise EInjectedIndexedSeekFailure.Create('Injected provider failure.');
  if FUnsupported then
    raise EIndexedSeekUnsupported.Create(
      'The requested index semantics are unsupported.');

  FLastRequest.IndexName := Request.IndexName;
  SetLength(FLastRequest.KeyValues, Length(Request.KeyValues));
  for Index := 0 to High(Request.KeyValues) do
    FLastRequest.KeyValues[Index] := Request.KeyValues[Index];
  Result := FResult;
end;

function ValidSeekResult(const Found: Boolean;
  const CurrentRowKind: TIndexedSeekCurrentRowKind;
  const CurrentRecordNumber: Int64; const BOF, EOF: Boolean):
  TIndexedSeekResult;
begin
  Result.Found := Found;
  Result.CurrentRowKind := CurrentRowKind;
  Result.CurrentRecordNumber := CurrentRecordNumber;
  Result.BOF := BOF;
  Result.EOF := EOF;
end;

procedure TTestAHW52IndexedSeekContract.
  TestRequestPreservesIndexPrefixAndTypedValues;
var
  Request: TIndexedSeekRequest;
begin
  Request := CreateIndexedSeekRequest('vat', [LongInt(123), 'prefix']);
  AssertEquals('vat', Request.IndexName);
  AssertEquals(2, Length(Request.KeyValues));
  AssertEquals('The first key component retains its integer variant type.',
    Ord(varInteger), Ord(VarType(Request.KeyValues[0])));
  AssertEquals(123, Integer(Request.KeyValues[0]));
  AssertEquals('The second string key component keeps its type.',
    'prefix', VarToStr(Request.KeyValues[1]));
end;

procedure TTestAHW52IndexedSeekContract.TestRejectsEmptyIndexName;
begin
  try
    CreateIndexedSeekRequest(' ', ['value']);
    Fail('An empty index name must be rejected.');
  except
    on E: EInvalidIndexedSeekRequest do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedSeekContract.TestRejectsEmptyKeyPrefix;
begin
  try
    CreateIndexedSeekRequest('ort_', []);
    Fail('An empty key prefix must be rejected.');
  except
    on E: EInvalidIndexedSeekRequest do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedSeekContract.TestRejectsNullKeyValue;
begin
  try
    CreateIndexedSeekRequest('ort_', [Null]);
    Fail('Null is not a supported index-key value.');
  except
    on E: EInvalidIndexedSeekRequest do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedSeekContract.TestRejectsEmptyVariantKeyValue;
begin
  try
    CreateIndexedSeekRequest('ort_', [Unassigned]);
    Fail('An empty variant is not a supported index-key value.');
  except
    on E: EInvalidIndexedSeekRequest do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedSeekContract.TestRejectsArrayKeyValue;
var
  ArrayValue: Variant;
begin
  ArrayValue := VarArrayCreate([0, 0], varInteger);
  try
    CreateIndexedSeekRequest('ort_', [ArrayValue]);
    Fail('An array is not a supported index-key value.');
  except
    on E: EInvalidIndexedSeekRequest do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedSeekContract.
  TestValidHitMayReportKnownRecordNumber;
var
  ResultValue: TIndexedSeekResult;
begin
  ResultValue := ValidSeekResult(True, isrkKnownRecordNumber, 2, False, False);
  ValidateIndexedSeekResult(ResultValue);
  AssertTrue(ResultValue.Found);
  AssertEquals(2, ResultValue.CurrentRecordNumber);
end;

procedure TTestAHW52IndexedSeekContract.TestValidMissMayRetainCurrentRow;
var
  ResultValue: TIndexedSeekResult;
begin
  ResultValue := ValidSeekResult(False, isrkKnownRecordNumber, 1, True, False);
  ValidateIndexedSeekResult(ResultValue);
  AssertFalse(ResultValue.Found);
  AssertTrue(ResultValue.BOF);
  AssertFalse(ResultValue.EOF);
  AssertEquals(1, ResultValue.CurrentRecordNumber);
end;

procedure TTestAHW52IndexedSeekContract.TestValidMissMayHaveNoCurrentRow;
var
  ResultValue: TIndexedSeekResult;
begin
  ResultValue := ValidSeekResult(False, isrkNoCurrentRow, 0, True, True);
  ValidateIndexedSeekResult(ResultValue);
  AssertFalse(ResultValue.Found);
  AssertTrue(ResultValue.BOF);
  AssertTrue(ResultValue.EOF);
  AssertEquals(Ord(isrkNoCurrentRow), Ord(ResultValue.CurrentRowKind));
end;

procedure TTestAHW52IndexedSeekContract.
  TestValidResultMayMarkIdentityUnavailable;
var
  ResultValue: TIndexedSeekResult;
begin
  ResultValue := ValidSeekResult(True, isrkIdentityUnavailable, 0, False, False);
  ValidateIndexedSeekResult(ResultValue);
  AssertTrue(ResultValue.Found);
end;

procedure TTestAHW52IndexedSeekContract.
  TestRejectsKnownRecordNumberWithoutPositiveOrdinal;
var
  ResultValue: TIndexedSeekResult;
begin
  ResultValue := ValidSeekResult(False, isrkKnownRecordNumber, 0, False, False);
  try
    ValidateIndexedSeekResult(ResultValue);
    Fail('A known record number must be positive.');
  except
    on E: EInvalidIndexedSeekResult do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedSeekContract.
  TestRejectsRecordNumberWithoutKnownIdentity;
var
  ResultValue: TIndexedSeekResult;
begin
  ResultValue := ValidSeekResult(False, isrkNoCurrentRow, 4, True, True);
  try
    ValidateIndexedSeekResult(ResultValue);
    Fail('A row number requires known identity state.');
  except
    on E: EInvalidIndexedSeekResult do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedSeekContract.TestRejectsHitWithoutCurrentRow;
var
  ResultValue: TIndexedSeekResult;
begin
  ResultValue := ValidSeekResult(True, isrkNoCurrentRow, 0, True, False);
  try
    ValidateIndexedSeekResult(ResultValue);
    Fail('A hit cannot report that there is no current row.');
  except
    on E: EInvalidIndexedSeekResult do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedSeekContract.
  TestExecutePassesRequestAndReturnsExplicitState;
var
  ProviderObject: TRecordingIndexedSeekProvider;
  Provider: IIndexedSeekProvider;
  Request: TIndexedSeekRequest;
  ResultValue: TIndexedSeekResult;
begin
  ProviderObject := TRecordingIndexedSeekProvider.Create;
  Provider := ProviderObject;
  ProviderObject.ResultValue := ValidSeekResult(
    False, isrkKnownRecordNumber, 1, True, False);
  Request := CreateIndexedSeekRequest('vat', [LongInt(123)]);

  ResultValue := ExecuteIndexedSeek(Provider, Request);

  AssertEquals('vat', ProviderObject.LastRequest.IndexName);
  AssertEquals(1, Length(ProviderObject.LastRequest.KeyValues));
  AssertEquals(123, Integer(ProviderObject.LastRequest.KeyValues[0]));
  AssertFalse(ResultValue.Found);
  AssertTrue(ResultValue.BOF);
  AssertFalse(ResultValue.EOF);
  AssertEquals(1, ResultValue.CurrentRecordNumber);
  Provider := nil;
end;

procedure TTestAHW52IndexedSeekContract.TestExecuteRejectsMissingProvider;
var
  Provider: IIndexedSeekProvider;
  Request: TIndexedSeekRequest;
begin
  Provider := nil;
  Request := CreateIndexedSeekRequest('ort_', ['place']);
  try
    ExecuteIndexedSeek(Provider, Request);
    Fail('A missing provider must fail explicitly.');
  except
    on E: EArgumentNilException do
      AssertEquals('Provider', E.Message);
  end;
end;

procedure TTestAHW52IndexedSeekContract.TestProviderFailurePropagates;
var
  ProviderObject: TRecordingIndexedSeekProvider;
  Provider: IIndexedSeekProvider;
  Request: TIndexedSeekRequest;
begin
  ProviderObject := TRecordingIndexedSeekProvider.Create;
  ProviderObject.FailLookup := True;
  Provider := ProviderObject;
  Request := CreateIndexedSeekRequest('ort_', ['place']);
  try
    ExecuteIndexedSeek(Provider, Request);
    Fail('Provider failures must not be converted to misses.');
  except
    on E: EInjectedIndexedSeekFailure do
      AssertEquals('Injected provider failure.', E.Message);
  end;
  Provider := nil;
end;

procedure TTestAHW52IndexedSeekContract.
  TestUnsupportedSemanticsDoNotBecomeMisses;
var
  ProviderObject: TRecordingIndexedSeekProvider;
  Provider: IIndexedSeekProvider;
  Request: TIndexedSeekRequest;
begin
  ProviderObject := TRecordingIndexedSeekProvider.Create;
  ProviderObject.Unsupported := True;
  Provider := ProviderObject;
  Request := CreateIndexedSeekRequest('ort_', ['place']);
  try
    ExecuteIndexedSeek(Provider, Request);
    Fail('Unsupported semantics must not be reported as a miss.');
  except
    on E: EIndexedSeekUnsupported do
      AssertTrue(E.Message <> '');
  end;
  Provider := nil;
end;

procedure TTestAHW52IndexedSeekContract.
  TestCandidateListContractRemainsSeparate;
var
  CandidateResult: TIndexedLookupResult;
begin
  CandidateResult := CreateIndexedLookupResult([8, 3]);
  ValidateIndexedLookupResult(CandidateResult);
  AssertEquals(Ord(ilrkCandidateList), Ord(CandidateResult.Kind));
  AssertEquals(8, CandidateResult.CandidateRecordNumbers[0]);
  AssertEquals(3, CandidateResult.CandidateRecordNumbers[1]);
end;

initialization
  RegisterTest(TTestAHW52IndexedSeekContract);

end.
