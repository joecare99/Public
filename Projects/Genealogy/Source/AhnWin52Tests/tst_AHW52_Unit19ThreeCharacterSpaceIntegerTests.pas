unit tst_AHW52_Unit19ThreeCharacterSpaceIntegerTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit19ThreeCharacterSpaceInteger = class(TTestCase)
  published
    procedure TestRightAlignsShortValues;
    procedure TestTruncatesValuesLongerThanThreeCharacters;
    procedure TestPreservesLegacyNegativeValuePlacement;
  end;

implementation

uses
  Unit19ThreeCharacterSpaceInteger;

procedure TTestAHW52Unit19ThreeCharacterSpaceInteger.TestRightAlignsShortValues;
begin
  AssertEquals('  0', FormatUnit19ThreeCharacterSpaceInteger(0));
  AssertEquals('  1', FormatUnit19ThreeCharacterSpaceInteger(1));
  AssertEquals(' 12', FormatUnit19ThreeCharacterSpaceInteger(12));
  AssertEquals('123', FormatUnit19ThreeCharacterSpaceInteger(123));
end;

procedure TTestAHW52Unit19ThreeCharacterSpaceInteger.TestTruncatesValuesLongerThanThreeCharacters;
begin
  AssertEquals('234', FormatUnit19ThreeCharacterSpaceInteger(1234));
end;

procedure TTestAHW52Unit19ThreeCharacterSpaceInteger.TestPreservesLegacyNegativeValuePlacement;
begin
  AssertEquals(' -1', FormatUnit19ThreeCharacterSpaceInteger(-1));
  AssertEquals('123', FormatUnit19ThreeCharacterSpaceInteger(-123));
end;

initialization
  RegisterTest(TTestAHW52Unit19ThreeCharacterSpaceInteger);

end.
