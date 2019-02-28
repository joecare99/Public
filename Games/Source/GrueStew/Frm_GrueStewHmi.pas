unit Frm_GrueStewHmi;

{$mode objfpc}{$H+}

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
    public

    end;

var
    frmGrueStewMain: TfrmGrueStewMain;

implementation

{$R *.lfm}

{ TfrmGrueStewMain }

procedure TfrmGrueStewMain.btnMoveClick(Sender: TObject);
var
    lMResult: TMoveResult;
begin
    if Sender.InheritsFrom(TControl) and Not fGrueStew.HasEnded then
      begin
        Memo1.Append(ITryMove[TDir(TControl(Sender).Tag)]);
        lMResult := fGrueStew.Move(TDir(TControl(Sender).Tag));
        case lMResult of
            mvOK:
              begin
                memo1.Clear;
                memo1.Append(fGrueStew.RoomDesc);
              end;
            mvWall: memo1.Append(CantMoveThere);
            mvExit: begin
              memo1.Append(ReachedExit);
            end;
            mvExitwMonst: begin
              memo1.Append(ReachedExitwM);
            end;
            mvMonster: memo1.Append(CaughtBYMonster);
            mvPit: memo1.Append(FellIntoPit);
            mvBat:
              begin
                memo1.Clear;
                memo1.Append(BatCatchYou);
                memo1.Append(fGrueStew.RoomDesc);
              end;
            mvEarthquake:
              begin
                memo1.Clear;
                memo1.Append(EQuake);
                memo1.Append(fGrueStew.RoomDesc);
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
        Memo1.Append(Ishoot[TDir(TControl(Sender).Tag)]);

        lSResult := fGrueStew.Shoot(TDir(TControl(Sender).Tag));
        case lSResult of
            shHit: Memo1.Append(HitMonster);
            shWall: Memo1.Append(HitWall);
            shMiss: Memo1.Append(NoHit1);
            shMiss2: Memo1.Append(NoHit2);
            shMiss3: Memo1.Append(NoHit3);
            shEarthquake:
              begin
                memo1.Clear;
                memo1.Append(EQuake);
                memo1.Append(fGrueStew.RoomDesc);
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
end;

procedure TfrmGrueStewMain.FormDestroy(Sender: TObject);
begin
    FreeAndNil(fGrueStew);
end;

procedure TfrmGrueStewMain.mniNewGameClick(Sender: TObject);
begin
    fGrueStew.NewGame;
    Memo1.Text := fGrueStew.GetDescription;
    memo1.Append(fGrueStew.RoomDesc);
    UpdateMap;
end;

procedure TfrmGrueStewMain.UpdateMap;
var
  dir: TDir;
  lMapDir: LongInt;
begin
  lblActRoom.Caption:= RaumTxt2[fGrueStew.ActRoom];
  for dir in Tdir do
    begin
      lMapDir:=fGrueStew.Map[dir];
      FMapLbl[dir].Caption := RaumTxt2[lMapDir];
      FMovBtn[dir].Enabled:=lMapDir <> -2;
      FShtBtn[dir].Enabled:=lMapDir <> -2;
    end;
end;

end.
