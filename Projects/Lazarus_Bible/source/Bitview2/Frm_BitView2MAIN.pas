unit Frm_BitView2MAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Jpeg, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, ExtCtrls, ExtDlgs;

type
  TfrmBitmapViewer2Main = class(TForm)
    BitImage: TImage;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenPictureDialog;
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBitmapViewer2Main: TfrmBitmapViewer2Main;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmBitmapViewer2Main.Open1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    BitImage.Picture.LoadFromFile(OpenDialog1.Filename);
    Caption := OpenDialog1.Filename;
    FormResize(Sender);
  end;
end;

procedure TfrmBitmapViewer2Main.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmBitmapViewer2Main.FormResize(Sender: TObject);
begin
  HorzScrollBar.Range := BitImage.Picture.Width;
  VertScrollBar.Range := BitImage.Picture.Height;
end;

procedure TfrmBitmapViewer2Main.FormActivate(Sender: TObject);
begin
  OpenDialog1.Filter := GraphicFilter(TGraphic);
end;

end.

