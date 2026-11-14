unit tst_AHW52_Unit15SpitzbasModelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit15SpitzbasModel = class(TTestCase)
  published
    procedure TestIndependentHeadingBranchesAppendSpitzBeforeBasis;
    procedure TestModeFallbackAndHeadingChecksAreExact;
    procedure TestSpprUsesExplicitCurrentRowAfterLookupMiss;
    procedure TestSpitzMarriageSuffixRequiresLookupHit;
    procedure TestSpitzAndBasisInclusionBoundaries;
    procedure TestBasisUsesAgeMarriageAndGenderSpecificLookupStates;
    procedure TestCutoffOnlySkipsFilteredTable9TraversalRows;
    procedure TestEventTextUsesLegacyPrecedenceAndNormalizer;
    procedure TestInvalidBasisYearAndMissingCurrentRowPropagate;
    procedure TestSyntheticRowsComposeWithUnit15Projection;
    procedure TestEmptyInputProducesNoRows;
  end;

implementation

uses
  SysUtils, DB, BufDataset, Unit15SpitzbasModel, Unit15SpitzbasRows;

function CreateTraversalItem: TUnit15SpitzbasTraversalItem;
begin
  Result := Default(TUnit15SpitzbasTraversalItem);
  Result.HasCurrentTable9Row := True;
  Result.Table9TraversalPassesCutoff := True;
  Result.CurrentTable9Row.Number := 42;
  Result.CurrentTable9Row.Name := 'Alpha';
  Result.CurrentTable9Row.GivenNames := 'Ada';
  Result.CurrentTable9Row.LifePlace := 'Bonn';
end;

function CreateModelInput(const AHeading, AMode: string;
  const AItem: TUnit15SpitzbasTraversalItem): TUnit15SpitzbasInput;
begin
  Result := Default(TUnit15SpitzbasInput);
  Result.Mode := AMode;
  Result.Heading := AHeading;
  Result.Items := nil;
  SetLength(Result.Items, 1);
  Result.Items[0] := AItem;
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestIndependentHeadingBranchesAppendSpitzBeforeBasis;
var
  item: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
begin
  item := CreateTraversalItem;
  item.BasisMarriageLookupFound := False;
  item.FatherIndexDescendantFound := True;
  item.CurrentTable9Row.Sex := 'M';
  item.CurrentTable9Row.BirthYear := '1950';
  item.CurrentTable9Row.DeathYear := '1900';
  item.CurrentTable9Row.BirthDay := '01';
  item.CurrentTable9Row.BirthMonth := '02';
  item.CurrentTable9Row.BirthPlace := 'Town';
  input := CreateModelInput('Spitz und Basis', 'basa', item);
  rows := BuildUnit15SpitzbasModel(input);

  AssertEquals('Both independent heading predicates append a row.', 2,
    Length(rows));
  AssertEquals('Spitz is appended first.', 'Alpha Ada * 01.02.1950 Town + ..1900 ',
    rows[0].Namvorn);
  AssertEquals('Basis follows the Spitz row.',
    'Alpha Ada(Nachfahren) * 01.02.1950 Town + ..1900 ', rows[1].Namvorn);
  AssertEquals('Both branches use the space-padded number.', '    42',
    rows[0].Kn);
  AssertEquals('Both branches use the Table9 life place.', 'Bonn', rows[1].Kmt);
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestModeFallbackAndHeadingChecksAreExact;
var
  item: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
begin
  item := CreateTraversalItem;
  item.Table24KekDisplayText := '2,5';
  input := CreateModelInput('spitz', 'Sppr', item);
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Heading matching is case-sensitive.', 0, Length(rows));

  input.Heading := 'Spitz';
  input.Mode := 'SPPR';
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Unknown mode values normalize to Sppo.', 1, Length(rows));
  AssertEquals('Fallback mode does not add the Sppr KEK prefix.',
    'Alpha Ada', rows[0].Namvorn);
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestSpprUsesExplicitCurrentRowAfterLookupMiss;
var
  item: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
begin
  item := CreateTraversalItem;
  item.Table9LookupFound := False;
  item.Table9TraversalPassesCutoff := False;
  item.Table24Number := 9001;
  item.Table24KekDisplayText := '2.5';
  input := CreateModelInput('Spitz', 'Sppr', item);
  input.CutoffYear := 2000;
  rows := BuildUnit15SpitzbasModel(input);

  AssertEquals('Sppr traverses Table24 items despite the Table9 cutoff state.',
    1, Length(rows));
  AssertEquals('The unchecked Table9 miss uses the explicitly supplied current row.',
    '[2.5] Alpha Ada', rows[0].Namvorn);
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestSpitzAndBasisInclusionBoundaries;
var
  item: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
