unit frm_MenuTestMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, LCLTranslator;

type

  { TfrmMenuTestMain }

  TfrmMenuTestMain = class(TForm)
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMenuTestMain: TfrmMenuTestMain;

implementation

{$R *.lfm}

{ TfrmMenuTestMain }

procedure TfrmMenuTestMain.MenuItem8Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMenuTestMain.FormCreate(Sender: TObject);
begin

end;

procedure TfrmMenuTestMain.MenuItem9Click(Sender: TObject);
begin
  SetDefaultLang('en');
  GetLocaleFormatSettings($409, DefaultFormatSettings);
end;

procedure TfrmMenuTestMain.MenuItem10Click(Sender: TObject);
begin
  SetDefaultLang('de');
  GetLocaleFormatSettings($407, DefaultFormatSettings);
end;

end.

