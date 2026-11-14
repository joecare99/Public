unit tst_AHW52_Unit21FokoPreviewTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit21FokoPreview = class(TTestCase)
  published
    procedure TestButtonDispatchesCallerDatasetToInjectedWorkflow;
    procedure TestWorkflowPreparesEmbeddedTemplateWithoutOpeningPreviewUI;
  end;

implementation

uses
  SysUtils, Classes, DB, BufDataset, FokoListReport, FokoListReportWorkflow, LR_Class,
  ReportPdfContracts, Unit21;

type
  TRecordingFokoWorkflow = class(TInterfacedObject,
    IFokoListReportWorkflow)
  public
    CallCount: Integer;
    ReceivedDataSet: TDataSet;
    procedure Preview(ADataSet: TDataSet);
    procedure ExportToPdf(ADataSet: TDataSet;
      const AMetadata: TReportPdfMetadata; const AFileName: string;
      const AWriter: IReportPdfWriter);
  end;

  TRecordingFokoPreviewPresenter = class(TInterfacedObject,
    IFokoListReportPreviewPresenter)
  public
    CallCount: Integer;
    PreparedPageCount: Integer;
    TemplatePageCount: Integer;
    HasRecoveredNameCaption: Boolean;
    HasRecoveredNameField: Boolean;
    procedure ShowPreparedReport(AReport: TfrReport);
  end;

  TTestableForm21 = class(TForm21)
  private
    FTestDataSet: TDataSet;
  protected
    function GetFokoReportDataSet: TDataSet; override;
  public
    constructor CreateForTest(ADataSet: TDataSet);
  end;

procedure TRecordingFokoWorkflow.Preview(ADataSet: TDataSet);
begin
  Inc(CallCount);
  ReceivedDataSet := ADataSet;
end;

procedure TRecordingFokoWorkflow.ExportToPdf(ADataSet: TDataSet;
  const AMetadata: TReportPdfMetadata; const AFileName: string;
  const AWriter: IReportPdfWriter);
begin
  raise Exception.Create(
    'PDF export is not supported by the recording preview workflow.');
end;

procedure TRecordingFokoPreviewPresenter.ShowPreparedReport(
  AReport: TfrReport);
var
  reportObject: TfrObject;
begin
  Inc(CallCount);
  PreparedPageCount := AReport.EMFPages.Count;
  TemplatePageCount := AReport.Pages.Count;
  reportObject := AReport.Pages[0].FindObject('NameCaption');
  if reportObject is TfrMemoView then
    HasRecoveredNameCaption :=
      Pos('Name', TfrMemoView(reportObject).Memo.Text) > 0;
  reportObject := AReport.Pages[0].FindObject('NameField');
  if reportObject is TfrMemoView then
    HasRecoveredNameField :=
      Pos('Table20."NAME"', TfrMemoView(reportObject).Memo.Text) > 0;
end;

constructor TTestableForm21.CreateForTest(ADataSet: TDataSet);
begin
  CreateNew(nil);
  FTestDataSet := ADataSet;
end;

function TTestableForm21.GetFokoReportDataSet: TDataSet;
begin
  Result := FTestDataSet;
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

procedure TTestAHW52Unit21FokoPreview.
  TestButtonDispatchesCallerDatasetToInjectedWorkflow;
var
  dataSet: TBufDataset;
  form: TTestableForm21;
  workflowObject: TRecordingFokoWorkflow;
  workflow: IFokoListReportWorkflow;
begin
  dataSet := CreateSyntheticTable20;
  form := TTestableForm21.CreateForTest(dataSet);
  workflowObject := TRecordingFokoWorkflow.Create;
  workflow := workflowObject;
  try
    form.ReportPreviewWorkflow := workflow;
    form.SpeedButton2Click(nil);
    AssertEquals(1, workflowObject.CallCount);
    AssertTrue('The FOKO button must pass the active caller dataset.',
      workflowObject.ReceivedDataSet = dataSet);
  finally
    form.Free;
    workflow := nil;
    dataSet.Free;
  end;
end;

procedure TTestAHW52Unit21FokoPreview.
  TestWorkflowPreparesEmbeddedTemplateWithoutOpeningPreviewUI;
var
  dataSet: TBufDataset;
  workflow: IFokoListReportWorkflow;
  presenterObject: TRecordingFokoPreviewPresenter;
  presenter: IFokoListReportPreviewPresenter;
  currentIdentifier: string;
begin
  dataSet := CreateSyntheticTable20;
  currentIdentifier := dataSet.FieldByName('BEKENN').AsString;
  presenterObject := TRecordingFokoPreviewPresenter.Create;
  presenter := presenterObject;
  workflow := TFokoListReportWorkflow.Create(presenter);
  try
    workflow.Preview(dataSet);
    AssertEquals(1, presenterObject.CallCount);
    AssertEquals(1, presenterObject.TemplatePageCount);
    AssertTrue('The embedded report should prepare synthetic report pages.',
      presenterObject.PreparedPageCount > 0);
    AssertTrue('The embedded layout should contain the recovered caption.',
      presenterObject.HasRecoveredNameCaption);
    AssertTrue('The embedded layout should bind the recovered NAME field.',
      presenterObject.HasRecoveredNameField);
    AssertTrue('The report workflow must preserve caller dataset ownership.',
      dataSet.Active);
    AssertEquals(currentIdentifier,
      dataSet.FieldByName('BEKENN').AsString);
  finally
    workflow := nil;
    presenter := nil;
    dataSet.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit21FokoPreview);

end.
