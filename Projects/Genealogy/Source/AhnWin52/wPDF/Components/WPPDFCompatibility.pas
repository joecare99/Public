unit WPPDFCompatibility;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  Classes, WPPDFEngineContract;

type
  TWPDFSecurity = (wpp40bit, wpp128bit);
  TWPDevMode = (
    wpNoBITBLTFillRect, wpNeverFill, wpWhiteBrushIsTransparent,
    wpExactTextPositioning, wpNoTextRectClipping, wpClipRectSupport,
    wpDontStackWorldModifications, wpDontAdjustTextSpacing,
    wpDontCropBitmaps, wpAllowTransparentBit, wpAlwaysHighResPDF,
    wpNeverHighResPDF, wpUseFontWidthArgument, wpNoTextScaling,
    wpMetaIsDOTNETEMF, wpInputIsWMFData, wpHatchBrushIsSolid,
    wpTestIfWeHaveCID, wpTextAsGlyphs, wpDisableAutoGlyphs,
    wpUseOldFontSubsetting, wpSimulateBoldFonts, wpConvertColorsToCMYK,
    wpWriteToUnicodeCMAP, wpDetailedGradients, wpOutlineNumberDetection,
    wpNoAutoTagsForPDFA, wpArabicAlwaysAsOutline,
    wpHebrewAlwaysAsOutline, wpNoOutlinesForASIANInPDFA,
    wpDontSimulateItalicFonts, wpPreserveBookmarkNames);
  TWPDevModes = set of TWPDevMode;
  TWPDFOption = (
    wpCreateAutoLinks, wpHideToolbar, wpHideMenuBar, wpHideWindowUI,
    wpCMYKFontMode, wpDisableAutoBoldSimulation);
  TWPDFOptions = set of TWPDFOption;
  TWPPDFFontMode = (
    wpUseTrueTypeFonts, wpEmbedTrueTypeFonts, wpEmbedSymbolTrueTypeFonts,
    wpUseBase14Type1Fonts, wpEmbedSubsetTrueType_Charsets,
    wpEmbedSubsetTrueType_UsedChar);
  TWPCompressStreamMethod = (
    wpCompressNone, wpCompressFlate, wpCompressRunlength,
    wpCompressFastFlate);
  TWPEncodeStreamMethod = (wpEncodeNone, wpASCII85Encode, wpASCIIHexEncode);
  TWPPDFPageModes = (pwUseNone, wpUseOutlines, wpUseThumbs, wpFullScreen);
  TWPPDFZoomModes = (
    pwZoomDefault, wpZoomFitPage, wpZoomFitVertical, wpZoomFitHorizontal);
  TWPPDFCanvasReference = (wprefScreen, wprefPrinter);
  TWPPDFInputfileMode = (
    pwIgnoreInput, pwAppendToInput, wpConvertInputToWatermark,
    wpUseInputAsWatermark);
  TWPPDFReadMode = (
    wpdfStandard, wpdfRetrieveASCII, wpdfRetrieveEMF, wpdfRetrieveBMP);
  TWPEncryptionOption = (
    wpEncryptFile, wpEnablePrinting, wpEnableChanging, wpEnableCopying,
    wpEnableForms, wpLowQualityPrintOnly, wpEnableDocAssembly,
    wpEnableFormFieldFillIn, wpEnableAccessibilityOp);
  TWPDFEncryption = set of TWPEncryptionOption;
  TWPPDFCidFontMode = (wpCIDOff, wpCIDUnicode, wpCIDSymbolOnly);
  TWPPDFAMode = (wpdfaOff, wpdfaLevelA, wpdfaLevelB);
  TWPJPEGQuality = (
    wpNoJPEG, wpJPEG_10, wpJPEG_25, wpJPEG_50, wpJPEG_75, wpJPEG_100);
  TWPExtraMessage = (wpOnEmbedFonts);
  TWPExtraMessages = set of TWPExtraMessage;

  TWPPDFExportInfo = class(TPersistent)
  private
    FAuthor: string;
    FDateValue8: Double;
    FDateValueC: Cardinal;
    FDateValue10: Double;
    FDateValue14: Cardinal;
    FIsUTF8: Boolean;
    FProducer: string;
    FTitle: string;
    FSubject: string;
    FKeywords: string;
    FStrings: TStringList;
    function GetStrings: TStrings;
    procedure SetStrings(Value: TStrings);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Author: string read FAuthor write FAuthor;
    property IsUTF8: Boolean read FIsUTF8 write FIsUTF8;
    property Producer: string read FProducer write FProducer;
    property Title: string read FTitle write FTitle;
    property Subject: string read FSubject write FSubject;
    property Keywords: string read FKeywords write FKeywords;
    property Strings: TStrings read GetStrings write SetStrings;
  end;

  TWPCustomPDFExport = class(TComponent)
  private
    FCidFontMode: TWPPDFCidFontMode;
    FCompressStreamMethod: TWPCompressStreamMethod;
    FConvertJPEGData: Boolean;
    FCreateOutlines: Boolean;
    FCreateThumbnails: Boolean;
    FDebugMode: Boolean;
    FEncodeStreamMethod: TWPEncodeStreamMethod;
    FEncryption: TWPDFEncryption;
    FExtraMessages: TWPExtraMessages;
    FFilename: string;
    FFontMode: TWPPDFFontMode;
    FInfo: TWPPDFExportInfo;
    FInMemoryMode: Boolean;
    FInputfileMode: TWPPDFInputfileMode;
    FJPEGQuality: TWPJPEGQuality;
    FModes: TWPDevModes;
    FOptions: TWPDFOptions;
    FPageMode: TWPPDFPageModes;
    FPDFAMode: TWPPDFAMode;
    FPDFReadMode: TWPPDFReadMode;
    FPreselectedCJK: Integer;
    FSecurity: TWPDFSecurity;
    FAutoLaunch: Boolean;
    FCanvasReference: TWPPDFCanvasReference;
    FZoomMode: TWPPDFZoomModes;
    FEngine: TWPPDFEngine;
    FDocumentActive: Boolean;
    FPageActive: Boolean;
    procedure SetPDFAMode(Value: TWPPDFAMode);
    procedure SetInfo(Value: TWPPDFExportInfo);
    procedure SetEngine(Value: TWPPDFEngine);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginDocument;
    procedure BeginPage(const Arguments: TWPPDFPageArguments);
    procedure EndPage;
    procedure EndDocument;
    property Engine: TWPPDFEngine read FEngine write SetEngine;
  published
    property CidFontMode: TWPPDFCidFontMode
      read FCidFontMode write FCidFontMode;
    property PDFAMode: TWPPDFAMode read FPDFAMode write SetPDFAMode;
    property PreselectedCJK: Integer
      read FPreselectedCJK write FPreselectedCJK;
    property PDFReadMode: TWPPDFReadMode read FPDFReadMode write FPDFReadMode;
    property CanvasReference: TWPPDFCanvasReference
      read FCanvasReference write FCanvasReference;
    property Filename: string read FFilename write FFilename;
    property AutoLaunch: Boolean read FAutoLaunch write FAutoLaunch;
    property EncodeStreamMethod: TWPEncodeStreamMethod
      read FEncodeStreamMethod write FEncodeStreamMethod;
    property CompressStreamMethod: TWPCompressStreamMethod
      read FCompressStreamMethod write FCompressStreamMethod;
    property Info: TWPPDFExportInfo read FInfo write SetInfo;
    property CreateThumbnails: Boolean
      read FCreateThumbnails write FCreateThumbnails;
    property CreateOutlines: Boolean
      read FCreateOutlines write FCreateOutlines;
    property Modes: TWPDevModes read FModes write FModes;
    property Options: TWPDFOptions read FOptions write FOptions;
    property PageMode: TWPPDFPageModes read FPageMode write FPageMode;
    property ZoomMode: TWPPDFZoomModes read FZoomMode write FZoomMode;
    property FontMode: TWPPDFFontMode read FFontMode write FFontMode;
    property Encryption: TWPDFEncryption read FEncryption write FEncryption;
    property Security: TWPDFSecurity read FSecurity write FSecurity;
    property InMemoryMode: Boolean read FInMemoryMode write FInMemoryMode;
    property JPEGQuality: TWPJPEGQuality read FJPEGQuality write FJPEGQuality;
    property ExtraMessages: TWPExtraMessages
      read FExtraMessages write FExtraMessages;
    property InputfileMode: TWPPDFInputfileMode
      read FInputfileMode write FInputfileMode;
    property ConvertJPEGData: Boolean
      read FConvertJPEGData write FConvertJPEGData;
    property DebugMode: Boolean read FDebugMode write FDebugMode;
  end;

  TWPPDFPrinter = class(TWPCustomPDFExport)
  end;

  TWPPDFProperties = class(TComponent)
  private
    FPDFPrinter: TWPCustomPDFExport;
    FShowInputModes: Boolean;
    FShowStartButton: Boolean;
  published
    property PDFPrinter: TWPCustomPDFExport
      read FPDFPrinter write FPDFPrinter;
    property ShowStartButton: Boolean
      read FShowStartButton write FShowStartButton;
    property ShowInputModes: Boolean
      read FShowInputModes write FShowInputModes;
  end;

