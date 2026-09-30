unit tst_AHW52_QuickReportCompatTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testutils, testregistry;

type
  TTestAHW52QuickReportCompat = class(TTestCase)
  published
    procedure TestQuickReportOperationsRejectUse;
  end;

implementation

uses
  SysUtils, Classes, Interfaces, Forms, QRCompatErrors, QRCtrls, QuickRpt,
  QRPrntr, Unit5, Unit15, Unit23, Unit25;

type
  TCompatOperation = procedure;

procedure AssertUnsupportedCall(const ExpectedOperation: string;
  const CompatOperation: TCompatOperation);
begin
  try
    CompatOperation();
  except
    on E: EQuickReportCompatibilityUnsupported do
    begin
      if E.Operation <> ExpectedOperation then
        raise Exception.CreateFmt(
          'Expected unsupported operation "%s", got "%s".',
          [ExpectedOperation, E.Operation]);
      Exit;
    end;
  end;

  raise Exception.CreateFmt(
    'Unsupported operation "%s" returned without reporting its boundary.',
    [ExpectedOperation]);
end;

procedure CallPrepare;
begin
  TCustomQuickRep(nil).Prepare;
end;

procedure CallPreview;
begin
  TCustomQuickRep(nil).Preview;
end;

procedure CallPreviewConstruction;
var
  preview: TQRPreview;
begin
  preview := TQRPreview.Create(nil);
  preview.Free;
end;

procedure CallPreviewSetPrinter;
begin
  TQRPreview(nil).SetQRPrinter(nil);
end;

procedure CallSetPaperSize;
begin
  TQRPage(nil).SetPaperSize(A4);
end;

procedure CallSetColumns;
begin
  TQRPage(nil).SetColumns(2);
end;

procedure CallReportPrint;
begin
  TCustomQuickRep(nil).Print;
end;

procedure CallPrinterPrint;
begin
  TQRPrinter(nil).Print;
end;

procedure CallPrinterSetup;
begin
  TQRPrinter(nil).PrintSetup;
end;

procedure CallPrinterSave;
begin
  TQRPrinter(nil).Save('synthetic.qrp');
end;

procedure CallPrinterLoad;
begin
  TQRPrinter(nil).Load('synthetic.qrp');
end;

procedure CallStreamCreateFromFile;
var
  stream: TQRStream;
begin
  stream := TQRStream.CreateFromFile(False, 'synthetic.qrp');
  stream.Free;
end;

procedure CallPrinterExport;
begin
  TQRPrinter(nil).ExportToFilter(nil);
end;

procedure CallPreviewPage;
begin
  TQRPreview(nil).SetPageNumber(1);
end;

procedure CallPreviewZoom;
begin
  TQRPreview(nil).SetZoom(100);
end;

procedure CallPreviewFit;
begin
  TQRPreview(nil).ZoomToFit;
end;

procedure CallPreviewWidth;
begin
  TQRPreview(nil).ZoomToWidth;
end;

procedure CallPreviewUpdateZoom;
begin
  TQRPreview(nil).UpdateZoom;
end;

procedure CallPreviewClose;
begin
  TQRPrinter(nil).ClosePreview(nil);
end;

procedure CallPrinterLength;
begin
  TQRPrinter(nil).PaperLengthValue;
end;

procedure CallPrinterWidth;
begin
  TQRPrinter(nil).PaperWidthValue;
end;

procedure CallPrinterGetPage;
begin
  TQRPrinter(nil).GetPage(1);
end;

procedure CallExportFilterList;
begin
  TQRExportFilterLibrary(nil).GetSaveDialogFilter;
end;

procedure AssertUnsupported(const FormClass: TFormClass);
var
  form: TForm;
begin
  try
    form := FormClass.Create(nil);
    form.Free;
  except
    on E: EQuickReportCompatibilityUnsupported do
    begin
      if E.Operation <> 'TQuickRep.Create' then
        raise Exception.CreateFmt(
          'Expected a TQuickRep construction failure, got "%s".',
          [E.Operation]);
      Exit;
    end;
  end;

  raise Exception.CreateFmt(
    '%s constructed without rejecting the compile-only QuickReport layer.',
    [FormClass.ClassName]);
end;

procedure TTestAHW52QuickReportCompat.TestQuickReportOperationsRejectUse;
begin
  AssertUnsupported(TForm5);
    AssertUnsupported(TForm15);
    AssertUnsupported(TForm23);
    AssertUnsupported(TForm25);
    AssertUnsupportedCall('TQRPreview.Create', @CallPreviewConstruction);
    AssertUnsupportedCall('TQRPreview.SetQRPrinter', @CallPreviewSetPrinter);
    AssertUnsupportedCall('TQRPage.SetPaperSize', @CallSetPaperSize);
    AssertUnsupportedCall('TQRPage.SetColumns', @CallSetColumns);
    AssertUnsupportedCall('TCustomQuickRep.Prepare', @CallPrepare);
    AssertUnsupportedCall('TCustomQuickRep.Preview', @CallPreview);
    AssertUnsupportedCall('TCustomQuickRep.Print', @CallReportPrint);
    AssertUnsupportedCall('TQRPrinter.Print', @CallPrinterPrint);
    AssertUnsupportedCall('TQRPrinter.PrintSetup', @CallPrinterSetup);
    AssertUnsupportedCall('TQRPrinter.Save', @CallPrinterSave);
    AssertUnsupportedCall('TQRPrinter.Load', @CallPrinterLoad);
    AssertUnsupportedCall('TQRStream.CreateFromFile', @CallStreamCreateFromFile);
    AssertUnsupportedCall('TQRPrinter.ExportToFilter', @CallPrinterExport);
    AssertUnsupportedCall('TQRPreview.SetPageNumber', @CallPreviewPage);
    AssertUnsupportedCall('TQRPreview.SetZoom', @CallPreviewZoom);
    AssertUnsupportedCall('TQRPreview.ZoomToFit', @CallPreviewFit);
    AssertUnsupportedCall('TQRPreview.ZoomToWidth', @CallPreviewWidth);
    AssertUnsupportedCall('TQRPreview.UpdateZoom', @CallPreviewUpdateZoom);
    AssertUnsupportedCall('TQRPrinter.ClosePreview', @CallPreviewClose);
    AssertUnsupportedCall('TQRPrinter.PaperLengthValue', @CallPrinterLength);
    AssertUnsupportedCall('TQRPrinter.PaperWidthValue', @CallPrinterWidth);
    AssertUnsupportedCall('TQRPrinter.GetPage', @CallPrinterGetPage);
    AssertUnsupportedCall('TQRExportFilterLibrary.GetSaveDialogFilter',
      @CallExportFilterList);
end;

initialization
  RegisterTest(TTestAHW52QuickReportCompat);

end.
