unit tst_AHW52_WPPDFCompatibilityTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52WPPDFCompatibility = class(TTestCase)
  published
    procedure TestRecoveredConstructorDefaults;
    procedure TestExportInfoAssignCopiesMetadataAndStrings;
    procedure TestPrinterInfoAssignmentCopiesMetadata;
    procedure TestExportLifecycleUsesInjectedEngine;
    procedure TestExportLifecycleRejectsInvalidTransitions;
    procedure TestExportLifecyclePreservesStateAfterEngineFailures;
    procedure TestExportRequiresAnEngine;
    procedure TestPDFALevelAEmbedsDefaultTrueTypeFontMode;
    procedure TestPDFAModePreservesAnExplicitFontMode;
    procedure TestDFMPropertiesAndPrinterReferenceStream;
  end;

implementation

uses
  Classes, SysUtils, Unit16, WPPDFCompatibility, WPPDFEngineContract;

type
  TRecordingWPPDFEngine = class(TWPPDFEngine)
  public
    Calls: TStringList;
    FailOn: string;
    PageArguments: TWPPDFPageArguments;
    constructor Create;
    destructor Destroy; override;
    procedure BeginDocument; override;
    procedure BeginPage(const Arguments: TWPPDFPageArguments); override;
    procedure EndPage; override;
    procedure EndDocument; override;
  end;

constructor TRecordingWPPDFEngine.Create;
begin
  inherited Create;
  Calls := TStringList.Create;
end;

destructor TRecordingWPPDFEngine.Destroy;
begin
  Calls.Free;
  inherited Destroy;
end;

procedure TRecordingWPPDFEngine.BeginDocument;
begin
  Calls.Add('BeginDocument');
  if FailOn = 'BeginDocument' then
    raise Exception.Create('Synthetic BeginDocument failure.');
end;

procedure TRecordingWPPDFEngine.BeginPage(
  const Arguments: TWPPDFPageArguments);
var
  index: Integer;
begin
  Calls.Add('BeginPage');
  if FailOn = 'BeginPage' then
    raise Exception.Create('Synthetic BeginPage failure.');
  for index := Low(Arguments) to High(Arguments) do
    PageArguments[index] := Arguments[index];
end;

procedure TRecordingWPPDFEngine.EndPage;
begin
  Calls.Add('EndPage');
  if FailOn = 'EndPage' then
    raise Exception.Create('Synthetic EndPage failure.');
end;

procedure TRecordingWPPDFEngine.EndDocument;
begin
  Calls.Add('EndDocument');
  if FailOn = 'EndDocument' then
    raise Exception.Create('Synthetic EndDocument failure.');
end;

procedure TTestAHW52WPPDFCompatibility.TestRecoveredConstructorDefaults;
var
  printer: TWPPDFPrinter;
begin
  printer := TWPPDFPrinter.Create(nil);
  try
    AssertEquals(128, printer.PreselectedCJK);
    AssertEquals('wPDF - http://www.wptools.de', printer.Info.Producer);
    AssertFalse(printer.Info.IsUTF8);
    AssertEquals(Ord(wprefScreen), Ord(printer.CanvasReference));
    AssertEquals(Ord(wpCIDOff), Ord(printer.CidFontMode));
    AssertEquals(Ord(wpdfaOff), Ord(printer.PDFAMode));
    AssertEquals(Ord(wpdfStandard), Ord(printer.PDFReadMode));
    AssertEquals(Ord(wpEncodeNone), Ord(printer.EncodeStreamMethod));
    AssertEquals(Ord(wpCompressNone), Ord(printer.CompressStreamMethod));
    AssertEquals(Ord(wpUseTrueTypeFonts), Ord(printer.FontMode));
    AssertEquals(Ord(wpNoJPEG), Ord(printer.JPEGQuality));
    AssertTrue(printer.Modes = []);
    AssertTrue(printer.Options = []);
    AssertTrue(printer.Encryption = []);
  finally
    printer.Free;
  end;
end;

procedure TTestAHW52WPPDFCompatibility.
  TestExportInfoAssignCopiesMetadataAndStrings;
