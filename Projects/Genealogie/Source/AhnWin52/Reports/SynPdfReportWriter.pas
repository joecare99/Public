unit SynPdfReportWriter;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  ReportPdfContracts;

type
  TSynPdfReportWriter = class(TInterfacedObject, IReportPdfWriter)
  public
    procedure WriteDocument(const AMetadata: TReportPdfMetadata;
      const APages: IReportPageSource; const AFileName: string);
  end;

implementation

uses
  Classes, SysUtils, Graphics, Types, SynPdf, ReportPdfFilePublisher;

procedure TSynPdfReportWriter.WriteDocument(
  const AMetadata: TReportPdfMetadata; const APages: IReportPageSource;
  const AFileName: string);
var
  document: TPdfDocumentGDI;
  pdfStream: TMemoryStream;
  pageIndex: Integer;
  pageDefinition: TReportPageDefinition;
  canvasSize: TSize;
  canvas: TCanvas;
begin
  if APages = nil then
    raise EReportPdfArgumentError.Create('APages must not be nil.');
  if Trim(AFileName) = '' then
    raise EReportPdfArgumentError.Create('AFileName must not be blank.');
  if APages.GetPageCount <= 0 then
    raise EReportPdfError.Create('A report must contain at least one page.');

  document := TPdfDocumentGDI.Create;
  try
    document.Info.Title := AMetadata.Title;
    document.Info.Author := AMetadata.Author;
    document.Info.Subject := AMetadata.Subject;
    document.Info.Keywords := AMetadata.Keywords;
    document.Info.Creator := AMetadata.Creator;
    pdfStream := TMemoryStream.Create;
    try
      for pageIndex := 0 to APages.GetPageCount - 1 do
      begin
        pageDefinition := APages.GetPageDefinition(pageIndex);
        ValidateReportPageDefinition(pageDefinition);
        document.DefaultPageWidth := pageDefinition.WidthPoints;
        document.DefaultPageHeight := pageDefinition.HeightPoints;
        document.AddPage;
        canvas := document.VCLCanvas;
        canvasSize := document.VCLCanvasSize;
        if (canvasSize.cx <= 0) or (canvasSize.cy <= 0) then
          raise EReportPdfError.CreateFmt(
            'SynPDF created an invalid canvas for page %d.', [pageIndex]);
        APages.RenderPage(pageIndex, canvas,
          Rect(0, 0, canvasSize.cx, canvasSize.cy));
      end;

      document.SaveToStream(pdfStream);
      PublishPdfStream(AFileName, pdfStream);
    finally
      pdfStream.Free;
    end;
  finally
    document.Free;
  end;
end;

end.
