unit tst_AHW52_BrowserFormTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52BrowserForm = class(TTestCase)
  private
    FCloseEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
  published
    procedure TestFinishButtonClosesBrowser;
    procedure TestActivationClearsAddressBasedState;
    procedure TestUnboundCounterIncrementAndZeroClear;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Classes, SysUtils, Unit11;

procedure TTestAHW52BrowserForm.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52BrowserForm.TestActivationClearsAddressBasedState;
var
  browserForm: TForm11;
begin
  Application.Initialize;
  browserForm := TForm11.CreateNew(nil);
  try
    GlobalVar_025358A8 := 5;
    browserForm.FormActivate(browserForm);

    if GlobalVar_025358A8 <> 0 then
      raise Exception.Create('Activation should clear the address-based state.');
  finally
    GlobalVar_025358A8 := 0;
    browserForm.Free;
  end;
end;

procedure TTestAHW52BrowserForm.TestFinishButtonClosesBrowser;
var
  browserForm: TForm11;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  browserForm := TForm11.CreateNew(nil);
  Unit11.Form11 := browserForm;
  try
    browserForm.OnClose := @RecordFormClose;
    browserForm.SpeedButton1Click(browserForm.SpeedButton1);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit11.Form11 := nil;
    browserForm.Free;
  end;
end;

procedure TTestAHW52BrowserForm.TestUnboundCounterIncrementAndZeroClear;
var
  browserForm: TForm11;
begin
  browserForm := TForm11.CreateNew(nil);
  try
    GlobalVar_025358C8 := 2;
    GlobalVar_025358AC := 'Preserve';
    browserForm._PROC_005CB585(browserForm);
    AssertEquals('Increment callback should add one.', 3,
      GlobalVar_025358C8);
    AssertEquals('Nonzero result should preserve the string.', 'Preserve',
      GlobalVar_025358AC);

    GlobalVar_025358C8 := -1;
    GlobalVar_025358AC := 'Clear at zero';
    browserForm._PROC_005CB585(browserForm);
    AssertEquals('Increment should reach zero.', 0, GlobalVar_025358C8);
    AssertEquals('Zero result should clear the string.', '',
      GlobalVar_025358AC);
  finally
    GlobalVar_025358C8 := 0;
    GlobalVar_025358AC := '';
    browserForm.Free;
  end;
end;

procedure TTestAHW52BrowserForm.TestUnboundCounterDecrement;
var
  browserForm: TForm11;
begin
  browserForm := TForm11.CreateNew(nil);
  try
    GlobalVar_025358C8 := 2;
    browserForm._PROC_005CB5C0(browserForm);
    AssertEquals('Decrement callback should subtract one.', 1,
      GlobalVar_025358C8);
  finally
    GlobalVar_025358C8 := 0;
    browserForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52BrowserForm);

end.