var
  sourceInfo: TWPPDFExportInfo;
  targetInfo: TWPPDFExportInfo;
begin
  sourceInfo := TWPPDFExportInfo.Create;
  targetInfo := TWPPDFExportInfo.Create;
  try
    sourceInfo.Author := 'Synthetic author';
    sourceInfo.IsUTF8 := True;
    sourceInfo.Producer := 'Synthetic producer';
    sourceInfo.Title := 'Synthetic title';
    sourceInfo.Subject := 'Synthetic subject';
    sourceInfo.Keywords := 'one;two';
    sourceInfo.Strings.Add('Synthetic font');

    targetInfo.Assign(sourceInfo);

    AssertEquals(sourceInfo.Author, targetInfo.Author);
    AssertEquals(sourceInfo.Producer, targetInfo.Producer);
    AssertEquals(sourceInfo.Title, targetInfo.Title);
    AssertEquals(sourceInfo.Subject, targetInfo.Subject);
    AssertEquals(sourceInfo.Keywords, targetInfo.Keywords);
    AssertEquals(1, targetInfo.Strings.Count);
    AssertEquals('Synthetic font', targetInfo.Strings[0]);
    AssertFalse('The recovered Assign listing does not copy IsUTF8.',
      targetInfo.IsUTF8);
  finally
    targetInfo.Free;
    sourceInfo.Free;
  end;
end;

procedure TTestAHW52WPPDFCompatibility.
  TestPrinterInfoAssignmentCopiesMetadata;
var
  printer: TWPPDFPrinter;
  info: TWPPDFExportInfo;
begin
  printer := TWPPDFPrinter.Create(nil);
  info := TWPPDFExportInfo.Create;
  try
    info.Title := 'Assigned title';
    info.Strings.Add('Assigned font');
    printer.Info := info;

    AssertEquals('Assigned title', printer.Info.Title);
    AssertEquals(1, printer.Info.Strings.Count);
    AssertEquals('Assigned font', printer.Info.Strings[0]);
  finally
    info.Free;
    printer.Free;
  end;
end;

procedure TTestAHW52WPPDFCompatibility.
  TestExportLifecycleUsesInjectedEngine;
var
  printer: TWPPDFPrinter;
  engine: TRecordingWPPDFEngine;
  pageArguments: TWPPDFPageArguments;
  index: Integer;
begin
  printer := TWPPDFPrinter.Create(nil);
  engine := TRecordingWPPDFEngine.Create;
  try
    pageArguments[0] := 800;
    pageArguments[1] := 600;
    pageArguments[2] := 0;
    pageArguments[3] := 254;
    pageArguments[4] := 254;
    printer.Engine := engine;

    printer.BeginDocument;
    printer.BeginPage(pageArguments);
    printer.EndPage;
    printer.BeginPage(pageArguments);
    printer.EndPage;
    printer.EndDocument;

    AssertEquals(6, engine.Calls.Count);
    AssertEquals('BeginDocument', engine.Calls[0]);
    AssertEquals('BeginPage', engine.Calls[1]);
    AssertEquals('EndPage', engine.Calls[2]);
    AssertEquals('BeginPage', engine.Calls[3]);
    AssertEquals('EndPage', engine.Calls[4]);
    AssertEquals('EndDocument', engine.Calls[5]);
    for index := Low(pageArguments) to High(pageArguments) do
      AssertEquals(pageArguments[index], engine.PageArguments[index]);
  finally
    printer.Free;
    engine.Free;
  end;
end;

procedure TTestAHW52WPPDFCompatibility.
  TestExportLifecycleRejectsInvalidTransitions;
var
  printer: TWPPDFPrinter;
  engine: TRecordingWPPDFEngine;
  pageArguments: TWPPDFPageArguments;
  raisedError: Boolean;
