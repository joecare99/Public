unit Unit15ListReport;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, DB, Graphics, LR_Class, LR_DBSet, Printers, Types,
  ReportPdfContracts;

type
  /// Prepares the recovered Unit15 layout using a caller-owned dataset.
  TUnit15ListReport = class(TComponent, IReportPageSource)
  private
    FDataSet: TDataSet;
    FReport: TfrReport;
    FReportDataSet: TfrDBDataSet;
    FPrepared: Boolean;
    procedure BindDataSet;
    procedure RequirePreparedPage(AIndex: Integer);
    procedure ValidateDataSet;
  public
    /// Loads the embedded Unit15 layout and binds the supplied dataset.
    constructor Create(AOwner: TComponent; ADataSet: TDataSet); reintroduce;
    /// Builds report pages without opening or replacing the supplied dataset.
    function PrepareReport: Boolean;
    /// Number of pages produced by the most recent preparation.
    function PreparedPageCount: Integer;
    /// Number of columns defined by the recovered report layout.
    function TemplateColumnCount: Integer;
    /// Exposes prepared Unit15 report pages through the shared PDF contract.
    function GetPageCount: Integer;
    /// Returns the recovered physical size and orientation for a page.
    function GetPageDefinition(AIndex: Integer): TReportPageDefinition;
    /// Renders a prepared report page onto a caller-owned canvas.
    procedure RenderPage(AIndex: Integer; ACanvas: TCanvas;
      const ATargetBounds: TRect);
    /// Prepares and writes the report through a caller-selected PDF provider.
    procedure ExportToPdf(const AMetadata: TReportPdfMetadata;
      const AFileName: string; const AWriter: IReportPdfWriter);
    /// Dataset supplied by the caller; ownership remains with the caller.
    property DataSet: TDataSet read FDataSet;
    /// Loaded LazReport template and prepared report.
    property Report: TfrReport read FReport;
  end;

implementation

uses
  SysUtils, Unit15ListReportTemplateResource;

const
  RequiredFields: array[0..14] of string = (
    'QRDBText1', 'QRDBText2', 'QRDBText3', 'QRDBText4', 'QRDBText5',
    'QRDBText6', 'QRDBText7', 'QRDBText8', 'QRDBText9', 'QRDBText10',
    'QRDBText11', 'QRDBText12', 'QRDBText13', 'QRDBText14', 'QRDBText15');

constructor TUnit15ListReport.Create(AOwner: TComponent; ADataSet: TDataSet);
var
  templateStream: TStream;
begin
  inherited Create(AOwner);
  if ADataSet = nil then
    raise EArgumentNilException.Create('ADataSet');

  FDataSet := ADataSet;
  FReport := TfrReport.Create(Self);
  FReport.ShowProgress := False;
  templateStream := CreateUnit15ListReportTemplateStream;
  try
    FReport.LoadFromXMLStream(templateStream);
  finally
    templateStream.Free;
  end;
  BindDataSet;
end;

procedure TUnit15ListReport.BindDataSet;
begin
  FReportDataSet := TfrDBDataSet.Create(FReport);
  FReportDataSet.Name := 'Unit15Rows';
  FReportDataSet.DataSet := FDataSet;
  FReportDataSet.OpenDataSource := False;
  FReport.Dataset := FReportDataSet;
end;

procedure TUnit15ListReport.ValidateDataSet;
var
  fieldIndex: Integer;
begin
  if not FDataSet.Active then
    raise EDatabaseError.Create(
      'The Unit15 report requires an already active dataset.');

  for fieldIndex := Low(RequiredFields) to High(RequiredFields) do
    if FDataSet.FindField(RequiredFields[fieldIndex]) = nil then
      raise EDatabaseError.CreateFmt(
        'The Unit15 report dataset is missing required field "%s".',
        [RequiredFields[fieldIndex]]);
end;

function TUnit15ListReport.PrepareReport: Boolean;
var
  bookmark: TBookmark;
begin
  ValidateDataSet;
  FPrepared := False;
  bookmark := FDataSet.GetBookmark;
  try
    Result := FReport.PrepareReport;
    FPrepared := Result;
  finally
    try
      if FDataSet.BookmarkValid(bookmark) then
        FDataSet.GotoBookmark(bookmark);
    finally
      FDataSet.FreeBookmark(bookmark);
    end;
  end;
end;

function TUnit15ListReport.PreparedPageCount: Integer;
begin
  Result := FReport.EMFPages.Count;
end;

function TUnit15ListReport.TemplateColumnCount: Integer;
begin
  if FReport.Pages.Count = 0 then
    Result := 0
  else
    Result := TfrPageReport(FReport.Pages[0]).ColCount;
end;

procedure TUnit15ListReport.RequirePreparedPage(AIndex: Integer);
begin
  if not FPrepared then
    raise EReportPdfStateError.Create(
      'The Unit15 report must be prepared before accessing its pages.');
  if (AIndex < 0) or (AIndex >= FReport.EMFPages.Count) then
    raise ERangeError.CreateFmt(
      'Prepared Unit15 report page index %d is outside the available range.',
      [AIndex]);
end;

function TUnit15ListReport.GetPageCount: Integer;
begin
  if not FPrepared then
    raise EReportPdfStateError.Create(
      'The Unit15 report must be prepared before accessing its pages.');
  Result := FReport.EMFPages.Count;
end;

function TUnit15ListReport.GetPageDefinition(
  AIndex: Integer): TReportPageDefinition;
var
  pageInfo: PfrPageInfo;
begin
  RequirePreparedPage(AIndex);
  pageInfo := FReport.EMFPages[AIndex];
  Result.WidthPoints := pageInfo^.pgWidth;
  Result.HeightPoints := pageInfo^.pgHeight;
  if pageInfo^.pgOr = poLandscape then
    Result.Orientation := rpoLandscape
  else
    Result.Orientation := rpoPortrait;
end;

procedure TUnit15ListReport.RenderPage(AIndex: Integer; ACanvas: TCanvas;
  const ATargetBounds: TRect);
begin
  RequirePreparedPage(AIndex);
  if ACanvas = nil then
    raise EArgumentNilException.Create('ACanvas');
  FReport.EMFPages.Draw(AIndex, ACanvas, ATargetBounds);
end;

procedure TUnit15ListReport.ExportToPdf(
  const AMetadata: TReportPdfMetadata; const AFileName: string;
  const AWriter: IReportPdfWriter);
var
  pageSource: IReportPageSource;
begin
  if not PrepareReport then
    raise EReportPdfError.Create(
      'LazReport did not prepare the Unit15 list report.');
  pageSource := Self;
  try
    ExportReportToPdf(AMetadata, pageSource, AWriter, AFileName);
  finally
    pageSource := nil;
  end;
end;

end.
