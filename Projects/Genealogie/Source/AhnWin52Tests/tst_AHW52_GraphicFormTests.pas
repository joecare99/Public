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
    FPaintEventCount: Integer;
    procedure RecordFormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure RecordParameterDialogClose(Sender: TObject;
      var CloseAction: TCloseAction);
    procedure RecordPaint(Sender: TObject);
  published
    procedure TestFormCreateInitializesPaintBoxAndAddressBackedState;
    procedure TestScrollbarChangesRefreshPaintBox;
    procedure TestGraphicButtonsUpdateAddressBackedState;
    procedure TestPenWidthButtonsRespectBounds;
    procedure TestScaleButtonsRespectThresholdAndStep;
    procedure TestUnboundUpDownCallbackAdjustsScale;
    procedure TestFinishButtonClosesGraphicForm;
    procedure TestPrinterSetupButtonExecutesDialog;
    procedure TestFormCloseClosesGlobalParametersThenHidesGlobalGraphic;
  end;

implementation

uses
  Buttons, Classes, ExtCtrls, PrintersDlgs, SysUtils, Unit12, Unit13;

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

procedure TTestAHW52GraphicForm.RecordPaint(Sender: TObject);
begin
  Inc(FPaintEventCount);
end;

procedure TTestAHW52GraphicForm.TestScaleButtonsRespectThresholdAndStep;
var
  graphicForm: TForm13;
  previousGlobalVar_0061E120: Extended;
begin
  Application.Initialize;
  previousGlobalVar_0061E120 := Unit13.GlobalVar_0061E120;
  FPaintEventCount := 0;
  graphicForm := TForm13.CreateNew(nil);
  try
    graphicForm.PaintBox1 := TPaintBox.Create(graphicForm);
    graphicForm.PaintBox1.Parent := graphicForm;
    graphicForm.PaintBox1.SetBounds(0, 0, 100, 100);
    graphicForm.PaintBox1.OnPaint := @RecordPaint;
    graphicForm.Show;
    Application.ProcessMessages;

    Unit13.GlobalVar_0061E120 := 0.4;
    FPaintEventCount := 0;
    graphicForm.Button5Click(nil);
    AssertTrue('A value below the threshold remains unchanged.',
      Abs(Unit13.GlobalVar_0061E120 - 0.4) < 1e-12);
    AssertEquals('A value below the threshold does not repaint.', 0,
      FPaintEventCount);

    Unit13.GlobalVar_0061E120 := 0.5;
    FPaintEventCount := 0;
    graphicForm.Button5Click(nil);
    AssertTrue('The exact threshold remains unchanged.',
      Abs(Unit13.GlobalVar_0061E120 - 0.5) < 1e-12);
    AssertEquals('The exact threshold does not repaint.', 0,
      FPaintEventCount);

    Unit13.GlobalVar_0061E120 := 0.63;
    FPaintEventCount := 0;
    graphicForm.Button5Click(nil);
    AssertTrue('A value above the threshold decreases by 0.13.',
      Abs(Unit13.GlobalVar_0061E120 - 0.5) < 1e-12);
    AssertTrue('The decrement requests a repaint.', FPaintEventCount > 0);

    Unit13.GlobalVar_0061E120 := 0.5;
    FPaintEventCount := 0;
    graphicForm.Button6Click(nil);
    AssertTrue('The increment button adds 0.13.',
      Abs(Unit13.GlobalVar_0061E120 - 0.63) < 1e-12);
    AssertTrue('The increment requests a repaint.', FPaintEventCount > 0);
  finally
    Unit13.GlobalVar_0061E120 := previousGlobalVar_0061E120;
    graphicForm.Free;
  end;
end;

procedure TTestAHW52GraphicForm.TestUnboundUpDownCallbackAdjustsScale;
var
  graphicForm: TForm13;
  previousGlobalVar_0061E120: Extended;
