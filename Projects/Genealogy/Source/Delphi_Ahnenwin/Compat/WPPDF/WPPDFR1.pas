unit WPPDFR1;

{-------------------------------------------------------------------------------
  WPPDFR1 - WPPDFDelphi 5.0 core types (compatibility stub).

  AHNENWIN 5.1 uses WPPDFDelphi 5.0 to export the ancestor chart (Unit13) and
  the report preview (Unit16) to PDF. The library is a third-party commercial
  component; it is neither installed in this environment nor reconstructible
  from the IDR decompilation:

    * Source\Projects_AhnenWin\WPPDFR1.pas is 150 KB of IDR output with
      anonymous-enum artefacts (".1 = (wpNoBITBLTFillRect, ...)") that no
      Pascal compiler can parse, and the class bodies are heavily damaged.
    * Source\Ahnw50\ contains the same library as a second IDR dump
      (Ahnw50.pas / WPPDFDev.pas), likewise not usable as a source.

  This stub reproduces the *type surface* that the AHNENWIN units and their
  DFM resources reference:

    * the enumerations of the PDF option model,
    * TWPPDFExportInfo (the document information record),
    * TWPCustomPDFExport, the PDF export component.

  The component is a structural shell only: it holds the state that the
  reconstructed units assign (file name, canvas reference, page mode, ...),
  but it produces no PDF. The PDF output of the reconstruction goes through
  the plain-text / HTML export in Unit16.Speichernunter1Click.

  Dependency direction: WPPDFR1 must not reference WPPDFR2 or WPPDFPRP.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, Graphics, Windows;

type
  TWPPDFSecurity = (wpp40bit, wpp128bit);

  TWPDevModes = set of (
    wpNoBITBLTFillRect, wpNeverFill, wpWhiteBrushIsTransparent,
    wpExactTextPositioning, wpNoTextRectClipping, wpClipRectSupport,
    wpDontStackWorldModifications, wpDontAdjustTextSpacing,
    wpDontCropBitmaps, wpAllowTransparentBit, wpAlwaysHighResPDF,
    wpNeverHighResPDF, wpUseFontWidthArgument, wpNoTextScaling,
    wpNoMetaIsDOTNETEMF, wpInputIsWMFData, wpHatchBrushIsSolid,
    wpTestIfWeHaveCID, wpTextAsGlyphs, wpDisableAutoGlyphs,
    wpUseOldFontSubsetting, wpSimulateBoldFonts, wpConvertColorsToCMYK,
    wpWriteToUnicodeCMAP, wpDetailedGradients, wpOutlineNumberDetection,
    wpNoAutoTagsForPDFA, wpArabicAlwaysAsOutline, wpHebrewAlwaysAsOutline,
    wpNoOutlinesForASIANinPDFA, wpDontSimulateItalicFonts,
    wpPreserveBookmarkNames);

  TWPDFOptions = set of (
    wpCreateAutoLinks, wpHideToolbar, wpHideMenuBar, wpHideWindowUI,
    wpCMYKFontMode, wpDisableAutoBoldSimulation);

  TWPPDFFontMode = (wpUseTrueTypeFonts, wpEmbedTrueTypeFonts,
                    wpEmbedSymbolTrueTypeFonts, wpUseBase14Type1Fonts,
                    wpEmbedSubsetTrueType_Charsets, wpEmbedSubsetTrueType_UsedChar);

  TWPCompressStreamMethod = (wpCompressNone, wpCompressFlate,
                              wpCompressRunlength, wpCompressFastFlate);

  TWPEncodeStreamMethod = (wpEncodeNone, wpEncodeASCII85Encode,
                            wpEncodeASCIIHexEncode);

  TWPPDFPageModes = (pwUseNone, pwUseOutlines, pwUseThumbs, pwFullScreen);

  TWPPDFZoomModes = (wpZoomDefault, wpZoomFitPage, wpZoomFitVertical,
                     wpZoomFitHorizontal);

  TWPPDFCanvasReference = (wprefScreen, wprefPrinter);

  TWPPDFInputfileMode = (wpIgnoreInput, wpAppendToInput,
                          wpConvertInputToWatermark, wpUseInputAsWatermark);

  TWPPDFReadMode = (wpdfStandard, wpdfRetrieveASCII, wpdfRetrieveEMF,
                    wpdfRetrieveBMP);

  TWPDFEncryption = set of (
    wpEncryptFile, wpEnablePrinting, wpEnableChanging, wpEnableCopying,
    wpEnableForms, wpLowQualityPrintOnly, wpEnableDocAssembly,
    wpEnableFormFieldFillIn, wpEnableAccessibilityOp);

  TWPPDFCidFontMode = (wpCIDOff, wpCIDUnicode, wpCIDSymbolOnly);

  TWPPDFAMode = (wpdfaOff, wpdfaLevelA, wpdfaLevelB);

  TWPJPEGQuality = (wpNoJPEG, wpJPEG_10, wpJPEG_25, wpJPEG_50, wpJPEG_75,
                     wpJPEG_100);

  TWPPDFUpdateGaugeEvent = procedure(Sender: TObject; position: Integer) of object;

  TWPPDFErrorEvent = procedure(Sender: TObject; num: Integer; text: String) of object;

  TWPPDFMergeTextEvent = procedure(Sender: TObject; var Text: String) of object;

  TWPPDFOnInternStartPage = procedure(Sender: TObject) of object;

  { Extra messages, streamed by the AHNENWIN resources as "ExtraMessages = []". }
  TWPExtraMessages = set of (wpOnEmbedFonts);

  { The document information record. The AHNENWIN resources stream
    "Info.IsUTF8" and "Info.Producer" on it. }
  TWPPDFExportInfo = class(TPersistent)
  private
    FIsUTF8: Boolean;
    FProducer: String;
  public
    Author: String;
    CreationDate: TDateTime;
    Creator: String;
    Keywords: String;
    Subject: String;
    Title: String;
    ModDate: TDateTime;
    constructor Create;
    destructor Destroy; override;
  published
    { The AHNENWIN resources stream "Info.IsUTF8" and "Info.Producer". }
    property IsUTF8: Boolean read FIsUTF8 write FIsUTF8;
    property Producer: String read FProducer write FProducer;
  end;

  { The PDF export component.

    The VMT slot layout below is the one recovered from the IDR decompilation
    of WPPDFR1.pas, so that the call sites in Unit13/Unit16 keep their
    meaning:

      v30  Clear / reset the document
      v34  (internal)
      v38  Begin the document
      v3C  (internal)
      v40  Set the target canvas / begin page
      v44  (internal)
      v48  End the document
      v4C  Render a control onto the canvas
      v50  (internal)
      v54  (internal)
  }
  TWPCustomPDFExport = class(TComponent)
  private
    FFilename: String;
    FCanvasReference: TWPPDFCanvasReference;
    FPageMode: TWPPDFPageModes;
    FZoomMode: TWPPDFZoomModes;
    FFontMode: TWPPDFFontMode;
    FOptions: TWPDFOptions;
    FModes: TWPDevModes;
    FSecurity: TWPPDFSecurity;
    FEncryption: TWPDFEncryption;
    FPDFAMode: TWPPDFAMode;
    FCidFontMode: TWPPDFCidFontMode;
    FEncodeStreamMethod: TWPEncodeStreamMethod;
    FCompressStreamMethod: TWPCompressStreamMethod;
    FInputfileMode: TWPPDFInputfileMode;
    FInputFile: String;
    FMergeStart: String;
    FUserPassword: String;
    FOwnerPassword: String;
    FCreateThumbnails: Boolean;
    FCreateOutlines: Boolean;
    FAutoLaunch: Boolean;
    FInMemoryMode: Boolean;
    FInfo: TWPPDFExportInfo;
    FOnUpdateGauge: TWPPDFUpdateGaugeEvent;
    FBeforeBeginDoc: TNotifyEvent;
    FOnInternStartPage: TWPPDFOnInternStartPage;
    FPreselectedCJK: Integer;
    FPDFReadMode: TWPPDFReadMode;
    FJPEGQuality: TWPJPEGQuality;
    FExtraMessages: TWPExtraMessages;
    FConvertJPEGData: Boolean;
    FDebugMode: Boolean;
    FField70: Boolean; //+70: geprueft 005736A3 (Unit13.SpeedButton3Click), Setter 00537824
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;
    procedure BeginDoc; virtual;
    procedure SetCanvasReference(Value: TWPPDFCanvasReference);
    procedure EndDoc; virtual;
    procedure RenderControl(AControl: TObject); virtual;
    procedure RenderControlPage(AControl: TObject; APage: Integer); virtual;
    procedure SetFilename(Value: String);
    procedure SetMergeStart(Value: String);
    procedure SetOptions(Value: TWPDFOptions);
    procedure SetModes(Value: TWPDevModes);
    procedure SetInfo(Value: TWPPDFExportInfo);
    procedure SetPDFAMode(Value: TWPPDFAMode);
    procedure SetLicenseLibrary(Value: String);    procedure StartDocument; virtual;
    procedure FinishDocument; virtual;
    { Byte-Feld +70 (005736A3/005736AD): im Shell-Recovery ohne
      etablierten Namen; der AHNENWIN-Code seiner Truth auf "False". }
    property Field70: Boolean read FField70 write FField70;
    property OnUpdateGauge: TWPPDFUpdateGaugeEvent
      read FOnUpdateGauge write FOnUpdateGauge;
  published
    { The AHNENWIN resources (Forms/Form13.dfm, Forms/Form16.dfm) stream
      these properties on the PDF printer component. }
    property Filename: String read FFilename write SetFilename;
    property CanvasReference: TWPPDFCanvasReference
      read FCanvasReference write SetCanvasReference;
    property PageMode: TWPPDFPageModes read FPageMode write FPageMode;
    property ZoomMode: TWPPDFZoomModes read FZoomMode write FZoomMode;
    property FontMode: TWPPDFFontMode read FFontMode write FFontMode;
    property Options: TWPDFOptions read FOptions write SetOptions;
    property Modes: TWPDevModes read FModes write SetModes;
    property Security: TWPPDFSecurity read FSecurity write FSecurity;
    property Encryption: TWPDFEncryption read FEncryption write FEncryption;
    property PDFAMode: TWPPDFAMode read FPDFAMode write SetPDFAMode;
    property CidFontMode: TWPPDFCidFontMode read FCidFontMode write FCidFontMode;
    property EncodeStreamMethod: TWPEncodeStreamMethod
      read FEncodeStreamMethod write FEncodeStreamMethod;
    property CompressStreamMethod: TWPCompressStreamMethod
      read FCompressStreamMethod write FCompressStreamMethod;
    property InputfileMode: TWPPDFInputfileMode
      read FInputfileMode write FInputfileMode;
    property InputFile: String read FInputFile write FInputFile;
    property MergeStart: String read FMergeStart write SetMergeStart;
    property UserPassword: String read FUserPassword write FUserPassword;
    property OwnerPassword: String read FOwnerPassword write FOwnerPassword;
    property CreateThumbnails: Boolean
      read FCreateThumbnails write FCreateThumbnails;
    property CreateOutlines: Boolean read FCreateOutlines write FCreateOutlines;
    property AutoLaunch: Boolean read FAutoLaunch write FAutoLaunch;
    property InMemoryMode: Boolean read FInMemoryMode write FInMemoryMode;
    property Info: TWPPDFExportInfo read FInfo write SetInfo;
    property BeforeBeginDoc: TNotifyEvent
      read FBeforeBeginDoc write FBeforeBeginDoc;
    property OnInternStartPage: TWPPDFOnInternStartPage
      read FOnInternStartPage write FOnInternStartPage;
    property PreselectedCJK: Integer read FPreselectedCJK write FPreselectedCJK;
    property PDFReadMode: TWPPDFReadMode read FPDFReadMode write FPDFReadMode;
    property JPEGQuality: TWPJPEGQuality read FJPEGQuality write FJPEGQuality;
    property ExtraMessages: TWPExtraMessages
      read FExtraMessages write FExtraMessages;
    property ConvertJPEGData: Boolean
      read FConvertJPEGData write FConvertJPEGData;
    property DebugMode: Boolean read FDebugMode write FDebugMode;
  end;

  { The concrete PDF printer component, streamed by Unit13 and Unit16. }
  TWPPDFPrinter = class(TWPCustomPDFExport)
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ 00536D90 (eax = Name, edx = Code): globale Lizenzregistrierung des
  PDF-Druckers (Unit13/Unit16). }