begin
  printer := TWPPDFPrinter.Create(nil);
  engine := TRecordingWPPDFEngine.Create;
  try
  pageArguments[0] := 0;
  pageArguments[1] := 0;
  pageArguments[2] := 0;
  pageArguments[3] := 0;
  pageArguments[4] := 0;
  printer.Engine := engine;

    raisedError := False;
    try
      printer.BeginPage(pageArguments);
    except
      on EWPPDFLifecycleError do
        raisedError := True;
    end;
    AssertTrue('BeginPage outside a document must be rejected.',
      raisedError);

    raisedError := False;
    try
      printer.EndPage;
    except
      on EWPPDFLifecycleError do
        raisedError := True;
    end;
    AssertTrue('EndPage without an active page must be rejected.',
      raisedError);

    printer.BeginDocument;
    printer.BeginPage(pageArguments);
    raisedError := False;
    try
      printer.EndDocument;
    except
      on EWPPDFLifecycleError do
        raisedError := True;
    end;
    AssertTrue('EndDocument with an active page must be rejected.',
      raisedError);
    printer.EndPage;
    printer.EndDocument;
    AssertEquals(4, engine.Calls.Count);
  finally
    printer.Free;
    engine.Free;
  end;
end;

procedure TTestAHW52WPPDFCompatibility.
  TestExportLifecyclePreservesStateAfterEngineFailures;
var
  printer: TWPPDFPrinter;
  engine: TRecordingWPPDFEngine;
  pageArguments: TWPPDFPageArguments;
  raisedError: Boolean;
begin
  printer := TWPPDFPrinter.Create(nil);
  engine := TRecordingWPPDFEngine.Create;
  try
    pageArguments[0] := 0;
    pageArguments[1] := 0;
    pageArguments[2] := 0;
    pageArguments[3] := 0;
    pageArguments[4] := 0;
    printer.Engine := engine;

    engine.FailOn := 'BeginDocument';
    raisedError := False;
    try
      printer.BeginDocument;
    except
      on Exception do
        raisedError := True;
    end;
    AssertTrue('Failed BeginDocument must propagate the backend error.',
      raisedError);
    engine.FailOn := '';
    printer.BeginDocument;

    engine.FailOn := 'BeginPage';
    raisedError := False;
    try
      printer.BeginPage(pageArguments);
    except
      on Exception do
        raisedError := True;
    end;
    AssertTrue('Failed BeginPage must propagate the backend error.',
      raisedError);
    engine.FailOn := '';
    printer.BeginPage(pageArguments);

    engine.FailOn := 'EndPage';
    raisedError := False;
    try
      printer.EndPage;
    except
      on Exception do
        raisedError := True;
    end;
    AssertTrue('Failed EndPage must propagate the backend error.',
      raisedError);
    engine.FailOn := '';
    printer.EndPage;

    engine.FailOn := 'EndDocument';
    raisedError := False;
    try
      printer.EndDocument;
    except
      on Exception do
        raisedError := True;
    end;
    AssertTrue('Failed EndDocument must propagate the backend error.',
      raisedError);
    engine.FailOn := '';
    printer.EndDocument;

    AssertEquals(8, engine.Calls.Count);
  finally
    printer.Free;
    engine.Free;
  end;
end;

procedure TTestAHW52WPPDFCompatibility.TestExportRequiresAnEngine;
var
  printer: TWPPDFPrinter;
  raisedError: Boolean;
begin
  printer := TWPPDFPrinter.Create(nil);
  try
    raisedError := False;
    try
      printer.BeginDocument;
    except
      on EWPPDFEngineUnavailable do
        raisedError := True;
    end;
    AssertTrue('Document creation without a backend must be explicit.',
      raisedError);
  finally
    printer.Free;
  end;
end;

procedure TTestAHW52WPPDFCompatibility.
  TestPDFALevelAEmbedsDefaultTrueTypeFontMode;
var
  printer: TWPPDFPrinter;
begin
  printer := TWPPDFPrinter.Create(nil);
  try
    printer.PDFAMode := wpdfaLevelA;
    AssertEquals(Ord(wpdfaLevelA), Ord(printer.PDFAMode));
    AssertEquals(Ord(wpEmbedTrueTypeFonts), Ord(printer.FontMode));
  finally
    printer.Free;
  end;
end;

procedure TTestAHW52WPPDFCompatibility.
  TestPDFAModePreservesAnExplicitFontMode;
