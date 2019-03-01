unit Frm_GrueStewHmi;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$EndIF}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
    ExtCtrls, Menus, unt_GrueStewBase, cls_GrueStewEng;

type

    { TfrmGrueStewMain }

    TfrmGrueStewMain = class(TForm)
        btnShootEast: TSpeedButton;
        btnShootNorth: TSpeedButton;
        btnShootSouth: TSpeedButton;
        btnShootWest: TSpeedButton;
        lblActRoom: TLabel;
        lblMapNorth: TLabel;
        lblMapWest: TLabel;
        lblMapSouth: TLabel;
        lblMapEast: TLabel;
        mniExit: TMenuItem;
        N1: TMenuItem;
        mniNewGame: TMenuItem;
        mniFile: TMenuItem;
        Walk: TLabel;
        Shoot: TLabel;
        MainMenu1: TMainMenu;
        Memo1: TMemo;
        Shape1: TShape;
        btnMoveNorth: TSpeedButton;
        btnMoveEast: TSpeedButton;
        btnMoveWest: TSpeedButton;
        btnMoveSouth: TSpeedButton;
        Shape2: TShape;
        procedure btnMoveClick(Sender: TObject);
        procedure btnShootClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure mniNewGameClick(Sender: TObject);
    private
        fGrueStew: TGrueStewEng;
        FMapLbl:array[tdir] of TLabel;
        FMovBtn:array[tdir] of TSpeedButton;
        FShtBtn:array[tdir] of TSpeedButton;
        Procedure UpdateMap;
        Procedure Write(str:String;clear:boolean=false);
    public

    end;

var
    frmGrueStewMain: TfrmGrueStewMain;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$EndIF}

{ TfrmGrueStewMain }

procedure TfrmGrueStewMain.btnMoveClick(Sender: TObject);
var
    lMResult: TMoveResult;
begin
    if Sender.InheritsFrom(TControl) and Not fGrueStew.HasEnded then
      begin
        Write(ITryMove[TDir(TControl(Sender).Tag)]);
        lMResult := fGrueStew.Move(TDir(TControl(Sender).Tag));
        case lMResult of
            mvOK:
              begin
                Write(fGrueStew.RoomDesc,true);
              end;
            mvWall: Write(CantMoveThere);
            mvExit: begin
              Write(ReachedExit);
            end;
            mvExitwMonst: begin
              Write(ReachedExitwM);
            end;
            mvMonster: Write(CaughtBYMonster);
            mvPit: Write(FellIntoPit);
            mvBat:
              begin
                Write(BatCatchYou,true);
                Write(fGrueStew.RoomDesc);
              end;
            mvEarthquake:
              begin
                memo1.Clear;
                Write(EQuake);
                Write(fGrueStew.RoomDesc);
              end;
          end;
                UpdateMap;

      end;
end;

procedure TfrmGrueStewMain.btnShootClick(Sender: TObject);

var
    lSResult: TShootResult;
begin
    if Sender.InheritsFrom(TControl) then
      begin
        Write(Ishoot[TDir(TControl(Sender).Tag)]);

        lSResult := fGrueStew.Shoot(TDir(TControl(Sender).Tag));
        case lSResult of
            shHit: Write(HitMonster);
            shWall: Write(HitWall);
            shMiss: Write(NoHit1);
            shMiss2: Write(NoHit2);
            shMiss3: Write(NoHit3);
            shEarthquake:
              begin
                memo1.Clear;
                Write(EQuake);
                Write(fGrueStew.RoomDesc);
              end;
          end;
        UpdateMap;
      end;
end;

procedure TfrmGrueStewMain.FormCreate(Sender: TObject);
begin
    fGrueStew := TGrueStewEng.Create;
    FMapLbl[drNorth] := lblMapNorth;
    FMapLbl[drEast] := lblMapEast;
    FMapLbl[drSouth] := lblMapSouth;
    FMapLbl[drWest] := lblMapWest;
    FMovBtn[drNorth] := btnMoveNorth;
    FMovBtn[drEast] := btnMoveEast;
    FMovBtn[drSouth] := btnMoveSouth;
    FMovBtn[drWest] := btnMoveWest;
    FShtBtn[drNorth] := btnShootNorth;
    FShtBtn[drEast] := btnShootEast;
    FShtBtn[drSouth] := btnShootSouth;
    FShtBtn[drWest] := btnShootWest;
    write(fGrueStew.GetDescription,true);
end;

procedure TfrmGrueStewMain.FormDestroy(Sender: TObject);
begin
    FreeAndNil(fGrueStew);
end;

procedure TfrmGrueStewMain.mniNewGameClick(Sender: TObject);
begin
    fGrueStew.NewGame;
    write(fGrueStew.RoomDesc,true);
    UpdateMap;
end;

procedure TfrmGrueStewMain.UpdateMap;
var
  dir: TDir;
  lMapDir: LongInt;
begin
  lblActRoom.Caption:= RaumTxt2[fGrueStew.ActRoom];
  for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
    begin
      lMapDir:=fGrueStew.Map[dir];
      FMapLbl[dir].Caption := RaumTxt2[lMapDir];
      FMovBtn[dir].Enabled:=lMapDir <> -2;
      FShtBtn[dir].Enabled:=lMapDir <> -2;
    end;
end;

procedure TfrmGrueStewMain.Write(str: String; clear: boolean);
begin
  if clear then memo1.Clear;
  str := stringreplace(str,'#','',[rfReplaceAll]);
  Memo1.Lines.Append(str);
end;

end.
