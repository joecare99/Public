unit Frm_Checks2Main;

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
  Forms, Dialogs, Menus, StdCtrls, ComCtrls, ExtCtrls, ActnList;

type

  { TfrmChecks2Main }

  TfrmChecks2Main = class(TForm)
    actLevel2: TAction;
    actLevel3: TAction;
    actLevel4: TAction;
    actLevel5: TAction;
    actLevel6: TAction;
    actLevel7: TAction;
    actLevel8: TAction;
    actLevel9: TAction;
    actLevel1: TAction;
    ActionList1: TActionList;
    bvlInfo: TBevel;
    CoolBar1: TCoolBar;
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
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure FileExitClick(Sender: TObject);
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
  frmChecks2Main: TfrmChecks2Main;

implementation

{$IFnDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  highLevel = 9;   { Highest level command }

procedure TfrmChecks2Main.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmChecks2Main.LevelClick(Sender: TObject);
var
  I: Integer;
begin
  //with LevelMenu do
  //  for I := 0 to highLevel - 1 do
  //    Items[I].Checked := False;
//  TMenuItem(Sender).Checked := True;
end;

function TfrmChecks2Main.GetLevel: Integer;
var
  I: Integer;
begin
  GetLevel := -1;
  with LevelMenu do
    for I := 0 to highLevel - 1 do
      if Items[I].Checked then
        GetLevel := I + 1;
end;

procedure TfrmChecks2Main.ShowButtonClick(Sender: TObject);
var
  S: string;
begin
  S := 'Level = ' + IntToStr(GetLevel) + ' -- Insert:';
  if LevelInsert.Checked
    then S := S + 'ON'
    else S := S + 'OFF';
  ShowMessage(S);
end;

procedure TfrmChecks2Main.LevelInsertClick(Sender: TObject);
begin
  with Sender as TMenuItem do
    Checked := not Checked;
end;

end.