var
  printer: TWPPDFPrinter;
begin
  printer := TWPPDFPrinter.Create(nil);
  try
    printer.FontMode := wpUseBase14Type1Fonts;
    printer.PDFAMode := wpdfaLevelA;
    AssertEquals(Ord(wpUseBase14Type1Fonts), Ord(printer.FontMode));
    printer.PDFAMode := wpdfaLevelB;
    AssertEquals(Ord(wpUseBase14Type1Fonts), Ord(printer.FontMode));
  finally
    printer.Free;
  end;
end;

procedure TTestAHW52WPPDFCompatibility.
  TestDFMPropertiesAndPrinterReferenceStream;
const
  ComponentText =
    'object Root: TComponent'#10 +
    '  object WPPDFPrinter1: TWPPDFPrinter'#10 +
    '    CidFontMode = wpCIDOff'#10 +
    '    PDFAMode = wpdfaOff'#10 +
    '    PreselectedCJK = 128'#10 +
    '    PDFReadMode = wpdfStandard'#10 +
    '    CanvasReference = wprefScreen'#10 +
    '    Filename = ''Default.PDF'''#10 +
    '    AutoLaunch = True'#10 +
    '    EncodeStreamMethod = wpEncodeNone'#10 +
    '    CompressStreamMethod = wpCompressNone'#10 +
    '    Info.IsUTF8 = False'#10 +
    '    Info.Producer = ''wPDF - http://www.wptools.de'''#10 +
    '    CreateThumbnails = False'#10 +
    '    CreateOutlines = False'#10 +
    '    Modes = [wpExactTextPositioning, wpClipRectSupport,'#10 +
    '      wpArabicAlwaysAsOutline]'#10 +
    '    Options = []'#10 +
    '    PageMode = pwUseNone'#10 +
    '    ZoomMode = pwZoomDefault'#10 +
    '    FontMode = wpUseTrueTypeFonts'#10 +
    '    Encryption = []'#10 +
    '    Security = wpp40bit'#10 +
    '    InMemoryMode = False'#10 +
    '    JPEGQuality = wpNoJPEG'#10 +
    '    ExtraMessages = []'#10 +
    '    InputfileMode = pwIgnoreInput'#10 +
    '    ConvertJPEGData = False'#10 +
    '    DebugMode = False'#10 +
    '  end'#10 +
    '  object WPPDFProperties1: TWPPDFProperties'#10 +
    '    PDFPrinter = WPPDFPrinter1'#10 +
    '    ShowStartButton = False'#10 +
    '    ShowInputModes = False'#10 +
    '  end'#10 +
    'end'#10;
var
  textStream: TStringStream;
  binaryStream: TMemoryStream;
  reader: TReader;
  root: TComponent;
  printer: TWPPDFPrinter;
  properties: TWPPDFProperties;
begin
  textStream := TStringStream.Create(ComponentText);
  binaryStream := TMemoryStream.Create;
  root := TComponent.Create(nil);
  try
    ObjectTextToBinary(textStream, binaryStream);
    binaryStream.Position := 0;
    reader := TReader.Create(binaryStream, 4096);
    try
      reader.ReadRootComponent(root);
    finally
      reader.Free;
    end;

    printer := root.FindComponent('WPPDFPrinter1') as TWPPDFPrinter;
    properties := root.FindComponent('WPPDFProperties1') as
      TWPPDFProperties;
    AssertNotNull(printer);
    AssertNotNull(properties);
    AssertEquals('Default.PDF', printer.Filename);
    AssertEquals(128, printer.PreselectedCJK);
    AssertTrue(wpExactTextPositioning in printer.Modes);
    AssertTrue(wpClipRectSupport in printer.Modes);
    AssertTrue(wpArabicAlwaysAsOutline in printer.Modes);
    AssertSame(printer, properties.PDFPrinter);
    AssertFalse(properties.ShowStartButton);
    AssertFalse(properties.ShowInputModes);
  finally
    root.Free;
    binaryStream.Free;
    textStream.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52WPPDFCompatibility);

end.
