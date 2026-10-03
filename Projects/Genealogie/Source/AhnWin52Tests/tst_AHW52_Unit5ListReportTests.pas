unit tst_AHW52_Unit5ListReportTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit5ListReport = class(TTestCase)
  published
    procedure TestDFMLayoutIsRepresentedAsSingleColumnLazReport;
    procedure TestSyntheticRowsPrepareAndPreserveCallerDataset;
    procedure TestMissingDFMFieldIsReported;
    procedure TestUnit5FormCreatesOwnedLazReportBuilder;
  end;

implementation

uses
  SysUtils, DB, BufDataset, Forms, LR_Class, Unit5ListReport, SingleColumnA4ReportForm;

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

procedure TTestAHW52Unit5ListReport.
  TestDFMLayoutIsRepresentedAsSingleColumnLazReport;
var
  dataSet: TBufDataset;
  listReport: TUnit5ListReport;
  reportObject: TfrObject;
  fieldIndex: Integer;
begin
  dataSet := CreateSyntheticRows;
  listReport := TUnit5ListReport.Create(nil, dataSet);
  try
    AssertEquals(1, listReport.Report.Pages.Count);
    AssertEquals(1, listReport.TemplateColumnCount);
    AssertEquals('Unit5Rows', listReport.Report.Dataset.Name);
    AssertMemo(listReport.Report, 'Caption1', 'QRLabel1');
    AssertMemo(listReport.Report, 'Caption2', 'QRLabel2');
    AssertMemo(listReport.Report, 'QRDBText1', 'Unit5Rows."QRDBText1"');
    AssertMemo(listReport.Report, 'QRDBText2', 'Unit5Rows."QRDBText2"');
    AssertMemo(listReport.Report, 'QRDBText15', 'Unit5Rows."QRDBText15"');
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
    AssertNull(listReport.Report.Pages[0].FindObject('QRImage1'));
  finally
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit5ListReport.
  TestSyntheticRowsPrepareAndPreserveCallerDataset;
var
  dataSet: TBufDataset;
  listReport: TUnit5ListReport;
  currentEntry: string;
begin
  dataSet := CreateSyntheticRows;
  listReport := nil;
  try
    dataSet.Last;
    currentEntry := dataSet.FieldByName('QRDBText1').AsString;
    listReport := TUnit5ListReport.Create(nil, dataSet);
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

procedure TTestAHW52Unit5ListReport.TestMissingDFMFieldIsReported;
var
  dataSet: TBufDataset;
  listReport: TUnit5ListReport;
  rejected: Boolean;
begin
  dataSet := TBufDataset.Create(nil);
  dataSet.Name := 'SyntheticRows';
  dataSet.FieldDefs.Add('QRDBText1', ftString, 40);
  dataSet.CreateDataset;
  dataSet.Open;
  listReport := TUnit5ListReport.Create(nil, dataSet);
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

procedure TTestAHW52Unit5ListReport.
  TestUnit5FormCreatesOwnedLazReportBuilder;
var
  dataSet: TBufDataset;
  reportForm: TSingleColumnA4ReportForm;
  listReport: TUnit5ListReport;
begin
  dataSet := CreateSyntheticRows;
  reportForm := TSingleColumnA4ReportForm.Create(nil);
  try
    AssertEquals('Form5', reportForm.Caption);
    AssertEquals(0, reportForm.ComponentCount);
    listReport := reportForm.CreateUnit5ListReport(dataSet);
    AssertTrue('The Unit5 form should own its LazReport builder.',
      listReport.Owner = reportForm);
    AssertTrue(listReport.PrepareReport);
  finally
    reportForm.Free;
    AssertTrue('The form must not destroy the caller dataset.', dataSet.Active);
    dataSet.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit5ListReport);

end.
