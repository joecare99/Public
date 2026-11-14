program SynPDFProbe;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  Graphics,
  Types,
  ReportPdfContracts,
  SynPdfReportWriter;

type
  TSyntheticReportPages = class(TInterfacedObject, IReportPageSource)
  public
    function GetPageCount: Integer;
    function GetPageDefinition(AIndex: Integer): TReportPageDefinition;
    procedure RenderPage(AIndex: Integer; ACanvas: TCanvas;
      const ATargetBounds: TRect);
  end;

function TSyntheticReportPages.GetPageCount: Integer;
begin
  Result := 2;
end;

function TSyntheticReportPages.GetPageDefinition(
  AIndex: Integer): TReportPageDefinition;
begin
  case AIndex of
    0:
      begin
        Result.WidthPoints := 595;
        Result.HeightPoints := 842;
        Result.Orientation := rpoPortrait;
      end;
    1:
      begin
        Result.WidthPoints := 842;
        Result.HeightPoints := 595;
        Result.Orientation := rpoLandscape;
      end;
  else
    raise ERangeError.CreateFmt('Unexpected page index %d.', [AIndex]);
  end;
end;

procedure TSyntheticReportPages.RenderPage(AIndex: Integer; ACanvas: TCanvas;
  const ATargetBounds: TRect);
begin
  ACanvas.Brush.Color := clWhite;
  ACanvas.FillRect(ATargetBounds);
  ACanvas.Pen.Color := clNavy;
  ACanvas.Rectangle(ATargetBounds.Left + 10, ATargetBounds.Top + 10,
    ATargetBounds.Right - 10, ATargetBounds.Bottom - 10);
  ACanvas.Font.Name := 'Arial';
  ACanvas.Font.Size := 18;
  ACanvas.TextOut(ATargetBounds.Left + 24, ATargetBounds.Top + 24,
    'Synthetic SynPDF page');
end;

procedure RunProbe(const OutputFileName: string);
var
  Pages: IReportPageSource;
  Writer: IReportPdfWriter;
  Metadata: TReportPdfMetadata;
begin
  Pages := TSyntheticReportPages.Create;
  Writer := TSynPdfReportWriter.Create;
  try
    Metadata.Title := 'Synthetic SynPDF Probe';
    Metadata.Author := 'AhnWin52 restoration test';
    Metadata.Subject := 'Synthetic report page output';
    Metadata.Keywords := 'synthetic; report';
    Metadata.Creator := 'AhnWin52 SynPDF adapter probe';
    ExportReportToPdf(Metadata, Pages, Writer, OutputFileName);
  finally
    Writer := nil;
    Pages := nil;
  end;
end;

begin
  try
    if ParamCount <> 1 then
      raise Exception.Create('Usage: SynPDFProbe <output.pdf>');
    RunProbe(ParamStr(1));
    Writeln('PDF created: ', ParamStr(1));
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, E.ClassName, ': ', E.Message);
      Halt(1);
    end;
  end;
end.
