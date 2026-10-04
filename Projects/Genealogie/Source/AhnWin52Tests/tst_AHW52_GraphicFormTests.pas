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
    procedure AssertFormShowSetup(const Mode, ExpectedRenderOperation: string);
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
    procedure TestFontSelectionStoresAcceptedNameAndRefreshes;
    procedure TestFontSelectionCancelPreservesNameAndRefreshes;
    procedure TestFormShowTranslatesPreludeAndOpensTablesInListingOrder;
    procedure TestFormShowStopsAtAncestorRenderingBoundary;
    procedure TestFormShowStopsAtDescendantRenderingBoundary;
    procedure TestGraphicPersonNumberFormattingMatchesListing;
    procedure TestGraphicTextUppercasePreservesLegacyUmlautBytes;
    procedure TestGraphicLabelNormalizationMatchesListingBranches;
  end;

implementation

uses
  Buttons, Classes, DB, Dialogs, ExtCtrls, Paradox, PrintersDlgs, StdCtrls,
  SysUtils, AncestorChartOptionsForm, GenealogyDataModule, Unit13,
  Unit13GraphicTextHelpers;

type
  TRecordingParadoxTable = class(TParadox)
  private
    FCallLog: TStrings;
    FLogName: string;
    FCursorOpen: Boolean;
  protected
    function GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode;
      DoCheck: Boolean): TGetResult; override;
    function GetRecordSize: Word; override;
    procedure InternalClose; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalOpen; override;
    function IsCursorOpen: Boolean; override;
  public
    constructor CreateRecorder(AOwner: TComponent; ACallLog: TStrings;
      const ALogName: string);
  end;

  TRecordingIntegerField = class(TIntegerField)
  private
    FReadCount: Integer;
    FValue: Integer;
  protected
    function GetAsInteger: Longint; override;
  public
    property ReadCount: Integer read FReadCount;
    property Value: Integer read FValue write FValue;
  end;

  TRecordingFontDialog = class(TFontDialog)
  private
    FAccept: Boolean;
    FInitialFontName: string;
    FSelectedFontName: string;
  public
    function Execute: Boolean; override;
    property Accept: Boolean read FAccept write FAccept;
    property InitialFontName: string read FInitialFontName;
    property SelectedFontName: string read FSelectedFontName write FSelectedFontName;
  end;

  TRecordingPrinterSetupDialog = class(TPrinterSetupDialog)
  private
    FExecuteCount: Integer;
  public
    function Execute: Boolean; override;
    property ExecuteCount: Integer read FExecuteCount;
  end;

  constructor TRecordingParadoxTable.CreateRecorder(AOwner: TComponent;
    ACallLog: TStrings;
    const ALogName: string);
  begin
    inherited Create(AOwner);
    FCallLog := ACallLog;
    FLogName := ALogName;
  end;

  function TRecordingParadoxTable.GetRecord(Buffer: TRecordBuffer;
    GetMode: TGetMode; DoCheck: Boolean): TGetResult;
  begin
    Result := grEOF;
  end;

  function TRecordingParadoxTable.GetRecordSize: Word;
  begin
    Result := 0;
  end;

  procedure TRecordingParadoxTable.InternalClose;
  begin
    FCursorOpen := False;
  end;

  procedure TRecordingParadoxTable.InternalInitFieldDefs;
  begin
  end;

  procedure TRecordingParadoxTable.InternalOpen;
  begin
    FCallLog.Add(FLogName);
    FCursorOpen := True;
  end;

  function TRecordingParadoxTable.IsCursorOpen: Boolean;
  begin
    Result := FCursorOpen;
  end;

function TRecordingIntegerField.GetAsInteger: Longint;
begin
  Inc(FReadCount);
  Result := FValue;
end;

  function TRecordingFontDialog.Execute: Boolean;
begin
  FInitialFontName := Font.Name;
  if FAccept then
    Font.Name := FSelectedFontName;
  Result := FAccept;
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
  previousParameterDialog: TAncestorChartOptionsForm;
  previousGraphicForm: TForm13;
  parameterDialog: TAncestorChartOptionsForm;
  graphicForm: TForm13;
  eventReceiver: TForm13;