begin
  Application.Initialize;
  previousGlobalVar_0061E120 := Unit13.GlobalVar_0061E120;
  graphicForm := TForm13.CreateNew(nil);
  try
    Unit13.GlobalVar_0061E120 := 0.4;
    graphicForm.UpDown1Click(nil);
    AssertTrue('A value below the threshold remains unchanged.',
      Abs(Unit13.GlobalVar_0061E120 - 0.4) < 1e-12);

    Unit13.GlobalVar_0061E120 := 0.5;
    graphicForm.UpDown1Click(nil);
    AssertTrue('The exact threshold remains unchanged.',
      Abs(Unit13.GlobalVar_0061E120 - 0.5) < 1e-12);

    Unit13.GlobalVar_0061E120 := 0.63;
    graphicForm.UpDown1Click(nil);
    AssertTrue('A value above the threshold decreases by 0.13.',
      Abs(Unit13.GlobalVar_0061E120 - 0.5) < 1e-12);
  finally
    Unit13.GlobalVar_0061E120 := previousGlobalVar_0061E120;
    graphicForm.Free;
  end;
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

procedure TTestAHW52GraphicForm.TestScrollbarChangesRefreshPaintBox;
var
  graphicForm: TForm13;
begin
  Application.Initialize;
  FPaintEventCount := 0;
  graphicForm := TForm13.CreateNew(nil);
  try
    graphicForm.PaintBox1 := TPaintBox.Create(graphicForm);
    graphicForm.PaintBox1.Parent := graphicForm;
    graphicForm.PaintBox1.SetBounds(0, 0, 100, 100);
    graphicForm.PaintBox1.OnPaint := @RecordPaint;
    graphicForm.Show;
    Application.ProcessMessages;
    FPaintEventCount := 0;

    graphicForm.ScrollBar1Change(nil);
    Application.ProcessMessages;
    AssertTrue('The first scrollbar change refreshes PaintBox1.',
      FPaintEventCount > 0);

    FPaintEventCount := 0;
    graphicForm.ScrollBar2Change(nil);
    Application.ProcessMessages;
    AssertTrue('The second scrollbar change refreshes PaintBox1.',
      FPaintEventCount > 0);
  finally
    graphicForm.Free;
  end;
end;

procedure TTestAHW52GraphicForm.TestGraphicButtonsUpdateAddressBackedState;
var
  graphicForm: TForm13;
  previousGlobalVar_011AD334: Integer;
  previousGlobalVar_011AD338: Integer;
  previousGlobalVar_0061E110: Integer;
  previousGlobalVar_0061E2DC: Integer;
