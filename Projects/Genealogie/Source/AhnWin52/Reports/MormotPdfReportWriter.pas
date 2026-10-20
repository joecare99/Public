unit MormotPdfReportWriter;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  ReportPdfContracts;

type
  TMormotPdfReportWriter = class(TInterfacedObject, IReportPdfWriter)
  public
    procedure WriteDocument(const AMetadata: TReportPdfMetadata;
      const APages: IReportPageSource; const AFileName: string);
  end;

implementation

uses
  Classes, SysUtils, Graphics, Types, mormot.ui.pdf,
  ReportPdfFilePublisher;

procedure TMormotPdfReportWriter.WriteDocument(
  const AMetadata: TReportPdfMetadata; const APages: IReportPageSource;
  const AFileName: string);
var
  document: TPdfDocumentGdi;
  pdfStream: TMemoryStream;
  pageCount: Integer;
  pageIndex: Integer;
  pageDefinition: TReportPageDefinition;
  canvas: TCanvas;
  canvasSize: TSize;
begin
  if APages = nil then
    raise EReportPdfArgumentError.Create('APages must not be nil.');
  if Trim(AFileName) = '' then
    raise EReportPdfArgumentError.Create('AFileName must not be blank.');
  pageCount := APages.GetPageCount;
  if pageCount <= 0 then
    raise EReportPdfError.Create('A report must contain at least one page.');

  document := TPdfDocumentGdi.Create;
  try
    document.Info.Title := AMetadata.Title;
    document.Info.Author := AMetadata.Author;
    document.Info.Subject := AMetadata.Subject;
    document.Info.Keywords := AMetadata.Keywords;
    document.Info.Creator := AMetadata.Creator;
    pdfStream := TMemoryStream.Create;
    try
      for pageIndex := 0 to pageCount - 1 do
      begin
        pageDefinition := APages.GetPageDefinition(pageIndex);
        ValidateReportPageDefinition(pageDefinition);
        document.DefaultPageWidth := pageDefinition.WidthPoints;
        document.DefaultPageHeight := pageDefinition.HeightPoints;
        document.AddPage;
        canvas := document.VclCanvas;
        canvasSize := document.VclCanvasSize;
        if (canvasSize.cx <= 0) or (canvasSize.cy <= 0) then
          raise EReportPdfError.CreateFmt(
            'mORMot2 created an invalid canvas for page %d.', [pageIndex]);
        APages.RenderPage(pageIndex, canvas,
          Types.Rect(0, 0, canvasSize.cx, canvasSize.cy));
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
