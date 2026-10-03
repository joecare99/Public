unit tst_AHW52_FokoDialogCounterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52FokoDialogCounters = class(TTestCase)
  published
    procedure TestIncrement;
    procedure TestDecrement;
  end;

implementation

uses
  Forms, Unit21;

procedure TTestAHW52FokoDialogCounters.TestIncrement;
var
  fokoDialog: TForm21;
begin
  fokoDialog := TForm21.CreateNew(nil);
  try
    GlobalVar_025358D8 := 6;
    fokoDialog._PROC_005CC40D(fokoDialog);
    AssertEquals(7, GlobalVar_025358D8);
  finally
    GlobalVar_025358D8 := 0;
    fokoDialog.Free;
  end;
end;

procedure TTestAHW52FokoDialogCounters.TestDecrement;
var
  fokoDialog: TForm21;
begin
  fokoDialog := TForm21.CreateNew(nil);
  try
    GlobalVar_025358D8 := 6;
    fokoDialog._PROC_005CC43C(fokoDialog);
    AssertEquals(5, GlobalVar_025358D8);
  finally
    GlobalVar_025358D8 := 0;
    fokoDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52FokoDialogCounters);

end.
