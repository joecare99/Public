unit tst_AHW52_Unit16PreviewActionsTests;

{$mode objfpc}{$H+}

interface

uses
  Buttons, Classes, Dialogs, fpcunit, PrintersDlgs, testregistry;

type
  TTestAHW52Unit16PreviewActions = class(TTestCase)
  private
    FClickedControl: TObject;
    FActionSender: TObject;
    FExportedFileName: string;
    procedure RecordButtonClick(Sender: TObject);
    procedure RecordReportAction(Sender: TObject);
    procedure RecordExportFile(const FileName: string);
  published
    procedure TestPreviousPageDecrements;
    procedure TestPreviousPageStopsAtFirstPage;
    procedure TestNextPageIncrements;
    procedure TestNextPageStopsAtLastPage;
    procedure TestNextPageStopsWhenNoPagesAreAvailable;
    procedure TestPageStatusFormatting;
    procedure TestEscapeKeyIsRecognized;
    procedure TestOtherKeysAreNotRecognizedAsEscape;
    procedure TestNeedDataContinuesThroughAvailablePages;
    procedure TestNeedDataStopsAfterLastPage;
    procedure TestSaveDialogUsesTextFilterAndExtension;
    procedure TestExportFileNameMustContainNonWhitespace;
    procedure TestExportCompatibilityErrorNamesOperation;
    procedure TestPrintDialogUsesAvailablePageRange;
    procedure TestZoomIndexZeroSelects100Percent;
    procedure TestZoomIndexOneSelectsFitPage;
    procedure TestZoomIndexTwoSelectsFitWidth;
    procedure TestOtherZoomIndicesDoNotChangeMode;
    procedure TestExitActionClicksTheDedicatedButton;
    procedure TestReportActionDispatchPreservesSender;
    procedure TestSaveActionReturnsWhenDialogIsCancelled;
    procedure TestSaveActionReturnsWhenFileNameIsBlank;
    procedure TestSaveActionExportsSelectedFileName;
  end;

implementation

uses
  Unit16PreviewActions, Unit16ExportCompatibilityError;

type
  TFakeSaveDialog = class(TSaveDialog)
  public
    ExecuteResult: Boolean;
    function Execute: Boolean; override;
  end;

function TFakeSaveDialog.Execute: Boolean;
begin
  Result := ExecuteResult;
end;

procedure TTestAHW52Unit16PreviewActions.RecordButtonClick(Sender: TObject);
begin
  FClickedControl := Sender;
end;

procedure TTestAHW52Unit16PreviewActions.RecordReportAction(Sender: TObject);
begin
  FActionSender := Sender;
end;

procedure TTestAHW52Unit16PreviewActions.RecordExportFile(
  const FileName: string);
begin
  FExportedFileName := FileName;
end;

procedure TTestAHW52Unit16PreviewActions.TestPreviousPageDecrements;
var
  pageNumber: Integer;
begin
  AssertTrue(TryGetPreviousPageNumber(3, pageNumber));
  AssertEquals(2, pageNumber);
end;

procedure TTestAHW52Unit16PreviewActions.TestPreviousPageStopsAtFirstPage;
var
  pageNumber: Integer;
begin
  AssertFalse(TryGetPreviousPageNumber(1, pageNumber));
  AssertEquals(1, pageNumber);
end;

procedure TTestAHW52Unit16PreviewActions.TestNextPageIncrements;
var
  pageNumber: Integer;
begin
  AssertTrue(TryGetNextPageNumber(2, 4, pageNumber));
  AssertEquals(3, pageNumber);
end;

procedure TTestAHW52Unit16PreviewActions.TestNextPageStopsAtLastPage;
var
  pageNumber: Integer;
begin
  AssertFalse(TryGetNextPageNumber(4, 4, pageNumber));
  AssertEquals(4, pageNumber);
end;

