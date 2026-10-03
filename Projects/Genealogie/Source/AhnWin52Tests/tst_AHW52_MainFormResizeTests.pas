unit tst_AHW52_MainFormResizeTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52MainFormResize = class(TTestCase)
  published
    procedure TestResizeStoresCurrentHeightAfterScaling;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52MainFormResize.TestResizeStoresCurrentHeightAfterScaling;
var
  mainForm: TForm1;
  previousGlobalForm: TForm1;
  previousHeight: LongInt;
begin
  Application.Initialize;
  previousGlobalForm := Form1;
  previousHeight := GlobalVar_02535BA4;
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.Height := 500;
    Form1 := mainForm;
    GlobalVar_02535BA4 := 400;

    mainForm.FormResize(nil);

    AssertEquals('Resize stores the current global form height.', 500,
      GlobalVar_02535BA4);
  finally
    Form1 := previousGlobalForm;
    GlobalVar_02535BA4 := previousHeight;
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52MainFormResize);

end.