begin
  Application.Initialize;
  FParameterDialogCloseEventCount := 0;
  FGraphicVisibleWhenParameterDialogCloses := False;
  previousParameterDialog := AncestorChartOptionsForm.Form12;
  previousGraphicForm := Unit13.Form13;
  parameterDialog := TAncestorChartOptionsForm.CreateNew(nil);
  graphicForm := nil;
  eventReceiver := nil;
  try
    graphicForm := TForm13.CreateNew(nil);
    eventReceiver := TForm13.CreateNew(nil);
    AncestorChartOptionsForm.Form12 := parameterDialog;
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
    AncestorChartOptionsForm.Form12 := previousParameterDialog;
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

procedure TTestAHW52GraphicForm.
  TestFontSelectionStoresAcceptedNameAndRefreshes;
var
  graphicForm: TForm13;
  fontDialog: TRecordingFontDialog;
  previousFontName: string;
begin
  Application.Initialize;
  previousFontName := Unit13.GlobalVar_0061E2EC;
  FPaintEventCount := 0;
  graphicForm := TForm13.CreateNew(nil);
  try
    graphicForm.PaintBox1 := TPaintBox.Create(graphicForm);
    graphicForm.PaintBox1.Parent := graphicForm;
    graphicForm.PaintBox1.SetBounds(0, 0, 100, 100);
    graphicForm.PaintBox1.OnPaint := @RecordPaint;
    fontDialog := TRecordingFontDialog.Create(graphicForm);
    fontDialog.Accept := True;
    fontDialog.SelectedFontName := 'Synthetic Font';
    graphicForm.FontDialog1 := fontDialog;
    graphicForm.Show;
    Application.ProcessMessages;
    FPaintEventCount := 0;

    graphicForm.SpeedButton12Click(nil);

    AssertEquals('The dialog starts with the recovered Arial font.',
      'Arial', fontDialog.InitialFontName);
    AssertEquals('The accepted font is stored in the mapped state cell.',
      'Synthetic Font', Unit13.GlobalVar_0061E2EC);
    AssertTrue('PaintBox1 is refreshed after accepting the font.',
      FPaintEventCount > 0);
  finally
    Unit13.GlobalVar_0061E2EC := previousFontName;
    graphicForm.Free;
  end;
end;

procedure TTestAHW52GraphicForm.
  TestFontSelectionCancelPreservesNameAndRefreshes;
var
  graphicForm: TForm13;
  fontDialog: TRecordingFontDialog;
  previousFontName: string;
begin
  Application.Initialize;
  previousFontName := Unit13.GlobalVar_0061E2EC;
  Unit13.GlobalVar_0061E2EC := 'Previously selected font';
  FPaintEventCount := 0;
  graphicForm := TForm13.CreateNew(nil);
  try
    graphicForm.PaintBox1 := TPaintBox.Create(graphicForm);
    graphicForm.PaintBox1.Parent := graphicForm;
    graphicForm.PaintBox1.SetBounds(0, 0, 100, 100);
    graphicForm.PaintBox1.OnPaint := @RecordPaint;
    fontDialog := TRecordingFontDialog.Create(graphicForm);
    fontDialog.Accept := False;
    fontDialog.SelectedFontName := 'Unused Font';
    graphicForm.FontDialog1 := fontDialog;
    graphicForm.Show;
    Application.ProcessMessages;
    FPaintEventCount := 0;

    graphicForm.SpeedButton12Click(nil);

    AssertEquals('The dialog starts with the recovered Arial font.',
      'Arial', fontDialog.InitialFontName);
    AssertEquals('Cancel preserves the previously selected font.',
      'Previously selected font', Unit13.GlobalVar_0061E2EC);
    AssertTrue('PaintBox1 is refreshed after cancelling the font dialog.',
      FPaintEventCount > 0);
  finally
    Unit13.GlobalVar_0061E2EC := previousFontName;
    graphicForm.Free;
  end;
end;

procedure TTestAHW52GraphicForm.
  TestFormShowTranslatesPreludeAndOpensTablesInListingOrder;
var
  graphicForm: TForm13;
  dataModule: TGenealogyDataModule;
  previousDataModule: TGenealogyDataModule;
  personNumberField: TRecordingIntegerField;
  openCalls: TStringList;
  previousMode: string;
  previousRoundScale: Integer;
  previousResetState1: Integer;
  previousResetState2: Integer;
  previousInitialBoxWidth: Integer;
  previousInitialLineWidth: Integer;
  previousZoom: Extended;
  previousProgressState: Integer;
