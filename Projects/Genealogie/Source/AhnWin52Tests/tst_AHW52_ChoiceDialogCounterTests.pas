unit tst_AHW52_ChoiceDialogCounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52ChoiceDialogCounters = class(TTestCase)
  published
    procedure TestIncrement;
    procedure TestDecrement;
  end;

implementation

uses
  Forms, SysUtils, Unit31;

procedure TTestAHW52ChoiceDialogCounters.TestIncrement;
var
  choiceDialog: TForm31;
begin
  choiceDialog := TForm31.CreateNew(nil);
  try
    GlobalVar_0061E108 := 4;
    choiceDialog._PROC_00563108(choiceDialog);
    AssertEquals(5, GlobalVar_0061E108);
  finally
    GlobalVar_0061E108 := 0;
    choiceDialog.Free;
  end;
end;

procedure TTestAHW52ChoiceDialogCounters.TestDecrement;
var
  choiceDialog: TForm31;
begin
  choiceDialog := TForm31.CreateNew(nil);
  try
    GlobalVar_0061E108 := 4;
    choiceDialog._PROC_00563138(choiceDialog);
    AssertEquals(3, GlobalVar_0061E108);
  finally
    GlobalVar_0061E108 := 0;
    choiceDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52ChoiceDialogCounters);

end.
