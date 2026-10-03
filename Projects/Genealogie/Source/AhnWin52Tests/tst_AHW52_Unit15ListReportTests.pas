unit tst_AHW52_Unit15ListReportTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit15ListReport = class(TTestCase)
  published
    procedure TestDFMLayoutIsRepresentedAsSingleColumnLazReport;
    procedure TestSyntheticRowsPrepareAndPreserveCallerDataset;
    procedure TestMissingDFMFieldIsReported;
    procedure TestUnit15FormCreatesOwnedLazReportBuilder;
    procedure TestPreparedPagesExposePdfPageContract;
    procedure TestUnit15ReportExportsPdfFromSyntheticRows;
  end;

implementation

uses
  SysUtils, Classes, DB, BufDataset, Forms, Graphics, LR_Class, Types,
  Unit15ListReport, SingleColumnA4ReportVariantForm, ReportPdfContracts, MormotPdfReportWriter;

function CreateSyntheticRows: TBufDataset;
var
  fieldIndex: Integer;
begin
  Result := TBufDataset.Create(nil);
  Result.Name := 'SyntheticRows';
  for fieldIndex := 1 to 15 do
    Result.FieldDefs.Add(Format('QRDBText%d', [fieldIndex]), ftString, 40);
  Result.CreateDataset;
  Result.Open;
  Result.AppendRecord(['Field 1', 'Field 2', 'Field 3', 'Field 4',
    'Field 5', 'Field 6', 'Field 7', 'Field 8', 'Field 9', 'Field 10',
    'Field 11', 'Field 12', 'Field 13', 'Field 14', 'Field 15']);
  Result.AppendRecord(['Other 1', 'Other 2', 'Other 3', 'Other 4',
    'Other 5', 'Other 6', 'Other 7', 'Other 8', 'Other 9', 'Other 10',
    'Other 11', 'Other 12', 'Other 13', 'Other 14', 'Other 15']);
end;

function NewTemporaryPdfName: string;
var
  fileId: TGUID;
begin
  if CreateGUID(fileId) <> 0 then
    raise Exception.Create('Could not create test output file name.');
  Result := IncludeTrailingPathDelimiter(GetTempDir) +
    'AhnWin52-Unit15-' + GUIDToString(fileId) + '.pdf';
end;

procedure AssertMemo(AReport: TfrReport; const AObjectName, AExpectedText: string);
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

procedure TTestAHW52Unit15ListReport.
  TestDFMLayoutIsRepresentedAsSingleColumnLazReport;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  reportObject: TfrObject;
  fieldIndex: Integer;
