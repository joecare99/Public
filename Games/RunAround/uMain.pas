unit uMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{
    Coder: Jack
    Compiled: Delphi 2007
    Website: www.delphibasics.co.nr
}

interface

uses
{$IFnDEF FPC}
  jpeg, Windows, GIFImg,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  Tfrm_game = class(TForm)
    tmr_enemy: TTimer;
    Game_panel: TPanel;
    lbl1: TLabel;
    Label2: TLabel;
    lbl_level: TLabel;
    tmr_level: TTimer;
    tmr_score: TTimer;
    lbl_score: TLabel;
    btn_start: TButton;
    lbl_enemy: TLabel;
    lbl_player: TLabel;
    btn_restart: TButton;
    lbl_scoremax: TLabel;
    lbl_levelmax: TLabel;
    lbl_3: TLabel;
    lbl_4: TLabel;
    lbl_5: TLabel;
    lbl_name: TLabel;
    edt_name: TEdit;
    lbl_6: TLabel;
    shp_player: TShape;
    shp_enemy: TShape;
    Label1: TLabel;
    procedure FormMouseMove(Sender: TObject; {%H-}Shift: TShiftState; X, Y: Integer);
    procedure tmr_enemyTimer(Sender: TObject);
    procedure tmr_levelTimer(Sender: TObject);
    procedure tmr_scoreTimer(Sender: TObject);
    procedure btn_startClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_restartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_game: Tfrm_game;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure Tfrm_game.FormCreate(Sender: TObject);
begin
  btn_restart.visible := false;
  edt_name.Visible := false;
  lbl_6.visible := false;
end;

procedure Tfrm_game.btn_startClick(Sender: TObject);
begin
btn_start.Visible := false;
lbl_player.visible := false;
lbl_enemy.Visible := false;
tmr_enemy.enabled := true;
tmr_level.enabled := true;
tmr_score.enabled := true;
end;


procedure Tfrm_game.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
lbl_player.left := x - lbl_player.Width;
lbl_player.Top := y - lbl_player.Height;
shp_player.Left := x  -1;
shp_player.Top := y   -shp_player.Height+1;

end;

procedure Tfrm_game.tmr_enemyTimer(Sender: TObject);
var
  overlay : Trect;
begin

  // This makes the enemy object chase the player object
if shp_enemy.Left < shp_player.Left then shp_enemy.Left := shp_enemy.Left + lbl_level.tag;
if shp_enemy.Left > shp_player.Left then shp_enemy.Left := shp_enemy.Left - lbl_level.tag;
if shp_enemy.Top < shp_player.Top then shp_enemy.Top := shp_enemy.Top + lbl_level.tag;
if shp_enemy.Top > shp_player.Top then shp_enemy.Top := shp_enemy.Top - lbl_level.tag;

    //This is the collision detection routine
  if  Intersectrect (overlay, shp_enemy.BoundsRect, shp_player.BoundsRect) then
    begin
    tmr_enemy.enabled := false;
    tmr_level.enabled := false;
    tmr_score.Enabled := false;
    showmessage ('Game Over');
    lbl_enemy.Visible := true;
    edt_name.visible := true;
    lbl_6.visible := true;
    shp_enemy.Top := 320 ;
    shp_enemy.Left := 752;
    btn_restart.visible := true;
    if lbl_scoremax.tag = lbl_score.tag then
      begin
      Showmessage ('Congratulations!  You have broken the record.  Enter your name.');
      edt_name.text := ('');
    end;
    lbl_player.visible := true;
    lbl_name.visible := true;
  end;
end;

procedure Tfrm_game.tmr_levelTimer(Sender: TObject);
begin
  //Increments the tag of lbl_level component
lbl_level.tag := lbl_level.tag + 1;
lbl_level.Caption := inttostr(lbl_level.Tag);
end;

procedure Tfrm_game.tmr_scoreTimer(Sender: TObject);
begin
  //Increments the tag of lbl_score component
lbl_score.tag := lbl_score.tag + 1;
lbl_score.caption := inttostr(lbl_score.tag);
  if lbl_score.Tag > lbl_scoremax.tag then
    begin
    lbl_scoremax.Tag := lbl_score.tag;
    lbl_scoremax.Caption := inttostr(lbl_scoremax.Tag);
  end;
  if lbl_level.Tag > lbl_levelmax.tag then
    begin
    lbl_levelmax.Tag := lbl_level.tag;
    lbl_levelmax.Caption := inttostr(lbl_levelmax.Tag);
  end;
end;

procedure Tfrm_game.btn_restartClick(Sender: TObject);
begin
  btn_restart.visible := false;
  lbl_player.visible := false;
  lbl_enemy.Visible := false;
  lbl_level.Tag := 1;
  lbl_level.Caption := ('1');
  lbl_score.Tag := 0;
  lbl_score.Caption := ('1');
  tmr_enemy.enabled := true;
  tmr_level.enabled := true;
  tmr_score.enabled := true;
  lbl_6.visible := false;
  edt_name.visible := false;
  lbl_name.Caption := edt_name.Text;
end;

end.
