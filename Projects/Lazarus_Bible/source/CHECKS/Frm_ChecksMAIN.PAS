unit Frm_ChecksMAIN;

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
  Forms, Dialogs, Menus, StdCtrls, ExtCtrls;

type

  { TfrmChecksMain }

  TfrmChecksMain = class(TForm)
    bvlInfo: TBevel;
    lblInfo: TLabel;
    mnuMainMenu1: TMainMenu;
    mniFileMenu: TMenuItem;
    mniFileExit: TMenuItem;
    mniLevelMenu: TMenuItem;
    mniLevel1: TMenuItem;
    mniLevel2: TMenuItem;
    mniLevel3: TMenuItem;
    mniLevel4: TMenuItem;
    mniLevel5: TMenuItem;
    mniLevel6: TMenuItem;
    mniLevel7: TMenuItem;
    mniLevel8: TMenuItem;
    mniLevel9: TMenuItem;
    btnShowButton: TButton;
    mniN1: TMenuItem;
    mniLevelInsert: TMenuItem;
    procedure mniFileExitClick(Sender: TObject);
    procedure LevelClick(Sender: TObject);
    procedure btnShowButtonClick(Sender: TObject);
    procedure mniLevelInsertClick(Sender: TObject);
  private
    { Private declarations }
    function GetLevel: Integer;
  public
    { Public declarations }
  end;

var
  frmChecksMain: TfrmChecksMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  highLevel = 9;   { Highest level command }

procedure TfrmChecksMain.mniFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmChecksMain.LevelClick(Sender: TObject);
var
  I: Integer;
begin
  with mniLevelMenu do
    for I := 0 to highLevel - 1 do
      Items[I].Checked := False;
  TMenuItem(Sender).Checked := True;
end;

function TfrmChecksMain.GetLevel: Integer;
var
  I: Integer;
begin
  GetLevel := -1;
  with mniLevelMenu do
    for I := 0 to highLevel - 1 do
      if Items[I].Checked then
        GetLevel := I + 1;
end;

procedure TfrmChecksMain.btnShowButtonClick(Sender: TObject);
var
  S: string;
begin
  S := 'Level = ' + IntToStr(GetLevel) + ' -- Insert:';
  if mniLevelInsert.Checked
    then S := S + 'ON'
    else S := S + 'OFF';
  ShowMessage(S);
end;

procedure TfrmChecksMain.mniLevelInsertClick(Sender: TObject);
begin
  with Sender as TMenuItem do
    Checked := not Checked;
end;

end.

