unit Unit15SpitzbasModel;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

type
  TUnit15SpitzbasPerson = record
    Number: Integer;
    FatherNumber: Integer;
    MotherNumber: Integer;
    Name: string;
    GivenNames: string;
    LifePlace: string;
    Sex: string;
    BirthDay: string;
    BirthMonth: string;
    BirthYear: string;
    BirthPlace: string;
    BaptismDay: string;
    BaptismMonth: string;
    BaptismYear: string;
    BaptismPlace: string;
    DeathDay: string;
    DeathMonth: string;
    DeathYear: string;
    DeathPlace: string;
    BurialDay: string;
    BurialMonth: string;
    BurialYear: string;
    BurialPlace: string;
  end;

  TUnit15SpitzbasTraversalItem = record
    HasCurrentTable9Row: Boolean;
    CurrentTable9Row: TUnit15SpitzbasPerson;
    // Lookup/filter outcomes are supplied snapshots; no provider lookup runs here.
    Table24Number: Integer;
    Table9LookupFound: Boolean;
    Table9TraversalPassesCutoff: Boolean;
    Table24KekDisplayText: string;
    SpitzMarriageLookupFound: Boolean;
    SpitzMarriageVerbind: string;
    BasisMarriageLookupFound: Boolean;
    FatherIndexDescendantFound: Boolean;
    MotherIndexDescendantFound: Boolean;
    InheritedIndexDescendantFound: Boolean;
  end;

  TUnit15SpitzbasTraversalItems = array of TUnit15SpitzbasTraversalItem;

  TUnit15SpitzbasInput = record
    Mode: string;
    Heading: string;
    CutoffYear: Integer;
    Items: TUnit15SpitzbasTraversalItems;
  end;

  TUnit15SpitzbasRow = record
    Kn: string;
    Namvorn: string;
    Kmt: string;
  end;

  TUnit15SpitzbasRows = array of TUnit15SpitzbasRow;

/// Builds listing-backed Table27 values from explicit, synthetic lookup
/// snapshots. It does not access datasets, providers, reports, or UI.
function BuildUnit15SpitzbasModel(
  const AInput: TUnit15SpitzbasInput): TUnit15SpitzbasRows;

implementation

uses
  SysUtils, DB, Unit3SourceTextNormalizer;

function NormalizeSpitzbasMode(const AMode: string): string;
begin
  if (AMode = 'Sppr') or (AMode = 'basa') then
    Result := AMode
  else
    Result := 'Sppo';
end;

function ContainsText(const AText, AValue: string): Boolean;
begin
  Result := Pos(AValue, AText) > 0;
end;

function HasBirthOrBaptism(const APerson: TUnit15SpitzbasPerson): string;
begin
  if (APerson.BirthYear <> '') or (APerson.BirthPlace <> '') then
    Result := ' * ' + APerson.BirthDay + '.' + APerson.BirthMonth + '.' +
      NormalizeUnit3SourceText(APerson.BirthYear) + ' ' + APerson.BirthPlace
  else if (APerson.BaptismYear <> '') or (APerson.BaptismPlace <> '') then
    Result := ' ~ ' + APerson.BaptismDay + '.' + APerson.BaptismMonth + '.' +
      NormalizeUnit3SourceText(APerson.BaptismYear) + ' ' +
      APerson.BaptismPlace
  else
    Result := '';
end;

function DeathOrBurialAnnotation(
  const APerson: TUnit15SpitzbasPerson): string;
begin
  if (APerson.DeathYear <> '') or (APerson.DeathPlace <> '') then
    Result := ' + ' + APerson.DeathDay + '.' + APerson.DeathMonth + '.' +
      NormalizeUnit3SourceText(APerson.DeathYear) + ' ' + APerson.DeathPlace
  else if (APerson.BurialYear <> '') or (APerson.BurialPlace <> '') then
    Result := ' # ' + APerson.BurialDay + '.' + APerson.BurialMonth + '.' +
      NormalizeUnit3SourceText(APerson.BurialYear) + ' ' + APerson.BurialPlace
  else
    Result := '';