begin
  previousProgressState := Unit13.GlobalVar_02535388;
  previousMode := AncestorChartOptionsForm.GlobalVar_0253592C;
  previousResetState1 := Unit13.GlobalVar_0061E2F4;
  previousResetState2 := Unit13.GlobalVar_0061E2F8;
  previousRoundScale := Unit13.GlobalVar_0061E11C;
  previousInitialBoxWidth := Unit13.GlobalVar_011AD338;
  previousInitialLineWidth := Unit13.GlobalVar_011AD334;
  previousZoom := Unit13.GlobalVar_0061E120;
  graphicForm := TForm13.CreateNew(nil);
  previousDataModule := GenealogyDataModule.DataModule2;
  dataModule := TGenealogyDataModule.CreateNew(nil);
  openCalls := TStringList.Create;
  personNumberField := TRecordingIntegerField.Create(dataModule);
  try
    graphicForm.Button1 := TSpeedButton.Create(graphicForm);
    graphicForm.Button1.Parent := graphicForm;
    graphicForm.Button1.Visible := True;
    dataModule.Table17 := TRecordingParadoxTable.CreateRecorder(
      dataModule, openCalls,
      'Table17.Open');
    dataModule.Table18 := TRecordingParadoxTable.CreateRecorder(
      dataModule, openCalls,
      'Table18.Open');
    personNumberField.Value := 42;
    dataModule.Table1Nummer := personNumberField;
    GenealogyDataModule.DataModule2 := dataModule;
    AncestorChartOptionsForm.GlobalVar_0253592C := '';
    Unit13.GlobalVar_02535388 := 1;

    graphicForm.FormShow(graphicForm);

    AssertEquals('FormShow resets the proven progress state.',
      0, Unit13.GlobalVar_02535388);
    AssertFalse('FormShow hides the proven button before opening tables.',
      graphicForm.Button1.Visible);
    AssertEquals('FormShow opens exactly the two listing-backed tables.', 2,
      openCalls.Count);
    AssertEquals('FormShow retains the first listing-backed table open.',
      'Table17.Open', openCalls[0]);
    AssertEquals('FormShow retains the second listing-backed table open.',
      'Table18.Open', openCalls[1]);
    AssertEquals('The field virtual call reads the integer field once.', 1,
      personNumberField.ReadCount);
    AssertEquals('FormShow clears the first opaque state cell.', 0,
      Unit13.GlobalVar_0061E2F4);
    AssertEquals('FormShow clears the second opaque state cell.', 0,
      Unit13.GlobalVar_0061E2F8);
    AssertTrue('FormShow restores the listing-backed scale.',
      Abs(Unit13.GlobalVar_0061E120 - 0.63) < 1e-12);
    AssertEquals('The first scale-derived state rounds 0.63 * 6.', 4,
      Unit13.GlobalVar_0061E11C);
    AssertEquals('FormShow initializes the observed state cell.', 20,
      Unit13.GlobalVar_011AD338);
    AssertEquals('The second scale-derived state rounds 0.63 * 120.', 76,
      Unit13.GlobalVar_011AD334);
  finally
    GenealogyDataModule.DataModule2 := previousDataModule;
    AncestorChartOptionsForm.GlobalVar_0253592C := previousMode;
    Unit13.GlobalVar_02535388 := previousProgressState;
    Unit13.GlobalVar_0061E2F4 := previousResetState1;
    Unit13.GlobalVar_0061E2F8 := previousResetState2;
    Unit13.GlobalVar_0061E11C := previousRoundScale;
    Unit13.GlobalVar_011AD338 := previousInitialBoxWidth;
    Unit13.GlobalVar_011AD334 := previousInitialLineWidth;
    Unit13.GlobalVar_0061E120 := previousZoom;
    graphicForm.Free;
    dataModule.Free;
    openCalls.Free;
  end;
end;

procedure TTestAHW52GraphicForm.TestFormShowStopsAtAncestorRenderingBoundary;
const
  Modes: array[0..1] of string = ('Vorgr1', 'Vorgr2');
var
  Mode: string;
begin
  for Mode in Modes do
    AssertFormShowSetup(Mode, 'TForm13.Vorf_erm');
end;

