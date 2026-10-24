unit tst_AHW52_Unit3SixCharacterSpaceIntegerTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit3SixCharacterSpaceInteger = class(TTestCase)
  published
    procedure TestRightAlignsShortValues;
    procedure TestKeepsSixDigitBoundaryAndTruncatesLongerValues;
    procedure TestPreservesLegacyNegativeValuePlacement;
  end;

implementation

uses
  Unit3SixCharacterSpaceInteger;

procedure TTestAHW52Unit3SixCharacterSpaceInteger.TestRightAlignsShortValues;
begin
  AssertEquals('     0', FormatUnit3SixCharacterSpaceInteger(0));
  AssertEquals('     1', FormatUnit3SixCharacterSpaceInteger(1));
  AssertEquals('   123', FormatUnit3SixCharacterSpaceInteger(123));
end;

procedure TTestAHW52Unit3SixCharacterSpaceInteger.TestKeepsSixDigitBoundaryAndTruncatesLongerValues;
begin
  AssertEquals('123456', FormatUnit3SixCharacterSpaceInteger(123456));
  AssertEquals('234567', FormatUnit3SixCharacterSpaceInteger(1234567));
end;

procedure TTestAHW52Unit3SixCharacterSpaceInteger.TestPreservesLegacyNegativeValuePlacement;
begin
  AssertEquals('    -1', FormatUnit3SixCharacterSpaceInteger(-1));
  AssertEquals('-12345', FormatUnit3SixCharacterSpaceInteger(-12345));
end;

initialization
  RegisterTest(TTestAHW52Unit3SixCharacterSpaceInteger);

end.
