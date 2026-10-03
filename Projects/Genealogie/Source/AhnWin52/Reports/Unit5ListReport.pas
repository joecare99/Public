unit Unit5ListReport;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, DB, LR_Class, LR_DBSet;

type
  /// Prepares the recovered Unit5 layout using a caller-owned dataset.
  TUnit5ListReport = class(TComponent)
  private
    FDataSet: TDataSet;
    FReport: TfrReport;
    FReportDataSet: TfrDBDataSet;
    procedure BindDataSet;
    procedure ValidateDataSet;
  public
    /// Loads the embedded Unit5 layout and binds the supplied dataset.
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
  SysUtils, Unit5ListReportTemplateResource;

const
  RequiredFields: array[0..14] of string = (
    'QRDBText1', 'QRDBText2', 'QRDBText3', 'QRDBText4', 'QRDBText5',
    'QRDBText6', 'QRDBText7', 'QRDBText8', 'QRDBText9', 'QRDBText10',
    'QRDBText11', 'QRDBText12', 'QRDBText13', 'QRDBText14', 'QRDBText15');

constructor TUnit5ListReport.Create(AOwner: TComponent; ADataSet: TDataSet);
var
  templateStream: TStream;
begin
  inherited Create(AOwner);
  if ADataSet = nil then
    raise EArgumentNilException.Create('ADataSet');

  FDataSet := ADataSet;
  FReport := TfrReport.Create(Self);
  FReport.ShowProgress := False;
  templateStream := CreateUnit5ListReportTemplateStream;
  try
    FReport.LoadFromXMLStream(templateStream);
  finally
    templateStream.Free;
  end;
  BindDataSet;
end;

procedure TUnit5ListReport.BindDataSet;
begin
  FReportDataSet := TfrDBDataSet.Create(FReport);
  FReportDataSet.Name := 'Unit5Rows';
  FReportDataSet.DataSet := FDataSet;
  FReportDataSet.OpenDataSource := False;
  FReport.Dataset := FReportDataSet;
end;

procedure TUnit5ListReport.ValidateDataSet;
var
  fieldIndex: Integer;
begin
  if not FDataSet.Active then
    raise EDatabaseError.Create(
      'The Unit5 report requires an already active dataset.');

  for fieldIndex := Low(RequiredFields) to High(RequiredFields) do
    if FDataSet.FindField(RequiredFields[fieldIndex]) = nil then
      raise EDatabaseError.CreateFmt(
        'The Unit5 report dataset is missing required field "%s".',
        [RequiredFields[fieldIndex]]);
end;

function TUnit5ListReport.PrepareReport: Boolean;
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

function TUnit5ListReport.PreparedPageCount: Integer;
begin
  Result := FReport.EMFPages.Count;
end;

function TUnit5ListReport.TemplateColumnCount: Integer;
begin
  if FReport.Pages.Count = 0 then
    Result := 0
  else
    Result := TfrPageReport(FReport.Pages[0]).ColCount;
end;

end.