procedure TTestAHW52GraphicForm.TestFormShowStopsAtDescendantRenderingBoundary;
const
  Modes: array[0..1] of string = ('Nachgr1', 'Nachgr2');
var
  Mode: string;
begin
  for Mode in Modes do
    AssertFormShowSetup(Mode, 'TForm13.Nach_erm');
end;

procedure TTestAHW52GraphicForm.TestGraphicPersonNumberFormattingMatchesListing;
begin
  AssertEquals('Zero is padded to six digits.', '000000',
    FormatGraphicPersonNumber(0));
  AssertEquals('Positive values are left-padded.', '000042',
    FormatGraphicPersonNumber(42));
  AssertEquals('Values longer than six characters keep their suffix.',
    '234567', FormatGraphicPersonNumber(1234567));
  AssertEquals('Negative values preserve the final six characters.',
    '0000-1', FormatGraphicPersonNumber(-1));
  AssertEquals('Negative over-width values preserve the final six characters.',
    '234567', FormatGraphicPersonNumber(-1234567));
end;

procedure TTestAHW52GraphicForm.TestGraphicTextUppercasePreservesLegacyUmlautBytes;
var
  input: RawByteString;
  expected: RawByteString;
begin
  input := '';
  expected := '';
  AssertEquals('Ordinary ASCII text uses uppercase conversion.',
    RawByteString('AHNWIN'), UppercaseGraphicText('AhnWin'));

  SetLength(input, 3);
  input[1] := AnsiChar($E4);
  input[2] := AnsiChar($F6);
  input[3] := AnsiChar($FC);
  SetLength(expected, 3);
  expected[1] := AnsiChar($C4);
  expected[2] := AnsiChar($D6);
  expected[3] := AnsiChar($DC);
  AssertEquals('The three evidenced ANSI umlaut bytes map explicitly.',
    expected, UppercaseGraphicText(input));
end;

procedure TTestAHW52GraphicForm.TestGraphicLabelNormalizationMatchesListingBranches;
begin
  AssertEquals('Trimmed double dots produce an empty label.',
    RawByteString(''), NormalizeGraphicLabel('  ..  '));
  AssertEquals('HK labels use the fixed seven-character slice.',
    RawByteString('HK 1234567'), NormalizeGraphicLabel('HK:1234567'));
  AssertEquals('vo.r labels use fixed positions and the final four bytes.',
    RawByteString('vor 1234'), NormalizeGraphicLabel('vo.r1234'));
  AssertEquals('na.ch labels use fixed positions and the final four bytes.',
    RawByteString('nac 1234'), NormalizeGraphicLabel('na.ch1234'));
  AssertEquals('Whitespace-only labels are returned unchanged.',
    RawByteString('   '), NormalizeGraphicLabel('   '));
  AssertEquals('Leading spaces and dots are stripped by repeated nine-byte slices.',
    RawByteString('12345'), NormalizeGraphicLabel('  .  123456789'));
  AssertEquals('General labels remove dots and add a space before digits.',
    RawByteString('Name 42'), NormalizeGraphicLabel('Name.42'));
  AssertEquals('Labels beginning with a digit bypass general normalization.',
    RawByteString('1.23456'), NormalizeGraphicLabel('1.23456'));
  AssertEquals('Alphabetic labels without punctuation remain unchanged.',
    RawByteString('Normal'), NormalizeGraphicLabel('Normal'));
end;

procedure TTestAHW52GraphicForm.AssertFormShowSetup(const Mode,
  ExpectedRenderOperation: string);
var
  graphicForm: TForm13;
  dataModule: TGenealogyDataModule;
  previousDataModule: TGenealogyDataModule;
  personNumberField: TRecordingIntegerField;
  openCalls: TStringList;
  previousMode: string;
  previousProgressState: Integer;
  previousResetState1: Integer;
  previousResetState2: Integer;
  previousRoundScale: Integer;
  previousInitialBoxWidth: Integer;
  previousInitialLineWidth: Integer;
  previousZoom: Extended;
