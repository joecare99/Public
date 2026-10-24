unit tst_AHW52_Unit1ByteUppercaseTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit1ByteUppercase = class(TTestCase)
  published
    procedure TestSpecialBytesMapToUppercaseBytes;
    procedure TestMixedStringPreservesByteOrder;
    procedure TestFallbackUppercasesAsciiByteByByte;
    procedure TestEmptyInputRemainsEmpty;
  end;

implementation

uses
  Unit1ByteUppercase;

procedure TTestAHW52Unit1ByteUppercase.TestSpecialBytesMapToUppercaseBytes;
var
  resultValue: AnsiString;
begin
  resultValue := UpperCaseUnit1Bytes(AnsiString(#$E4));
  AssertEquals(1, Length(resultValue));
  AssertEquals($C4, Ord(resultValue[1]));

  resultValue := UpperCaseUnit1Bytes(AnsiString(#$F6));
  AssertEquals(1, Length(resultValue));
  AssertEquals($D6, Ord(resultValue[1]));

  resultValue := UpperCaseUnit1Bytes(AnsiString(#$FC));
  AssertEquals(1, Length(resultValue));
  AssertEquals($DC, Ord(resultValue[1]));
end;

procedure TTestAHW52Unit1ByteUppercase.TestMixedStringPreservesByteOrder;
var
  inputValue: AnsiString;
  resultValue: AnsiString;
begin
  inputValue := 'a' + AnsiChar($E4) + '-' + AnsiChar($F6) +
    'z' + AnsiChar($FC);
  resultValue := UpperCaseUnit1Bytes(inputValue);

  AssertEquals(6, Length(resultValue));
  AssertEquals(Ord('A'), Ord(resultValue[1]));
  AssertEquals($C4, Ord(resultValue[2]));
  AssertEquals(Ord('-'), Ord(resultValue[3]));
  AssertEquals($D6, Ord(resultValue[4]));
  AssertEquals(Ord('Z'), Ord(resultValue[5]));
  AssertEquals($DC, Ord(resultValue[6]));
end;

procedure TTestAHW52Unit1ByteUppercase.TestFallbackUppercasesAsciiByteByByte;
var
  resultValue: AnsiString;
begin
  resultValue := UpperCaseUnit1Bytes('a9.z');
  AssertEquals('A9.Z', string(resultValue));
end;

procedure TTestAHW52Unit1ByteUppercase.TestEmptyInputRemainsEmpty;
begin
  AssertEquals(0, Length(UpperCaseUnit1Bytes('')));
end;

initialization
  RegisterTest(TTestAHW52Unit1ByteUppercase);

end.
