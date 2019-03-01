unit frm_SwatMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, Messages,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
   SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls;

const
  crMaletUp : integer = 5;
  crMaletDown : integer  = 6;
  MissedPoints : integer  = -2;
  HitPoints  : integer = 5;
  MissedCritter : integer = -1;
  CritterSize : integer = 72;
  TimerId  : integer = 1;

type
  THole = record
    Time : integer;
    Dead : boolean;
  end;
  
  { TfrmSwatMain }

  TfrmSwatMain = class(TForm)
    mnuSwatMain: TMainMenu;
    Gamr1: TMenuItem;
    New1: TMenuItem;
    Options1: TMenuItem;
    Stop1: TMenuItem;
    Pause1: TMenuItem;
    About1: TMenuItem;
    Timer1: TTimer;
    imgGameOver: TImage;
    imgScoreBoard: TImage;
    lblTime: TLabel;
    lblMiss: TLabel;
    lblHits: TLabel;
    lblEscaped: TLabel;
    lblScore: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure New1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Pause1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
    FScore : integer;
    FHits, FMiss, FEscaped : integer;
    FIsGameOver, FIsPause : Boolean;
    FLive : TBitmap;
    FDead : TBitmap;
    FHoleInfo : array[0..4] of THole;
    FHoles : array[0..4] of TPoint;
    procedure WriteScore;
  public
    { Public declarations }
    LiveTime,  Frequence, GameTime : integer;
  end;

var
  frmSwatMain: TfrmSwatMain;

implementation

uses Types, frm_SwatOptions, frm_AboutSwat;

{$IFDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.dfm}
{$ENDIF}
{$R extrares.res}

resourcestring
  rsTitle = 'Swat!';
  rsPause = '&Pause';
  rsContinue = '&Continue';

procedure TfrmSwatMain.FormCreate(Sender: TObject);
begin
  FHoles[0] := Point( 10, 10 );
  FHoles[1] := Point( 200, 10 );
  FHoles[2] := Point( 100, 100 );
  FHoles[3] := Point( 10, 200 );
  FHoles[4] := Point( 200, 200 );

  Caption := rsTitle;
  Screen.Cursors[crMaletUp] := LoadCursor(HInstance, 'Malet');
  Screen.Cursors[crMaletDown] := LoadCursor(HInstance, 'MaletDown');
  Screen.Cursor := TCursor(crMaletUp);

  randomize;

  FLive := TBitmap.Create;
  FLive.LoadFromResourceName(HInstance, 'Live');
  FDead := TBitmap.Create;
  FDead.LoadFromResourceName(HInstance, 'Dead');

  FIsGameOver := true;
  FIsPause := false;
  LiveTime := 10;
  Frequence := 20;
  GameTime := 150;        // fifteen seconds

  Application.OnMinimize := Pause1Click;
  Application.OnRestore := Pause1Click;
end;

procedure TfrmSwatMain.Timer1Timer(Sender: TObject);
var
  i : integer;
begin
  Timer1.Tag := Timer1.Tag + 1;
  i := random(Frequence);
  if (i < 5) then
  begin
    if (FHoleInfo[i].Time = 0) then
    begin
      FHoleInfo[i].Time := Timer1.Tag + LiveTime;
      FHoleInfo[i].Dead := false;
      Canvas.Draw(FHoles[i].x, FHoles[i].y, FLive);
    end;
  end;
  for i := 0 to 4 do
  begin
    if ( (Timer1.Tag > FHoleInfo[i].Time ) and ( FHoleInfo[i].Time <> 0 ) ) then
    begin
      FHoleInfo[i].Time := 0;
      if not(FHoleInfo[i].Dead) then
      begin
        inc( FScore, MissedCritter );
        inc( FEscaped );
      end;
      Canvas.FillRect(Rect(FHoles[i].x, FHoles[i].y, FHoles[i].x + FDead.Width, FHoles[i].y + FDead.Height));
    end;
  end;
  WriteScore;
  if (Timer1.Tag >= GameTime) then
    Stop1Click(self);
end;

procedure TfrmSwatMain.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i : integer;
  hit : boolean;
begin
  Screen.Cursor := TCursor(crMaletDown);

  if (FIsGameOver or FIsPause) then
    exit;

  hit := false;
  for i := 0 to 4 do
    if ( (not FHoleInfo[i].Dead) and (FHoleInfo[i].Time <> 0) ) then
      if (X > FHoles[i].x ) and ( X < (FHoles[i].x + FLive.Width) ) and
         ( Y > FHoles[i].y ) and ( Y < (FHoles[i].y + FLive.Height)) then
      begin
        inc( FScore, HitPoints );
        FHoleInfo[i].Dead := true;
        FHoleInfo[i].Time := Timer1.Tag + 2 * LiveTime;
        inc( FHits );
        hit := true;
        Canvas.Draw(FHoles[i].x, FHoles[i].y, FDead);
      end;
  if not(hit) then
  begin
    inc ( FScore, MissedPoints );
    inc( FMiss );
  end;
  WriteScore;
end;

procedure TfrmSwatMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := TCursor(crMaletUp);
end;

procedure TfrmSwatMain.New1Click(Sender: TObject);
begin
  Timer1.Enabled := true;
  Timer1.Tag := 0;
  FScore := 0;
  FHits := 0;
  FMiss := 0;
  FEscaped := 0;
  if (FIsPause)
  then begin
    FIsPause := false;
    Pause1.Caption := rsPause;
  end;
  imgGameOver.Visible := false;
  FIsGameOver := false;
  FillChar(FHoleInfo, sizeof(FHoleInfo), 0);
  New1.Enabled := false;
  Options1.Enabled := false;
  Stop1.Enabled := true;
end;

procedure TfrmSwatMain.Options1Click(Sender: TObject);
begin
  frmSwatOptionDlg.ShowModal;
end;

procedure TfrmSwatMain.Stop1Click(Sender: TObject);
var
 i : integer;
begin
  Timer1.Enabled := false;
  FIsPause := false;
  imgGameOver.Visible := true;
  FIsGameOver := true;
  Timer1.Tag := GameTime;
  New1.Enabled := true;
  Options1.Enabled := true;
  Stop1.Enabled := false;
  for i := 0 to 4 do
    if (FHoleInfo[i].Time <> 0) then
      Canvas.FillRect(Rect(FHoles[i].x, FHoles[i].y, FHoles[i].x + FDead.Width,
        FHoles[i].y + FDead.Height));
end;

procedure TfrmSwatMain.Pause1Click(Sender: TObject);
begin
  if (FIsGameOver) then
    exit;

  if (FIsPause) then
  begin
    FIsPause := false;
    Pause1.Caption := rsPause;
    Stop1.Enabled := true;
    Timer1.Enabled := true;
  end
  else
  begin
    FIsPause := true;
    Pause1.Caption := rsContinue;
    Stop1.Enabled := false;
    Timer1.Enabled := false;
  end;
end;

procedure TfrmSwatMain.About1Click(Sender: TObject);
begin
  frmAboutSwat.ShowModal;
end;

procedure TfrmSwatMain.WriteScore;
begin
  lblTime.Caption := IntToStr(GameTime - Timer1.Tag);
  lblHits.Caption := IntToStr(FHits);
  lblMiss.Caption := IntToStr(FMiss);
  lblEscaped.Caption := IntToStr(FEscaped);
  lblScore.Caption := IntToStr(FScore);
end;

end.
