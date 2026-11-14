unit tst_AHW52_Unit3SixCharacterIntegerTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit3SixCharacterInteger = class(TTestCase)
  published
    procedure TestPadsNonnegativeValuesToSixCharacters;
    procedure TestKeepsTheLastSixCharactersForLongValues;
    procedure TestPreservesLegacyNegativeValuePlacement;
    procedure TestHandlesMinimumInteger;
  end;

implementation

uses
  Unit3SixCharacterInteger;

procedure TTestAHW52Unit3SixCharacterInteger.TestPadsNonnegativeValuesToSixCharacters;
begin
  AssertEquals('000000', FormatUnit3SixCharacterInteger(0));
  AssertEquals('000001', FormatUnit3SixCharacterInteger(1));
  AssertEquals('012345', FormatUnit3SixCharacterInteger(12345));
  AssertEquals('123456', FormatUnit3SixCharacterInteger(123456));
end;

procedure TTestAHW52Unit3SixCharacterInteger.TestKeepsTheLastSixCharactersForLongValues;
begin
  AssertEquals('234567', FormatUnit3SixCharacterInteger(1234567));
  AssertEquals('483647', FormatUnit3SixCharacterInteger(2147483647));
end;

procedure TTestAHW52Unit3SixCharacterInteger.TestPreservesLegacyNegativeValuePlacement;
begin
  AssertEquals('0000-1', FormatUnit3SixCharacterInteger(-1));
  AssertEquals('0-1234', FormatUnit3SixCharacterInteger(-1234));
  AssertEquals('-12345', FormatUnit3SixCharacterInteger(-12345));
end;

procedure TTestAHW52Unit3SixCharacterInteger.TestHandlesMinimumInteger;
begin
  AssertEquals('483648', FormatUnit3SixCharacterInteger(-2147483648));
end;

initialization
  RegisterTest(TTestAHW52Unit3SixCharacterInteger);

end.
