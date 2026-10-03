unit tst_AHW52_SourceDialogCancelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52SourceDialog = class(TTestCase)
  private
    FCloseEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
  published
    procedure TestCancelButtonClosesForm;
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

initialization
  RegisterTest(TTestAHW52SourceDialog);

end.
