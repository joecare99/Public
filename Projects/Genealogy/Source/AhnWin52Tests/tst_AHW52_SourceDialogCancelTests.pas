unit tst_AHW52_SourceDialogCancelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52SourceDialog = class(TTestCase)
  private
    FCloseEventCount: Integer;
    FReceiverCloseEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure RecordReceiverClose(Sender: TObject;
      var CloseAction: TCloseAction);
  published
    procedure TestCancelButtonClosesForm;
    procedure TestCancelButtonClosesGlobalFormInsteadOfReceiver;
  end;

implementation

uses
  Classes, SysUtils, Unit30;

procedure TTestAHW52SourceDialog.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52SourceDialog.RecordReceiverClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FReceiverCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52SourceDialog.TestCancelButtonClosesForm;
var
  sourceDialog: TForm30;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  sourceDialog := TForm30.CreateNew(nil);
  Unit30.Form30 := sourceDialog;
  try
    sourceDialog.OnClose := @RecordFormClose;
    sourceDialog.BitBtn1Click(sourceDialog.BitBtn1);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit30.Form30 := nil;
    sourceDialog.Free;
  end;
end;

procedure TTestAHW52SourceDialog.
  TestCancelButtonClosesGlobalFormInsteadOfReceiver;
var
  sourceDialog: TForm30;
  eventReceiver: TForm30;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  FReceiverCloseEventCount := 0;
  sourceDialog := TForm30.CreateNew(nil);
  eventReceiver := TForm30.CreateNew(nil);
  Unit30.Form30 := sourceDialog;
  try
    sourceDialog.OnClose := @RecordFormClose;
    eventReceiver.OnClose := @RecordReceiverClose;
    eventReceiver.BitBtn1Click(eventReceiver.BitBtn1);

    AssertEquals('The global Form30 should receive the close request.', 1,
      FCloseEventCount);
    AssertEquals('The event receiver should remain open.', 0,
      FReceiverCloseEventCount);
  finally
    Unit30.Form30 := nil;
    eventReceiver.Free;
    sourceDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52SourceDialog);

end.
