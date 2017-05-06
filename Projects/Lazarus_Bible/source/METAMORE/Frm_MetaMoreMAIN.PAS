unit Frm_MetaMoreMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, ExtCtrls;

type
  TMainForm = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileOpen: TMenuItem;
    N1: TMenuItem;
    FileExit: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    FileSaveAs: TMenuItem;
    procedure FileOpenClick(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
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

procedure TMainForm.FileOpenClick(Sender: TObject);
begin
  with OpenDialog1 do
  if Execute then
  begin
    Image1.Picture.LoadFromFile(Filename);
    Caption := Lowercase(Filename);
  end;
end;

procedure TMainForm.FileSaveAsClick(Sender: TObject);
begin
  with SaveDialog1 do
  begin
    Filename := Caption;
    if Execute then
    begin
      Image1.Picture.SaveToFile(Filename);
      Caption := Lowercase(Filename);
    end;
  end;
end;

procedure TMainForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

end.
