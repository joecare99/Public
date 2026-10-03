unit tst_AHW52_MainFormPureHelperTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52MainFormPureHelper = class(TTestCase)
  published
    procedure DecimalPaddingReturnsTwentyFiveCharacters;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52MainFormPureHelper.DecimalPaddingReturnsTwentyFiveCharacters;
var
  mainForm: TForm1;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    AssertEquals(
      'The helper should right-align a short formatted value in a 25-character field.',
      StringOfChar(' ', 23) + '42',
      mainForm.Proc_005D3AB8(42.0));
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52MainFormPureHelper);

end.
