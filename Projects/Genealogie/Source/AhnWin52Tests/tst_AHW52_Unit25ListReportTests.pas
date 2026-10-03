unit tst_AHW52_Unit25ListReportTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit25ListReport = class(TTestCase)
  published
    procedure TestDFMLayoutIsRepresentedAsTwoColumnLazReport;
    procedure TestSyntheticRowsPrepareAndPreserveCallerDataset;
    procedure TestMissingDFMFieldIsReported;
    procedure TestUnit25FormCreatesOwnedLazReportBuilder;
  end;

implementation

uses
  SysUtils, DB, BufDataset, Forms, LR_Class, Unit25ListReport, Unit25;

function CreateSyntheticRows: TBufDataset;
begin
  Result := TBufDataset.Create(nil);
  Result.Name := 'SyntheticRows';
  Result.FieldDefs.Add('QRDBText1', ftString, 40);
  Result.FieldDefs.Add('QRDBText2', ftString, 80);
  Result.FieldDefs.Add('QRDBText10', ftString, 20);
  Result.FieldDefs.Add('QRDBText11', ftString, 20);
  Result.FieldDefs.Add('QRDBText12', ftString, 20);
  Result.FieldDefs.Add('QRDBText13', ftString, 20);
  Result.FieldDefs.Add('QRDBText14', ftString, 20);
  Result.FieldDefs.Add('QRDBText15', ftString, 20);
  Result.CreateDataset;
  Result.Open;
  Result.AppendRecord(['Entry 1', 'Synthetic details 1', '10', '11', '12',
    '13', '14', '15']);
  Result.AppendRecord(['Entry 2', 'Synthetic details 2', '20', '21', '22',
    '23', '24', '25']);
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

procedure TTestAHW52Unit25ListReport.
  TestDFMLayoutIsRepresentedAsTwoColumnLazReport;
var
  dataSet: TBufDataset;
  listReport: TUnit25ListReport;
  reportObject: TfrObject;
begin
  dataSet := CreateSyntheticRows;
  listReport := TUnit25ListReport.Create(nil, dataSet);
  try
    AssertEquals(1, listReport.Report.Pages.Count);
    AssertEquals(2, listReport.TemplateColumnCount);
    AssertEquals('Unit25Rows', listReport.Report.Dataset.Name);
    AssertMemo(listReport.Report, 'HeaderCaption', 'QRLabel1');
    AssertMemo(listReport.Report, 'QRDBText1', 'Unit25Rows."QRDBText1"');
    AssertMemo(listReport.Report, 'QRDBText2', 'Unit25Rows."QRDBText2"');
    AssertMemo(listReport.Report, 'QRDBText15', 'Unit25Rows."QRDBText15"');
    AssertMemo(listReport.Report, 'PrintedDate', '[DATE]');
    AssertMemo(listReport.Report, 'PageNumber', '[PAGE#]');
    reportObject := listReport.Report.Pages[0].FindObject('QRDBText10');
    AssertNotNull(reportObject);
    AssertFalse('The six disabled DFM fields remain hidden.',
      reportObject.Visible);
  finally
    listReport.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit25ListReport.
  TestSyntheticRowsPrepareAndPreserveCallerDataset;
var
  dataSet: TBufDataset;
  listReport: TUnit25ListReport;
  currentEntry: string;
begin
  dataSet := CreateSyntheticRows;
  listReport := nil;
  try
    dataSet.Last;
    currentEntry := dataSet.FieldByName('QRDBText1').AsString;
    listReport := TUnit25ListReport.Create(nil, dataSet);
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

procedure TTestAHW52Unit25ListReport.TestMissingDFMFieldIsReported;
var
  dataSet: TBufDataset;
  listReport: TUnit25ListReport;
  rejected: Boolean;
begin
  dataSet := TBufDataset.Create(nil);
  dataSet.Name := 'SyntheticRows';
  dataSet.FieldDefs.Add('QRDBText1', ftString, 40);
  dataSet.CreateDataset;
  dataSet.Open;
  listReport := TUnit25ListReport.Create(nil, dataSet);
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

procedure TTestAHW52Unit25ListReport.
  TestUnit25FormCreatesOwnedLazReportBuilder;
var
  dataSet: TBufDataset;
  reportForm: TForm25;
  listReport: TUnit25ListReport;
begin
  dataSet := CreateSyntheticRows;
  reportForm := TForm25.Create(nil);
  try
    AssertEquals('Form25', reportForm.Caption);
    AssertEquals(0, reportForm.ComponentCount);
    listReport := reportForm.CreateUnit25ListReport(dataSet);
    AssertTrue('The Unit25 form should own its LazReport builder.',
      listReport.Owner = reportForm);
    AssertTrue(listReport.PrepareReport);
  finally
    reportForm.Free;
    AssertTrue('The form must not destroy the caller dataset.', dataSet.Active);
    dataSet.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit25ListReport);

end.