begin
  Application.Initialize;
  previousGlobalVar_011AD334 := Unit13.GlobalVar_011AD334;
  previousGlobalVar_011AD338 := Unit13.GlobalVar_011AD338;
  previousGlobalVar_0061E110 := Unit13.GlobalVar_0061E110;
  previousGlobalVar_0061E2DC := Unit13.GlobalVar_0061E2DC;
  FPaintEventCount := 0;
  graphicForm := TForm13.CreateNew(nil);
  try
    graphicForm.PaintBox1 := TPaintBox.Create(graphicForm);
    graphicForm.PaintBox1.Parent := graphicForm;
    graphicForm.PaintBox1.SetBounds(0, 0, 100, 100);
    graphicForm.PaintBox1.OnPaint := @RecordPaint;
    graphicForm.Button1 := TSpeedButton.Create(graphicForm);
    graphicForm.Button1.Parent := graphicForm;
    graphicForm.Show;
    Application.ProcessMessages;

    Unit13.GlobalVar_0061E2DC := 0;
    FPaintEventCount := 0;
    graphicForm.Button1Click(nil);
    AssertEquals('The first click selects asymmetric mode.', 1,
      Unit13.GlobalVar_0061E2DC);
    AssertEquals('The first click updates the button caption.', 'asym.',
      graphicForm.Button1.Caption);
    AssertTrue('The first mode click refreshes PaintBox1.',
      FPaintEventCount > 0);

    FPaintEventCount := 0;
    graphicForm.Button1Click(nil);
    AssertEquals('The second click selects symmetric mode.', 0,
      Unit13.GlobalVar_0061E2DC);
    AssertEquals('The second click updates the button caption.', 'symm.',
      graphicForm.Button1.Caption);
    AssertTrue('The second mode click refreshes PaintBox1.',
      FPaintEventCount > 0);

    Unit13.GlobalVar_011AD338 := 40;
    Unit13.GlobalVar_0061E110 := 50;
    FPaintEventCount := 0;
    graphicForm.Button2Click(nil);
    AssertEquals('The right-arrow button advances the first state by ten.',
      50, Unit13.GlobalVar_011AD338);
    AssertEquals('The right-arrow button advances the second state by ten.',
      60, Unit13.GlobalVar_0061E110);
    AssertTrue('The right-arrow button refreshes PaintBox1.',
      FPaintEventCount > 0);

    Unit13.GlobalVar_011AD334 := 70;
    FPaintEventCount := 0;
    graphicForm.Button3Click(nil);
    AssertEquals('The left-arrow button reduces the bounded state by ten.',
      50, Unit13.GlobalVar_0061E110);
    AssertEquals('The second left-arrow branch reduces its paired state.',
      40, Unit13.GlobalVar_011AD338);
    AssertTrue('Both left-arrow branches request a redraw.',
      FPaintEventCount >= 2);

    Unit13.GlobalVar_0061E110 := 30;
    Unit13.GlobalVar_011AD334 := 60;
    Unit13.GlobalVar_011AD338 := 77;
    FPaintEventCount := 0;
    graphicForm.Button3Click(nil);
    AssertEquals('The first lower bound is preserved.', 30,
      Unit13.GlobalVar_0061E110);
    AssertEquals('The second lower bound is preserved.', 77,
      Unit13.GlobalVar_011AD338);
    AssertEquals('The lower-bound no-op does not repaint.', 0,
      FPaintEventCount);
  finally
    Unit13.GlobalVar_011AD334 := previousGlobalVar_011AD334;
    Unit13.GlobalVar_011AD338 := previousGlobalVar_011AD338;
    Unit13.GlobalVar_0061E110 := previousGlobalVar_0061E110;
    Unit13.GlobalVar_0061E2DC := previousGlobalVar_0061E2DC;
    graphicForm.Free;
  end;
end;

procedure TTestAHW52GraphicForm.TestPenWidthButtonsRespectBounds;
var
  graphicForm: TForm13;
begin
  Application.Initialize;
  FPaintEventCount := 0;
  graphicForm := TForm13.CreateNew(nil);
  try
    graphicForm.PaintBox1 := TPaintBox.Create(graphicForm);
    graphicForm.PaintBox1.Parent := graphicForm;
    graphicForm.PaintBox1.SetBounds(0, 0, 100, 100);
    graphicForm.PaintBox1.OnPaint := @RecordPaint;
    graphicForm.Show;
    Application.ProcessMessages;
    graphicForm.PaintBox1.Canvas.Pen.Width := 1;

    FPaintEventCount := 0;
    graphicForm.Button7Click(nil);
    AssertEquals('The narrowest pen width remains one.', 1,
      graphicForm.PaintBox1.Canvas.Pen.Width);
    AssertEquals('The minimum-width no-op does not repaint.', 0,
      FPaintEventCount);

    graphicForm.Button8Click(nil);
    AssertEquals('The increase button advances the pen width to two.', 2,
      graphicForm.PaintBox1.Canvas.Pen.Width);
    AssertTrue('A pen-width increase refreshes PaintBox1.',
      FPaintEventCount > 0);

    FPaintEventCount := 0;
    graphicForm.Button8Click(nil);
    AssertEquals('The increase button advances the pen width to three.', 3,
      graphicForm.PaintBox1.Canvas.Pen.Width);
    AssertTrue('The second pen-width increase refreshes PaintBox1.',
      FPaintEventCount > 0);

    FPaintEventCount := 0;
    graphicForm.Button8Click(nil);
    AssertEquals('The maximum pen width remains three.', 3,
      graphicForm.PaintBox1.Canvas.Pen.Width);
    AssertEquals('The maximum-width no-op does not repaint.', 0,
      FPaintEventCount);

    graphicForm.Button7Click(nil);
    AssertEquals('The decrease button reduces the pen width to two.', 2,
      graphicForm.PaintBox1.Canvas.Pen.Width);
    AssertTrue('A pen-width decrease refreshes PaintBox1.',
      FPaintEventCount > 0);

    FPaintEventCount := 0;
    graphicForm.Button7Click(nil);
    AssertEquals('The decrease button reduces the pen width to one.', 1,
      graphicForm.PaintBox1.Canvas.Pen.Width);
    AssertTrue('The second pen-width decrease refreshes PaintBox1.',
      FPaintEventCount > 0);

    FPaintEventCount := 0;
    graphicForm.Button7Click(nil);
    AssertEquals('The minimum pen width remains one.', 1,
      graphicForm.PaintBox1.Canvas.Pen.Width);
    AssertEquals('The second minimum-width no-op does not repaint.', 0,
      FPaintEventCount);
  finally
    graphicForm.Free;
  end;