procedure WPPDFRegisterLicense(AName, ACode: String);


implementation

constructor TWPPDFExportInfo.Create;
begin
  inherited Create;
end;

destructor TWPPDFExportInfo.Destroy;
begin
  inherited Destroy;
end;

constructor TWPCustomPDFExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvasReference := wprefScreen;
  FPageMode := pwUseNone;
  FZoomMode := wpZoomDefault;
  FFontMode := wpUseTrueTypeFonts;
  FSecurity := wpp40bit;
  FPDFAMode := wpdfaOff;
  FCidFontMode := wpCIDOff;
  FEncodeStreamMethod := wpEncodeNone;
  FCompressStreamMethod := wpCompressNone;
  FInputfileMode := wpIgnoreInput;
  FInfo := TWPPDFExportInfo.Create;
end;

destructor TWPCustomPDFExport.Destroy;
begin
  FInfo.Free;
  inherited Destroy;
end;

procedure TWPCustomPDFExport.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TWPCustomPDFExport then
  begin
    FFilename := TWPCustomPDFExport(Source).FFilename;
    FPageMode := TWPCustomPDFExport(Source).FPageMode;
  end;
end;

procedure TWPCustomPDFExport.Clear;
begin
end;

procedure TWPCustomPDFExport.BeginDoc;
begin
end;

