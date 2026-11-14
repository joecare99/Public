unit ReportPdfContracts;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  Classes, Graphics, SysUtils, Types;

type
  TReportPageOrientation = (rpoPortrait, rpoLandscape);

  TReportPageDefinition = record
    WidthPoints: Cardinal;
    HeightPoints: Cardinal;
    Orientation: TReportPageOrientation;
  end;

  TReportPdfMetadata = record
    Title: string;
    Author: string;
    Subject: string;
    Keywords: string;
    Creator: string;
  end;

  IReportPageSource = interface
    ['{58ED729F-26C1-4CA2-AE4D-02CA1FB0EA3C}']
    function GetPageCount: Integer;
    function GetPageDefinition(AIndex: Integer): TReportPageDefinition;
    procedure RenderPage(AIndex: Integer; ACanvas: TCanvas;
      const ATargetBounds: TRect);
  end;

  IReportPdfWriter = interface
    ['{E641A456-587A-4A04-ADF7-152076FD900B}']
    procedure WriteDocument(const AMetadata: TReportPdfMetadata;
      const APages: IReportPageSource; const AFileName: string);
  end;

  EReportPdfError = class(Exception);
  EReportPdfArgumentError = class(EReportPdfError);
  EReportPdfStateError = class(EReportPdfError);

procedure ExportReportToPdf(const AMetadata: TReportPdfMetadata;
  const APages: IReportPageSource; const AWriter: IReportPdfWriter;
  const AFileName: string);
procedure ValidateReportPageDefinition(
  const ADefinition: TReportPageDefinition);

implementation

procedure ExportReportToPdf(const AMetadata: TReportPdfMetadata;
  const APages: IReportPageSource; const AWriter: IReportPdfWriter;
  const AFileName: string);
begin
  if APages = nil then
    raise EReportPdfArgumentError.Create('APages must not be nil.');
  if AWriter = nil then
    raise EReportPdfArgumentError.Create('AWriter must not be nil.');
  if Trim(AFileName) = '' then
    raise EReportPdfArgumentError.Create('AFileName must not be blank.');
  if APages.GetPageCount <= 0 then
    raise EReportPdfError.Create('A report must contain at least one page.');

  AWriter.WriteDocument(AMetadata, APages, AFileName);
end;

procedure ValidateReportPageDefinition(
  const ADefinition: TReportPageDefinition);
begin
  if (ADefinition.WidthPoints = 0) or (ADefinition.HeightPoints = 0) then
    raise EReportPdfError.Create('Report page dimensions must be positive.');

  if (ADefinition.Orientation = rpoPortrait) and
    (ADefinition.WidthPoints > ADefinition.HeightPoints) then
    raise EReportPdfError.Create(
      'Portrait report pages must not be wider than they are high.');

  if (ADefinition.Orientation = rpoLandscape) and
    (ADefinition.WidthPoints < ADefinition.HeightPoints) then
    raise EReportPdfError.Create(
      'Landscape report pages must not be higher than they are wide.');
end;

end.
