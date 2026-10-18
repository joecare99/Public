unit tst_AHW52_Unit11MetricsTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Unit11;

type
  TScaleRecordingForm11 = class(TForm11)
  public
    ScaleCallCount: Integer;
    ScaleMultiplier: Integer;
    ScaleDivider: Integer;
    WidthBeforeScale: Integer;
    HeightBeforeScale: Integer;
    procedure ChangeScale(Multiplier, Divider: Integer); override;
  end;

  TTestAHW52Unit11Metrics = class(TTestCase)
  published
    procedure TestFormActivateResetsPrintPageCounter;
    procedure TestPrinterPixelsPerCentimetreUsesLegacyIntegerRatios;
    procedure TestScaleForm11ExtentPreservesBorderAndTruncates;
    procedure TestApplyEnvironmentMetricsCapturesPrinterAndCanvasState;
    procedure TestApplyEnvironmentMetricsScalesForScreenChange;
    procedure TestInvalidPrinterMetricsDoNotPartiallyUpdateGlobals;
  end;

implementation

uses
  ExtCtrls, Forms, Graphics, SysUtils;

procedure TTestAHW52Unit11Metrics.TestFormActivateResetsPrintPageCounter;
var
  form: TForm11;
  previousCounter: Integer;
begin
  previousCounter := GlobalVar_025358A8;
  form := TForm11.CreateNew(nil);
  try
    GlobalVar_025358A8 := 7;
    form.FormActivate(form);
    AssertEquals(0, GlobalVar_025358A8);
  finally
    GlobalVar_025358A8 := previousCounter;
    form.Free;
  end;
end;

procedure TScaleRecordingForm11.ChangeScale(Multiplier, Divider: Integer);
begin
  Inc(ScaleCallCount);
  ScaleMultiplier := Multiplier;
  ScaleDivider := Divider;
  WidthBeforeScale := Width;
  HeightBeforeScale := Height;
  inherited ChangeScale(Multiplier, Divider);
end;

procedure TTestAHW52Unit11Metrics.
  TestPrinterPixelsPerCentimetreUsesLegacyIntegerRatios;
begin
  AssertEquals(118, PrinterPixelsPerCentimetre(2480, 2481, 300));
  AssertEquals(120, PrinterPixelsPerCentimetre(3508, 3508, 300));
end;

procedure TTestAHW52Unit11Metrics.
  TestScaleForm11ExtentPreservesBorderAndTruncates;
begin
  AssertEquals(1196, ScaleForm11Extent(980, 1000, 1920, 1600));
  AssertEquals(952, ScaleForm11Extent(760, 800, 1080, 900));
end;

procedure TTestAHW52Unit11Metrics.
  TestApplyEnvironmentMetricsCapturesPrinterAndCanvasState;
var
  form: TForm11;
  paintBox: TPaintBox;
  metrics: TForm11EnvironmentMetrics;
  previousCanvas: TCanvas;
  previousCounter: Integer;
  previousWidthCentimetres: Integer;
  previousWidthPixels: Integer;
  previousHeightCentimetres: Integer;
  previousHeightPixels: Integer;
  previousHorizontalScale: Integer;
  previousVerticalScale: Integer;
begin
  previousCanvas := GlobalVar_02535894;
  previousCounter := GlobalVar_025358A8;
  previousWidthCentimetres := GlobalVar_025358B0;
  previousWidthPixels := GlobalVar_025358B4;
  previousHeightCentimetres := GlobalVar_025358B8;
  previousHeightPixels := GlobalVar_025358BC;
  previousHorizontalScale := GlobalVar_025358C0;
  previousVerticalScale := GlobalVar_025358C4;

  form := TForm11.CreateNew(nil);
  try
    form.SetBounds(0, 0, 800, 600);
    paintBox := TPaintBox.Create(form);
    paintBox.Parent := form;
    paintBox.SetBounds(10, 20, 100, 80);
    form.PaintBox1 := paintBox;

    metrics.PaperWidthPixels := 2481;
    metrics.PaperHeightPixels := 3508;
    metrics.PrintableWidthPixels := 2480;
    metrics.PrintableHeightPixels := 3508;
    metrics.PrinterXDPI := 300;
    metrics.PrinterYDPI := 300;
    metrics.ScreenWidth := 1600;
    metrics.ScreenHeight := 900;
    metrics.ReferenceScreenWidth := 1600;
    metrics.ReferenceScreenHeight := 900;
    metrics.HostWidth := 1000;
    metrics.HostHeight := 800;
    metrics.HostClientWidth := 980;
    metrics.HostClientHeight := 760;

    GlobalVar_025358A8 := 17;
    form.ApplyEnvironmentMetrics(metrics);

    AssertEquals(21, GlobalVar_025358B0);
    AssertEquals(2480, GlobalVar_025358B4);
    AssertEquals(29, GlobalVar_025358B8);
    AssertEquals(3508, GlobalVar_025358BC);
    AssertEquals(118, GlobalVar_025358C0);
    AssertEquals(120, GlobalVar_025358C4);
    AssertSame(paintBox.Canvas, GlobalVar_02535894);
    AssertEquals(0, GlobalVar_025358A8);
    AssertTrue(form.Scaled);
    AssertEquals(800, form.Width);
    AssertEquals(600, form.Height);
  finally
    GlobalVar_02535894 := previousCanvas;
    GlobalVar_025358A8 := previousCounter;
    GlobalVar_025358B0 := previousWidthCentimetres;
    GlobalVar_025358B4 := previousWidthPixels;
    GlobalVar_025358B8 := previousHeightCentimetres;
    GlobalVar_025358BC := previousHeightPixels;
    GlobalVar_025358C0 := previousHorizontalScale;
    GlobalVar_025358C4 := previousVerticalScale;
    form.Free;
  end;
