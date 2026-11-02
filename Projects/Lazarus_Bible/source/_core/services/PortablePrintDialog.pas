unit PortablePrintDialog;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Graphics;

type
  TPortablePrintDialog = class(TForm)
  private
    FLines: TStringList;
    FTitle: string;
    FPage: Integer;
    FPageCount: Integer;
    FPrinterBox: TComboBox;
    FPreview: TPaintBox;
    FPageLabel: TLabel;
    FPreviousButton: TButton;
    FNextButton: TButton;
    FPrintButton: TButton;
    FCancelButton: TButton;
    procedure PrinterChanged(Sender: TObject);
    procedure PreviousPage(Sender: TObject);
    procedure NextPage(Sender: TObject);
    procedure PaintPreview(Sender: TObject);
    procedure UpdatePage;
    procedure PrintDocument(Sender: TObject);
    function LinesPerPage: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function Execute(AOwner: TComponent; const ATitle: string;
      ALines: TStrings): Boolean;
    class procedure SelectPrinter(AOwner: TComponent);
  end;

implementation

uses
  Printers;

constructor TPortablePrintDialog.Create(AOwner: TComponent);
var
  ControlsPanel: TPanel;
begin
  inherited CreateNew(AOwner);
  Caption := 'Print preview';
  BorderStyle := bsDialog;
  Position := poScreenCenter;
  Width := 620;
  Height := 700;

  FLines := TStringList.Create;
  FPage := 0;
  FPageCount := 1;

  FPrinterBox := TComboBox.Create(Self);
  FPrinterBox.Parent := Self;
  FPrinterBox.Left := 12;
  FPrinterBox.Top := 12;
  FPrinterBox.Width := 380;
  FPrinterBox.Style := csDropDownList;
  FPrinterBox.OnChange := PrinterChanged;

  FPreview := TPaintBox.Create(Self);
  FPreview.Parent := Self;
  FPreview.Left := 12;
  FPreview.Top := 48;
  FPreview.Width := 580;
  FPreview.Height := 570;
  FPreview.Anchors := [akLeft, akTop, akRight, akBottom];
  FPreview.OnPaint := PaintPreview;

  ControlsPanel := TPanel.Create(Self);
  ControlsPanel.Parent := Self;
  ControlsPanel.Align := alBottom;
  ControlsPanel.Height := 48;
  ControlsPanel.BevelOuter := bvNone;

  FPageLabel := TLabel.Create(Self);
  FPageLabel.Parent := ControlsPanel;
  FPageLabel.Left := 12;
  FPageLabel.Top := 17;

  FPreviousButton := TButton.Create(Self);
  FPreviousButton.Parent := ControlsPanel;
  FPreviousButton.Caption := '<';
  FPreviousButton.SetBounds(250, 8, 44, 32);
  FPreviousButton.OnClick := PreviousPage;

  FNextButton := TButton.Create(Self);
  FNextButton.Parent := ControlsPanel;
  FNextButton.Caption := '>';
  FNextButton.SetBounds(298, 8, 44, 32);
  FNextButton.OnClick := NextPage;

  FPrintButton := TButton.Create(Self);
  FPrintButton.Parent := ControlsPanel;
  FPrintButton.Caption := 'Print';
  FPrintButton.SetBounds(430, 8, 72, 32);
  FPrintButton.Anchors := [akRight, akBottom];
  FPrintButton.OnClick := PrintDocument;

  FCancelButton := TButton.Create(Self);
  FCancelButton.Parent := ControlsPanel;
  FCancelButton.Caption := 'Close';
  FCancelButton.SetBounds(510, 8, 72, 32);
  FCancelButton.Anchors := [akRight, akBottom];
  FCancelButton.ModalResult := mrCancel;

  FPrinterBox.Items.Assign(Printer.Printers);
  if (Printer.PrinterIndex >= 0) and
     (Printer.PrinterIndex < FPrinterBox.Items.Count) then
    FPrinterBox.ItemIndex := Printer.PrinterIndex
  else if FPrinterBox.Items.Count > 0 then
    FPrinterBox.ItemIndex := 0;
  FPrintButton.Enabled := FPrinterBox.Items.Count > 0;
end;

destructor TPortablePrintDialog.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

class function TPortablePrintDialog.Execute(AOwner: TComponent;
  const ATitle: string; ALines: TStrings): Boolean;
var
  Dialog: TPortablePrintDialog;
begin
  Dialog := TPortablePrintDialog.Create(AOwner);
  try
    Dialog.FTitle := ATitle;
    if ALines <> nil then
      Dialog.FLines.Assign(ALines);
    Dialog.FPrintButton.Enabled := Dialog.FPrinterBox.Items.Count > 0;
    Dialog.UpdatePage;
    Result := Dialog.ShowModal = mrOk;
  finally
    Dialog.Free;
  end;
end;

class procedure TPortablePrintDialog.SelectPrinter(AOwner: TComponent);
var
  Dialog: TPortablePrintDialog;
