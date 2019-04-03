UNIT Frw_GrueStewMain;

{$mode objfpc}

INTERFACE

USES
  JS, Classes, SysUtils, web, cls_GrueStewEng, unt_GrueStewBase;

TYPE
  { TFrwGrueStew }

  TFrwGrueStew = CLASS
  public
    pnlMain:   TJSElement;
    pnlInput:  TJSElement;
    pnlStatus: TJSElement;

    edtTextOut: TJSHTMLElement;

    btnNewGame: TJSHTMLButtonElement;
    lblActRoom: TJSNode;

    CONSTRUCTOR Create; reintroduce;
  private
    fGrueStew: TGrueStewEng;
    FMapLbl:   ARRAY[tdir] OF TJSNode;
    FMovBtn:   ARRAY[tdir] OF TJSHTMLButtonElement;
    FShtBtn:   ARRAY[tdir] OF TJSHTMLButtonElement;
    FUNCTION btnNewGameClick(aEvent: TJSMouseEvent): Boolean;
    FUNCTION onBtnMoveClick(aEvent: TJSMouseEvent): Boolean;
    FUNCTION onBtnShootClick(aEvent: TJSMouseEvent): Boolean;
    PROCEDURE UpdateMap;
    PROCEDURE Write(str: String; Clear: Boolean = False);
  END;

IMPLEMENTATION


{ TFrwGrueStew }

CONSTRUCTOR TFrwGrueStew.Create;

  FUNCTION CreateMemoEdit(aName: String): TJSHTMLElement;

  BEGIN
    Result      := TJSHTMLElement(document.createElement('textarea'));
    Result.Name := aName;
    Result['id'] := 'memo ' + aName;
    Result['rows'] := '25';
    Result['cols'] := '80';
    //    Result['style'] := 'width: 640px; height: 480px;';
  END;

  FUNCTION CreateSmallButton(aName, aCaption: String): TJSHTMLButtonElement;

  BEGIN
    Result      := TJSHTMLButtonElement(document.createElement('input'));
    Result['id'] := aName;
    Result['type'] := 'submit';
    Result['value'] := aCaption;
    Result.Name := aName;
    Result['style'] := 'width: 40px; height: 40px;';
    Result['class'] := 'btn btn-default';
  END;

  FUNCTION CreateNButton(aName, aCaption: String): TJSHTMLButtonElement;

  BEGIN
    Result      := TJSHTMLButtonElement(document.createElement('input'));
    Result['id'] := aName;
    Result['type'] := 'submit';
    Result['value'] := aCaption;
    Result.Name := aName;
    Result['style'] := 'width: 160px;';
    Result['class'] := 'btn btn-default';
  END;


  FUNCTION CreateLabel(aName, aCaption: String): TJSNode;

  BEGIN
    Result := document.createTextNode(aCaption);
//    Result['id'] := aName;
  END;

VAR
  ltable, ltableRow, ltableCell: TJSElement;
  dir: TDir;
BEGIN
  fGrueStew := TGrueStewEng.Create;

  // Create Form-Elements
  pnlMain := document.createElement('div');
  // attrs are default array property...
  pnlMain['class'] := 'panel panel-default';

  pnlInput := document.createElement('div');
  pnlInput['class'] := 'panel-body';
  pnlInput['align'] := 'center';

  pnlStatus := document.createElement('div');
  pnlStatus['class'] := 'panel-body';

  btnNewGame := CreateNButton('btnNewGame', 'Neues Spiel: Start');
  btnNewGame.onclick := @btnNewGameClick;

  edtTextOut := CreateMemoEdit('edtTextOut');


  FOR dir in Tdir DO
  BEGIN
    FMovBtn[dir] := CreateSmallButton('btnMove' + CDirDesc[dir], CDirShortDesc[dir]);
    FMovBtn[dir]['Dir'] := IntToStr(Ord(dir));
    FMovBtn[dir].onclick := @onBtnMoveClick;
    FShtBtn[dir] := CreateSmallButton('btnShoot' + CDirDesc[dir], CDirShortDesc[dir]);
    FShtBtn[dir]['Dir'] := IntToStr(Ord(dir));
    FShtBtn[dir].onclick := @onBtnShootClick;
    FMapLbl[Dir] := CreateLabel('lblMap' + CDirDesc[dir], '..');
  END;

  lblActRoom := CreateLabel('lblActRoom', '..');

  // Build Form
  document.body.appendChild(pnlMain);

  ltable     := document.createElement('table');
  ltable['style'] := 'width: 100%';
  ltableRow  := document.createElement('tr');
  ltableCell := document.createElement('td');
  ltableCell['style'] := 'width: 70%';
  pnlMain.appendChild(ltable);
  ltable.appendChild(ltableRow);
  ltableRow.appendChild(ltableCell);
  ltableCell.appendChild(pnlStatus);
  ltableCell := document.createElement('td');
  ltableCell['style'] := 'width: 30%';
  ltableRow.appendChild(ltableCell);
  ltableCell.appendChild(pnlInput);

  pnlStatus.appendChild(btnNewGame);
  pnlStatus.appendChild(document.createElement('BR'));
  pnlStatus.appendChild(edtTextOut);

  pnlInput.appendChild(FMapLbl[drNorth]);
  pnlInput.appendChild(document.createElement('BR'));
  pnlInput.appendChild(FShtBtn[drNorth]);
  pnlInput.appendChild(document.createElement('BR'));
  pnlInput.appendChild(FMovBtn[drNorth]);
  pnlInput.appendChild(document.createElement('BR'));

  pnlInput.appendChild(FMapLbl[drWest]);
  pnlInput.appendChild(FShtBtn[drWest]);
  pnlInput.appendChild(FMovBtn[drWest]);

  pnlInput.appendChild(lblActRoom);

  pnlInput.appendChild(FMovBtn[drEast]);
  pnlInput.appendChild(FShtBtn[drEast]);
  pnlInput.appendChild(FMapLbl[drEast]);

  pnlInput.appendChild(document.createElement('BR'));
  pnlInput.appendChild(FMovBtn[drSouth]);
  pnlInput.appendChild(document.createElement('BR'));
  pnlInput.appendChild(FShtBtn[drSouth]);
  pnlInput.appendChild(document.createElement('BR'));
  pnlInput.appendChild(FMapLbl[drSouth]);

  write(fGrueStew.GetDescription,true);