begin
  item := CreateTraversalItem;
  input := CreateModelInput('Spitz', 'Sppo', item);
  item.CurrentTable9Row.FatherNumber := 1;
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Spitz excludes rows with a father.', 0, Length(rows));

  item.CurrentTable9Row.FatherNumber := 0;
  item.CurrentTable9Row.MotherNumber := 1;
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Spitz excludes rows with a mother.', 0, Length(rows));

  item.CurrentTable9Row.MotherNumber := 0;
  item.CurrentTable9Row.Name := '   ';
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Spitz tests the trimmed name for emptiness.', 0, Length(rows));

  item.CurrentTable9Row.Name := 'NN';
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Spitz rejects the raw NN name.', 0, Length(rows));

  item.CurrentTable9Row.BirthYear := '1900';
  item.CurrentTable9Row.DeathYear := '1869';
  input := CreateModelInput('Basis', 'basa', item);
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Basis requires an age difference of at least 32.', 0,
    Length(rows));

  item.CurrentTable9Row.DeathYear := '1868';
  item.CurrentTable9Row.Name := 'NN';
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Basis accepts NN when the other predicates pass.', 1,
    Length(rows));

  item.CurrentTable9Row.Name := '';
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Basis rejects an empty name.', 0, Length(rows));
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestSpitzMarriageSuffixRequiresLookupHit;
var
  item: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
begin
  item := CreateTraversalItem;
  item.SpitzMarriageLookupFound := True;
  item.SpitzMarriageVerbind := 'Ehes';
  input := CreateModelInput('Spitz', 'Sppo', item);
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('A found Ehes lookup appends the marriage suffix.',
    'Alpha Ada, oo', rows[0].Namvorn);

  item.SpitzMarriageLookupFound := False;
  item.SpitzMarriageVerbind := 'Ehes';
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('A miss does not read the retained Verbind value.',
    'Alpha Ada', rows[0].Namvorn);

  item.SpitzMarriageLookupFound := True;
  item.SpitzMarriageVerbind := 'other';
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('A found non-Ehes lookup appends the alternate suffix.',
    'Alpha Ada, o-o', rows[0].Namvorn);
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestBasisUsesAgeMarriageAndGenderSpecificLookupStates;
var
  item: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
begin
  item := CreateTraversalItem;
  item.CurrentTable9Row.BirthYear := '1950';
  item.CurrentTable9Row.DeathYear := '1900';
  item.CurrentTable9Row.FatherNumber := 10;
  item.CurrentTable9Row.Sex := 'm';
  item.FatherIndexDescendantFound := True;
  item.MotherIndexDescendantFound := False;
  item.InheritedIndexDescendantFound := False;
  input := CreateModelInput('Basis', 'basa', item);
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('A qualifying M row uses the vat/father-index result.', 1,
    Length(rows));
  AssertEquals('The marker is appended without an extra space.',
    'Alpha Ada(Nachfahren) * ..1950  + ..1900 ', rows[0].Namvorn);

  item.CurrentTable9Row.Sex := 'W';
  item.FatherIndexDescendantFound := False;
  item.MotherIndexDescendantFound := True;
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('A W row uses the mut/mother-index result.',
    'Alpha Ada(Nachfahren) * ..1950  + ..1900 ', rows[0].Namvorn);

  item.CurrentTable9Row.Sex := 'X';
  item.MotherIndexDescendantFound := False;
  item.InheritedIndexDescendantFound := True;
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Other sex values use the explicitly supplied inherited-index result.',
    'Alpha Ada(Nachfahren) * ..1950  + ..1900 ', rows[0].Namvorn);

  item.InheritedIndexDescendantFound := False;
  input.Items[0] := item;
  input.CutoffYear := 1965;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('A Table8 lookup miss after filtering omits the descendant marker.',
    'Alpha Ada * ..1950  + ..1900 ', rows[0].Namvorn);

  item.BasisMarriageLookupFound := True;
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('A found Basis marriage lookup excludes the row.', 0,
    Length(rows));
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestCutoffOnlySkipsFilteredTable9TraversalRows;
var
  item1: TUnit15SpitzbasTraversalItem;
  item2: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
begin
  item1 := CreateTraversalItem;
  item1.CurrentTable9Row.Name := 'First';
  item2 := CreateTraversalItem;
  item2.CurrentTable9Row.Name := 'Second';
  item2.Table9TraversalPassesCutoff := False;
  input := CreateModelInput('Spitz', 'Sppo', item1);
  SetLength(input.Items, 2);
  input.Items[1] := item2;

  input.CutoffYear := 1900;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('An active cutoff retains only eligible Table9 traversal rows.',
    1, Length(rows));
  AssertEquals('Input traversal order is retained.', 'First Ada',
    rows[0].Namvorn);

  input.CutoffYear := 1;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('A cutoff at or below one does not activate the filter.',
    2, Length(rows));
  AssertEquals('The second synthetic source item remains second.',
    'Second Ada', rows[1].Namvorn);

  input.Mode := 'Sppr';
  input.CutoffYear := 1900;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Sppr traverses Table24; Table9 filter state affects only its lookup.',
    2, Length(rows));
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestEventTextUsesLegacyPrecedenceAndNormalizer;
var
  item: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