end;

procedure TTestAHW52GraphicForm.
  TestFormCreateInitializesPaintBoxAndAddressBackedState;
var
  graphicForm: TForm13;
  previousGlobalVar_02535380: Integer;
  previousGlobalVar_02535384: Integer;
  previousGlobalVar_011AD31C: Integer;
  previousGlobalVar_011AD324: Integer;
  previousGlobalVar_011AD318: Integer;
  previousGlobalVar_0253537C: Integer;
begin
  previousGlobalVar_02535380 := Unit13.GlobalVar_02535380;
  previousGlobalVar_02535384 := Unit13.GlobalVar_02535384;
  previousGlobalVar_011AD31C := Unit13.GlobalVar_011AD31C;
  previousGlobalVar_011AD324 := Unit13.GlobalVar_011AD324;
  previousGlobalVar_011AD318 := Unit13.GlobalVar_011AD318;
  previousGlobalVar_0253537C := Unit13.GlobalVar_0253537C;
  graphicForm := TForm13.CreateNew(nil);
  try
    graphicForm.PaintBox1 := TPaintBox.Create(graphicForm);
    graphicForm.PaintBox1.Parent := graphicForm;
    Unit13.GlobalVar_02535380 := 1;
    Unit13.GlobalVar_02535384 := 2;
    Unit13.GlobalVar_011AD31C := 3;
    Unit13.GlobalVar_011AD324 := 4;
    Unit13.GlobalVar_011AD318 := 5;
    Unit13.GlobalVar_0253537C := 6;

    graphicForm.FormCreate(graphicForm);

    AssertEquals('The listing assigns the first graphics bound.', $35C,
      Unit13.GlobalVar_02535380);
    AssertEquals('The listing assigns the second graphics bound.', $258,
      Unit13.GlobalVar_02535384);
    AssertEquals('The first graphics state cell is cleared.', 0,
      Unit13.GlobalVar_011AD31C);
    AssertEquals('The second graphics state cell is cleared.', 0,
      Unit13.GlobalVar_011AD324);
    AssertEquals('The third graphics state cell is cleared.', 0,
      Unit13.GlobalVar_011AD318);
    AssertEquals('The fourth graphics state cell is cleared.', 0,
      Unit13.GlobalVar_0253537C);
    AssertEquals('PaintBox1 height is initialized.', 100,
      graphicForm.PaintBox1.Height);
    AssertEquals('PaintBox1 width is initialized.', 100,
      graphicForm.PaintBox1.Width);
    AssertEquals('PaintBox1 color is initialized to white.', $00FFFFFF,
      graphicForm.PaintBox1.Color);
    AssertEquals('PaintBox1 pen width is initialized.', 1,
      graphicForm.PaintBox1.Canvas.Pen.Width);
  finally
    Unit13.GlobalVar_02535380 := previousGlobalVar_02535380;
    Unit13.GlobalVar_02535384 := previousGlobalVar_02535384;
    Unit13.GlobalVar_011AD31C := previousGlobalVar_011AD31C;
    Unit13.GlobalVar_011AD324 := previousGlobalVar_011AD324;
    Unit13.GlobalVar_011AD318 := previousGlobalVar_011AD318;
    Unit13.GlobalVar_0253537C := previousGlobalVar_0253537C;
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
