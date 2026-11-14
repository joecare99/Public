unit tst_AHW52_GregorianCalendarCounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52GregorianCalendarCounters = class(TTestCase)
  published
    procedure TestIncrement;
    procedure TestDecrement;
  end;

implementation

uses
  Forms, GregorianCalendar;

procedure TTestAHW52GregorianCalendarCounters.TestIncrement;
var
  calendarForm: TGregorianCalendarForm;
begin
  calendarForm := TGregorianCalendarForm.CreateNew(nil);
  try
    GlobalVar_025358EC := 41;
    calendarForm._PROC_005CE618(calendarForm);
    AssertEquals(42, GlobalVar_025358EC);
  finally
    GlobalVar_025358EC := 0;
    calendarForm.Free;
  end;
end;

procedure TTestAHW52GregorianCalendarCounters.TestDecrement;
var
  calendarForm: TGregorianCalendarForm;
begin
  calendarForm := TGregorianCalendarForm.CreateNew(nil);
  try
    GlobalVar_025358EC := 41;
    calendarForm._PROC_005CE648(calendarForm);
    AssertEquals(40, GlobalVar_025358EC);
  finally
    GlobalVar_025358EC := 0;
    calendarForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52GregorianCalendarCounters);

end.
