unit tst_AHW52_Unit1DateDifferenceCoreTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit1DateDifferenceCore = class(TTestCase)
  published
    procedure TestSameDateProducesEmptyText;
    procedure TestWithinMonthFormatsDays;
    procedure TestBorrowsDaysAcrossMonthBoundary;
    procedure TestBorrowsDaysAcrossLeapFebruary;
    procedure TestBorrowsMonthsAcrossYearBoundary;
    procedure TestYearsOnlySuppressesMonthsAndDays;
    procedure TestNegativeDifferencesAreNotEmitted;
  end;

implementation

uses
  Unit1DateDifferenceCore;

procedure TTestAHW52Unit1DateDifferenceCore.TestSameDateProducesEmptyText;
begin
  AssertEquals('', BuildUnit1ValidatedDateDifferenceText(12, 3, 2020, 12, 3, 2020,
    False));
end;

procedure TTestAHW52Unit1DateDifferenceCore.TestWithinMonthFormatsDays;
begin
  AssertEquals('5 T', BuildUnit1ValidatedDateDifferenceText(4, 3, 2020, 9, 3, 2020,
    False));
end;

procedure TTestAHW52Unit1DateDifferenceCore.TestBorrowsDaysAcrossMonthBoundary;
begin
  AssertEquals('1 T', BuildUnit1ValidatedDateDifferenceText(31, 1, 2021, 1, 2, 2021,
    False));
end;

procedure TTestAHW52Unit1DateDifferenceCore.TestBorrowsDaysAcrossLeapFebruary;
begin
  AssertEquals('2 T', BuildUnit1ValidatedDateDifferenceText(28, 2, 2020, 1, 3, 2020,
    False));
end;

procedure TTestAHW52Unit1DateDifferenceCore.TestBorrowsMonthsAcrossYearBoundary;
begin
  AssertEquals('1 J 3 T', BuildUnit1ValidatedDateDifferenceText(30, 12, 2019, 2, 1,
    2021, False));
end;

procedure TTestAHW52Unit1DateDifferenceCore.TestYearsOnlySuppressesMonthsAndDays;
begin
  AssertEquals('1 J ', BuildUnit1ValidatedDateDifferenceText(31, 12, 2018, 1, 1, 2020,
    True));
end;

procedure TTestAHW52Unit1DateDifferenceCore.TestNegativeDifferencesAreNotEmitted;
begin
  AssertEquals('', BuildUnit1ValidatedDateDifferenceText(12, 3, 2021, 12, 3, 2020,
    False));
end;

initialization
  RegisterTest(TTestAHW52Unit1DateDifferenceCore);

end.
