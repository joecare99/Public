unit Frm_BitViewMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLIntf, LCLType,JPEGLib,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, ExtCtrls, ExtDlgs;

type
  TfrmBitmapViewerMain = class(TForm)
    BitImage: TImage;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBitmapViewerMain: TfrmBitmapViewerMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmBitmapViewerMain.Open1Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
    BitImage.Picture.LoadFromFile(OpenPictureDialog1.Filename);
    Caption := OpenPictureDialog1.Filename;
  end;
end;

procedure TfrmBitmapViewerMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.