begin
  item := CreateTraversalItem;
  item.CurrentTable9Row.BirthYear := 'HK 1234567';
  item.CurrentTable9Row.BirthDay := '03';
  item.CurrentTable9Row.BirthMonth := '04';
  item.CurrentTable9Row.BirthPlace := 'Birth';
  item.CurrentTable9Row.BaptismYear := '1800';
  item.CurrentTable9Row.BaptismPlace := 'Baptism';
  item.CurrentTable9Row.DeathYear := '1902';
  item.CurrentTable9Row.DeathPlace := 'Death';
  item.CurrentTable9Row.DeathDay := '05';
  item.CurrentTable9Row.DeathMonth := '06';
  item.CurrentTable9Row.BurialYear := '1901';
  item.CurrentTable9Row.BurialPlace := 'Cemetery';
  input := CreateModelInput('Spitz', 'Sppo', item);
  rows := BuildUnit15SpitzbasModel(input);

  AssertEquals('Birth data takes precedence over baptism.',
    'Alpha Ada * 03.04.HK 1234567 Birth + 05.06.1902 Death',
    rows[0].Namvorn);

  item.CurrentTable9Row.BirthYear := '';
  item.CurrentTable9Row.BirthPlace := '';
  item.CurrentTable9Row.DeathYear := '';
  item.CurrentTable9Row.DeathPlace := '';
  item.CurrentTable9Row.BurialYear := '';
  item.CurrentTable9Row.BurialPlace := '';
  item.CurrentTable9Row.BaptismYear := '1900';
  item.CurrentTable9Row.BaptismPlace := 'Baptism';
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Baptism is used when both birth fields are empty.',
    'Alpha Ada ~ ..1900 Baptism', rows[0].Namvorn);

  item.CurrentTable9Row.BaptismYear := '';
  item.CurrentTable9Row.BaptismPlace := '';
  item.CurrentTable9Row.BurialYear := '1901';
  item.CurrentTable9Row.BurialPlace := 'Cemetery';
  input.Items[0] := item;
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('Burial is used when both death fields are empty.',
    'Alpha Ada # ..1901 Cemetery', rows[0].Namvorn);
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestInvalidBasisYearAndMissingCurrentRowPropagate;
var
  item: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
  rejected: Boolean;
begin
  item := CreateTraversalItem;
  item.CurrentTable9Row.BirthYear := '1950';
  item.CurrentTable9Row.DeathYear := '1900';
  item.CurrentTable9Row.BirthYear := 'not-a-year';
  input := CreateModelInput('Basis', 'basa', item);
  rejected := False;
  rows := nil;
  try
    rows := BuildUnit15SpitzbasModel(input);
    rejected := Length(rows) > 0;
  except
    on E: EConvertError do
      rejected := True;
  end;
  AssertTrue('Invalid listing-backed StrToInt input propagates.',
    rejected);

  item := CreateTraversalItem;
  item.HasCurrentTable9Row := False;
  input := CreateModelInput('Spitz', 'Sppo', item);
  rejected := False;
  rows := nil;
  try
    rows := BuildUnit15SpitzbasModel(input);
    rejected := Length(rows) > 0;
  except
    on E: EDatabaseError do
      rejected := Pos('current Table9 row', E.Message) > 0;
  end;
  AssertTrue('A missing current row is an explicit error.', rejected);
end;

procedure TTestAHW52Unit15SpitzbasModel.
  TestSyntheticRowsComposeWithUnit15Projection;
var
  item: TUnit15SpitzbasTraversalItem;
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
  source: TBufDataset;
  projected: TBufDataset;
  rowIndex: Integer;
begin
  item := CreateTraversalItem;
  item.CurrentTable9Row.BirthYear := '';
  item.CurrentTable9Row.DeathYear := '';
  input := CreateModelInput('Spitz', 'Sppo', item);
  rows := BuildUnit15SpitzbasModel(input);

  source := TBufDataset.Create(nil);
  projected := nil;
  try
    source.FieldDefs.Add('Kn', ftString, 20);
    source.FieldDefs.Add('Namvorn', ftString, 125);
    source.FieldDefs.Add('Kmt', ftString, 30);
    source.CreateDataset;
    source.Open;
    for rowIndex := 0 to High(rows) do
      source.AppendRecord([rows[rowIndex].Kn, rows[rowIndex].Namvorn,
        rows[rowIndex].Kmt]);

    projected := CreateUnit15SpitzbasRows(source);
    AssertEquals('The model output feeds the existing report projection.',
      1, projected.RecordCount);
    AssertEquals('The projected name matches the model row.',
      rows[0].Namvorn, projected.FieldByName('QRDBText1').AsString);
    AssertEquals('The projected key matches the model row.',
      rows[0].Kn, projected.FieldByName('QRDBText2').AsString);
  finally
    projected.Free;
    source.Free;
  end;
end;

procedure TTestAHW52Unit15SpitzbasModel.TestEmptyInputProducesNoRows;
var
  input: TUnit15SpitzbasInput;
  rows: TUnit15SpitzbasRows;
begin
  input := Default(TUnit15SpitzbasInput);
  rows := BuildUnit15SpitzbasModel(input);
  AssertEquals('No synthetic traversal items produce no rows.', 0,
    Length(rows));
end;

initialization
  RegisterTest(TTestAHW52Unit15SpitzbasModel);

end.
