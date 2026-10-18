unit tst_AHW52_IndexedLookupProviderTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52IndexedLookupProvider = class(TTestCase)
  private
    procedure AssertFieldList(const IndexName: string;
      const ExpectedFields: array of string);
  published
    procedure TestRequestPreservesRecoveredIndexAndKeyOrder;
    procedure TestPersonSearchBuildsRecoveredGebaPrefix;
    procedure TestPersonSearchUsesProviderAndCandidateList;
    procedure TestPersonSearchRejectsMalformedProviderResult;
    procedure TestPersonSearchRejectsMissingProvider;
    procedure TestRecoveredTable9IndexDefinitions;
    procedure TestNoCandidatesClassifyAsNotFound;
    procedure TestOneCandidateClassifiesAsSingle;
    procedure TestMultipleCandidatesRemainAnOrderedList;
    procedure TestRejectsEmptyIndexName;
    procedure TestRejectsEmptyKeyPrefix;
    procedure TestRejectsInconsistentNotFoundResult;
    procedure TestRejectsInconsistentSingleResult;
    procedure TestRejectsInconsistentCandidateList;
    procedure TestProviderFailurePropagates;
  end;

implementation

uses
  Classes, SysUtils, IndexedLookupContract, Table9IndexDefinitions,
  PersonSearchLookupRequest;

type
  EInjectedLookupFailure = class(Exception);

  TRecordingLookupProvider = class(TInterfacedObject, IIndexedLookupProvider)
  private
    FLastRequest: TIndexedLookupRequest;
    FResult: TIndexedLookupResult;
    FFailLookup: Boolean;
  public
    function FindCandidates(
      const Request: TIndexedLookupRequest): TIndexedLookupResult;
    property LastRequest: TIndexedLookupRequest read FLastRequest;
    property ResultValue: TIndexedLookupResult read FResult write FResult;
    property FailLookup: Boolean read FFailLookup write FFailLookup;
  end;

function CloneRequest(const Source: TIndexedLookupRequest):
  TIndexedLookupRequest;
var
  Index: LongInt;
begin
  Result.IndexName := Source.IndexName;
  SetLength(Result.KeyValues, Length(Source.KeyValues));
  for Index := 0 to High(Source.KeyValues) do
    Result.KeyValues[Index] := Source.KeyValues[Index];
end;

function CloneResult(const Source: TIndexedLookupResult):
  TIndexedLookupResult;
var
  Index: LongInt;
begin
  Result.Kind := Source.Kind;
  SetLength(Result.CandidateRecordNumbers,
    Length(Source.CandidateRecordNumbers));
  for Index := 0 to High(Source.CandidateRecordNumbers) do
    Result.CandidateRecordNumbers[Index] :=
      Source.CandidateRecordNumbers[Index];
end;

function TRecordingLookupProvider.FindCandidates(
  const Request: TIndexedLookupRequest): TIndexedLookupResult;
begin
  if FFailLookup then
    raise EInjectedLookupFailure.Create('Injected provider failure.');
  FLastRequest := CloneRequest(Request);
  Result := CloneResult(FResult);
end;

procedure TTestAHW52IndexedLookupProvider.AssertFieldList(
  const IndexName: string; const ExpectedFields: array of string);
var
  Definition: TTable9IndexDefinition;
  Index: LongInt;
begin
  Definition := GetTable9IndexDefinition(IndexName);
  AssertEquals(IndexName, Definition.Name);
  AssertEquals('intl850', Definition.Collation);
  AssertEquals(Length(ExpectedFields), Length(Definition.FieldNames));
  for Index := 0 to High(ExpectedFields) do
    AssertEquals('Index ' + IndexName + ' field order at position ' +
      IntToStr(Index), ExpectedFields[Index], Definition.FieldNames[Index]);
end;

procedure TTestAHW52IndexedLookupProvider.
  TestRequestPreservesRecoveredIndexAndKeyOrder;
var
  Provider: IIndexedLookupProvider;
  ProviderObject: TRecordingLookupProvider;
  Request: TIndexedLookupRequest;
begin
  ProviderObject := TRecordingLookupProvider.Create;
  Provider := ProviderObject;
  ProviderObject.ResultValue := CreateIndexedLookupResult([42]);
  Request := CreateIndexedLookupRequest('geba',
    ['Schmidt', 'Anna']);

  Provider.FindCandidates(Request);

  AssertEquals('The recovered index identity is preserved.',
    'geba', ProviderObject.LastRequest.IndexName);
  AssertEquals('Name remains the leading key value.',
    'Schmidt', ProviderObject.LastRequest.KeyValues[0]);
  AssertEquals('Given name remains the second key value.',
    'Anna', ProviderObject.LastRequest.KeyValues[1]);
  AssertEquals('The two-field request remains a key prefix.',
    2, Length(ProviderObject.LastRequest.KeyValues));
  Provider := nil;
