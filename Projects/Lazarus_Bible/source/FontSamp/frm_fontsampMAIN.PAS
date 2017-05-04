unit frm_fontsampMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, {$IFNDEF FPC} Windows, Messages,  {$ENDIF}Classes, Graphics, Controls,
  Forms, Dialogs, Menus, Printers, StdCtrls, Buttons, ExtCtrls,
  frm_fontsampAbout, Preview, DrawPage, PrintersDlgs ;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    PrintPreview1: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    SelectAllBitBtn: TBitBtn;
    PrintBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    FontListBox: TListBox;
    Bevel1: TBevel;
    Label1: TLabel;
    PreviewBitBtn: TBitBtn;
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PreviewBitBtnClick(Sender: TObject);
    procedure PrintBitBtnClick(Sender: TObject);
    procedure SelectAllBitBtnClick(Sender: TObject);
  private
    Previewing: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.PrintSetup1Click(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FontListBox.Items := Printer.Fonts;
  Previewing := False;
end;

procedure TMainForm.PreviewBitBtnClick(Sender: TObject);
begin
  if PreviewForm.ShowModal = mrOk then
    PrintBitBtn.Click;  { User selected preview's print button }
end;

{ This is the procedure that prints the pages }
procedure TMainForm.PrintBitBtnClick(Sender: TObject);
var
  PpiX, PpiY, Page, FirstPage, LastPage: Integer;

  { Initialize PrintDialog1 object}
  procedure InitPrintDialog;
  begin
    with PrintDialog1 do
    begin
      MinPage := 1;
      MaxPage := FontListBox.SelCount;
      FromPage := MinPage;
      ToPage := MaxPage;
    end;
  end;

  { Initialize printing variables }
  procedure InitParameters;
  begin
  { Do our own scaling based on Page width and height. This
  seems to be more reliable than GetDeviceCaps. }
    PpiX := Trunc(Printer.PageWidth / 8.5);
    PpiY := Trunc(Printer.PageHeight / 11.0);
  { Set FirstPage and LastPage }
    if PrintDialog1.PrintRange = prAllPages then
    begin
      FirstPage := 1;
      LastPage := FontListBox.SelCount;
    end else
    begin
      FirstPage := PrintDialog1.FromPage;
      LastPage := PrintDialog1.ToPage;
    end;
  end;

begin
  InitPrintDialog;
  if PrintDialog1.Execute then
  begin
    Printer.BeginDoc;
    try
      InitParameters;
      for Page := FirstPage to LastPage do
      begin
        DrawOnePage(Printer.Canvas, FontListBox, Page,
          Printer.PageWidth, Printer.PageHeight, False,
          PpiX, PpiY);
        if Page < LastPage then
          Printer.NewPage;
      end;
    finally
      Printer.EndDoc;
    end;
  end;

end;

procedure TMainForm.SelectAllBitBtnClick(Sender: TObject);
var
  I: Integer;
begin
  with FontListBox, Items do
  for I := 0 to Count - 1 do
    Selected[I] := True;
end;

end.

