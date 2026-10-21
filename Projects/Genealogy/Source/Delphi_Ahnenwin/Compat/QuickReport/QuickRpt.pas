unit QuickRpt;

{-------------------------------------------------------------------------------
  QuickRpt - QuickReport 3.x report model (compatibility stub).

  AHNENWIN 5.1 links against QuickReport 3.x. In this environment:

    * C:\copy\delphi\RAD Studio\3.0\lib\QuickRpt.dcu exists, but it is the
      *old* QuickRpt 1.x/2.x-era build that does not match the DFM resources
      of the 5.1 program, and its companion units QRCtrls / QRExpr /
      QRPrntr are not installed at all.
    * The IDR decompilation in Source\Projects_AhnenWin\QuickRpt.pas is not
      usable as a source either: the unit refers to itself in its uses clause
      and the class bodies are heavily damaged.

  This stub therefore reproduces the public surface that the AHNENWIN
  resources actually stream and that the reconstructed application units
  actually call. The property set was derived directly from the DFM files:

    Forms\Form5.dfm, Forms\Form15.dfm, Forms\Form23.dfm, Forms\Form25.dfm
      TQuickRep: Frame.*, Font.*, Functions.*, Options, Page.*,
                 PrinterSettings.*, PrintIfEmpty, ShowProgress, SnapToGrid,
                 Units, Zoom
    Forms/Form16.dfm, Forms/QRStandardPreview.dfm
      TQRPreview: Zoom, PageNumber, QRPrinter, ...

  The stub performs NO report rendering. Every report that the reconstruction
  actually produces is written through the plain-text / HTML export in
  Unit16.Speichernunter1Click, not through the QuickReport engine.

  Dependency direction: QuickRpt references QRExpr and QRPrntr, never the
  other way round, to avoid a circular unit reference (E2047).
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, DB, Controls, Graphics, Forms, StdCtrls, QRExpr, QRPrntr;

type
  { Report band kinds. The original enumerates the QuickReport band types
    (rbTitle, rbPageHeader, rbColumnHeader, rbDetail, rbSummary, ...).
    The DFMs of AHNENWIN only use "rbTitle" and "rbDetail" (see
    Forms/Form15.dfm), but the full set is provided for completeness. }
  TQRBandType = (rbTitle, rbPageHeader, rbColumnHeader, rbGroupHeader,
                 rbDetail, rbSummary, rbPageFooter, rbGroupFooter,
                 rbSubtotal, rbChild);

  { Report units. The original enumeration is recovered verbatim from the
    decompilation of Source\Projects_AhnenWin\QuickRpt.pas line 89:
      TQRUnit = (MM, Inches, Pixels, Characters, Native)
    and the AHNENWIN resources stream "Units = MM". }
  TQRUnit = (MM, Inches, Pixels, Characters, Native);

  { Report options.

    The AHNENWIN resources stream exactly
        Options = [FirstPageHeader, LastPageFooter, Compression]
    so the element names have to match the DFM spelling exactly. }
  TQROptions = (FirstPageHeader, LastPageFooter, Compression, ReportTitle,
                DefaultPage, KeepColumnTogether, KeepTogether, PrintIfEmpty,
                ShowProgress);

  { Named set type, so that it can be used as a property type. }
  TQROptionSet = set of TQROptions;

  { Alignment of a report element. The resources use the VCL spellings
    taCenter / taLeftJustify / taRightJustify, so the VCL TAlignment is
    reused verbatim. }
  TQRAlignment = TAlignment;

  { Built-in report functions usable in a QuickReport expression. The DFMs of
    AHNENWIN use PAGENUMBER, COLUMNNUMBER and REPORTTITLE. }
  TQRFunction = (qrfPagenumber, qrfColumnnumber, qrfReporttitle, qrfRecordnumber,
                 qrfRecordcount, qrfDetailcount, qrfDetailno, qrfDate,
                 qrfTime, qrfPagecount);

  { The report function list.

    The AHNENWIN resources stream the built-in report functions as

        Functions.Strings = (
          'PAGENUMBER'
          'COLUMNNUMBER'
          'REPORTTITLE')
        Functions.DATA = (
          '0'
          '0'
          #39#39)

    Both blocks are plain string lists, and neither carries the ".Strings"
    suffix that a published TStrings property would produce. The original
    QuickReport therefore registers them through the DefineProperty
    mechanism (the same mechanism it uses for the page "Values"), and so
    does this stub.

    "Functions.Strings" is the TStrings list of the function names,
    "Functions.DATA" the parallel list of their default values. The empty
    third entry of DATA (written as the two apostrophes #39#39) is the
    default of REPORTTITLE. }
  TQRFunctionList = class(TStringList)
  private
    FData: TStringList;
    FFunctions: TStringList;
  public
    destructor Destroy; override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadFunctions(Reader: TReader);
    procedure WriteFunctions(Writer: TWriter);
    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
    property DATA: TStringList read FData write FData;
    property FunctionNames: TStringList read FFunctions;
  end;

  { Frame (the rectangle drawn around a report element). }
  TQRFrame = class(TComponent)
  private
    FColor: TColor;
    FDrawTop: Boolean;
    FDrawBottom: Boolean;
    FDrawLeft: Boolean;
    FDrawRight: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
  published
    { The resources stream these properties on the frame sub-object. }
    property Color: TColor read FColor write FColor;
    property DrawTop: Boolean read FDrawTop write FDrawTop;
    property DrawBottom: Boolean read FDrawBottom write FDrawBottom;
    property DrawLeft: Boolean read FDrawLeft write FDrawLeft;
    property DrawRight: Boolean read FDrawRight write FDrawRight;
  end;

  { Size of a report element.

    The original streams the size as the property "Size.Values" with four
    Extended values, again through the DefineProperty mechanism
    (TQRPrintableSize.ReadValues at $0051B2C0 in the decompilation of
    Source\Projects_AhnenWin\QuickRpt.pas):
      0 Height   1 Left   2 Top   3 Width }
  TQRPrintableSizeValues = array[0..3] of Extended;

  TQRPrintableSize = class(TComponent)
  private
    FValues: TQRPrintableSizeValues;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadValues(Reader: TReader);
    procedure WriteValues(Writer: TWriter);
    property Values: TQRPrintableSizeValues read FValues;
  end;

  { Forward declaration: the report elements hold a back reference to the
    report they belong to, and the report holds its elements. }
  TCustomQuickRep = class;

  { Base class of everything that can be placed on a report page.

    The AHNENWIN resources stream the following properties on every report
    element (derived from Forms/Form15.dfm, Form5.dfm, Form23.dfm and
    Form25.dfm):

      Alignment, AlignToBand, AutoSize, AutoStretch, Color, Font.*,
      Frame.*, Height, Left, ParentFont, Size.Values, Top, Transparent,
      Width, WordWrap

    TQRPrintable descends from TControl, so Left / Top / Width / Height /
    Color / Font / ParentFont / Transparent / Enabled are already provided
    by the VCL. Only the QuickReport specific ones are added here. }
  TQRPrintable = class(TCustomControl)
  private
    FAlignment: TQRAlignment;
    FAlignToBand: Boolean;
    FFrame: TQRFrame;
    FSize: TQRPrintableSize;
    FParentReport: TCustomQuickRep;
    FAutoStretch: Boolean;
    FWordWrap: Boolean;
    FFontSize: Integer;
    FTransparent: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetAlignment(Value: TQRAlignment);
    procedure SetAlignToBand(Value: Boolean);
    procedure SetFrame(Value: TQRFrame);
    procedure SetSize(Value: TQRPrintableSize);
    procedure SetAutoStretch(Value: Boolean);
    procedure SetWordWrap(Value: Boolean);
    procedure SetFontSize(Value: Integer);
    procedure SetTransparent(Value: Boolean);
    property ParentReport: TCustomQuickRep read FParentReport write FParentReport;
  published
    { The resources stream these properties on every report element. }
    property Alignment: TQRAlignment read FAlignment write SetAlignment;
    property AlignToBand: Boolean read FAlignToBand write SetAlignToBand;
    property Frame: TQRFrame read FFrame write SetFrame;
    property Size: TQRPrintableSize read FSize write SetSize;
    property AutoStretch: Boolean read FAutoStretch write SetAutoStretch;
    property WordWrap: Boolean read FWordWrap write SetWordWrap;
    property FontSize: Integer read FFontSize write SetFontSize;
    { Delphi 9's TControl publishes only Left, Top, Width, Height, Cursor,
      Hint and the Help* properties. Everything else the report elements
      use - Color, AutoSize, Font, ParentFont, Enabled, Transparent - lives
      in protected fields and has to be re-published here so that the
      resources can stream it. }
    property Color;
    property AutoSize;
    property Font;
    property ParentFont;
    property Enabled;
    property Transparent: Boolean read FTransparent write SetTransparent;
    { BiDiMode and ParentBiDiMode are also protected in TControl, and the
      resources of TQRSysData stream them. }
    property BiDiMode;
    property ParentBiDiMode;
  end;

  { A report band. }
  TQRBand = class(TQRPrintable)
  private
    FBandType: TQRBandType;
    FAlignToBottom: Boolean;
    FForceNewColumn: Boolean;
    FForceNewPage: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBandType(Value: TQRBandType);
  published
    property BandType: TQRBandType read FBandType write SetBandType;
    property AlignToBottom: Boolean read FAlignToBottom write FAlignToBottom;
    property ForceNewColumn: Boolean read FForceNewColumn write FForceNewColumn;
    property ForceNewPage: Boolean read FForceNewPage write FForceNewPage;
  end;

  { The report itself.

    The report is not a window control in the original either - it is a
    non-visual component - but the resources stream Left/Top/Width/Height,
    Font.* and Frame.* on it, so those are published here as plain values. }
  TCustomQuickRep = class(TComponent)
  private
    FPage: TQRPage;
    FPrinterSettings: TQRCompositePrinterSettings;
    FFunctions: TQRFunctionList;
    FOptions: TQROptionSet;
    FUnits: TQRUnit;
    FZoom: Integer;
    FSnapToGrid: Boolean;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FFont: TFont;
    FFrame: TQRFrame;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetPage(Value: TQRPage);
    procedure SetPrinterSettings(Value: TQRCompositePrinterSettings);
    procedure SetFunctions(Value: TQRFunctionList);
    procedure SetOptions(Value: TQROptionSet);
    procedure SetUnits(Value: TQRUnit);
    procedure SetZoom(Value: Integer);
    procedure SetSnapToGrid(Value: Boolean);
  published
    { The resources stream these properties, so they have to be published. }
    property Left: Integer read FLeft write FLeft;
    property Top: Integer read FTop write FTop;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property Font: TFont read FFont write FFont;
    property Frame: TQRFrame read FFrame write FFrame;
    property Page: TQRPage read FPage write SetPage;
    property PrinterSettings: TQRCompositePrinterSettings
      read FPrinterSettings write SetPrinterSettings;
    property Functions: TQRFunctionList read FFunctions write SetFunctions;
    property Options: TQROptionSet read FOptions write SetOptions;
    property Units: TQRUnit read FUnits write SetUnits;
    property Zoom: Integer read FZoom write SetZoom;
    property SnapToGrid: Boolean read FSnapToGrid write SetSnapToGrid;
  end;

  TQuickRep = class(TCustomQuickRep)
  private
    FDataSet: TDataSet;
    FPrintIfEmpty: Boolean;
    FShowProgress: Boolean;
    FReportTitle: String;
    FPageNumber: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetDataSet(Value: TDataSet);
    function GetDataSet: TDataSet;
    property ReportTitle: String read FReportTitle write FReportTitle;
    property PageNumber: Integer read FPageNumber write FPageNumber;
  published
    { The resources stream these properties on the report itself. }
    property DataSet: TDataSet read GetDataSet write SetDataSet;
    property PrintIfEmpty: Boolean read FPrintIfEmpty write FPrintIfEmpty;
    property ShowProgress: Boolean read FShowProgress write FShowProgress;
  end;

  { Report preview control, used by Unit16 and QRStandardPreview.

    The original lives in QuickReport's QRPrev unit; the AHNENWIN unit
    Unit16 declares "QRPreview1: TQRPreview" and reaches it through
    QRCtrls, so the class is provided here. The listing of Unit16 shows
    the used members: Zoom, PageNumber and QRPrinter. }
  TQRPreview = class(TCustomControl)
  private
    FZoom: Integer;
    FPageNumber: Integer;
    FQRPrinter: TQRPrinter;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetZoom(Value: Integer);
    procedure SetPageNumber(Value: Integer);
    procedure SetQRPrinter(Value: TQRPrinter);
  published
    property Zoom: Integer read FZoom write SetZoom;
    property PageNumber: Integer read FPageNumber write SetPageNumber;
    property QRPrinter: TQRPrinter read FQRPrinter write SetQRPrinter;
    { The resources of Unit16 and QRStandardPreview stream the scroll bar
      settings ("HorzScrollBar.Smooth", "HorzScrollBar.Tracking", ...).
      TScrollingWinControl keeps the two scroll bar controls in protected
      fields, so they have to be re-published here. }
    property HorzScrollBar: TScrollBar;
    property VertScrollBar: TScrollBar;
  end;

  { Standard preview form shell, streamed by Forms/QRStandardPreview.dfm. }
  TQRStandardPreview = class(TForm)
  public
    QRPrinter: TQRPrinter;
    procedure SetZoom(Value: Integer);
  end;

implementation

{ TQRFunctionList }

destructor TQRFunctionList.Destroy;
begin
  FreeAndNil(FData);
  FreeAndNil(FFunctions);
  inherited Destroy;
end;

procedure TQRFunctionList.DefineProperties(Filer: TFiler);
begin
  { The inherited TStrings.DefineProperties would register a pseudo property
    called 'Strings', which the writer would emit as
    "Functions.Strings.Strings". The original QuickReport writes the two
    lists directly as "Functions.Strings" and "Functions.DATA", so the
    inherited registration is replaced here. }
  Filer.DefineProperty('Strings', ReadFunctions, WriteFunctions, True);
  Filer.DefineProperty('DATA', ReadData, WriteData, True);
end;

procedure TQRFunctionList.ReadData(Reader: TReader);
var
  S: string;
begin
  if FData = nil then
    FData := TStringList.Create;
  FData.Clear;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
  begin
    S := Reader.ReadString;
    FData.Add(S);
  end;
  Reader.ReadListEnd;
end;

procedure TQRFunctionList.WriteData(Writer: TWriter);
var
  i: Integer;
begin
  Writer.WriteListBegin;
  if FData <> nil then
    for i := 0 to FData.Count - 1 do
      Writer.WriteString(FData[i]);
  Writer.WriteListEnd;
end;

procedure TQRFunctionList.ReadFunctions(Reader: TReader);
var
  S: string;
begin
  if FFunctions = nil then
    FFunctions := TStringList.Create;
  FFunctions.Clear;
  Reader.ReadListBegin;
  while not Reader.EndOfList do
  begin
    S := Reader.ReadString;
    FFunctions.Add(S);
  end;
  Reader.ReadListEnd;
end;

procedure TQRFunctionList.WriteFunctions(Writer: TWriter);
var
  i: Integer;
begin
  Writer.WriteListBegin;
  if FFunctions <> nil then
    for i := 0 to FFunctions.Count - 1 do
      Writer.WriteString(FFunctions[i]);
  Writer.WriteListEnd;
end;

{ TQRFrame }

constructor TQRFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColor := clBlack;
  FDrawTop := False;
  FDrawBottom := False;
  FDrawLeft := False;
  FDrawRight := False;
end;

{ TQRPrintableSize }

constructor TQRPrintableSize.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TQRPrintableSize.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Values', ReadValues, WriteValues, True);
end;

procedure TQRPrintableSize.ReadValues(Reader: TReader);
var
  I: Integer;
begin
  { The original reads exactly four floats (TQRPrintableSize.ReadValues at
    $0051B2C0 in the decompilation), but the AHNENWIN resources contain
    both four-value lists and two-value lists - the two-value ones come
    from an older QuickReport version that only wrote width and height.
    The reader therefore accepts a list of up to four values and leaves
    the remaining fields at zero. }
  I := 0;
  Reader.ReadListBegin;
  while (I < 4) and not Reader.EndOfList do
  begin
    FValues[I] := Reader.ReadFloat;
    Inc(I);
  end;
  Reader.ReadListEnd;
end;

procedure TQRPrintableSize.WriteValues(Writer: TWriter);
begin
  Writer.WriteListBegin;
  Writer.WriteFloat(FValues[0]);
  Writer.WriteFloat(FValues[1]);
  Writer.WriteFloat(FValues[2]);
  Writer.WriteFloat(FValues[3]);
  Writer.WriteListEnd;
end;

{ TQRPrintable }

constructor TQRPrintable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFrame := TQRFrame.Create(nil);
  FSize := TQRPrintableSize.Create(nil);
  FAlignment := taLeftJustify;
  FAlignToBand := False;
end;

destructor TQRPrintable.Destroy;
begin
  FFrame.Free;
  FSize.Free;
  inherited Destroy;
end;

procedure TQRPrintable.SetAlignment(Value: TQRAlignment);
begin
  FAlignment := Value;
end;

procedure TQRPrintable.SetAlignToBand(Value: Boolean);
begin
  FAlignToBand := Value;
end;

procedure TQRPrintable.SetFrame(Value: TQRFrame);
begin
  FFrame := Value;
end;

procedure TQRPrintable.SetSize(Value: TQRPrintableSize);
begin
  FSize := Value;
end;

procedure TQRPrintable.SetAutoStretch(Value: Boolean);
begin
  FAutoStretch := Value;
end;

procedure TQRPrintable.SetWordWrap(Value: Boolean);
begin
  FWordWrap := Value;
end;

procedure TQRPrintable.SetFontSize(Value: Integer);
begin
  FFontSize := Value;
  Font.Size := Value;
end;

procedure TQRPrintable.SetTransparent(Value: Boolean);
begin
  FTransparent := Value;
end;

{ TQRBand }

constructor TQRBand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBandType := rbDetail;
end;

procedure TQRBand.SetBandType(Value: TQRBandType);
begin
  FBandType := Value;
end;

{ TCustomQuickRep }

constructor TCustomQuickRep.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPage := TQRPage.Create(nil);
  FPrinterSettings := TQRCompositePrinterSettings.Create(nil);
  FFunctions := TQRFunctionList.Create;
  FFont := TFont.Create;
  FFrame := TQRFrame.Create(nil);
  FUnits := MM;
  FZoom := 100;
  FSnapToGrid := False;
  FWidth := 794;
  FHeight := 1123;
end;

destructor TCustomQuickRep.Destroy;
begin
  FPage.Free;
  FPrinterSettings.Free;
  FFunctions.Free;
  FFont.Free;
  FFrame.Free;
  inherited Destroy;
end;

procedure TCustomQuickRep.SetPage(Value: TQRPage);
begin
  FPage := Value;
end;

procedure TCustomQuickRep.SetPrinterSettings(Value: TQRCompositePrinterSettings);
begin
  FPrinterSettings := Value;
end;

procedure TCustomQuickRep.SetFunctions(Value: TQRFunctionList);
begin
  FFunctions := Value;
end;

procedure TCustomQuickRep.SetOptions(Value: TQROptionSet);
begin
  FOptions := Value;
end;

procedure TCustomQuickRep.SetUnits(Value: TQRUnit);
begin
  FUnits := Value;
end;

procedure TCustomQuickRep.SetZoom(Value: Integer);
begin
  FZoom := Value;
end;

procedure TCustomQuickRep.SetSnapToGrid(Value: Boolean);
begin
  FSnapToGrid := Value;
end;

{ TQuickRep }

constructor TQuickRep.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPrintIfEmpty := True;
  FShowProgress := False;
  FPageNumber := 1;
end;

function TQuickRep.GetDataSet: TDataSet;
begin
  Result := FDataSet;
end;

procedure TQuickRep.SetDataSet(Value: TDataSet);
begin
  FDataSet := Value;
end;

{ TQRPreview }

constructor TQRPreview.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FZoom := 100;
  FPageNumber := 1;
end;

destructor TQRPreview.Destroy;
begin
  inherited Destroy;
end;

procedure TQRPreview.SetZoom(Value: Integer);
begin
  FZoom := Value;
end;

procedure TQRPreview.SetPageNumber(Value: Integer);
begin
  FPageNumber := Value;
end;

procedure TQRPreview.SetQRPrinter(Value: TQRPrinter);
begin
  FQRPrinter := Value;
end;

{ TQRStandardPreview }

procedure TQRStandardPreview.SetZoom(Value: Integer);
begin
end;

end.