end;

procedure TTestAHW52Unit11Metrics.
  TestApplyEnvironmentMetricsScalesForScreenChange;
var
  form: TScaleRecordingForm11;
  paintBox: TPaintBox;
  metrics: TForm11EnvironmentMetrics;
  previousCanvas: TCanvas;
  previousCounter: Integer;
  previousWidthCentimetres: Integer;
  previousWidthPixels: Integer;
  previousHeightCentimetres: Integer;
  previousHeightPixels: Integer;
  previousHorizontalScale: Integer;
  previousVerticalScale: Integer;
begin
  previousCanvas := GlobalVar_02535894;
  previousCounter := GlobalVar_025358A8;
  previousWidthCentimetres := GlobalVar_025358B0;
  previousWidthPixels := GlobalVar_025358B4;
  previousHeightCentimetres := GlobalVar_025358B8;
  previousHeightPixels := GlobalVar_025358BC;
  previousHorizontalScale := GlobalVar_025358C0;
  previousVerticalScale := GlobalVar_025358C4;

  form := TScaleRecordingForm11.CreateNew(nil);
  try
    form.SetBounds(0, 0, 800, 600);
    paintBox := TPaintBox.Create(form);
    paintBox.Parent := form;
    form.PaintBox1 := paintBox;

    metrics.PaperWidthPixels := 2481;
    metrics.PaperHeightPixels := 3508;
    metrics.PrintableWidthPixels := 2480;
    metrics.PrintableHeightPixels := 3508;
    metrics.PrinterXDPI := 300;
    metrics.PrinterYDPI := 300;
    metrics.ScreenWidth := 1920;
    metrics.ScreenHeight := 1080;
    metrics.ReferenceScreenWidth := 1600;
    metrics.ReferenceScreenHeight := 900;
    metrics.HostWidth := 1000;
    metrics.HostHeight := 800;
    metrics.HostClientWidth := 980;
    metrics.HostClientHeight := 760;

    form.ApplyEnvironmentMetrics(metrics);

    AssertEquals(1, form.ScaleCallCount);
    AssertEquals(1600, form.ScaleMultiplier);
    AssertEquals(1920, form.ScaleDivider);
    AssertEquals(1196, form.WidthBeforeScale);
    AssertEquals(952, form.HeightBeforeScale);
    AssertEquals(0, GlobalVar_025358A8);
  finally
    GlobalVar_02535894 := previousCanvas;
    GlobalVar_025358A8 := previousCounter;
    GlobalVar_025358B0 := previousWidthCentimetres;
    GlobalVar_025358B4 := previousWidthPixels;
    GlobalVar_025358B8 := previousHeightCentimetres;
    GlobalVar_025358BC := previousHeightPixels;
    GlobalVar_025358C0 := previousHorizontalScale;
    GlobalVar_025358C4 := previousVerticalScale;
    form.Free;
  end;
end;

procedure TTestAHW52Unit11Metrics.
  TestInvalidPrinterMetricsDoNotPartiallyUpdateGlobals;
var
  form: TForm11;
  paintBox: TPaintBox;
  metrics: TForm11EnvironmentMetrics;
  previousCanvas: TCanvas;
  previousCounter: Integer;
  previousWidthCentimetres: Integer;
  raised: Boolean;
begin
  previousCanvas := GlobalVar_02535894;
  previousCounter := GlobalVar_025358A8;
  previousWidthCentimetres := GlobalVar_025358B0;
  form := TForm11.CreateNew(nil);
  try
    paintBox := TPaintBox.Create(form);
    paintBox.Parent := form;
    form.PaintBox1 := paintBox;

    metrics.PaperWidthPixels := 0;
    metrics.PaperHeightPixels := 3508;
    metrics.PrintableWidthPixels := 2480;
    metrics.PrintableHeightPixels := 3508;
    metrics.PrinterXDPI := 300;
    metrics.PrinterYDPI := 300;
    metrics.ScreenWidth := 1600;
    metrics.ScreenHeight := 900;
    metrics.ReferenceScreenWidth := 1600;
    metrics.ReferenceScreenHeight := 900;
    metrics.HostWidth := 1000;
    metrics.HostHeight := 800;
    metrics.HostClientWidth := 980;
    metrics.HostClientHeight := 760;

    GlobalVar_025358A8 := 17;
    GlobalVar_025358B0 := 99;
    raised := False;
    try
      form.ApplyEnvironmentMetrics(metrics);
    except
      on E: ERangeError do
        raised := True;
    end;

    AssertTrue('Invalid paper dimensions must be rejected.', raised);
    AssertSame(previousCanvas, GlobalVar_02535894);
    AssertEquals(17, GlobalVar_025358A8);
    AssertEquals(99, GlobalVar_025358B0);
  finally
    GlobalVar_02535894 := previousCanvas;
    GlobalVar_025358A8 := previousCounter;
    GlobalVar_025358B0 := previousWidthCentimetres;
    form.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit11Metrics);

end.
