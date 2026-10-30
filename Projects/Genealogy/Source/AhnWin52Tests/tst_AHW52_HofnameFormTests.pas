unit tst_AHW52_HofnameFormTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52HofnameForm = class(TTestCase)
  private
    FCloseEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
  published
    procedure TestCancelButtonClosesForm;
    procedure TestActivationCopiesSharedHofnameIntoEdit;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Classes, StdCtrls, SysUtils, Unit40;

procedure TTestAHW52HofnameForm.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52HofnameForm.TestCancelButtonClosesForm;
var
  hofnameDialog: TForm40;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  hofnameDialog := TForm40.CreateNew(nil);
  Unit40.Form40 := hofnameDialog;
  try
    hofnameDialog.OnClose := @RecordFormClose;
    hofnameDialog.BitBtn1Click(hofnameDialog.BitBtn1);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit40.Form40 := nil;
    hofnameDialog.Free;
  end;
end;

procedure TTestAHW52HofnameForm.TestActivationCopiesSharedHofnameIntoEdit;
var
  hofnameDialog: TForm40;
begin
  Application.Initialize;
  hofnameDialog := TForm40.CreateNew(nil);
  try
    hofnameDialog.Edit1 := TEdit.Create(hofnameDialog);
    GlobalVar_025353CC := 'Synthetic hofname';
    hofnameDialog.FormActivate(hofnameDialog);

    if hofnameDialog.Edit1.Text <> 'Synthetic hofname' then
      raise Exception.CreateFmt('Expected the shared hofname in Edit1, got "%s".',
        [hofnameDialog.Edit1.Text]);
  finally
    GlobalVar_025353CC := '';
    hofnameDialog.Free;
  end;
end;

procedure TTestAHW52HofnameForm.TestUnboundCounterIncrement;
var
  hofnameDialog: TForm40;
begin
  hofnameDialog := TForm40.CreateNew(nil);
  try
    GlobalVar_025353C4 := 7;
    hofnameDialog._PROC_00575F20(hofnameDialog);
    AssertEquals('Increment callback should add one.', 8,
      GlobalVar_025353C4);
  finally
    GlobalVar_025353C4 := 0;
    hofnameDialog.Free;
  end;
end;

procedure TTestAHW52HofnameForm.TestUnboundCounterDecrement;
var
  hofnameDialog: TForm40;
begin
  hofnameDialog := TForm40.CreateNew(nil);
  try
    GlobalVar_025353C4 := 7;
    hofnameDialog._PROC_00575F50(hofnameDialog);
    AssertEquals('Decrement callback should subtract one.', 6,
      GlobalVar_025353C4);
  finally
    GlobalVar_025353C4 := 0;
    hofnameDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52HofnameForm);

end.
