unit tst_AHW52_Unit23FokoReportTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit23FokoReport = class(TTestCase)
  published
    procedure TestTemplateContainsRecoveredCaptionsAndFieldBindings;
    procedure TestSyntheticDatasetPreparesReportPages;
    procedure TestPreviewUsesInjectedPresenter;
    procedure TestPrintFailsWithNamedCompatibilityException;
    procedure TestMissingDatasetFieldIsReported;
    procedure TestUnit23LazarusFormLoadsWithoutQuickReportComponents;
    procedure TestUnit23FactoryCreatesOwnedReportBuilder;
    procedure TestPreparedPageIsA4Portrait;
    procedure TestUnit23WorkflowExportsPdfFromSyntheticDataset;
  end;

implementation

uses
  SysUtils, Classes, DB, BufDataset, Forms, LazReport, LR_Class,
  FokoListReport, FokoListReportCompatibilityError, FokoListReportWorkflow,
  ReportPdfContracts, MormotPdfReportWriter, FokoFilePrintForm;

type
  TRecordingFokoPreviewPresenter = class(TInterfacedObject,
    IFokoListReportPreviewPresenter)
  public
    CallCount: Integer;
    PreparedPageCount: Integer;
    TemplatePageCount: Integer;
    procedure ShowPreparedReport(AReport: TfrReport);
  end;

procedure TRecordingFokoPreviewPresenter.ShowPreparedReport(
  AReport: TfrReport);
begin
  Inc(CallCount);
  PreparedPageCount := AReport.EMFPages.Count;
  TemplatePageCount := AReport.Pages.Count;
end;

function FindRepositoryTemplate: string;
var
  baseDirectory: string;
  candidate: string;
  parentDirectory: string;
  attempt: Integer;
begin
  baseDirectory := ExpandFileName(GetCurrentDir);
  for attempt := 0 to 12 do
  begin
    candidate := IncludeTrailingPathDelimiter(baseDirectory) +
      'Source\AhnWin52\Reports\Unit23Foko.lrf';
    if FileExists(candidate) then
    begin
      Result := candidate;
      Exit;
    end;
    parentDirectory := ExtractFileDir(baseDirectory);
    if parentDirectory = baseDirectory then
      Break;
    baseDirectory := parentDirectory;
  end;
  raise Exception.Create(
    'Could not locate Source\AhnWin52\Reports\Unit23Foko.lrf from the test working directory.');
end;

function CreateSyntheticTable20: TBufDataset;
begin
  Result := TBufDataset.Create(nil);
  Result.Name := 'Table20';
  Result.FieldDefs.Add('STAAT', ftString, 10);
  Result.FieldDefs.Add('PLZ_KZ', ftString, 10);
  Result.FieldDefs.Add('ORT', ftString, 80);
  Result.FieldDefs.Add('TER', ftString, 10);
  Result.FieldDefs.Add('MK', ftString, 10);
  Result.FieldDefs.Add('VON', ftString, 20);
  Result.FieldDefs.Add('BIS', ftString, 20);
  Result.FieldDefs.Add('NAME', ftString, 100);
  Result.FieldDefs.Add('BEKENN', ftString, 20);
  Result.CreateDataset;
  Result.Open;
  Result.AppendRecord(['DE', '12345', 'Synthetic Town', '01', 'A', '1900',
    '1950', 'Synthetic Person', 'TEST-001']);
  Result.AppendRecord(['AT', '54321', 'Sample City', '02', 'B', '1910',
    '1960', 'Example Person', 'TEST-002']);
end;

procedure AssertTemplateMemo(AReport: TfrReport; const AObjectName,
  AExpectedText: string);
var
  reportObject: TfrObject;
begin
  reportObject := AReport.Pages[0].FindObject(AObjectName);
  if not (reportObject is TfrMemoView) then
    raise Exception.CreateFmt('Template object "%s" is not a memo.',
      [AObjectName]);
  if Pos(AExpectedText, TfrMemoView(reportObject).Memo.Text) = 0 then
    raise Exception.CreateFmt('Template object "%s" lacks "%s".',
      [AObjectName, AExpectedText]);
end;

procedure TTestAHW52Unit23FokoReport.
  TestTemplateContainsRecoveredCaptionsAndFieldBindings;
var
  report: TfrReport;