begin
  dataSet := CreateSyntheticRows;
  listReport := TUnit15ListReport.Create(nil, dataSet);
  try
    AssertEquals(1, listReport.Report.Pages.Count);
    AssertEquals(1, listReport.TemplateColumnCount);
    AssertEquals('Unit15Rows', listReport.Report.Dataset.Name);
    AssertMemo(listReport.Report, 'Caption1', 'QRLabel1');
    AssertMemo(listReport.Report, 'Caption2', 'QRLabel2');
    AssertMemo(listReport.Report, 'QRDBText1', 'Unit15Rows."QRDBText1"');
    AssertMemo(listReport.Report, 'QRDBText2', 'Unit15Rows."QRDBText2"');
    AssertMemo(listReport.Report, 'QRDBText15', 'Unit15Rows."QRDBText15"');
    AssertMemo(listReport.Report, 'PrintedDate', '[DATE]');
    AssertMemo(listReport.Report, 'PageNumber', '[PAGE#]');
    AssertMemo(listReport.Report, 'QRMemo1', #13#10);
    for fieldIndex := 3 to 15 do
    begin
      reportObject := listReport.Report.Pages[0].FindObject(
        Format('QRDBText%d', [fieldIndex]));
      AssertNotNull(reportObject);
      AssertFalse(Format('DFM field QRDBText%d remains hidden.', [fieldIndex]),
        reportObject.Visible);
    end;
    AssertNull(listReport.Report.Pages[0].FindObject('QRImage4'));
  finally
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestSyntheticRowsPrepareAndPreserveCallerDataset;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  currentEntry: string;
begin
  dataSet := CreateSyntheticRows;
  listReport := nil;
  try
    dataSet.Last;
    currentEntry := dataSet.FieldByName('QRDBText1').AsString;
    listReport := TUnit15ListReport.Create(nil, dataSet);
    AssertTrue('The report should prepare its two synthetic rows.',
      listReport.PrepareReport);
    AssertTrue('Preparation should produce at least one report page.',
      listReport.PreparedPageCount > 0);
    AssertTrue('The caller retains ownership of the dataset.', dataSet.Active);
    AssertEquals(currentEntry, dataSet.FieldByName('QRDBText1').AsString);
  finally
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.TestMissingDFMFieldIsReported;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  rejected: Boolean;
begin
  dataSet := TBufDataset.Create(nil);
  dataSet.Name := 'SyntheticRows';
  dataSet.FieldDefs.Add('QRDBText1', ftString, 40);
  dataSet.CreateDataset;
  dataSet.Open;
  listReport := TUnit15ListReport.Create(nil, dataSet);
  try
    rejected := False;
    try
      listReport.PrepareReport;
    except
      on E: EDatabaseError do
      begin
        rejected := True;
        AssertTrue('The missing DFM field should be identified.',
          Pos('QRDBText2', E.Message) > 0);
      end;
    end;
    AssertTrue('A missing report field must not return false success.',
      rejected);
  finally
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.
  TestUnit15FormCreatesOwnedLazReportBuilder;
var
  dataSet: TBufDataset;
  reportForm: TSingleColumnA4ReportVariantForm;
  listReport: TUnit15ListReport;
begin
  dataSet := CreateSyntheticRows;
  reportForm := TSingleColumnA4ReportVariantForm.Create(nil);
  try
    AssertEquals('Form15', reportForm.Caption);
    AssertEquals(0, reportForm.ComponentCount);
    listReport := reportForm.CreateUnit15ListReport(dataSet);
    AssertTrue('The Unit15 form should own its LazReport builder.',
      listReport.Owner = reportForm);
    AssertTrue(listReport.PrepareReport);
  finally
    reportForm.Free;
    AssertTrue('The form must not destroy the caller dataset.', dataSet.Active);
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.TestPreparedPagesExposePdfPageContract;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  pageSource: IReportPageSource;
  pageDefinition: TReportPageDefinition;
begin
  dataSet := CreateSyntheticRows;
  listReport := TUnit15ListReport.Create(nil, dataSet);
  pageSource := listReport;
  try
    AssertTrue(listReport.PrepareReport);
    AssertTrue('The prepared report should expose at least one page.',
      pageSource.GetPageCount > 0);
    pageDefinition := pageSource.GetPageDefinition(0);
    AssertEquals(595, pageDefinition.WidthPoints);
    AssertEquals(842, pageDefinition.HeightPoints);
    AssertEquals(Ord(rpoPortrait), Ord(pageDefinition.Orientation));
  finally
    pageSource := nil;
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit15ListReport.TestUnit15ReportExportsPdfFromSyntheticRows;
var
  dataSet: TBufDataset;
  listReport: TUnit15ListReport;
  writer: IReportPdfWriter;
  metadata: TReportPdfMetadata;
  outputFileName: string;
  pdfStream: TFileStream;
  pdfContent: AnsiString;
begin
  dataSet := CreateSyntheticRows;
  dataSet.Last;
  listReport := nil;
  writer := TMormotPdfReportWriter.Create;
  outputFileName := NewTemporaryPdfName;
  try
    metadata.Title := 'Synthetic Unit15 list report';
    metadata.Author := 'AhnWin52 tests';
    metadata.Subject := 'Recovered Unit15 layout';
    metadata.Keywords := 'synthetic; Unit15';
    metadata.Creator := 'AhnWin52 test suite';
    listReport := TUnit15ListReport.Create(nil, dataSet);
    listReport.ExportToPdf(metadata, outputFileName, writer);

    AssertTrue('The Unit15 PDF should be created.', FileExists(outputFileName));
    pdfStream := TFileStream.Create(outputFileName,
      fmOpenRead or fmShareDenyNone);
    try
      AssertTrue('The Unit15 PDF should contain data.', pdfStream.Size > 0);
      SetLength(pdfContent, pdfStream.Size);
      pdfStream.ReadBuffer(pdfContent[1], Length(pdfContent));
    finally
      pdfStream.Free;
    end;
    AssertEquals('%PDF-', Copy(string(pdfContent), 1, 5));
    AssertTrue('The Unit15 PDF should contain its requested title.',
      Pos('Synthetic Unit15 list report', string(pdfContent)) > 0);
    AssertTrue('The Unit15 PDF should use recovered A4 page dimensions.',
      Pos('0 0 595 842', string(pdfContent)) > 0);
    AssertTrue('The caller dataset should remain active.', dataSet.Active);
    AssertEquals('Other 1', dataSet.FieldByName('QRDBText1').AsString);
  finally
    listReport.Free;
    writer := nil;
    dataSet.Free;
    if FileExists(outputFileName) then
      DeleteFile(outputFileName);
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit15ListReport);

end.
