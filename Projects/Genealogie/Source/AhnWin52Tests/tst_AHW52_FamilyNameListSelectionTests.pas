unit tst_AHW52_FamilyNameListSelectionTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52FamilyNameListSelection = class(TTestCase)
  published
    procedure TestListClickCopiesSelectedAndUnselectedIndices;
  end;

implementation

uses
  Forms, StdCtrls, SysUtils, Unit39;

procedure TTestAHW52FamilyNameListSelection.
  TestListClickCopiesSelectedAndUnselectedIndices;
var
  familyNameForm: TForm39;
begin
  Application.Initialize;
  familyNameForm := TForm39.CreateNew(nil);
  try
    familyNameForm.ListBox1 := TListBox.Create(familyNameForm);
    familyNameForm.ListBox1.Items.Add('First synthetic family name');
    familyNameForm.ListBox1.Items.Add('Second synthetic family name');
    familyNameForm.ListBox1.ItemIndex := 1;
    GlobalVar_025353D0 := -99;
    familyNameForm.ListBox1Click(familyNameForm.ListBox1);

    if GlobalVar_025353D0 <> 1 then
      raise Exception.CreateFmt('Expected selected index 1, got %d.',
        [GlobalVar_025353D0]);

    familyNameForm.ListBox1.ItemIndex := -1;
    familyNameForm.ListBox1Click(familyNameForm.ListBox1);
    if GlobalVar_025353D0 <> -1 then
      raise Exception.CreateFmt('Expected no-selection index -1, got %d.',
        [GlobalVar_025353D0]);
  finally
    GlobalVar_025353D0 := 0;
    familyNameForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52FamilyNameListSelection);

end.