begin
  report := TfrReport.Create(nil);
  try
    report.LoadFromFile(FindRepositoryTemplate);
    AssertEquals(1, report.Pages.Count);
    AssertTemplateMemo(report, 'ReportFileCaption', 'FOKO-Datei:');
    AssertTemplateMemo(report, 'NameCaption', 'Name');
    AssertTemplateMemo(report, 'IdentifierCaption', 'Bek.');
    AssertTemplateMemo(report, 'StateCaption', 'Staat');
    AssertTemplateMemo(report, 'PostalCodeCaption', 'PLZ');
    AssertTemplateMemo(report, 'PlaceCaption', 'Ort');
    AssertTemplateMemo(report, 'TerritoryCaption', 'Terr.');
    AssertTemplateMemo(report, 'MarkerCaption', 'MK');
    AssertTemplateMemo(report, 'FromCaption', 'von');
    AssertTemplateMemo(report, 'UntilCaption', 'bis');
    AssertTemplateMemo(report, 'FooterCaption', 'FOKO-Datei');
    AssertTemplateMemo(report, 'IdentifierField', 'Table20."BEKENN"');
    AssertTemplateMemo(report, 'StateField', 'Table20."STAAT"');
    AssertTemplateMemo(report, 'PostalCodeField', 'Table20."PLZ_KZ"');
    AssertTemplateMemo(report, 'PlaceField', 'Table20."ORT"');
    AssertTemplateMemo(report, 'TerritoryField', 'Table20."TER"');
    AssertTemplateMemo(report, 'MarkerField', 'Table20."MK"');
    AssertTemplateMemo(report, 'FromField', 'Table20."VON"');
    AssertTemplateMemo(report, 'UntilField', 'Table20."BIS"');
    AssertTemplateMemo(report, 'NameField', 'Table20."NAME"');
  finally
    report.Free;
  end;
end;

procedure TTestAHW52Unit23FokoReport.
  TestSyntheticDatasetPreparesReportPages;
var
  dataSet: TBufDataset;
  fokoReport: TFokoListReport;
begin
  dataSet := CreateSyntheticTable20;
  fokoReport := nil;
  try
    AssertEquals('TEST-002', dataSet.FieldByName('BEKENN').AsString);
    fokoReport := TFokoListReport.Create(nil, FindRepositoryTemplate, dataSet);
    AssertEquals(1, fokoReport.TemplatePageCount);
    AssertTrue('Synthetic report preparation should succeed.',
      fokoReport.PrepareReport);
    AssertTrue('Synthetic report should produce at least one page.',
      fokoReport.PreparedPageCount > 0);
    AssertTrue('The caller retains ownership of its dataset.',
      dataSet.Active);
    AssertEquals('TEST-002', dataSet.FieldByName('BEKENN').AsString);
  finally
    fokoReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit23FokoReport.
  TestPrintFailsWithNamedCompatibilityException;
var
  dataSet: TBufDataset;
  fokoReport: TFokoListReport;
  rejected: Boolean;
begin
  dataSet := CreateSyntheticTable20;
  fokoReport := nil;
  try
    fokoReport := TFokoListReport.Create(nil, FindRepositoryTemplate, dataSet);
    rejected := False;
    try
      fokoReport.Print;
    except
      on E: EFokoListReportOperationUnsupported do
      begin
        rejected := True;
        AssertEquals('TfrReport.PrintPreparedReport', E.Operation);
      end;
    end;
    AssertTrue('Unported printing must be rejected explicitly.', rejected);
  finally
    fokoReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit23FokoReport.TestMissingDatasetFieldIsReported;
var
  dataSet: TBufDataset;
  fokoReport: TFokoListReport;
  rejected: Boolean;
begin
  dataSet := TBufDataset.Create(nil);
  dataSet.Name := 'Table20';
  dataSet.FieldDefs.Add('NAME', ftString, 30);
  dataSet.CreateDataset;
  dataSet.Open;
  fokoReport := nil;
  try
    fokoReport := TFokoListReport.Create(nil, FindRepositoryTemplate, dataSet);
    rejected := False;
    try
      fokoReport.PrepareReport;
    except
      on E: EDatabaseError do
      begin
        rejected := True;
        AssertTrue('The missing schema field should be named.',
          Pos('STAAT', E.Message) > 0);
      end;
    end;
    AssertTrue('A missing report field must not yield a false success.',
      rejected);
  finally
    fokoReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit23FokoReport.TestPreviewUsesInjectedPresenter;
var
  dataSet: TBufDataset;
  fokoReport: TFokoListReport;
  presenterObject: TRecordingFokoPreviewPresenter;
  presenter: IFokoListReportPreviewPresenter;
begin
  dataSet := CreateSyntheticTable20;
  fokoReport := nil;
  presenterObject := TRecordingFokoPreviewPresenter.Create;
  presenter := presenterObject;
  try
    fokoReport := TFokoListReport.Create(nil, FindRepositoryTemplate, dataSet);
    AssertTrue(fokoReport.PrepareReport);
    fokoReport.ShowPreview(presenter);
    AssertEquals(1, presenterObject.CallCount);
    AssertTrue('The presenter should receive prepared report pages.',
      presenterObject.PreparedPageCount > 0);
    AssertEquals(1, presenterObject.TemplatePageCount);
  finally
    fokoReport.Free;
    dataSet.Free;
    presenter := nil;
  end;
