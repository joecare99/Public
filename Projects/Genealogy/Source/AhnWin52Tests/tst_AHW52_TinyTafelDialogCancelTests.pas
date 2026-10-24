unit tst_AHW52_TinyTafelDialogCancelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52TinyTafelDialog = class(TTestCase)
  private
    FCloseEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
  published
    procedure TestCancelButtonClosesDialog;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Classes, SysUtils, Unit22;

procedure TTestAHW52TinyTafelDialog.TestUnboundCounterIncrement;
var
  tinyTafelDialog: TOKBottomDlg;
begin
  tinyTafelDialog := TOKBottomDlg.CreateNew(nil);
  try
    GlobalVar_0061DFF8 := 3;
    tinyTafelDialog._PROC_0054F575(tinyTafelDialog);
    AssertEquals('Increment callback should add one.', 4,
      GlobalVar_0061DFF8);
  finally
    GlobalVar_0061DFF8 := 0;
    tinyTafelDialog.Free;
  end;
end;

procedure TTestAHW52TinyTafelDialog.TestUnboundCounterDecrement;
var
  tinyTafelDialog: TOKBottomDlg;
begin
  tinyTafelDialog := TOKBottomDlg.CreateNew(nil);
  try
    GlobalVar_0061DFF8 := 3;
    tinyTafelDialog._PROC_0054F5A4(tinyTafelDialog);
    AssertEquals('Decrement callback should subtract one.', 2,
      GlobalVar_0061DFF8);
  finally
    GlobalVar_0061DFF8 := 0;
    tinyTafelDialog.Free;
  end;
end;

procedure TTestAHW52TinyTafelDialog.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52TinyTafelDialog.TestCancelButtonClosesDialog;
var
  tinyTafelDialog: TOKBottomDlg;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  tinyTafelDialog := TOKBottomDlg.CreateNew(nil);
  Unit22.OKBottomDlg := tinyTafelDialog;
  try
    tinyTafelDialog.OnClose := @RecordFormClose;
    tinyTafelDialog.SpeedButton2Click(tinyTafelDialog.SpeedButton2);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit22.OKBottomDlg := nil;
    tinyTafelDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52TinyTafelDialog);

end.
