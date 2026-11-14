unit FokoListReport;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, DB, Graphics, Printers, Types, LR_Class, LR_DBSet,
  ReportPdfContracts;

type
  IFokoListReportPreviewPresenter = interface
    ['{9E882C7D-9DA9-4BB3-8F15-8309DEB0E330}']
    procedure ShowPreparedReport(AReport: TfrReport);
  end;

  /// Prepares the recovered Unit23 FOKO list layout from a caller-owned dataset.
  TFokoListReport = class(TComponent, IReportPageSource)
  private
    FDataSet: TDataSet;
    FReport: TfrReport;
    FReportDataSet: TfrDBDataSet;
    FTemplateFileName: string;
    FPrepared: Boolean;
    procedure Initialize(ADataSet: TDataSet);
    procedure BindDataSet;
    procedure ValidateDataSet;
    procedure RequirePreparedPage(AIndex: Integer);
  public
    /// Loads the LazReport template and binds the already-named Table20 dataset.
    constructor Create(AOwner: TComponent; const ATemplateFileName: string;
      ADataSet: TDataSet); reintroduce; overload;
    /// Loads a caller-owned template stream and binds the already-named Table20 dataset.
    /// The caller retains ownership of the stream.
    constructor CreateFromStream(AOwner: TComponent; ATemplateStream: TStream;
      ADataSet: TDataSet);
    /// Builds the report pages without opening or replacing the supplied dataset.
    function PrepareReport: Boolean;
    /// Shows a prepared report through the supplied presenter or LazReport preview UI.
    procedure ShowPreview(
      const APreviewPresenter: IFokoListReportPreviewPresenter = nil);
    /// Printing remains unavailable until printer behavior is migrated.
    procedure Print;
    /// Number of pages produced by the most recent preparation.
    function PreparedPageCount: Integer;
    /// Number of pages defined by the loaded report template.
    function TemplatePageCount: Integer;
    /// Number of generated pages, through the provider-neutral PDF page contract.
    function GetPageCount: Integer;
    /// Returns the recovered dimensions and orientation for a prepared page.
    function GetPageDefinition(AIndex: Integer): TReportPageDefinition;
    /// Draws a prepared page onto a supplied canvas without taking its ownership.
    procedure RenderPage(AIndex: Integer; ACanvas: TCanvas;
      const ATargetBounds: TRect);
    /// Dataset supplied by the caller; ownership remains with the caller.
    property DataSet: TDataSet read FDataSet;
  end;

implementation

uses
  SysUtils, FokoListReportCompatibilityError;

const
  RequiredFields: array[0..8] of string = (
    'STAAT', 'PLZ_KZ', 'ORT', 'TER', 'MK', 'VON', 'BIS', 'NAME', 'BEKENN');

constructor TFokoListReport.Create(AOwner: TComponent;
  const ATemplateFileName: string; ADataSet: TDataSet);
begin
  inherited Create(AOwner);
  if not FileExists(ATemplateFileName) then
    raise EFOpenError.CreateFmt('FOKO report template not found: "%s".',
      [ATemplateFileName]);

  Initialize(ADataSet);
  FTemplateFileName := ATemplateFileName;
  FReport.LoadFromFile(FTemplateFileName);
  BindDataSet;
end;

constructor TFokoListReport.CreateFromStream(AOwner: TComponent;
  ATemplateStream: TStream; ADataSet: TDataSet);
begin
  inherited Create(AOwner);
  if ATemplateStream = nil then
    raise EArgumentNilException.Create('ATemplateStream');

  Initialize(ADataSet);
  FTemplateFileName := '-stream-';
  FReport.LoadFromXMLStream(ATemplateStream);
  BindDataSet;
end;

procedure TFokoListReport.Initialize(ADataSet: TDataSet);
begin
  if ADataSet = nil then
    raise EArgumentNilException.Create('ADataSet');
  if not SameText(ADataSet.Name, 'Table20') then
    raise EArgumentException.CreateFmt(
      'The Unit23 report requires the resource-bound Table20 dataset; got "%s".',
      [ADataSet.Name]);

  FDataSet := ADataSet;
  FReport := TfrReport.Create(Self);
  FReport.ShowProgress := False;
end;

procedure TFokoListReport.BindDataSet;
begin
  FReportDataSet := TfrDBDataSet.Create(FReport);
  FReportDataSet.Name := 'FokoReportDataSet';
  FReportDataSet.DataSet := FDataSet;
  FReportDataSet.OpenDataSource := False;
  FReport.Dataset := FReportDataSet;
end;

procedure TFokoListReport.ValidateDataSet;
var
  fieldIndex: Integer;
begin
  if not FDataSet.Active then
    raise EDatabaseError.Create(
      'The Unit23 report requires an already active Table20 dataset.');

  for fieldIndex := Low(RequiredFields) to High(RequiredFields) do
    if FDataSet.FindField(RequiredFields[fieldIndex]) = nil then
      raise EDatabaseError.CreateFmt(
        'The synthetic/report dataset is missing required field "%s".',
        [RequiredFields[fieldIndex]]);
end;

function TFokoListReport.PrepareReport: Boolean;
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

procedure TFokoListReport.ShowPreview(
  const APreviewPresenter: IFokoListReportPreviewPresenter);
begin
  if APreviewPresenter <> nil then
    APreviewPresenter.ShowPreparedReport(FReport)
  else
    FReport.ShowPreparedReport;
end;

procedure TFokoListReport.Print;
begin
  raise EFokoListReportOperationUnsupported.Create(
    'TfrReport.PrintPreparedReport');
end;

function TFokoListReport.PreparedPageCount: Integer;
begin
  Result := FReport.EMFPages.Count;
end;

function TFokoListReport.TemplatePageCount: Integer;
begin
  Result := FReport.Pages.Count;
end;

procedure TFokoListReport.RequirePreparedPage(AIndex: Integer);
begin
  if not FPrepared then
    raise EReportPdfStateError.Create(
      'The Unit23 report must be prepared before accessing its pages.');
  if (AIndex < 0) or (AIndex >= FReport.EMFPages.Count) then
    raise ERangeError.CreateFmt(
      'Prepared report page index %d is outside the available range.',
      [AIndex]);
end;

function TFokoListReport.GetPageCount: Integer;
begin
  if not FPrepared then
    raise EReportPdfStateError.Create(
      'The Unit23 report must be prepared before accessing its pages.');
  Result := FReport.EMFPages.Count;
end;

function TFokoListReport.GetPageDefinition(
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

procedure TFokoListReport.RenderPage(AIndex: Integer; ACanvas: TCanvas;
  const ATargetBounds: TRect);
begin
  RequirePreparedPage(AIndex);
  if ACanvas = nil then
    raise EArgumentNilException.Create('ACanvas');
  FReport.EMFPages.Draw(AIndex, ACanvas, ATargetBounds);
end;

end.
