unit Table9IndexDefinitions;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

type
  TTable9FieldNames = array of string;

  TTable9IndexDefinition = record
    Name: string;
    FieldNames: TTable9FieldNames;
    Collation: string;
  end;

/// Header-decoded schema for the approved fixture; not runtime file discovery.
function GetTable9IndexDefinition(
  const IndexName: string): TTable9IndexDefinition;
function GetTable9IndexNames: TTable9FieldNames;

implementation

uses
  SysUtils;

procedure SetDefinition(var Definition: TTable9IndexDefinition;
  const IndexName, Collation: string; const FieldNames: array of string);
var
  Index: LongInt;
begin
  Definition.FieldNames := nil;
  Definition.Name := IndexName;
  Definition.Collation := Collation;
  SetLength(Definition.FieldNames, Length(FieldNames));
  for Index := 0 to High(FieldNames) do
    Definition.FieldNames[Index] := FieldNames[Index];
end;

function GetTable9IndexDefinition(
  const IndexName: string): TTable9IndexDefinition;
begin
  Result.Name := '';
  Result.FieldNames := nil;
  Result.Collation := '';
  if SameText(IndexName, 'muto') then
    SetDefinition(Result, 'muto', 'intl850',
      ['Mutter', 'Gebjahr', 'Gebmonat', 'Gebtag', 'Taufjahr',
       'Taufmonat', 'Tauftag', 'Nummer'])
  else if SameText(IndexName, 'vato') then
    SetDefinition(Result, 'vato', 'intl850',
      ['Vater', 'Gebjahr', 'Gebmonat', 'Gebtag', 'Taufjahr',
       'Taufmonat', 'Tauftag', 'Nummer'])
  else if SameText(IndexName, 'namgeb') then
    SetDefinition(Result, 'namgeb', 'intl850',
      ['Name', 'Vornamen', 'Gebjahr', 'Indj', 'Indm', 'Indt', 'Nummer'])
  else if SameText(IndexName, 'geba') then
    SetDefinition(Result, 'geba', 'intl850',
      ['Name', 'Vornamen', 'Gebjahr', 'Gebmonat', 'Gebtag',
       'Taufjahr', 'Taufmonat', 'Tauftag', 'Nummer'])
  else if SameText(IndexName, 'gebnam') then
    SetDefinition(Result, 'gebnam', 'intl850',
      ['Indj', 'Indm', 'Indt', 'Name', 'Vornamen', 'Nummer'])
  else if SameText(IndexName, 'mut') then
    SetDefinition(Result, 'mut', 'intl850',
      ['Mutter', 'Indj', 'Indm', 'Indt', 'Nummer'])
  else if SameText(IndexName, 'vat') then
    SetDefinition(Result, 'vat', 'intl850',
      ['Vater', 'Indj', 'Indm', 'Indt', 'Nummer'])
  else if SameText(IndexName, 'gebo') then
    SetDefinition(Result, 'gebo', 'intl850', ['Gebort', 'Nummer'])
  else
    raise EArgumentException.CreateFmt('Unknown Table9 index "%s".',
      [IndexName]);
end;

function GetTable9IndexNames: TTable9FieldNames;
begin
  Result := nil;
  SetLength(Result, 8);
  Result[0] := 'muto';
  Result[1] := 'vato';
  Result[2] := 'namgeb';
  Result[3] := 'geba';
  Result[4] := 'gebnam';
  Result[5] := 'mut';
  Result[6] := 'vat';
  Result[7] := 'gebo';
end;

end.