begin
  previousDataModule := GenealogyDataModule.DataModule2;
  previousMode := AncestorChartOptionsForm.GlobalVar_0253592C;
  previousProgressState := Unit13.GlobalVar_02535388;
  previousResetState1 := Unit13.GlobalVar_0061E2F4;
  previousResetState2 := Unit13.GlobalVar_0061E2F8;
  previousRoundScale := Unit13.GlobalVar_0061E11C;
  previousInitialBoxWidth := Unit13.GlobalVar_011AD338;
  previousInitialLineWidth := Unit13.GlobalVar_011AD334;
  previousZoom := Unit13.GlobalVar_0061E120;
  graphicForm := TForm13.CreateNew(nil);
  dataModule := TGenealogyDataModule.CreateNew(nil);
  openCalls := TStringList.Create;
  personNumberField := TRecordingIntegerField.Create(dataModule);
  try
    graphicForm.Button1 := TSpeedButton.Create(graphicForm);
    graphicForm.Button1.Parent := graphicForm;
    graphicForm.Button1.Visible := True;
    graphicForm.PaintBox1 := TPaintBox.Create(graphicForm);
    graphicForm.PaintBox1.Parent := graphicForm;
    graphicForm.ScrollBar1 := TScrollBar.Create(graphicForm);
    graphicForm.ScrollBar1.Parent := graphicForm;
    graphicForm.ScrollBar2 := TScrollBar.Create(graphicForm);
    graphicForm.ScrollBar2.Parent := graphicForm;
    graphicForm.ScrollBar1.Position := 17;
    graphicForm.ScrollBar2.Position := 23;

    dataModule.Table17 := TRecordingParadoxTable.CreateRecorder(
      dataModule, openCalls, 'Table17.Open');
    dataModule.Table18 := TRecordingParadoxTable.CreateRecorder(
      dataModule, openCalls, 'Table18.Open');
    personNumberField.Value := 42;
    dataModule.Table1Nummer := personNumberField;
    GenealogyDataModule.DataModule2 := dataModule;
    AncestorChartOptionsForm.GlobalVar_0253592C := Mode;
    Unit13.GlobalVar_02535388 := 1;
    Unit13.GlobalVar_0061E120 := 0.9;

    try
      graphicForm.FormShow(graphicForm);
      Fail('FormShow must stop at the unsupported rendering boundary.');
    except
      on E: EInvalidOpException do
        AssertEquals(
          Format('Graphic rendering operation "%s" is not reconstructed.',
            [ExpectedRenderOperation]),
          E.Message);
    end;

    AssertEquals('FormShow reads the person-number field before rendering.',
      1, personNumberField.ReadCount);
    AssertEquals('FormShow clears the first state cell before rendering.', 0,
      Unit13.GlobalVar_0061E2F4);
    AssertEquals('FormShow clears the second state cell before rendering.', 0,
      Unit13.GlobalVar_0061E2F8);
    AssertTrue('FormShow initializes the scale before rendering.',
      Abs(Unit13.GlobalVar_0061E120 - 0.63) < 1e-12);
    AssertEquals('FormShow calculates the first scale value before rendering.',
      4, Unit13.GlobalVar_0061E11C);
    AssertEquals('FormShow initializes the observed state cell before rendering.',
      20,
      Unit13.GlobalVar_011AD338);
    AssertEquals('FormShow calculates the second scale value before rendering.',
      76, Unit13.GlobalVar_011AD334);
    AssertEquals('The selected mode opens the expected tables first.', 2,
      openCalls.Count);
    AssertEquals('The first table opens before rendering.', 'Table17.Open',
      openCalls[0]);
    AssertEquals('The second table opens before rendering.', 'Table18.Open',
      openCalls[1]);
    AssertEquals('The first scrollbar resets before rendering.', 0,
      graphicForm.ScrollBar1.Position);
    AssertEquals('The second scrollbar resets before rendering.', 0,
      graphicForm.ScrollBar2.Position);
  finally
    GenealogyDataModule.DataModule2 := previousDataModule;
    AncestorChartOptionsForm.GlobalVar_0253592C := previousMode;
    Unit13.GlobalVar_02535388 := previousProgressState;
    Unit13.GlobalVar_0061E2F4 := previousResetState1;
    Unit13.GlobalVar_0061E2F8 := previousResetState2;
    Unit13.GlobalVar_0061E11C := previousRoundScale;
    Unit13.GlobalVar_011AD338 := previousInitialBoxWidth;
    Unit13.GlobalVar_011AD334 := previousInitialLineWidth;
    Unit13.GlobalVar_0061E120 := previousZoom;
    graphicForm.Free;
    dataModule.Free;
    openCalls.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52GraphicForm);

end.
