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

  { TfrmBitmapViewerMain }

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
    PRocedure LoadImage(aFilename:String);
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
    LoadImage(OpenPictureDialog1.FileName);
  end;
end;

procedure TfrmBitmapViewerMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmBitmapViewerMain.LoadImage(aFilename: String);
begin
  try
    Caption := aFilename;
    BitImage.Picture.LoadFromFile(aFilename);
  Except
    Caption := 'Error: '+aFilename;
  end;
end;

end.

