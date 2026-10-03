unit QuickRpt;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, DB, QRCompatErrors, QRCtrls, QRPrntr;

type
  TQuickRepOption = (FirstPageHeader, LastPageFooter, Compression);
  TQuickRepOptions = set of TQuickRepOption;
  TQRUnits = (Inches, MM, Pixels);
  TQRPageOrientation = (poPortrait, poLandscape);
  TQRPaperSize = (Letter, Legal, A3, A4, A5, Custom);

  /// Design-time page contract surfaced by the recovered report forms.
  TQRPage = class(TPersistent)
  private
    FColumns: Integer;
    FOrientation: TQRPageOrientation;
    FPaperSize: TQRPaperSize;
  public
    procedure SetPaperSize(const Value: TQRPaperSize);
    procedure SetColumns(const Value: Integer);
  published
    property Columns: Integer read FColumns write FColumns;
    property Orientation: TQRPageOrientation read FOrientation
      write FOrientation;
    property PaperSize: TQRPaperSize read FPaperSize write FPaperSize;
  end;

  TQROutputBin = (Auto, Upper, OnlyOne, Lower, Middle, Manual, Tractor,
    SmallFormat, LargeFormat, Envelope);

  TQRPrinterSettings = class(TPersistent)
  private
    FCopies: Integer;
    FDuplex: Boolean;
    FFirstPage: Integer;
    FLastPage: Integer;
    FOutputBin: TQROutputBin;
  published
    property Copies: Integer read FCopies write FCopies;
    property Duplex: Boolean read FDuplex write FDuplex;
    property FirstPage: Integer read FFirstPage write FFirstPage;
    property LastPage: Integer read FLastPage write FLastPage;
    property OutputBin: TQROutputBin read FOutputBin write FOutputBin;
  end;

  TCustomQuickRep = class(TQuickReportCompatComponent)
  public
    procedure Prepare;
    procedure Preview;
    procedure Print;
  end;

  TQuickRep = class(TCustomQuickRep)
  private
    FDataSet: TDataSet;
    FOptions: TQuickRepOptions;
    FPage: TQRPage;
    FPrintIfEmpty: Boolean;
    FPrinterSettings: TQRPrinterSettings;
    FShowProgress: Boolean;
    FSnapToGrid: Boolean;
    FUnits: TQRUnits;
    FZoom: Integer;
  published
    property DataSet: TDataSet read FDataSet write FDataSet;
    property Options: TQuickRepOptions read FOptions write FOptions;
    property Page: TQRPage read FPage write FPage;
    property PrintIfEmpty: Boolean read FPrintIfEmpty write FPrintIfEmpty;
    property PrinterSettings: TQRPrinterSettings read FPrinterSettings
      write FPrinterSettings;
    property ShowProgress: Boolean read FShowProgress write FShowProgress;
    property SnapToGrid: Boolean read FSnapToGrid write FSnapToGrid;
    property Units: TQRUnits read FUnits write FUnits;
    property Zoom: Integer read FZoom write FZoom;
  end;

implementation

procedure TQRPage.SetPaperSize(const Value: TQRPaperSize);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPage.SetPaperSize');
end;

procedure TQRPage.SetColumns(const Value: Integer);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPage.SetColumns');
end;

procedure TCustomQuickRep.Prepare;
begin
  raise EQuickReportCompatibilityUnsupported.Create('TCustomQuickRep.Prepare');
end;

procedure TCustomQuickRep.Preview;
begin
  raise EQuickReportCompatibilityUnsupported.Create('TCustomQuickRep.Preview');
end;

procedure TCustomQuickRep.Print;
begin
  raise EQuickReportCompatibilityUnsupported.Create('TCustomQuickRep.Print');
end;

initialization
  RegisterClass(TQuickRep);

end.