end;

procedure TTestAHW52Unit23FokoReport.
  TestUnit23LazarusFormLoadsWithoutQuickReportComponents;
var
  reportForm: TFokoFilePrintForm;
begin
  reportForm := TFokoFilePrintForm.Create(nil);
  try
    AssertEquals('FOKO-Datei drucken', reportForm.Caption);
    AssertEquals(0, reportForm.ComponentCount);
  finally
    reportForm.Free;
  end;
end;

procedure TTestAHW52Unit23FokoReport.
  TestUnit23FactoryCreatesOwnedReportBuilder;
var
  dataSet: TBufDataset;
  reportForm: TFokoFilePrintForm;
  fokoReport: TFokoListReport;
begin
  dataSet := CreateSyntheticTable20;
  reportForm := TFokoFilePrintForm.Create(nil);
  try
    fokoReport := reportForm.CreateFokoListReport(FindRepositoryTemplate,
      dataSet);
    AssertTrue('The form should own its report builder.',
      fokoReport.Owner = reportForm);
    AssertTrue(fokoReport.PrepareReport);
  finally
    reportForm.Free;
    AssertTrue('Destroying the form must not destroy the caller dataset.',
      dataSet.Active);
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit23FokoReport.TestPreparedPageIsA4Portrait;
var
  dataSet: TBufDataset;
  fokoReport: TFokoListReport;
  pageDefinition: TReportPageDefinition;
begin
  dataSet := CreateSyntheticTable20;
  fokoReport := nil;
  try
    fokoReport := TFokoListReport.Create(nil, FindRepositoryTemplate, dataSet);
    AssertTrue(fokoReport.PrepareReport);
    AssertEquals(1, fokoReport.GetPageCount);
    pageDefinition := fokoReport.GetPageDefinition(0);
    AssertEquals(595, pageDefinition.WidthPoints);
    AssertEquals(842, pageDefinition.HeightPoints);
    AssertEquals(Ord(rpoPortrait), Ord(pageDefinition.Orientation));
  finally
    fokoReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit23FokoReport.
  TestUnit23WorkflowExportsPdfFromSyntheticDataset;
var
  dataSet: TBufDataset;
  workflow: IFokoListReportWorkflow;
  writer: IReportPdfWriter;
  metadata: TReportPdfMetadata;
  outputFileName: string;
  pdfStream: TFileStream;
  pdfContent: AnsiString;
begin
  dataSet := CreateSyntheticTable20;
  dataSet.Last;
  workflow := TFokoListReportWorkflow.Create;
  writer := TMormotPdfReportWriter.Create;
  outputFileName := IncludeTrailingPathDelimiter(GetTempDir) +
    'AhnWin52-Unit23-' + IntToHex(GetTickCount, 8) + '.pdf';
  try
    metadata.Title := 'Synthetic Unit23 FOKO';
    metadata.Author := 'AhnWin52 tests';
    metadata.Subject := 'Synthetic LazReport PDF slice';
    metadata.Keywords := 'synthetic; report';
    metadata.Creator := 'AhnWin52 test suite';

    workflow.ExportToPdf(dataSet, metadata, outputFileName, writer);

    AssertTrue('PDF output should be created.', FileExists(outputFileName));
    pdfStream := TFileStream.Create(outputFileName, fmOpenRead or fmShareDenyNone);
    try
      AssertTrue('PDF output must contain data.', pdfStream.Size > 0);
      SetLength(pdfContent, pdfStream.Size);
      pdfStream.ReadBuffer(pdfContent[1], Length(pdfContent));
    finally
      pdfStream.Free;
    end;
    AssertEquals('%PDF-', Copy(string(pdfContent), 1, 5));
    AssertTrue('PDF metadata must preserve the caller title.',
      Pos('Synthetic Unit23 FOKO', string(pdfContent)) > 0);
    AssertTrue('PDF output should define a page media box.',
      Pos('/MediaBox', string(pdfContent)) > 0);
    AssertTrue('PDF page should use the recovered Unit23 A4 dimensions.',
      Pos('0 0 595 842', string(pdfContent)) > 0);
    AssertTrue('The caller dataset must remain active.', dataSet.Active);
    AssertEquals('TEST-002', dataSet.FieldByName('BEKENN').AsString);
  finally
    writer := nil;
    workflow := nil;
    dataSet.Free;
    if FileExists(outputFileName) then
      DeleteFile(outputFileName);
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit23FokoReport);

end.
