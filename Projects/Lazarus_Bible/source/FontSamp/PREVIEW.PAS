unit PREVIEW;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, {$IFNDEF FPC} Windows, Messages,  {$ENDIF}Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, DrawPage;

type
  TPreviewForm = class(TForm)
    ToolBar: TPanel;
    LeftPageSB: TSpeedButton;
    RightPageSB: TSpeedButton;
    PrintSB: TSpeedButton;
    CloseSB: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CloseSBClick(Sender: TObject);
    procedure PrintSBClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LeftPageSBClick(Sender: TObject);
    procedure RightPageSBClick(Sender: TObject);
  private
    PreBits: TBitmap;       { Preview bitmap with canvas }
    PpiX, PpiY: Integer;    { Logical pixels per inch }
    Page: Integer;          { One font sampler per page }
    procedure InitGlobals;  { Initialize global variables }
  public
    FontListBox: TListBox;  { Reference to form's ListBox }
  end;

var
  PreviewForm: TPreviewForm;

implementation

uses frm_FontsampMain;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  border = 10;      { Top and bottom preview bitmap borders }

{ Create form and a bitmap to represent the preview page }
procedure TPreviewForm.FormCreate(Sender: TObject);
begin
  FontListBox := nil;
  PreBits := TBitmap.Create;
end;

{ Initialize global variables and window size }
procedure TPreviewForm.InitGlobals;
begin
  PreBits.Width := ClientWidth div 2;  { Bitmap width = 1/2 client width }
  PreBits.Height := Round(1.3 * PreBits.Width);  { 1.3 = 8-1/2 x 11 ratio }
  PpiX := Round(PreBits.Width / 8.5);    { Logical pixels per inch }
  PpiY := Round(PreBits.Height / 11.0);  { Logical pixels per inch }
  if WindowState <> wsMaximized then     { Adjust window bottom }
    ClientHeight := ToolBar.Height + PreBits.Height + border * 2;
end;

{ Tip: OnResize is called before OnActivate, but
only if the form is NOT maximized, in which case FormResize
is never called. Don't use OnResize as your only
display initializer--also initialize in OnActivate. }
procedure TPreviewForm.FormResize(Sender: TObject);
begin
  InitGlobals;
  DrawOnePage(PreBits.Canvas, FontListBox, Page,  { Redraw page }
    PreBits.Width, Height, True, PpiX, PpiY);
  Invalidate;  { Tell Windows to issue wm_Paint to form }
end;

{ Because the program does its own scaling, we can call Draw
instead of StretchDraw as some previewers do. This keeps the
display fast and keeps the text looking as wysiwyg as possible. }
procedure TPreviewForm.FormPaint(Sender: TObject);
begin
  Canvas.Draw(ClientWidth div 4, ToolBar.Height + border, PreBits);
end;

procedure TPreviewForm.FormDestroy(Sender: TObject);
begin
  PreBits.Free;
end;

procedure TPreviewForm.CloseSBClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPreviewForm.PrintSBClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

{ This procedure prepares the FontListBox, and it draws
the first page (or a blank if no font is selected). The
procedure also enables and disables the toolbar speed buttons }
procedure TPreviewForm.FormActivate(Sender: TObject);
begin
{ If you don't assign a ListBox to PreviewForm.FontListBox, this
statement picks up the LisBox from the parent form. }
  if FontListBox = nil then
    FontListBox := MainForm.FontListBox;
{ Draw first page }
  Page := 1;
  InitGlobals;
  DrawOnePage(PreBits.Canvas, FontListBox, Page,
    PreBits.Width, Height, True, PpiX, PpiY);
{ Enable / disable speed buttons in toolbar }
  with FontListBox do
  begin
    LeftPageSB.Enabled := SelCount > 1;
    RightPageSB.Enabled := SelCount > 1;
    PrintSB.Enabled := SelCount > 0;
  end;
end;

{ Display previous page }
procedure TPreviewForm.LeftPageSBClick(Sender: TObject);
begin
  if Page > 1 then
  begin
    Dec(Page);
    DrawOnePage(PreBits.Canvas, FontListBox, Page,
      PreBits.Width, Height, True, PpiX, PpiY);
    Invalidate;
  end;
end;

{ Display next page }
procedure TPreviewForm.RightPageSBClick(Sender: TObject);
begin
  if Page < FontListBox.SelCount then
  begin
    Inc(Page);
    DrawOnePage(PreBits.Canvas, FontListBox, Page,
      PreBits.Width, Height, True, PpiX, PpiY);
    Invalidate;
  end;
end;

end.

