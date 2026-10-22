unit QRPrntr;

{-------------------------------------------------------------------------------
  QRPrntr - QuickReport printer/page model (compatibility stub).

  QuickReport 3.x splits its printer support across QRPrntr. The DCU and the
  source are both unavailable in this environment, and the IDR decompilation
  (Source\Projects_AhnenWin\QRPrntr.pas) leaves 232 method signatures
  unresolved, so it cannot be used as a source.

  This stub reproduces the public surface that the AHNENWIN resources and the
  reconstructed application units reference:

    * TQRPrinter         - the printer session object
    * TQRPage            - page geometry (columns, orientation, paper size,
                           and the six margin values that the resources
                           stream as "Page.Values")
    * TQuickRepPrinterSettings / TQRCompositePrinterSettings

  The settings objects derive from TComponent so that their properties can
  be published and therefore streamed from the DFM resources.

  Dependency direction: QRPrntr must NOT reference QuickRpt, because QuickRpt
  references QRPrntr. Avoiding the back-reference prevents a circular unit
  reference (E2047) - verified empirically with dcc32 17.0.

  The stub performs NO printing. Pages are described, not rendered. Every
  report actually produced by the reconstruction goes through the plain-text
  / HTML export path in Unit16.Speichernunter1Click, not through a printer.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, Graphics, Printers;

type
  { Paper sizes. The AHNENWIN resources stream "Page.PaperSize = A4", so
    the element names follow the QuickReport spelling, which is the plain
    paper name for the common formats and DMPAPER_* for the rest. }
  TQRPaperSize = (Letter, LetterSmall, Tabloid, Ledger, Legal, Statement,
                  Executive, A3, A4, A4Small, A5, B4, B5, Folio, Quarto,
                  DMPAPER_10x14, DMPAPER_11x17, DMPAPER_ENV10, DMPAPER_ENV11,
                  DMPAPER_ENV12, DMPAPER_ENV14, DMPAPER_ENV_C, DMPAPER_ENV_D,
                  DMPAPER_ENV_DL, DMPAPER_ENV_E, DMPAPER_ENV_FAX,
                  DMPAPER_ENV_PERSONAL, DMPAPER_ENV_REPLY, DMPAPER_ENV_OTHER);

  { Page orientation. The resources stream "Page.Orientation = poPortrait",
    which is the VCL TPrinterOrientation spelling. }
  TQROrientation = TPrinterOrientation;

  { Output bin / duplex as used by the resource files. }
  { Output bin. The resources stream "PrinterSettings.OutputBin = Auto". }
  TQROutputBin = (Auto, Upper, Lower, Middle, Manual, FormSource,
                  ManualEnvelope, EnvelopeSource, ManualDuplex, PaperSource,
                  UpperFullWidth, LowerFullWidth, MiddleFullWidth,
                  UpperFullWidthDeck, LowerFullWidthDeck, MiddleFullWidthDeck);

  { Duplex. The resources stream "PrinterSettings.Duplex = False", i.e. a
    Boolean flag rather than an enumeration. }
  TQRDuplex = Boolean;

  { The page margin / size values that the AHNENWIN resources stream under
    "Page.Values".

    The original QuickReport does NOT use a published array property - the
    decompilation of Source\Projects_AhnenWin\QuickRpt.pas shows

      TQRPage.ReadValues(Reader)  at $0051572C
      TQRPage.WriteValues(Writer) at $005157C4

    and TQRUnitBase.DefineProperties (at $00515240) registers them through
    Filer.DefineProperty('Values', ReadValues, WriteValues, True).

    The same mechanism is reproduced here, because Delphi 9 rejects a
    published array property (E2188).

    The seven values are, in the order of the original ReadValues listing:
      0 BottomMargin   1 Length        2 TopMargin     3 Width
      4 LeftMargin     5 RightMargin   6 ColumnSpace

    They are streamed as Extended, exactly like the original. }
  TQRPageValues = array[0..6] of Extended;

  { Printer session. The original wraps the Windows printer API. }
  TQRPrinter = class(TComponent)
  private
    FPageCount: Integer;
    FPaperSize: TQRPaperSize;
    FOrientation: TQROrientation;
    FCopies: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    property PageCount: Integer read FPageCount write FPageCount;
    property PaperSize: TQRPaperSize read FPaperSize write FPaperSize;
    property Orientation: TQROrientation read FOrientation write FOrientation;
    property Copies: Integer read FCopies write FCopies;
  end;

  { Page geometry. }
  TQRPage = class(TComponent)
  private
    FColumns: Integer;
    FOrientation: TQROrientation;
    FPaperSize: TQRPaperSize;
    FValues: TQRPageValues;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadValues(Reader: TReader);
    procedure WriteValues(Writer: TWriter);
    property Values: TQRPageValues read FValues;
  published
    property Columns: Integer read FColumns write FColumns;
    property Orientation: TQROrientation read FOrientation write FOrientation;
    property PaperSize: TQRPaperSize read FPaperSize write FPaperSize;
  end;

  { Printer settings as streamed by the resources. }
  TQuickRepPrinterSettings = class(TComponent)
  private
    FCopies: Integer;
    FDuplex: TQRDuplex;
    FFirstPage: Integer;
    FLastPage: Integer;
    FOutputBin: TQROutputBin;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Copies: Integer read FCopies write FCopies;
    property Duplex: TQRDuplex read FDuplex write FDuplex;
    property FirstPage: Integer read FFirstPage write FFirstPage;
    property LastPage: Integer read FLastPage write FLastPage;
    property OutputBin: TQROutputBin read FOutputBin write FOutputBin;
  end;

  { Composite settings as used by TQuickRep.PrinterSettings. }
  TQRCompositePrinterSettings = class(TQuickRepPrinterSettings)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TQRPrinter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPageCount := 0;
  FPaperSize := A4;
  FOrientation := poPortrait;
  FCopies := 1;
end;

constructor TQRPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColumns := 1;
  FOrientation := poPortrait;
  FPaperSize := A4;
end;

{ The 'Values' property is streamed as a list of seven Extended values, the
  same way the original QuickReport does it (TQRUnitBase.DefineProperties
  at $00515240 in the decompilation). }
procedure TQRPage.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Values', ReadValues, WriteValues, True);
end;

procedure TQRPage.ReadValues(Reader: TReader);
var
  I: Integer;
begin
  { The original reads exactly seven floats (TQRPage.ReadValues at
    $0051572C in the decompilation). The AHNENWIN resources always carry
    six values, so the reader accepts a list of up to seven and leaves the
    remaining fields at zero. }
  I := 0;
  Reader.ReadListBegin;
  while (I < 7) and not Reader.EndOfList do
  begin
    FValues[I] := Reader.ReadFloat;
    Inc(I);
  end;
  Reader.ReadListEnd;
end;

procedure TQRPage.WriteValues(Writer: TWriter);
begin
  Writer.WriteListBegin;
  Writer.WriteFloat(FValues[0]);
  Writer.WriteFloat(FValues[1]);
  Writer.WriteFloat(FValues[2]);
  Writer.WriteFloat(FValues[3]);
  Writer.WriteFloat(FValues[4]);
  Writer.WriteFloat(FValues[5]);
  Writer.WriteFloat(FValues[6]);
  Writer.WriteListEnd;
end;

constructor TQuickRepPrinterSettings.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCopies := 1;
  FDuplex := False;
  FFirstPage := 0;
  FLastPage := 0;
  FOutputBin := Auto;
end;

constructor TQRCompositePrinterSettings.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
