unit tst_AHW52_Unit18StringNormalizerTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit18StringNormalizer = class(TTestCase)
  published
    procedure TestDoubleDotMarkerClearsOutput;
    procedure TestHKPrefixFormatting;
    procedure TestVorRecordFormatting;
    procedure TestNachRecordFormatting;
    procedure TestLeadingSeparatorsAndDotRemoval;
    procedure TestNumericPrefixPreservesInput;
    procedure TestWhitespaceInputRemainsUnchanged;
    procedure TestPeriodOnlyInputProducesEmptyOutput;
  end;

implementation

uses
  Unit18;

procedure TTestAHW52Unit18StringNormalizer.TestDoubleDotMarkerClearsOutput;
var
  outputText: AnsiString;
begin
  outputText := 'Previous value';
  Proc_00545A0C('  ..  ', outputText);
  AssertEquals('', outputText);
end;

procedure TTestAHW52Unit18StringNormalizer.TestHKPrefixFormatting;
var
  outputText: AnsiString;
begin
  outputText := '';
  Proc_00545A0C('HK_1234567', outputText);
  AssertEquals('HK 1234567', outputText);
end;

procedure TTestAHW52Unit18StringNormalizer.TestVorRecordFormatting;
var
  outputText: AnsiString;
begin
  outputText := '';
  Proc_00545A0C('XXvo.r123456', outputText);
  AssertEquals('XXo 3456', outputText);
end;

procedure TTestAHW52Unit18StringNormalizer.TestNachRecordFormatting;
var
  outputText: AnsiString;
begin
  outputText := '';
  Proc_00545A0C('XXna.ch123456', outputText);
  AssertEquals('XXa. 3456', outputText);
end;

procedure TTestAHW52Unit18StringNormalizer.TestLeadingSeparatorsAndDotRemoval;
var
  outputText: AnsiString;
begin
  outputText := '';
  Proc_00545A0C(' .A.123', outputText);
  AssertEquals('A 123', outputText);
end;

procedure TTestAHW52Unit18StringNormalizer.TestNumericPrefixPreservesInput;
var
  outputText: AnsiString;
begin
  outputText := '';
  Proc_00545A0C('123. Main', outputText);
  AssertEquals('123. Main', outputText);
end;

procedure TTestAHW52Unit18StringNormalizer.TestWhitespaceInputRemainsUnchanged;
var
  outputText: AnsiString;
begin
  outputText := '';
  Proc_00545A0C('  ', outputText);
  AssertEquals('  ', outputText);
end;

procedure TTestAHW52Unit18StringNormalizer.TestPeriodOnlyInputProducesEmptyOutput;
var
  outputText: AnsiString;
begin
  outputText := 'Previous value';
  Proc_00545A0C('.', outputText);
  AssertEquals('', outputText);
end;

initialization
  RegisterTest(TTestAHW52Unit18StringNormalizer);

end.
