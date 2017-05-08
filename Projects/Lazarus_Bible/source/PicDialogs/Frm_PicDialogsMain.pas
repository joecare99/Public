unit Frm_PicDialogsMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  jpeg, Windows,
{$ELSE}
  LCLIntf, LCLType, JPEGLib,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtDlgs, ExtCtrls;

type
  TMainForm = class(TForm)
    Image1: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
  private
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

procedure TMainForm.Open1Click(Sender: TObject);
begin
  with OpenPictureDialog1 do
  if Execute then
  begin
    Image1.Picture.LoadFromFile(Filename);
    Caption := Lowercase(Filename);
    Save1.Enabled := True; // Enable File|Save... command
  end;
end;

procedure TMainForm.Save1Click(Sender: TObject);
begin
  with SavePictureDialog1 do
  begin
    Filename := Caption;
    if Execute then
    begin
      Image1.Picture.SaveToFile(Filename);
      Caption := Lowercase(Filename);
    end;
  end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
