unit tst_AHW52_Unit3MonthAbbreviationTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit3MonthAbbreviation = class(TTestCase)
  published
    procedure TestLegacyMonthTokens;
    procedure TestUnknownTokenUsesTrimmedFirstTwoCharacters;
    procedure TestMatchingIsCaseSensitiveAndDoesNotTrimFirst;
  end;

implementation

uses
  Unit3MonthAbbreviation;

procedure TTestAHW52Unit3MonthAbbreviation.TestLegacyMonthTokens;
begin
  AssertEquals('01', NormalizeUnit3MonthAbbreviation('JAN'));
  AssertEquals('02', NormalizeUnit3MonthAbbreviation('FEB'));
  AssertEquals('03', NormalizeUnit3MonthAbbreviation('MAR'));
  AssertEquals('03', NormalizeUnit3MonthAbbreviation('M'#$C4'R'));
  AssertEquals('04', NormalizeUnit3MonthAbbreviation('APR'));
  AssertEquals('05', NormalizeUnit3MonthAbbreviation('MAY'));
  AssertEquals('05', NormalizeUnit3MonthAbbreviation('MAI'));
  AssertEquals('06', NormalizeUnit3MonthAbbreviation('JUN'));
  AssertEquals('07', NormalizeUnit3MonthAbbreviation('JUL'));
  AssertEquals('08', NormalizeUnit3MonthAbbreviation('AUG'));
  AssertEquals('09', NormalizeUnit3MonthAbbreviation('SEP'));
  AssertEquals('10', NormalizeUnit3MonthAbbreviation('OCT'));
  AssertEquals('10', NormalizeUnit3MonthAbbreviation('OKT'));
  AssertEquals('11', NormalizeUnit3MonthAbbreviation('NOV'));
  AssertEquals('12', NormalizeUnit3MonthAbbreviation('DEC'));
  AssertEquals('12', NormalizeUnit3MonthAbbreviation('DEZ'));
end;

procedure TTestAHW52Unit3MonthAbbreviation.TestUnknownTokenUsesTrimmedFirstTwoCharacters;
begin
  AssertEquals('XY', NormalizeUnit3MonthAbbreviation('  XYZ  '));
  AssertEquals('X', NormalizeUnit3MonthAbbreviation(' X '));
  AssertEquals('', NormalizeUnit3MonthAbbreviation('   '));
  AssertEquals('AN', NormalizeUnit3MonthAbbreviation('AN'));
end;

procedure TTestAHW52Unit3MonthAbbreviation.TestMatchingIsCaseSensitiveAndDoesNotTrimFirst;
begin
  AssertEquals('01', NormalizeUnit3MonthAbbreviation('JA'));
  AssertEquals('ja', NormalizeUnit3MonthAbbreviation('jan'));
  AssertEquals('JA', NormalizeUnit3MonthAbbreviation(' JAN'));
  AssertEquals('JA', NormalizeUnit3MonthAbbreviation('JAN '));
end;

initialization
  RegisterTest(TTestAHW52Unit3MonthAbbreviation);

end.
