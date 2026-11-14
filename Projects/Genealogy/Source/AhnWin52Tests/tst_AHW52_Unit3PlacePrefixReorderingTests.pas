unit tst_AHW52_Unit3PlacePrefixReorderingTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit3PlacePrefixReordering = class(TTestCase)
  published
    procedure TestNonNumericInputIsPreserved;
    procedure TestNumericPrefixMovesAfterFirstSpace;
    procedure TestOnlyTheFirstSpaceSeparatesTheParts;
    procedure TestNumericInputWithoutSpaceRetainsLegacyTrailingSpace;
    procedure TestLeadingWhitespacePreventsReordering;
  end;

implementation

uses
  Unit3PlacePrefixReordering;

procedure TTestAHW52Unit3PlacePrefixReordering.TestNonNumericInputIsPreserved;
begin
  AssertEquals('Berlin', ReorderUnit3NumericPlacePrefix('Berlin'));
  AssertEquals(' Berlin ', ReorderUnit3NumericPlacePrefix(' Berlin '));
  AssertEquals('', ReorderUnit3NumericPlacePrefix(''));
end;

procedure TTestAHW52Unit3PlacePrefixReordering.TestNumericPrefixMovesAfterFirstSpace;
begin
  AssertEquals('Neustadt 12', ReorderUnit3NumericPlacePrefix('12 Neustadt'));
  AssertEquals('Dorf 7', ReorderUnit3NumericPlacePrefix('7 Dorf'));
  AssertEquals('Dorf   7', ReorderUnit3NumericPlacePrefix('7 Dorf  '));
end;

procedure TTestAHW52Unit3PlacePrefixReordering.TestOnlyTheFirstSpaceSeparatesTheParts;
begin
  AssertEquals('Alt Dorf 3', ReorderUnit3NumericPlacePrefix('3 Alt Dorf'));
end;

procedure TTestAHW52Unit3PlacePrefixReordering.TestNumericInputWithoutSpaceRetainsLegacyTrailingSpace;
begin
  AssertEquals('123 ', ReorderUnit3NumericPlacePrefix('123'));
end;

procedure TTestAHW52Unit3PlacePrefixReordering.TestLeadingWhitespacePreventsReordering;
begin
  AssertEquals(' 12 Neustadt',
    ReorderUnit3NumericPlacePrefix(' 12 Neustadt'));
end;

initialization
  RegisterTest(TTestAHW52Unit3PlacePrefixReordering);

end.