implementation

constructor TWPPDFExportInfo.Create;
begin
  inherited Create;
  FStrings := TStringList.Create;
end;

destructor TWPPDFExportInfo.Destroy;
begin
  FStrings.Free;
  inherited Destroy;
end;

procedure TWPPDFExportInfo.Assign(Source: TPersistent);
var
  sourceInfo: TWPPDFExportInfo;
begin
  if Source is TWPPDFExportInfo then
  begin
    sourceInfo := TWPPDFExportInfo(Source);
    FAuthor := sourceInfo.FAuthor;
    FDateValue8 := sourceInfo.FDateValue8;
    FDateValueC := sourceInfo.FDateValueC;
    FDateValue10 := sourceInfo.FDateValue10;
    FDateValue14 := sourceInfo.FDateValue14;
    FProducer := sourceInfo.FProducer;
    FTitle := sourceInfo.FTitle;
    FSubject := sourceInfo.FSubject;
    FKeywords := sourceInfo.FKeywords;
    FStrings.Assign(sourceInfo.FStrings);
  end
  else
    inherited Assign(Source);
end;

procedure TWPPDFExportInfo.SetStrings(Value: TStrings);
begin
  FStrings.Assign(Value);
end;

function TWPPDFExportInfo.GetStrings: TStrings;
begin
  Result := FStrings;