end;

procedure TTestAHW52IndexedLookupProvider.
  TestPersonSearchBuildsRecoveredGebaPrefix;
var
  Request: TIndexedLookupRequest;
begin
  Request := BuildPersonSearchLookupRequest('Schmidt', 'Anna');
  AssertEquals('The person dialog uses the recovered geba index.',
    'geba', Request.IndexName);
  AssertEquals(2, Length(Request.KeyValues));
  AssertEquals('Edit1 / surname is the first key component.',
    'Schmidt', Request.KeyValues[0]);
  AssertEquals('Edit2 / given name is the second key component.',
    'Anna', Request.KeyValues[1]);
end;

procedure TTestAHW52IndexedLookupProvider.
  TestPersonSearchUsesProviderAndCandidateList;
var
  ProviderObject: TRecordingLookupProvider;
  Provider: IIndexedLookupProvider;
  LookupResult: TIndexedLookupResult;
begin
  ProviderObject := TRecordingLookupProvider.Create;
  ProviderObject.ResultValue := CreateIndexedLookupResult([12, 8]);
  Provider := ProviderObject;

  LookupResult := FindPersonSearchCandidates(Provider, 'Schmidt', 'Anna');

  AssertEquals('geba', ProviderObject.LastRequest.IndexName);
  AssertEquals('Schmidt', ProviderObject.LastRequest.KeyValues[0]);
  AssertEquals('Anna', ProviderObject.LastRequest.KeyValues[1]);
  AssertEquals(Ord(ilrkCandidateList), Ord(LookupResult.Kind));
  AssertEquals(12, LookupResult.CandidateRecordNumbers[0]);
  AssertEquals(8, LookupResult.CandidateRecordNumbers[1]);
  Provider := nil;
end;

procedure TTestAHW52IndexedLookupProvider.
  TestPersonSearchRejectsMalformedProviderResult;
var
  ProviderObject: TRecordingLookupProvider;
  Provider: IIndexedLookupProvider;
  MalformedResult: TIndexedLookupResult;
  Raised: Boolean;
begin
  ProviderObject := TRecordingLookupProvider.Create;
  MalformedResult.Kind := ilrkSingleCandidate;
  MalformedResult.CandidateRecordNumbers := nil;
  ProviderObject.ResultValue := MalformedResult;
  Provider := ProviderObject;
  Raised := False;
  try
    FindPersonSearchCandidates(Provider, 'Schmidt', 'Anna');
  except
    on E: EInvalidLookupResult do
      Raised := True;
  end;
  AssertTrue('Malformed provider responses must not reach the UI.', Raised);
  Provider := nil;
end;

procedure TTestAHW52IndexedLookupProvider.
  TestPersonSearchRejectsMissingProvider;
var
  Provider: IIndexedLookupProvider;
  Raised: Boolean;
begin
  Provider := nil;
  Raised := False;
  try
    FindPersonSearchCandidates(Provider, 'Schmidt', 'Anna');
  except
    on E: EArgumentException do
      Raised := E.Message <> '';
  end;
  AssertTrue('A missing provider must be reported explicitly.', Raised);
end;

procedure TTestAHW52IndexedLookupProvider.
  TestRecoveredTable9IndexDefinitions;
var
  IndexNames: TTable9FieldNames;
  Index: LongInt;
begin
  IndexNames := GetTable9IndexNames;
  try
    AssertEquals('All eight fixture index headers are represented.',
      8, Length(IndexNames));
    for Index := 0 to High(IndexNames) do
    begin
      AssertTrue('Each decoded index has ordered key fields.',
        Length(GetTable9IndexDefinition(IndexNames[Index]).FieldNames) > 0);
    end;

    AssertFieldList('muto',
      ['Mutter', 'Gebjahr', 'Gebmonat', 'Gebtag', 'Taufjahr',
       'Taufmonat', 'Tauftag', 'Nummer']);
    AssertFieldList('vato',
      ['Vater', 'Gebjahr', 'Gebmonat', 'Gebtag', 'Taufjahr',
       'Taufmonat', 'Tauftag', 'Nummer']);
    AssertFieldList('namgeb',
      ['Name', 'Vornamen', 'Gebjahr', 'Indj', 'Indm', 'Indt', 'Nummer']);
    AssertFieldList('geba',
      ['Name', 'Vornamen', 'Gebjahr', 'Gebmonat', 'Gebtag', 'Taufjahr',
       'Taufmonat', 'Tauftag', 'Nummer']);
    AssertFieldList('gebnam',
      ['Indj', 'Indm', 'Indt', 'Name', 'Vornamen', 'Nummer']);
    AssertFieldList('mut', ['Mutter', 'Indj', 'Indm', 'Indt', 'Nummer']);
    AssertFieldList('vat', ['Vater', 'Indj', 'Indm', 'Indt', 'Nummer']);
    AssertFieldList('gebo', ['Gebort', 'Nummer']);
  finally
    IndexNames := nil;
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestNoCandidatesClassifyAsNotFound;
var
  LookupResult: TIndexedLookupResult;
