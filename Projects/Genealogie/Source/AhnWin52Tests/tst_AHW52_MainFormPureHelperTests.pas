unit tst_AHW52_MainFormPureHelperTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52MainFormPureHelper = class(TTestCase)
  published
    procedure DecimalPaddingReturnsTwentyFiveCharacters;
    procedure PictureOutputUsesBasenameAndReplacesLastThreeCharacters;
    procedure PictureOutputPreservesLegacyShortNameTruncation;
    procedure SourceTextNormalizerMatchesRecoveredHelper;
  end;

implementation

uses
  Forms, frmAhnenWinMain, Unit3SourceTextNormalizer;

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

procedure TTestAHW52MainFormPureHelper.PictureOutputUsesBasenameAndReplacesLastThreeCharacters;
var
  mainForm: TForm1;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    AssertEquals(
      'The helper should return only the input basename with its final three characters replaced.',
      'Family.jpg',
      mainForm.Proc_005FBFD8('C:\incoming\Family.BMP'));
    AssertEquals(
      'The helper should truncate three characters without validating the source extension.',
      'Family.jpg',
      mainForm.Proc_005FBFD8('C:\incoming\Family.TIF'));
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormPureHelper.PictureOutputPreservesLegacyShortNameTruncation;
var
  mainForm: TForm1;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    AssertEquals('jpg', mainForm.Proc_005FBFD8('ab'));
    AssertEquals('jpg', mainForm.Proc_005FBFD8(''));
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormPureHelper.SourceTextNormalizerMatchesRecoveredHelper;
const
  Inputs: array[0..10] of string = (
    '..',
    '  ..  ',
    'HK 1234567 trailing',
    'HKx',
    'xxvo.rABCD',
    'ABcvo.r123456',
    'xxna.chABCD',
    'ABxna.ch123456',
    '. ABCDEFGHIJKLM',
    'ABC.DEF 12',
    '   ');
var
  mainForm: TForm1;
  index: Integer;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    for index := Low(Inputs) to High(Inputs) do
      AssertEquals(
        'Legacy normalizer differs from the recovered helper for input "' +
          Inputs[index] + '".',
        NormalizeUnit3SourceText(Inputs[index]),
        mainForm.Proc_005D32CC(Inputs[index]));
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52MainFormPureHelper);

end.
