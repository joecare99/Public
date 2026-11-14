unit tst_AHW52_HofnameListDoubleClickTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52HofnameListDoubleClick = class(TTestCase)
  private
    FShowEventCount: Integer;
    procedure MakeTestFormInvisible(form: TCustomForm);
    procedure RecordFormShow(Sender: TObject);
  published
    procedure TestDoubleClickCopiesNameAndShowsHofnameForm;
  end;

implementation

uses
  Classes, StdCtrls, SysUtils, Unit39, Unit40;

procedure TTestAHW52HofnameListDoubleClick.MakeTestFormInvisible(
  form: TCustomForm);
begin
  form.AlphaBlend := True;
  form.AlphaBlendValue := 0;
  form.ShowInTaskBar := stNever;
end;

procedure TTestAHW52HofnameListDoubleClick.RecordFormShow(Sender: TObject);
begin
  Inc(FShowEventCount);
end;

procedure TTestAHW52HofnameListDoubleClick.
  TestDoubleClickCopiesNameAndShowsHofnameForm;
var
  familyNameForm: TForm39;
  hofnameForm: TForm40;
begin
  Application.Initialize;
  familyNameForm := TForm39.CreateNew(nil);
  hofnameForm := TForm40.CreateNew(nil);
  Unit40.Form40 := hofnameForm;
  try
    familyNameForm.ListBox1 := TListBox.Create(familyNameForm);
    familyNameForm.ListBox1.Items.Add('First synthetic name');
    familyNameForm.ListBox1.Items.Add('Selected synthetic name');
    familyNameForm.ListBox1.ItemIndex := 1;

    hofnameForm.Label3 := TLabel.Create(hofnameForm);
    MakeTestFormInvisible(hofnameForm);
    hofnameForm.OnShow := @RecordFormShow;
    FShowEventCount := 0;
    GlobalVar_025353CC := 'Stale name';
    hofnameForm.Hide;

    familyNameForm.ListBox1DblClick(familyNameForm.ListBox1);

    AssertEquals('Selected name should replace the shared name.',
      'Selected synthetic name', GlobalVar_025353CC);
    AssertEquals('Caption should receive the original prefix and name.',
      'Aktueller Hofname:    Selected synthetic name',
      hofnameForm.Label3.Caption);
    AssertEquals('The edit form should be shown once.', 1, FShowEventCount);
    AssertTrue('The edit form should be visible.', hofnameForm.Visible);
  finally
    hofnameForm.Hide;
    Unit40.Form40 := nil;
    GlobalVar_025353CC := '';
    hofnameForm.Free;
    familyNameForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52HofnameListDoubleClick);

end.
