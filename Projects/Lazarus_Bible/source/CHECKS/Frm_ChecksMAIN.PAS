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

  { TMainForm }

  TMainForm = class(TForm)
    bvlInfo: TBevel;
    lblInfo: TLabel;
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileExit: TMenuItem;
    LevelMenu: TMenuItem;
    Level1: TMenuItem;
    Level2: TMenuItem;
    Level3: TMenuItem;
    Level4: TMenuItem;
    Level5: TMenuItem;
    Level6: TMenuItem;
    Level7: TMenuItem;
    Level8: TMenuItem;
    Level9: TMenuItem;
    ShowButton: TButton;
    N1: TMenuItem;
    LevelInsert: TMenuItem;
    procedure FileExitClick(Sender: TObject);
    procedure lblInfoClick(Sender: TObject);
    procedure LevelClick(Sender: TObject);
    procedure ShowButtonClick(Sender: TObject);
    procedure LevelInsertClick(Sender: TObject);
  private
    { Private declarations }
    function GetLevel: Integer;
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

const
  highLevel = 9;   { Highest level command }

procedure TMainForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.lblInfoClick(Sender: TObject);
begin

end;

procedure TMainForm.LevelClick(Sender: TObject);
var
  I: Integer;
begin
  with LevelMenu do
    for I := 0 to highLevel - 1 do
      Items[I].Checked := False;
  TMenuItem(Sender).Checked := True;
end;

function TMainForm.GetLevel: Integer;
var
  I: Integer;
begin
  GetLevel := -1;
  with LevelMenu do
    for I := 0 to highLevel - 1 do
      if Items[I].Checked then
        GetLevel := I + 1;
end;

procedure TMainForm.ShowButtonClick(Sender: TObject);
var
  S: string;
begin
  S := 'Level = ' + IntToStr(GetLevel) + ' -- Insert:';
  if LevelInsert.Checked
    then S := S + 'ON'
    else S := S + 'OFF';
  ShowMessage(S);
end;

procedure TMainForm.LevelInsertClick(Sender: TObject);
begin
  with Sender as TMenuItem do
    Checked := not Checked;
end;

end.