procedure TTestAHW52Unit16PreviewActions.
  TestNextPageStopsWhenNoPagesAreAvailable;
var
  pageNumber: Integer;
begin
  AssertFalse(TryGetNextPageNumber(1, 0, pageNumber));
  AssertEquals(1, pageNumber);
end;

procedure TTestAHW52Unit16PreviewActions.TestPageStatusFormatting;
begin
  AssertEquals('Seite 2 von 5', BuildPageStatus(2, 5));
end;

procedure TTestAHW52Unit16PreviewActions.TestEscapeKeyIsRecognized;
begin
  AssertTrue(IsUnit16EscapeKey($001B));
end;

procedure TTestAHW52Unit16PreviewActions.
  TestOtherKeysAreNotRecognizedAsEscape;
begin
  AssertFalse(IsUnit16EscapeKey($000D));
end;

procedure TTestAHW52Unit16PreviewActions.
  TestNeedDataContinuesThroughAvailablePages;
var
  currentPage: Integer;
begin
  currentPage := 0;

  AssertTrue(AdvanceUnit16ReportPage(currentPage, 3));
  AssertEquals(1, currentPage);
  AssertTrue(AdvanceUnit16ReportPage(currentPage, 3));
  AssertEquals(2, currentPage);
  AssertTrue(AdvanceUnit16ReportPage(currentPage, 3));
  AssertEquals(3, currentPage);
end;

procedure TTestAHW52Unit16PreviewActions.TestNeedDataStopsAfterLastPage;
var
  currentPage: Integer;
begin
  currentPage := 3;

  AssertFalse(AdvanceUnit16ReportPage(currentPage, 3));
  AssertEquals('The listing increments its counter before testing the limit.',
    4, currentPage);
end;

procedure TTestAHW52Unit16PreviewActions.
  TestSaveDialogUsesTextFilterAndExtension;
var
  saveDialog: TSaveDialog;
begin
  saveDialog := TSaveDialog.Create(nil);
  try
    saveDialog.Filter := 'Initial filter';
    saveDialog.DefaultExt := 'old';
    saveDialog.FilterIndex := 2;

    ConfigureUnit16SaveDialog(saveDialog);

    AssertEquals('Text-Dateien ( *.txt)|*.txt', saveDialog.Filter);
{$IFDEF FPC}
    AssertEquals('.txt', saveDialog.DefaultExt);
{$ELSE}
    AssertEquals('txt', saveDialog.DefaultExt);
{$ENDIF}
    AssertEquals(2, saveDialog.FilterIndex);
  finally
    saveDialog.Free;
  end;
end;

procedure TTestAHW52Unit16PreviewActions.
  TestExportFileNameMustContainNonWhitespace;