END;

PROCEDURE TFrwGrueStew.UpdateMap;
VAR
  dir:     TDir;
  lMapDir: Longint;
BEGIN
  lblActRoom.textContent := RaumTxt2[fGrueStew.ActRoom];
  FOR dir in TDir DO
  BEGIN
    lMapDir := fGrueStew.Map[dir];
    FMapLbl[dir].textContent := RaumTxt2[lMapDir];
    FMovBtn[dir].disabled := lMapDir = -2;
    FShtBtn[dir].disabled := lMapDir = -2;
  END;
END;

FUNCTION TFrwGrueStew.onBtnMoveClick(aEvent: TJSMouseEvent): Boolean;
VAR
  lDir:     Integer;
  lMResult: TMoveResult;
BEGIN
  IF (aEvent.target.tagName = 'INPUT') and not fGrueStew.HasEnded and
    TryStrToInt(aEvent.target['Dir'], lDir) THEN
  BEGIN
    Write(ITryMove[TDir(ldir)]);
    lMResult := fGrueStew.Move(TDir(lDir));
    CASE lMResult OF
      mvOK:
        Write(fGrueStew.RoomDesc, True);
      mvWall: Write(CantMoveThere);
      mvExit: Write(ReachedExit);
      mvExitwMonst: Write(ReachedExitwM);
      mvMonster: Write(CaughtBYMonster);
      mvPit: Write(FellIntoPit);
      mvBat:
      BEGIN
        Write(BatCatchYou, True);
        Write(fGrueStew.RoomDesc);
      END;
      mvEarthquake:
      BEGIN
        Write(EQuake, True);
        Write(fGrueStew.RoomDesc);
      END;
    END;
    UpdateMap;

  END;
END;

FUNCTION TFrwGrueStew.btnNewGameClick(aEvent: TJSMouseEvent): Boolean;
BEGIN
  fGrueStew.NewGame;
  Write(fGrueStew.RoomDesc, True);
  UpdateMap;
END;

FUNCTION TFrwGrueStew.onBtnShootClick(aEvent: TJSMouseEvent): Boolean;

VAR
  lDir:     NativeInt;
  lSResult: TShootResult;
BEGIN
  IF (aEvent.target.tagName = 'INPUT') and not fGrueStew.HasEnded and
    TryStrToInt(aEvent.target['Dir'], lDir) THEN
  BEGIN
    Write(Ishoot[TDir(lDir)]);

    lSResult := fGrueStew.Shoot(TDir(lDir));
    CASE lSResult OF
      shHit: Write(HitMonster);
      shWall: Write(HitWall);
      shMiss: Write(NoHit1);
      shMiss2: Write(NoHit2);
      shMiss3: Write(NoHit3);
      shEarthquake:
      BEGIN
        Write(EQuake, True);
        Write(fGrueStew.RoomDesc);
      END;
    END;
    UpdateMap;
  END;
END;

PROCEDURE TFrwGrueStew.Write(str: String; Clear: Boolean);
BEGIN
  IF Clear THEN
    edtTextOut.textContent := '';
  str := stringreplace(str, '#', '', [rfReplaceAll]);
  edtTextOut.textContent := edtTextOut.textContent + LineEnding + str;
END;

END.