procedure TWPCustomPDFExport.SetCanvasReference(Value: TWPPDFCanvasReference);
begin
  FCanvasReference := Value;
end;

procedure TWPCustomPDFExport.EndDoc;
begin
end;

procedure TWPCustomPDFExport.RenderControl(AControl: TObject);
begin
end;

procedure TWPCustomPDFExport.RenderControlPage(AControl: TObject; APage: Integer);
begin
end;

procedure TWPCustomPDFExport.SetFilename(Value: String);
begin
  FFilename := Value;
end;

procedure TWPCustomPDFExport.SetMergeStart(Value: String);
begin
  FMergeStart := Value;
end;

procedure TWPCustomPDFExport.SetOptions(Value: TWPDFOptions);
begin
  FOptions := Value;
end;

procedure TWPCustomPDFExport.SetModes(Value: TWPDevModes);
begin
  FModes := Value;
end;

procedure TWPCustomPDFExport.SetInfo(Value: TWPPDFExportInfo);
begin
  FInfo.Assign(Value);
end;

procedure TWPCustomPDFExport.SetPDFAMode(Value: TWPPDFAMode);
begin
  FPDFAMode := Value;
end;

{ 00537710 (eax = Komponente, edx = DllName): registriert die
  Lizenzbibliothek des PDF-Druckers (Parameter 'Ahnw50.dll' in
  Unit13/Unit16). Kompatibilitaet: kein Original-Registrierungsgrundlag. }
procedure TWPCustomPDFExport.SetLicenseLibrary(Value: String);
begin
end;

{ 00536D90 (eax = Name, edx = Code): globale Lizenzregistrierung
  ('Heribert Reitmeier' / 'A144arg6fm45afqf96d4@80B340EF'). }
procedure WPPDFRegisterLicense(AName, ACode: String);
begin
end;

{ [vmt+40]/005379E0, Aufruf 005736BF (Unit13.SpeedButton3Click): bereitet
  Dokument/Standard-Zeilenumbruch des Canvas vor. }
procedure TWPCustomPDFExport.StartDocument;
begin
end;

{ [vmt+54]/00538D00, Aufruf 0057370D: schliesst den Export endgueltig ab. }
procedure TWPCustomPDFExport.FinishDocument;
begin
end;


constructor TWPPDFPrinter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
