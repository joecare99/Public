unit tst_AHW52_Unit3SourceTextNormalizerTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit3SourceTextNormalizer = class(TTestCase)
  published
    procedure TestTrimmedDoubleDotBecomesEmpty;
    procedure TestHKPrefixUsesFixedSlice;
    procedure TestSpecialVoRPatternUsesFixedPositions;
    procedure TestSpecialNaChPatternUsesFixedPositions;
    procedure TestStripsLeadingPeriodsAndSpacesWithLegacyLengthLimit;
    procedure TestRemovesPeriodsAndInsertsBeforeFirstLowByte;
    procedure TestDigitLeadingAndBlankValuesRemainUnchanged;
  end;

implementation

uses
  Unit3SourceTextNormalizer;

procedure TTestAHW52Unit3SourceTextNormalizer.TestTrimmedDoubleDotBecomesEmpty;
begin
  AssertEquals('', NormalizeUnit3SourceText('..'));
  AssertEquals('', NormalizeUnit3SourceText('  ..  '));
end;

procedure TTestAHW52Unit3SourceTextNormalizer.TestHKPrefixUsesFixedSlice;
begin
  AssertEquals('HK 1234567', NormalizeUnit3SourceText('HK 1234567 trailing'));
  AssertEquals('HK ', NormalizeUnit3SourceText('HKx'));
  AssertEquals('hk 123', NormalizeUnit3SourceText('hk123'));
end;

procedure TTestAHW52Unit3SourceTextNormalizer.TestSpecialVoRPatternUsesFixedPositions;
begin
  AssertEquals('xxo ABCD', NormalizeUnit3SourceText('xxvo.rABCD'));
  AssertEquals('ABv 3456', NormalizeUnit3SourceText('ABcvo.r123456'));
  AssertEquals('vor vo.r', NormalizeUnit3SourceText('vo.r'));
end;

procedure TTestAHW52Unit3SourceTextNormalizer.TestSpecialNaChPatternUsesFixedPositions;
begin
  AssertEquals('xxa. ABCD', NormalizeUnit3SourceText('xxna.chABCD'));
  AssertEquals('ABna 3456', NormalizeUnit3SourceText('ABxna.ch123456'));
  AssertEquals('nach a.ch', NormalizeUnit3SourceText('na.ch'));
end;

procedure TTestAHW52Unit3SourceTextNormalizer.
  TestStripsLeadingPeriodsAndSpacesWithLegacyLengthLimit;
begin
  AssertEquals('ABCDEFGH',
    NormalizeUnit3SourceText('. ABCDEFGHIJKLM'));
  AssertEquals('ABC', NormalizeUnit3SourceText('...ABC'));
end;

procedure TTestAHW52Unit3SourceTextNormalizer.
  TestRemovesPeriodsAndInsertsBeforeFirstLowByte;
begin
  AssertEquals('ABCDEF  12', NormalizeUnit3SourceText('ABC.DEF 12'));
  AssertEquals('ABCDEF', NormalizeUnit3SourceText('ABC.DEF'));
end;

procedure TTestAHW52Unit3SourceTextNormalizer.
  TestDigitLeadingAndBlankValuesRemainUnchanged;
begin
  AssertEquals('12.34 56', NormalizeUnit3SourceText('12.34 56'));
  AssertEquals('   ', NormalizeUnit3SourceText('   '));
end;

initialization
  RegisterTest(TTestAHW52Unit3SourceTextNormalizer);

end.
