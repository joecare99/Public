unit tst_AHW52_GraphicFormTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms;

type
  TTestAHW52GraphicForm = class(TTestCase)
  private
    FCloseEventCount: Integer;
    FParameterDialogCloseEventCount: Integer;
    FGraphicVisibleWhenParameterDialogCloses: Boolean;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure RecordParameterDialogClose(Sender: TObject;
      var CloseAction: TCloseAction);
  published
    procedure TestFinishButtonClosesGraphicForm;
    procedure TestPrinterSetupButtonExecutesDialog;
    procedure TestFormCloseClosesGlobalParametersThenHidesGlobalGraphic;
  end;

implementation

uses
  Classes, PrintersDlgs, SysUtils, Unit12, Unit13;

type
  TRecordingPrinterSetupDialog = class(TPrinterSetupDialog)
  private
    FExecuteCount: Integer;
  public
    function Execute: Boolean; override;
    property ExecuteCount: Integer read FExecuteCount;
  end;

function TRecordingPrinterSetupDialog.Execute: Boolean;
begin
  Inc(FExecuteCount);
  Result := True;
end;

procedure TTestAHW52GraphicForm.RecordFormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  CloseAction := caHide;
end;

procedure TTestAHW52GraphicForm.RecordParameterDialogClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  Inc(FParameterDialogCloseEventCount);
  FGraphicVisibleWhenParameterDialogCloses := Unit13.Form13.Visible;
  CloseAction := caHide;
end;

procedure TTestAHW52GraphicForm.TestFinishButtonClosesGraphicForm;
var
  graphicForm: TForm13;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  graphicForm := TForm13.CreateNew(nil);
  Unit13.Form13 := graphicForm;
  try
    graphicForm.OnClose := @RecordFormClose;
    graphicForm.SpeedButton2Click(graphicForm.SpeedButton2);

    if FCloseEventCount <> 1 then
      raise Exception.CreateFmt('Expected one close event, got %d.',
        [FCloseEventCount]);
  finally
    Unit13.Form13 := nil;
    graphicForm.Free;
  end;
end;

procedure TTestAHW52GraphicForm.
  TestFormCloseClosesGlobalParametersThenHidesGlobalGraphic;
var
  previousParameterDialog: TForm12;
  previousGraphicForm: TForm13;
  parameterDialog: TForm12;
  graphicForm: TForm13;
  eventReceiver: TForm13;
begin
  Application.Initialize;
  FParameterDialogCloseEventCount := 0;
  FGraphicVisibleWhenParameterDialogCloses := False;
  previousParameterDialog := Unit12.Form12;
  previousGraphicForm := Unit13.Form13;
  parameterDialog := TForm12.CreateNew(nil);
  graphicForm := nil;
  eventReceiver := nil;
  try
    graphicForm := TForm13.CreateNew(nil);
    eventReceiver := TForm13.CreateNew(nil);
    Unit12.Form12 := parameterDialog;
    Unit13.Form13 := graphicForm;
    parameterDialog.OnClose := @RecordParameterDialogClose;
    parameterDialog.AlphaBlend := True;
    parameterDialog.AlphaBlendValue := 0;
    parameterDialog.ShowInTaskBar := stNever;
    graphicForm.AlphaBlend := True;
    graphicForm.AlphaBlendValue := 0;
    graphicForm.ShowInTaskBar := stNever;
    eventReceiver.AlphaBlend := True;
    eventReceiver.AlphaBlendValue := 0;
    eventReceiver.ShowInTaskBar := stNever;

    graphicForm.Show;
    eventReceiver.Show;
    AssertTrue('The global graphic form should start visible.',
      graphicForm.Visible);
    AssertTrue('The event receiver should start visible.',
      eventReceiver.Visible);

    eventReceiver.FormClose(eventReceiver);

    AssertEquals('The parameter dialog closes exactly once.', 1,
      FParameterDialogCloseEventCount);
    AssertTrue('The global graphic remains visible while the parameter ' +
      'dialog closes.', FGraphicVisibleWhenParameterDialogCloses);
    AssertFalse('The global graphic form is hidden afterward.',
      graphicForm.Visible);
    AssertTrue('The non-global event receiver is not hidden.',
      eventReceiver.Visible);
  finally
    Unit12.Form12 := previousParameterDialog;
    Unit13.Form13 := previousGraphicForm;
    eventReceiver.Free;
    graphicForm.Free;
    parameterDialog.Free;
  end;
end;

procedure TTestAHW52GraphicForm.TestPrinterSetupButtonExecutesDialog;
var
  graphicForm: TForm13;
  printerSetupDialog: TRecordingPrinterSetupDialog;
begin
  Application.Initialize;
  graphicForm := TForm13.CreateNew(nil);
  try
    printerSetupDialog := TRecordingPrinterSetupDialog.Create(graphicForm);
    graphicForm.PrinterSetupDialog1 := printerSetupDialog;

    graphicForm.SpeedButton13Click(graphicForm);

    AssertEquals('Printer setup should be dispatched exactly once.', 1,
      printerSetupDialog.ExecuteCount);
  finally
    graphicForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52GraphicForm);

end.
