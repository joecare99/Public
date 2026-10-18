unit tst_AHW52_ProfessionDialogFinishTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52ProfessionDialogFinish = class(TTestCase)
  published
    procedure TestFinishResetsSelectionAndClosesDialog;
  end;

implementation

uses
  Controls, Forms, StdCtrls, Unit36;

procedure TTestAHW52ProfessionDialogFinish.
  TestFinishResetsSelectionAndClosesDialog;
var
  professionDialog: TForm36;
begin
  professionDialog := TForm36.CreateNew(nil);
  Form36 := professionDialog;
  try
    professionDialog.ListBox1 := TListBox.Create(professionDialog);
    professionDialog.ListBox1.Items.Add('First synthetic profession');
    professionDialog.ListBox1.Items.Add('Second synthetic profession');
    professionDialog.ListBox1.ItemIndex := 1;
    GlobalVar_025353B8 := 1;

    professionDialog.BitBtn1Click(nil);

    AssertEquals('Selection state should be reset.', 0,
      GlobalVar_025353B8);
    AssertEquals('List should return to its first item.', 0,
      professionDialog.ListBox1.ItemIndex);
    AssertEquals('Finish should set the cancel modal result.', mrCancel,
      professionDialog.ModalResult);
  finally
    Form36 := nil;
    GlobalVar_025353B8 := 0;
    professionDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52ProfessionDialogFinish);

end.
