unit QRPrntr;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, Controls, Graphics, QRCompatErrors;

type
  /// Compile-time stand-in for the Delphi graphics type returned by GetPage.
  TMetafile = TGraphic;

  /// QuickReport preview callback signature recovered from the preview controls.
  TQRPreviewEvent = procedure(Sender: TObject) of object;

  TQRPrinter = class;

  TQRPreview = class(TQuickReportCompatComponent)
  private
    FOnPageAvailable: TQRPreviewEvent;
    FPageNumber: Integer;
    FZoom: Integer;
  public
    procedure SetPageNumber(const Value: Integer);
    procedure SetZoom(const Value: Integer);
    procedure SetQRPrinter(Value: TQRPrinter);
    procedure ZoomToFit;
    procedure ZoomToWidth;
    procedure UpdateZoom;
  published
    property OnPageAvailable: TQRPreviewEvent read FOnPageAvailable
      write FOnPageAvailable;
    property PageNumber: Integer read FPageNumber write FPageNumber;
    property Zoom: Integer read FZoom write FZoom;
  end;

  TQRPrinter = class(TQuickReportCompatComponent)
  public
    procedure ClosePreview(Preview: TWinControl);
    procedure Print;
    procedure PrintSetup;
    procedure Save(const FileName: string);
    procedure Load(const FileName: string);
    procedure ExportToFilter(Filter: TObject);
    function PaperLengthValue: Integer;
    function PaperWidthValue: Integer;
    function GetPage(const PageNumber: Integer): TMetafile;
  end;

  TQRStream = class(TQuickReportCompatComponent)
  public
    constructor CreateFromFile(const CreateForWriting: Boolean;
      const FileName: string);
  end;

  TQRExportFilter = class(TQuickReportCompatComponent);

  TQRExportFilterLibrary = class
  public
    function GetSaveDialogFilter: string;
  end;

implementation

procedure TQRPreview.SetPageNumber(const Value: Integer);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPreview.SetPageNumber');
end;

procedure TQRPreview.SetZoom(const Value: Integer);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPreview.SetZoom');
end;

procedure TQRPreview.SetQRPrinter(Value: TQRPrinter);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPreview.SetQRPrinter');
end;

procedure TQRPreview.ZoomToFit;
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPreview.ZoomToFit');
end;

procedure TQRPreview.ZoomToWidth;
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPreview.ZoomToWidth');
end;

procedure TQRPreview.UpdateZoom;
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPreview.UpdateZoom');
end;

procedure TQRPrinter.ClosePreview(Preview: TWinControl);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPrinter.ClosePreview');
end;

procedure TQRPrinter.Print;
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPrinter.Print');
end;

procedure TQRPrinter.PrintSetup;
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPrinter.PrintSetup');
end;

procedure TQRPrinter.Save(const FileName: string);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPrinter.Save');
end;

procedure TQRPrinter.Load(const FileName: string);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPrinter.Load');
end;

procedure TQRPrinter.ExportToFilter(Filter: TObject);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPrinter.ExportToFilter');
end;

function TQRPrinter.PaperLengthValue: Integer;
begin
  raise EQuickReportCompatibilityUnsupported.Create(
    'TQRPrinter.PaperLengthValue');
end;

function TQRPrinter.PaperWidthValue: Integer;
begin
  raise EQuickReportCompatibilityUnsupported.Create(
    'TQRPrinter.PaperWidthValue');
end;

function TQRPrinter.GetPage(const PageNumber: Integer): TMetafile;
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRPrinter.GetPage');
end;

constructor TQRStream.CreateFromFile(const CreateForWriting: Boolean;
  const FileName: string);
begin
  raise EQuickReportCompatibilityUnsupported.Create('TQRStream.CreateFromFile');
end;

function TQRExportFilterLibrary.GetSaveDialogFilter: string;
begin
  raise EQuickReportCompatibilityUnsupported.Create(
    'TQRExportFilterLibrary.GetSaveDialogFilter');
end;

initialization
  RegisterClass(TQRPreview);
  RegisterClass(TQRExportFilter);

end.
