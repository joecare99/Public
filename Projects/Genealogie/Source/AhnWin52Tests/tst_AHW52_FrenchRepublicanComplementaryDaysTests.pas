unit tst_AHW52_FrenchRepublicanComplementaryDaysTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52FrenchRepublicanComplementaryDays = class(TTestCase)
  published
    procedure TestRegularDayIsNotComplementary;
    procedure TestComplementaryDaysRequireFructidorAndLeapYearIndex;
    procedure TestJrevIsAcceptedOnlyAtLeapFructidor;
    procedure TestTextBeyondJrevIsNotClassifiedAsComplementary;
  end;

implementation

uses
  SysUtils, FrenchRepublicanComplementaryDays;

procedure TTestAHW52FrenchRepublicanComplementaryDays.
  TestRegularDayIsNotComplementary;
begin
  AssertEquals(Ord(frcdNotComplementary),
    Ord(ClassifyFrenchRepublicanComplementaryDay('30', 'Fructidor', 2)));
end;

procedure TTestAHW52FrenchRepublicanComplementaryDays.
  TestComplementaryDaysRequireFructidorAndLeapYearIndex;
const
  LeapYearIndexes: array[0..2] of Integer = (2, 6, 10);
var
  index: Integer;
begin
  for index := Low(LeapYearIndexes) to High(LeapYearIndexes) do
    AssertEquals('Fructidor complementary days are accepted at index ' +
      IntToStr(LeapYearIndexes[index]), Ord(frcdValid),
      Ord(ClassifyFrenchRepublicanComplementaryDay('jc 1',
        ' Fructidor ', LeapYearIndexes[index])));

  AssertEquals('A different month rejects the complementary day.',
    Ord(frcdInvalid),
    Ord(ClassifyFrenchRepublicanComplementaryDay('jc 1', 'Vendemiaire', 2)));
  AssertEquals('A non-leap republican year rejects the complementary day.',
    Ord(frcdInvalid),
    Ord(ClassifyFrenchRepublicanComplementaryDay('jc 1', 'Fructidor', 3)));
end;

procedure TTestAHW52FrenchRepublicanComplementaryDays.
  TestJrevIsAcceptedOnlyAtLeapFructidor;
begin
  AssertEquals(Ord(frcdValid),
    Ord(ClassifyFrenchRepublicanComplementaryDay('jrev', 'Fructidor', 6)));
  AssertEquals(Ord(frcdInvalid),
    Ord(ClassifyFrenchRepublicanComplementaryDay('jrev', 'Fructidor', 7)));
  AssertEquals(Ord(frcdInvalid),
    Ord(ClassifyFrenchRepublicanComplementaryDay('jrev', 'Nivose', 6)));
end;

procedure TTestAHW52FrenchRepublicanComplementaryDays.
  TestTextBeyondJrevIsNotClassifiedAsComplementary;
begin
  AssertEquals(Ord(frcdNotComplementary),
    Ord(ClassifyFrenchRepublicanComplementaryDay('jzz', 'Fructidor', 2)));
end;

initialization
  RegisterTest(TTestAHW52FrenchRepublicanComplementaryDays);

end.