begin
  AssertFalse(HasUnit16ExportFileName('  ' + #9));
  AssertTrue(HasUnit16ExportFileName(' report.txt '));
end;

procedure TTestAHW52Unit16PreviewActions.
  TestExportCompatibilityErrorNamesOperation;
var
  exportError: EUnit16ExportOperationUnsupported;
begin
  exportError := EUnit16ExportOperationUnsupported.Create(
    'TForm16.Speichernunter1Click output');
  try
    AssertEquals('TForm16.Speichernunter1Click output',
      exportError.Operation);
  finally
    exportError.Free;
  end;
end;

procedure TTestAHW52Unit16PreviewActions.
  TestPrintDialogUsesAvailablePageRange;
var
  printDialog: TPrintDialog;
begin
  printDialog := TPrintDialog.Create(nil);
  try
    printDialog.MinPage := 0;
    printDialog.FromPage := 4;
    printDialog.MaxPage := 8;
    printDialog.ToPage := 6;

    ConfigureUnit16PrintDialog(printDialog, 3);

    AssertEquals(1, printDialog.MinPage);
    AssertEquals(1, printDialog.FromPage);
    AssertEquals(3, printDialog.MaxPage);
    AssertEquals('The listing does not change ToPage before Execute.',
      6, printDialog.ToPage);
  finally
    printDialog.Free;
  end;
end;

procedure TTestAHW52Unit16PreviewActions.TestZoomIndexZeroSelects100Percent;
begin
  AssertEquals(Ord(uzaSet100Percent), Ord(ResolveUnit16ZoomAction(0)));
end;

procedure TTestAHW52Unit16PreviewActions.TestZoomIndexOneSelectsFitPage;
begin
  AssertEquals(Ord(uzaFitPage), Ord(ResolveUnit16ZoomAction(1)));
end;

procedure TTestAHW52Unit16PreviewActions.TestZoomIndexTwoSelectsFitWidth;
begin
  AssertEquals(Ord(uzaFitWidth), Ord(ResolveUnit16ZoomAction(2)));
end;

procedure TTestAHW52Unit16PreviewActions.TestOtherZoomIndicesDoNotChangeMode;
begin
  AssertEquals(Ord(uzaNoChange), Ord(ResolveUnit16ZoomAction(-1)));
  AssertEquals(Ord(uzaNoChange), Ord(ResolveUnit16ZoomAction(3)));
end;

procedure TTestAHW52Unit16PreviewActions.
  TestExitActionClicksTheDedicatedButton;
var
  exitButton: TSpeedButton;
begin
  FClickedControl := nil;
  exitButton := TSpeedButton.Create(nil);
  try
    exitButton.OnClick := @RecordButtonClick;

    InvokeUnit16ExitButton(exitButton);

    AssertTrue('The dedicated button receives the click.',
      FClickedControl = exitButton);
  finally
    exitButton.Free;
  end;
end;

procedure TTestAHW52Unit16PreviewActions.
  TestReportActionDispatchPreservesSender;
var
  sender: TObject;
begin
  FActionSender := nil;
  sender := TObject.Create;
  try
    DispatchUnit16ReportAction(@RecordReportAction, sender);

    AssertTrue('The original sender is forwarded to the report action.',
      FActionSender = sender);
  finally
    sender.Free;
  end;
end;

procedure TTestAHW52Unit16PreviewActions.
  TestSaveActionReturnsWhenDialogIsCancelled;
var
  saveDialog: TFakeSaveDialog;
begin
  saveDialog := TFakeSaveDialog.Create(nil);
  try
    saveDialog.ExecuteResult := False;
    FExportedFileName := '';

    AssertFalse(ExecuteUnit16SaveDialog(saveDialog, @RecordExportFile));
    AssertEquals('', FExportedFileName);
  finally
    saveDialog.Free;
  end;
end;

procedure TTestAHW52Unit16PreviewActions.
  TestSaveActionReturnsWhenFileNameIsBlank;
var
  saveDialog: TFakeSaveDialog;
begin
  saveDialog := TFakeSaveDialog.Create(nil);
  try
    saveDialog.ExecuteResult := True;
    saveDialog.FileName := '  ' + #9;
    FExportedFileName := '';

    AssertFalse(ExecuteUnit16SaveDialog(saveDialog, @RecordExportFile));
    AssertEquals('', FExportedFileName);
  finally
    saveDialog.Free;
  end;
end;

procedure TTestAHW52Unit16PreviewActions.
  TestSaveActionExportsSelectedFileName;
var
  saveDialog: TFakeSaveDialog;
begin
  saveDialog := TFakeSaveDialog.Create(nil);
  try
    saveDialog.ExecuteResult := True;
    saveDialog.FileName := 'report.txt';
    FExportedFileName := '';

    AssertTrue(ExecuteUnit16SaveDialog(saveDialog, @RecordExportFile));
    AssertEquals('report.txt', FExportedFileName);
    AssertEquals('Text-Dateien ( *.txt)|*.txt', saveDialog.Filter);
  finally
    saveDialog.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit16PreviewActions);

end.
