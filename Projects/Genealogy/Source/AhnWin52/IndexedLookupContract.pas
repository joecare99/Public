unit IndexedLookupContract;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  TIndexedLookupKeyValues = array of string;

  /// Ordered values for a prefix of a named index, not a BDE cursor operation.
  TIndexedLookupRequest = record
    IndexName: string;
    KeyValues: TIndexedLookupKeyValues;
  end;

  TTable9RecordNumber = LongInt;
  TTable9RecordNumbers = array of TTable9RecordNumber;

  TIndexedLookupResultKind = (
    ilrkNotFound,
    ilrkSingleCandidate,
    ilrkCandidateList
  );

  TIndexedLookupResult = record
    Kind: TIndexedLookupResultKind;
    /// Ordered by the provider's configured index collation.
    CandidateRecordNumbers: TTable9RecordNumbers;
  end;

  EUnknownLookupIndex = class(Exception);
  EInvalidLookupKey = class(Exception);
  EInvalidLookupResult = class(Exception);

  IIndexedLookupProvider = interface
    ['{1439D3A6-3EBB-4514-9AFD-557B5DE6208C}']
    /// Returns all records matching the supplied prefix of the named index.
    /// Multiple candidates are ordered by that index's configured collation.
    /// The result does not expose or mutate an implicit dataset cursor.
    function FindCandidates(
      const Request: TIndexedLookupRequest): TIndexedLookupResult;
  end;

function CreateIndexedLookupRequest(const IndexName: string;
  const KeyValues: array of string): TIndexedLookupRequest;
/// Maps zero, one, or several candidates to the approved explicit result kind.
function CreateIndexedLookupResult(
  const CandidateRecordNumbers: array of TTable9RecordNumber):
  TIndexedLookupResult;
procedure ValidateIndexedLookupResult(const ResultValue: TIndexedLookupResult);

implementation

function CreateIndexedLookupRequest(const IndexName: string;
  const KeyValues: array of string): TIndexedLookupRequest;
var
  Index: LongInt;
begin
  if Trim(IndexName) = '' then
    raise EInvalidLookupKey.Create('An index name is required.');
  if Length(KeyValues) = 0 then
    raise EInvalidLookupKey.Create('At least one ordered index-key value is required.');

  Result.KeyValues := nil;
  Result.IndexName := IndexName;
  SetLength(Result.KeyValues, Length(KeyValues));
  for Index := 0 to High(KeyValues) do
    Result.KeyValues[Index] := KeyValues[Index];
end;

function CreateIndexedLookupResult(
  const CandidateRecordNumbers: array of TTable9RecordNumber):
  TIndexedLookupResult;
var
  Index: LongInt;
begin
  Result.CandidateRecordNumbers := nil;
  SetLength(Result.CandidateRecordNumbers, Length(CandidateRecordNumbers));
  for Index := 0 to High(CandidateRecordNumbers) do
    Result.CandidateRecordNumbers[Index] := CandidateRecordNumbers[Index];

  case Length(Result.CandidateRecordNumbers) of
    0:
      Result.Kind := ilrkNotFound;
    1:
      Result.Kind := ilrkSingleCandidate;
  else
    Result.Kind := ilrkCandidateList;
  end;
end;

procedure ValidateIndexedLookupResult(const ResultValue: TIndexedLookupResult);
var
  CandidateCount: LongInt;
begin
  CandidateCount := Length(ResultValue.CandidateRecordNumbers);
  case ResultValue.Kind of
    ilrkNotFound:
      if CandidateCount <> 0 then
        raise EInvalidLookupResult.Create(
          'A not-found result cannot contain candidate record numbers.');
    ilrkSingleCandidate:
      if CandidateCount <> 1 then
        raise EInvalidLookupResult.Create(
          'A single-candidate result must contain exactly one record number.');
    ilrkCandidateList:
      if CandidateCount < 2 then
        raise EInvalidLookupResult.Create(
          'A candidate-list result must contain at least two record numbers.');
  else
    raise EInvalidLookupResult.Create('The lookup result kind is invalid.');
  end;
end;

end.
