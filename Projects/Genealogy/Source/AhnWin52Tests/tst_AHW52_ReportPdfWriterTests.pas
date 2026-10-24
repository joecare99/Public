unit tst_AHW52_ReportPdfWriterTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52ReportPdfWriter = class(TTestCase)
  published
    procedure TestWritesPortraitAndLandscapePagesWithMetadata;
    procedure TestRenderFailurePreservesExistingTarget;
    procedure TestInvalidPageSizeDoesNotCreateOutput;
  end;

implementation

uses
  SysUtils, Classes, Graphics, Types, ReportPdfContracts,
  MormotPdfReportWriter;

type
  ESyntheticRenderError = class(Exception);

  TSyntheticReportPages = class(TInterfacedObject, IReportPageSource)
  private
    FFailOnRender: Boolean;
    FInvalidDimensions: Boolean;
  public
    constructor Create(AFailOnRender: Boolean = False;
      AInvalidDimensions: Boolean = False);
    function GetPageCount: Integer;
    function GetPageDefinition(AIndex: Integer): TReportPageDefinition;
    procedure RenderPage(AIndex: Integer; ACanvas: TCanvas;
      const ATargetBounds: TRect);
  end;

constructor TSyntheticReportPages.Create(AFailOnRender: Boolean;
  AInvalidDimensions: Boolean);
begin
  inherited Create;
  FFailOnRender := AFailOnRender;
  FInvalidDimensions := AInvalidDimensions;
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
        if FInvalidDimensions then
        begin
          Result.WidthPoints := 842;
          Result.HeightPoints := 595;
        end
        else
        begin
          Result.WidthPoints := 595;
          Result.HeightPoints := 842;
        end;
        Result.Orientation := rpoPortrait;
      end;
    1:
      begin
        Result.WidthPoints := 842;
        Result.HeightPoints := 595;
        Result.Orientation := rpoLandscape;
      end;
  else
    raise ERangeError.CreateFmt('Unexpected synthetic page index %d.',
      [AIndex]);
  end;
end;

procedure TSyntheticReportPages.RenderPage(AIndex: Integer; ACanvas: TCanvas;
  const ATargetBounds: TRect);
begin
  if FFailOnRender then
    raise ESyntheticRenderError.Create('Synthetic report rendering failed.');
  ACanvas.Brush.Color := clWhite;
  ACanvas.FillRect(ATargetBounds);
  ACanvas.Pen.Color := clNavy;
  ACanvas.Rectangle(ATargetBounds.Left + 10, ATargetBounds.Top + 10,
    ATargetBounds.Right - 10, ATargetBounds.Bottom - 10);
  ACanvas.Font.Name := 'Arial';
  ACanvas.Font.Size := 14;
  ACanvas.TextOut(ATargetBounds.Left + 20, ATargetBounds.Top + 20,
    'Synthetic page ' + IntToStr(AIndex + 1));
end;

function NewTemporaryPdfName: string;
var
  fileId: TGUID;
begin
  if CreateGUID(fileId) <> 0 then
    raise Exception.Create('Could not create test output file name.');
  Result := IncludeTrailingPathDelimiter(GetTempDir) +
    'AhnWin52-' + GUIDToString(fileId) + '.pdf';
end;

function ReadFileContent(const AFileName: string): AnsiString;
var
  fileStream: TFileStream;
begin
  fileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    SetLength(Result, fileStream.Size);
    if Length(Result) > 0 then
      fileStream.ReadBuffer(Result[1], Length(Result));
  finally
    fileStream.Free;
  end;
end;

procedure TTestAHW52ReportPdfWriter.
  TestWritesPortraitAndLandscapePagesWithMetadata;
var
  pages: IReportPageSource;
  writer: IReportPdfWriter;
  metadata: TReportPdfMetadata;
  outputFileName: string;
  content: AnsiString;
begin
  pages := TSyntheticReportPages.Create;
  writer := TMormotPdfReportWriter.Create;
  outputFileName := NewTemporaryPdfName;
  try
    metadata.Title := 'Synthetic report writer test';
    metadata.Author := 'AhnWin52 tests';
    metadata.Subject := 'Two orientations';
    metadata.Keywords := 'synthetic';
    metadata.Creator := 'AhnWin52 test suite';
    ExportReportToPdf(metadata, pages, writer, outputFileName);

    AssertTrue('The report PDF should be written.', FileExists(outputFileName));
    content := ReadFileContent(outputFileName);
    AssertEquals('%PDF-', Copy(string(content), 1, 5));
    AssertTrue('The PDF should contain the requested title.',
      Pos('Synthetic report writer test', string(content)) > 0);
    AssertTrue('The PDF should define page media boxes.',
      Pos('/MediaBox', string(content)) > 0);
    AssertTrue('The first page should be portrait A4.',
      Pos('0 0 595 842', string(content)) > 0);
    AssertTrue('The second page should be landscape A4.',
      Pos('0 0 842 595', string(content)) > 0);
  finally
    writer := nil;
    pages := nil;
    if FileExists(outputFileName) then
      DeleteFile(outputFileName);
  end;
end;

procedure TTestAHW52ReportPdfWriter.TestRenderFailurePreservesExistingTarget;
var
  pages: IReportPageSource;
  writer: IReportPdfWriter;
  metadata: TReportPdfMetadata;
  outputFileName: string;
  fileStream: TFileStream;
  rejected: Boolean;
begin
  pages := TSyntheticReportPages.Create(True);
  writer := TMormotPdfReportWriter.Create;
  outputFileName := NewTemporaryPdfName;
  fileStream := TFileStream.Create(outputFileName, fmCreate);
  try
    fileStream.WriteBuffer(PAnsiChar('ORIGINAL')^, 8);
  finally
    fileStream.Free;
  end;

  rejected := False;
  try
    try
      ExportReportToPdf(metadata, pages, writer, outputFileName);
    except
      on E: ESyntheticRenderError do
        rejected := True;
    end;
    AssertTrue('The renderer exception must propagate.', rejected);
    AssertEquals('ORIGINAL', string(ReadFileContent(outputFileName)));
  finally
    writer := nil;
    pages := nil;
    if FileExists(outputFileName) then
      DeleteFile(outputFileName);
  end;
end;

procedure TTestAHW52ReportPdfWriter.TestInvalidPageSizeDoesNotCreateOutput;
var
  pages: IReportPageSource;
  writer: IReportPdfWriter;
  metadata: TReportPdfMetadata;
  outputFileName: string;
  rejected: Boolean;
begin
  pages := TSyntheticReportPages.Create(False, True);
  writer := TMormotPdfReportWriter.Create;
  outputFileName := NewTemporaryPdfName;
  rejected := False;
  try
    try
      ExportReportToPdf(metadata, pages, writer, outputFileName);
    except
      on E: EReportPdfError do
      begin
        rejected := True;
        AssertTrue('The bad dimensions should be described.',
          Pos('Portrait', E.Message) > 0);
      end;
    end;
    AssertTrue('Inconsistent orientation/dimensions must fail.', rejected);
    AssertFalse('Invalid content must not create a PDF.', FileExists(outputFileName));
  finally
    writer := nil;
    pages := nil;
    if FileExists(outputFileName) then
      DeleteFile(outputFileName);
  end;
end;

initialization
  RegisterTest(TTestAHW52ReportPdfWriter);

end.