begin
  LookupResult := CreateIndexedLookupResult([]);
  AssertEquals(Ord(ilrkNotFound), Ord(LookupResult.Kind));
  AssertEquals(0, Length(LookupResult.CandidateRecordNumbers));
  ValidateIndexedLookupResult(LookupResult);
end;

procedure TTestAHW52IndexedLookupProvider.TestOneCandidateClassifiesAsSingle;
var
  LookupResult: TIndexedLookupResult;
begin
  LookupResult := CreateIndexedLookupResult([17]);
  AssertEquals(Ord(ilrkSingleCandidate), Ord(LookupResult.Kind));
  AssertEquals(1, Length(LookupResult.CandidateRecordNumbers));
  AssertEquals(17, LookupResult.CandidateRecordNumbers[0]);
  ValidateIndexedLookupResult(LookupResult);
end;

procedure TTestAHW52IndexedLookupProvider.
  TestMultipleCandidatesRemainAnOrderedList;
var
  LookupResult: TIndexedLookupResult;
begin
  LookupResult := CreateIndexedLookupResult([19, 4, 27]);
  AssertEquals(Ord(ilrkCandidateList), Ord(LookupResult.Kind));
  AssertEquals(3, Length(LookupResult.CandidateRecordNumbers));
  AssertEquals('The abstraction preserves provider index order.',
    19, LookupResult.CandidateRecordNumbers[0]);
  AssertEquals(4, LookupResult.CandidateRecordNumbers[1]);
  AssertEquals(27, LookupResult.CandidateRecordNumbers[2]);
  ValidateIndexedLookupResult(LookupResult);
end;

procedure TTestAHW52IndexedLookupProvider.TestRejectsEmptyIndexName;
begin
  try
    CreateIndexedLookupRequest(' ', ['Name']);
    Fail('An empty index name must be rejected.');
  except
    on E: EInvalidLookupKey do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestRejectsEmptyKeyPrefix;
begin
  try
    CreateIndexedLookupRequest('geba', []);
    Fail('An empty key prefix must be rejected.');
  except
    on E: EInvalidLookupKey do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestRejectsInconsistentNotFoundResult;
var
  LookupResult: TIndexedLookupResult;
begin
  LookupResult.Kind := ilrkNotFound;
  LookupResult.CandidateRecordNumbers := [9];
  try
    ValidateIndexedLookupResult(LookupResult);
    Fail('A not-found result cannot carry candidates.');
  except
    on E: EInvalidLookupResult do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestRejectsInconsistentSingleResult;
var
  LookupResult: TIndexedLookupResult;
begin
  LookupResult.Kind := ilrkSingleCandidate;
  LookupResult.CandidateRecordNumbers := nil;
  try
    ValidateIndexedLookupResult(LookupResult);
    Fail('A single-candidate result must carry exactly one candidate.');
  except
    on E: EInvalidLookupResult do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedLookupProvider.
  TestRejectsInconsistentCandidateList;
var
  LookupResult: TIndexedLookupResult;
begin
  LookupResult.Kind := ilrkCandidateList;
  LookupResult.CandidateRecordNumbers := [9];
  try
    ValidateIndexedLookupResult(LookupResult);
    Fail('A candidate list must contain at least two candidates.');
  except
    on E: EInvalidLookupResult do
      AssertTrue(E.Message <> '');
  end;
end;

procedure TTestAHW52IndexedLookupProvider.TestProviderFailurePropagates;
var
  ProviderObject: TRecordingLookupProvider;
  Provider: IIndexedLookupProvider;
  Request: TIndexedLookupRequest;
  Raised: Boolean;
begin
  ProviderObject := TRecordingLookupProvider.Create;
  ProviderObject.FailLookup := True;
  Provider := ProviderObject;
  Request := CreateIndexedLookupRequest('geba', ['Name', 'Vorname']);
  Raised := False;
  try
    Provider.FindCandidates(Request);
  except
    on E: EInjectedLookupFailure do
      Raised := True;
  end;
  AssertTrue('Provider errors must remain visible.', Raised);
  Provider := nil;
end;

initialization
  RegisterTest(TTestAHW52IndexedLookupProvider);

end.