end;

constructor TWPCustomPDFExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInfo := TWPPDFExportInfo.Create;
  FInfo.Producer := 'wPDF - http://www.wptools.de';
  FPreselectedCJK := 128;
end;

destructor TWPCustomPDFExport.Destroy;
begin
  FInfo.Free;
  inherited Destroy;
end;

procedure TWPCustomPDFExport.SetPDFAMode(Value: TWPPDFAMode);
begin
  FPDFAMode := Value;
  if (Value = wpdfaLevelA) and (FFontMode = wpUseTrueTypeFonts) then
    FFontMode := wpEmbedTrueTypeFonts;
end;

procedure TWPCustomPDFExport.SetInfo(Value: TWPPDFExportInfo);
begin
  FInfo.Assign(Value);
end;

procedure TWPCustomPDFExport.SetEngine(Value: TWPPDFEngine);
begin
  if FDocumentActive then
    raise EWPPDFLifecycleError.Create(
      'The wPDF engine cannot change while a document is active.');
  FEngine := Value;
end;

procedure TWPCustomPDFExport.BeginDocument;
begin
  if FDocumentActive then
    raise EWPPDFLifecycleError.Create(
      'A wPDF document is already active.');
  if not Assigned(FEngine) then
    raise EWPPDFEngineUnavailable.Create(
      'No wPDF engine implementation has been assigned.');

  FEngine.BeginDocument;
  FDocumentActive := True;
end;

procedure TWPCustomPDFExport.BeginPage(
  const Arguments: TWPPDFPageArguments);
begin
  if not FDocumentActive then
    raise EWPPDFLifecycleError.Create(
      'A wPDF page can only begin inside an active document.');
  if FPageActive then
    raise EWPPDFLifecycleError.Create(
      'A wPDF page is already active.');

  FEngine.BeginPage(Arguments);
  FPageActive := True;
end;

procedure TWPCustomPDFExport.EndPage;
begin
  if not FPageActive then
    raise EWPPDFLifecycleError.Create(
      'No wPDF page is active.');

  FEngine.EndPage;
  FPageActive := False;
end;

procedure TWPCustomPDFExport.EndDocument;
begin
  if not FDocumentActive then
    raise EWPPDFLifecycleError.Create(
      'No wPDF document is active.');
  if FPageActive then
    raise EWPPDFLifecycleError.Create(
      'The active wPDF page must end before the document.');

  FEngine.EndDocument;
  FDocumentActive := False;
end;

initialization
  RegisterClasses([TWPPDFPrinter, TWPPDFProperties]);

finalization
  UnRegisterClasses([TWPPDFPrinter, TWPPDFProperties]);

end.