end;

function BuildSpitzbasText(const AItem: TUnit15SpitzbasTraversalItem;
  const AMode: string): string;
var
  spouseSuffix: string;
begin
  spouseSuffix := '';
  if AItem.SpitzMarriageLookupFound then
    if ContainsText(AItem.SpitzMarriageVerbind, 'Ehes') then
      spouseSuffix := ', oo'
    else
      spouseSuffix := ', o-o';

  Result := AItem.CurrentTable9Row.Name + ' ' +
    AItem.CurrentTable9Row.GivenNames + spouseSuffix;
  if AMode = 'Sppr' then
    Result := '[' + AItem.Table24KekDisplayText + '] ' + Result;

  Result := Result + HasBirthOrBaptism(AItem.CurrentTable9Row) +
    DeathOrBurialAnnotation(AItem.CurrentTable9Row);
end;

function HasDescendantLookupHit(
  const AItem: TUnit15SpitzbasTraversalItem): Boolean;
var
  sex: string;
begin
  sex := UpperCase(AItem.CurrentTable9Row.Sex);
  if sex = 'M' then
    Result := AItem.FatherIndexDescendantFound
  else if sex = 'W' then
    Result := AItem.MotherIndexDescendantFound
  else
    Result := AItem.InheritedIndexDescendantFound;
end;

function BuildBasisText(const AItem: TUnit15SpitzbasTraversalItem): string;
begin
  Result := AItem.CurrentTable9Row.Name + ' ' +
    AItem.CurrentTable9Row.GivenNames;
  if HasDescendantLookupHit(AItem) then
    Result := Result + '(Nachfahren)';
  Result := Result + HasBirthOrBaptism(AItem.CurrentTable9Row) +
    DeathOrBurialAnnotation(AItem.CurrentTable9Row);
end;

function BuildUnit15SpitzbasModel(
  const AInput: TUnit15SpitzbasInput): TUnit15SpitzbasRows;
var
  itemIndex: Integer;
  mode: string;
  hasSpitz: Boolean;
  hasBasis: Boolean;
  person: TUnit15SpitzbasPerson;
  row: TUnit15SpitzbasRow;
  ageDifference: Integer;
begin
  Result := nil;
  mode := NormalizeSpitzbasMode(AInput.Mode);
  hasSpitz := ContainsText(AInput.Heading, 'Spitz');
  hasBasis := ContainsText(AInput.Heading, 'Basis');

  for itemIndex := 0 to High(AInput.Items) do
  begin
    if (AInput.CutoffYear > 1) and (mode <> 'Sppr') and
      not AInput.Items[itemIndex].Table9TraversalPassesCutoff then
      Continue;

    if not (hasSpitz or hasBasis) then
      Continue;

    if not AInput.Items[itemIndex].HasCurrentTable9Row then
      raise EDatabaseError.Create(
        'The synthetic traversal item has no current Table9 row.');
    person := AInput.Items[itemIndex].CurrentTable9Row;

    if hasSpitz and (person.FatherNumber = 0) and
      (person.MotherNumber = 0) and (Trim(person.Name) <> '') and
      (person.Name <> 'NN') then
    begin
      row.Kn := Format('%6s', [IntToStr(person.Number)]);
      row.Namvorn := BuildSpitzbasText(AInput.Items[itemIndex], mode);
      row.Kmt := person.LifePlace;
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := row;
    end;

    if hasBasis and (person.BirthYear <> '') and
      (person.DeathYear <> '') then
    begin
      ageDifference := StrToInt(person.BirthYear) -
        StrToInt(person.DeathYear);
      if (ageDifference >= 32) and (person.Name <> '') and
        not AInput.Items[itemIndex].BasisMarriageLookupFound then
      begin
        row.Kn := Format('%6s', [IntToStr(person.Number)]);
        row.Namvorn := BuildBasisText(AInput.Items[itemIndex]);
        row.Kmt := person.LifePlace;
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)] := row;
      end;
    end;
  end;
end;

end.