begin
  Dialog := TPortablePrintDialog.Create(AOwner);
  try
    Dialog.Caption := 'Printer setup';
    Dialog.FPrintButton.Visible := False;
    Dialog.FPreviousButton.Visible := False;
    Dialog.FNextButton.Visible := False;
    Dialog.FPageLabel.Visible := False;
    Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

procedure TPortablePrintDialog.PrinterChanged(Sender: TObject);
begin
  if FPrinterBox.ItemIndex >= 0 then
    Printer.PrinterIndex := FPrinterBox.ItemIndex;
  UpdatePage;
end;

procedure TPortablePrintDialog.PreviousPage(Sender: TObject);
begin
  if FPage > 0 then
    Dec(FPage);
  UpdatePage;
end;

procedure TPortablePrintDialog.NextPage(Sender: TObject);
begin
  if FPage < FPageCount - 1 then
    Inc(FPage);
  UpdatePage;
end;

function TPortablePrintDialog.LinesPerPage: Integer;
var
  LineHeight: Integer;
begin
  LineHeight := FPreview.Canvas.TextHeight('Ag') + 4;
  if LineHeight < 1 then
    LineHeight := 1;
  Result := (FPreview.Height - 100) div LineHeight;
  if Result < 1 then
    Result := 1;
end;

procedure TPortablePrintDialog.UpdatePage;
begin
  FPageCount := (FLines.Count + LinesPerPage - 1) div LinesPerPage;
  if FPageCount < 1 then
    FPageCount := 1;
  if FPage >= FPageCount then
    FPage := FPageCount - 1;
  FPageLabel.Caption := 'Page ' + IntToStr(FPage + 1) + ' of ' +
    IntToStr(FPageCount);
  FPreviousButton.Enabled := FPage > 0;
  FNextButton.Enabled := FPage < FPageCount - 1;
  FPreview.Invalidate;
end;

procedure TPortablePrintDialog.PaintPreview(Sender: TObject);
var
  I, FirstLine, LastLine, Y, LineHeight, PageWidth, PageHeight: Integer;
  Scale: Double;
begin
  FPreview.Canvas.Brush.Color := clBtnFace;
  FPreview.Canvas.FillRect(FPreview.ClientRect);
  PageWidth := FPreview.Width - 48;
  PageHeight := FPreview.Height - 24;
  if PageWidth < 1 then
    Exit;
  Scale := PageWidth / 600;
  if PageHeight / 800 < Scale then
    Scale := PageHeight / 800;
  PageWidth := Round(600 * Scale);
  PageHeight := Round(800 * Scale);
  FPreview.Canvas.Brush.Color := clWhite;
  FPreview.Canvas.Pen.Color := clGray;
  FPreview.Canvas.Rectangle((FPreview.Width - PageWidth) div 2,
    (FPreview.Height - PageHeight) div 2,
    (FPreview.Width + PageWidth) div 2,
    (FPreview.Height + PageHeight) div 2);
  FPreview.Canvas.Font.Size := 10;
  LineHeight := FPreview.Canvas.TextHeight('Ag') + 4;
  FirstLine := FPage * LinesPerPage;
  LastLine := FirstLine + LinesPerPage - 1;
  if LastLine >= FLines.Count then
    LastLine := FLines.Count - 1;
  Y := (FPreview.Height - PageHeight) div 2 + Round(42 * Scale);
  FPreview.Canvas.Font.Style := [fsBold];
  FPreview.Canvas.TextOut((FPreview.Width - PageWidth) div 2 + Round(42 * Scale),
    Y, FTitle);
  Inc(Y, LineHeight * 2);
  FPreview.Canvas.Font.Style := [];
  for I := FirstLine to LastLine do
  begin
    FPreview.Canvas.TextOut((FPreview.Width - PageWidth) div 2 + Round(42 * Scale),
      Y, FLines[I]);
    Inc(Y, LineHeight);
  end;
end;

procedure TPortablePrintDialog.PrintDocument(Sender: TObject);
var
  I, LineHeight, Y, PageLine, PageLines: Integer;
begin
  try
    Printer.PrinterIndex := FPrinterBox.ItemIndex;
    Printer.BeginDoc;
    try
      PageLines := (Printer.PageHeight - 200) div
        (Printer.Canvas.TextHeight('Ag') + 4);
      if PageLines < 1 then
        PageLines := 1;
      Printer.Canvas.Font.Style := [fsBold];
      Printer.Canvas.TextOut(100, 100, FTitle);
      Printer.Canvas.Font.Style := [];
      LineHeight := Printer.Canvas.TextHeight('Ag') + 4;
      Y := 100 + LineHeight * 2;
      PageLine := 0;
      for I := 0 to FLines.Count - 1 do
      begin
        if PageLine >= PageLines then
        begin
          Printer.NewPage;
          Y := 100;
          PageLine := 0;
        end;
        Printer.Canvas.TextOut(100, Y, FLines[I]);
        Inc(Y, LineHeight);
        Inc(PageLine);
      end;
    finally
      Printer.EndDoc;
    end;
    ModalResult := mrOk;
  except
    on E: Exception do
      Application.MessageBox(PChar(E.Message), PChar('Printing failed'), 0);
  end;
end;

end.
