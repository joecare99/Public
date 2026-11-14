unit PersonSearchLookupRequest;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  IndexedLookupContract;

function BuildPersonSearchLookupRequest(const Surname,
  GivenName: string): TIndexedLookupRequest;
function FindPersonSearchCandidates(const Provider: IIndexedLookupProvider;
  const Surname, GivenName: string): TIndexedLookupResult;

implementation

uses
  SysUtils;

function BuildPersonSearchLookupRequest(const Surname,
  GivenName: string): TIndexedLookupRequest;
begin
  Result := CreateIndexedLookupRequest('geba', [Surname, GivenName]);
end;

function FindPersonSearchCandidates(const Provider: IIndexedLookupProvider;
  const Surname, GivenName: string): TIndexedLookupResult;
var
  Request: TIndexedLookupRequest;
begin
  if not Assigned(Provider) then
    raise EArgumentException.Create('A lookup provider is required.');
  Request := BuildPersonSearchLookupRequest(Surname, GivenName);
  Result := Provider.FindCandidates(Request);
  ValidateIndexedLookupResult(Result);
end;

end.
