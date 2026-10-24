unit Unit25ListReport;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, DB, LR_Class, LR_DBSet;

type
  /// Prepares the recovered Unit25 list layout from a caller-owned dataset.
  TUnit25ListReport = class(TComponent)
  private
    FDataSet: TDataSet;
    FReport: TfrReport;
    FReportDataSet: TfrDBDataSet;
    procedure BindDataSet;
    procedure ValidateDataSet;
  public
    /// Loads the embedded layout and binds the caller-provided dataset.
    constructor Create(AOwner: TComponent; ADataSet: TDataSet); reintroduce;
    /// Builds report pages without opening or replacing the supplied dataset.
    function PrepareReport: Boolean;
    /// Number of pages produced by the most recent preparation.
    function PreparedPageCount: Integer;
    /// Number of columns defined by the recovered report layout.
    function TemplateColumnCount: Integer;
    /// Dataset supplied by the caller; ownership remains with the caller.
    property DataSet: TDataSet read FDataSet;
    /// Loaded LazReport template and prepared report.
    property Report: TfrReport read FReport;
  end;

implementation

uses
  SysUtils, Unit25ListReportTemplateResource;

const
  RequiredFields: array[0..7] of string = (
    'QRDBText1', 'QRDBText2', 'QRDBText10', 'QRDBText11',
    'QRDBText12', 'QRDBText13', 'QRDBText14', 'QRDBText15');

constructor TUnit25ListReport.Create(AOwner: TComponent; ADataSet: TDataSet);
var
  templateStream: TStream;
begin
  inherited Create(AOwner);
  if ADataSet = nil then
    raise EArgumentNilException.Create('ADataSet');

  FDataSet := ADataSet;
  FReport := TfrReport.Create(Self);
  FReport.ShowProgress := False;
  templateStream := CreateUnit25ListReportTemplateStream;
  try
    FReport.LoadFromXMLStream(templateStream);
  finally
    templateStream.Free;
  end;
  BindDataSet;
end;

procedure TUnit25ListReport.BindDataSet;
begin
  FReportDataSet := TfrDBDataSet.Create(FReport);
  FReportDataSet.Name := 'Unit25Rows';
  FReportDataSet.DataSet := FDataSet;
  FReportDataSet.OpenDataSource := False;
  FReport.Dataset := FReportDataSet;
end;

procedure TUnit25ListReport.ValidateDataSet;
var
  fieldIndex: Integer;
begin
  if not FDataSet.Active then
    raise EDatabaseError.Create(
      'The Unit25 report requires an already active dataset.');

  for fieldIndex := Low(RequiredFields) to High(RequiredFields) do
    if FDataSet.FindField(RequiredFields[fieldIndex]) = nil then
      raise EDatabaseError.CreateFmt(
        'The Unit25 report dataset is missing required field "%s".',
        [RequiredFields[fieldIndex]]);
end;

function TUnit25ListReport.PrepareReport: Boolean;
var
  bookmark: TBookmark;
begin
  ValidateDataSet;
  bookmark := FDataSet.GetBookmark;
  try
    Result := FReport.PrepareReport;
  finally
    try
      if FDataSet.BookmarkValid(bookmark) then
        FDataSet.GotoBookmark(bookmark);
    finally
      FDataSet.FreeBookmark(bookmark);
    end;
  end;
end;

function TUnit25ListReport.PreparedPageCount: Integer;
begin
  Result := FReport.EMFPages.Count;
end;

function TUnit25ListReport.TemplateColumnCount: Integer;
begin
  if FReport.Pages.Count = 0 then
    Result := 0
  else
    Result := TfrPageReport(FReport.Pages[0]).ColCount;
end;

end.
