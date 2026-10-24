unit FokoListReportWorkflow;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, DB, FokoListReport, ReportPdfContracts;

type
  /// Dispatches an already-active FOKO dataset through the recovered report.
  IFokoListReportWorkflow = interface
    ['{3DB0315D-55C8-4AA9-A826-A3E206991226}']
    procedure Preview(ADataSet: TDataSet);
    procedure ExportToPdf(ADataSet: TDataSet;
      const AMetadata: TReportPdfMetadata; const AFileName: string;
      const AWriter: IReportPdfWriter);
  end;

  /// Prepares the embedded Unit23 layout and opens its LazReport preview.
  TFokoListReportWorkflow = class(TInterfacedObject, IFokoListReportWorkflow)
  private
    FPreviewPresenter: IFokoListReportPreviewPresenter;
  public
    constructor Create(
      const APreviewPresenter: IFokoListReportPreviewPresenter = nil);
    procedure Preview(ADataSet: TDataSet);
    procedure ExportToPdf(ADataSet: TDataSet;
      const AMetadata: TReportPdfMetadata; const AFileName: string;
      const AWriter: IReportPdfWriter);
  end;

implementation

uses
  SysUtils, LR_Class, FokoListReportCompatibilityError,
  FokoListReportTemplateResource;

constructor TFokoListReportWorkflow.Create(
  const APreviewPresenter: IFokoListReportPreviewPresenter);
begin
  inherited Create;
  FPreviewPresenter := APreviewPresenter;
end;

procedure TFokoListReportWorkflow.Preview(ADataSet: TDataSet);
var
  templateStream: TStream;
  report: TFokoListReport;
begin
  templateStream := CreateFokoListReportTemplateStream;
  try
    report := TFokoListReport.CreateFromStream(nil, templateStream, ADataSet);
    try
      if not report.PrepareReport then
        raise EFokoListReportPreparationFailed.Create(
          'LazReport did not prepare the Unit23 FOKO report.');
      report.ShowPreview(FPreviewPresenter);
    finally
      report.Free;
    end;
  finally
    templateStream.Free;
  end;
end;

procedure TFokoListReportWorkflow.ExportToPdf(ADataSet: TDataSet;
  const AMetadata: TReportPdfMetadata; const AFileName: string;
  const AWriter: IReportPdfWriter);
var
  templateStream: TStream;
  report: TFokoListReport;
  pageSource: IReportPageSource;
begin
  templateStream := CreateFokoListReportTemplateStream;
  try
    report := TFokoListReport.CreateFromStream(nil, templateStream, ADataSet);
    try
      if not report.PrepareReport then
        raise EFokoListReportPreparationFailed.Create(
          'LazReport did not prepare the Unit23 FOKO report.');
      pageSource := report;
      ExportReportToPdf(AMetadata, pageSource, AWriter, AFileName);
    finally
      pageSource := nil;
      report.Free;
    end;
  finally
    templateStream.Free;
  end;
end;

end.
