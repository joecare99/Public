UNIT Unt_GameBase;

{$ifdef FPC}
{$mode delphi}{$H+}
{$ENDIF ~FPC}

INTERFACE

USES classes,
  cls_Gamebase,
  int_GameHMI,
  unt_Terragen,
  win32Crt;

PROCEDURE Init;
PROCEDURE Execute;
PROCEDURE Done;

TYPE
  TPlayer = CLASS(TPlayerBase)

  PRIVATE
    FNewXKoor: integer;
    FNewYKoor: integer;
    PROCEDURE SetNewKoor(NewX, NewY: integer);
  PUBLIC
    PROCEDURE MoveN;
    PROCEDURE MoveNE;
    PROCEDURE MoveE;
    PROCEDURE MoveSE;
    PROCEDURE MoveS;
    PROCEDURE MoveSW;
    PROCEDURE MoveW;
    PROCEDURE MoveNW;
    PROCEDURE MoveUp;
    PROCEDURE MoveDown;
    PROPERTY XKoor: integer READ GetXKoor;
    PROPERTY YKoor: integer READ GetYKoor;
    PROPERTY NewXKoor: integer READ FNewXKoor;
    PROPERTY NewYKoor: integer READ FNewYKoor;
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen vorbereitet</Info>
    /// <since>26.09.2012</since>
    PROCEDURE PreMove; OVERRIDE;
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen ausgeführt</Info>
    /// <since>26.09.2012</since>
    PROCEDURE ExecMove; OVERRIDE;
  END;

  TBoard = CLASS(TBoardBase)

  END;

  TGame = CLASS(TComponent)
  PRIVATE
    FEnded:      Boolean;
    TerrGenData: ARRAY [0 .. 7, 0 .. 7] OF extended;
  PUBLIC
    Player: TPlayer;
    Board:  TBoard;
    CONSTRUCTOR CreateGame;
    DESTRUCTOR Done; VIRTUAL;
    PROPERTY Ended: Boolean READ FEnded;
    FUNCTION TerrainFkt(vx, vy: extended): TField;
    PROCEDURE InitTerrain;
    PROCEDURE UpDateScreen;
    PROCEDURE UpDateBoard;
    PROCEDURE UserAction;
    PROCEDURE PlayerAction(Action: TPlayerAction; Sender: TObject);
    PROCEDURE SearchStartSpot(OUT X: integer; OUT Y: integer);
  END;



procedure RegisterObject(ObjClass:TObjClass);
procedure RegisterEnemy(EnemyClass:TEnemyClass);
procedure RegisterField(FieldClass:TFieldClass);

VAR
  Game: TGame;
  HMI:  iHMI;

IMPLEMENTATION

var GameObjects:array of TObjClass;
    EnemyObjects:array of TEnemyClass;
    FieldObjects:array of array of TFieldClass;


PROCEDURE TPlayer.SetNewKoor(NewX, NewY: integer);
BEGIN
  IF assigned(Owner) THEN
    IF (NewX >= 0) AND (NewX < TBoardBase(Owner).SizeX) AND (NewY >= 0) AND
      (NewY < TBoardBase(Owner).Sizey) THEN
      BEGIN
        FNewXKoor := NewX;
        FNewYKoor := NewY;
      END;
END;

PROCEDURE TPlayer.MoveN;
BEGIN
  SetNewKoor(XKoor, YKoor - 1);
END;

PROCEDURE TPlayer.MoveNE;
BEGIN
  SetNewKoor(XKoor + 1, YKoor - 1);
END;

PROCEDURE TPlayer.MoveE;
BEGIN
  SetNewKoor(XKoor + 1, YKoor);
END;

PROCEDURE TPlayer.MoveSE;
BEGIN
  SetNewKoor(XKoor + 1, YKoor + 1);
END;

PROCEDURE TPlayer.MoveS;
BEGIN
  SetNewKoor(XKoor, YKoor + 1);
END;

PROCEDURE TPlayer.MoveSW;
BEGIN
  SetNewKoor(XKoor - 1, YKoor + 1);
END;

PROCEDURE TPlayer.MoveW;
BEGIN
  SetNewKoor(XKoor - 1, YKoor);
END;

PROCEDURE TPlayer.MoveNW;
BEGIN
  SetNewKoor(XKoor - 1, YKoor - 1);
END;

PROCEDURE TPlayer.MoveUp;
BEGIN
  //
END;

PROCEDURE TPlayer.MoveDown;
BEGIN
  //
END;

PROCEDURE TPlayer.PreMove;
BEGIN
END;

PROCEDURE TPlayer.ExecMove;
BEGIN
  SetKoor(FNewXKoor, FNewYKoor);
END;

{ ====================TGame========================== }
CONSTRUCTOR TGame.CreateGame;
VAR
  I, J: integer;
BEGIN
  FOR I := 0 TO 7 DO
    FOR J := 0 TO 7 DO
      TerrGenData[I, J] := Random; { 0..1 }
  Board := TBoard.Create(self);
  Board.SetSize(100, 100);
  Player := TPlayer.Create(Board);
  Board.Append(Player);
END;

DESTRUCTOR TGame.Done;

BEGIN
  Game.Player.Free;
  Game.Board.Free;
END;

PROCEDURE TGame.InitTerrain;

VAR
  X, Y: integer;

BEGIN
  FOR X := 0 TO Board.SizeX - 1 DO
    FOR Y := 0 TO Board.Sizey - 1 DO
      Board.Field[X, Y] := TerrainFkt(X / Board.SizeX, Y / Board.Sizey);
END;

FUNCTION TGame.TerrainFkt(vx, vy: extended): TField;

var MainFieldType,Subclass : integer;
    FieldClass,FC : TFieldClass;
BEGIN
  MainFieldType := trunc(sqr(TG4(vx, vy)) * 20);
  Fieldclass := TField;
  if (high(FieldObjects)>=MainFieldType) and
      ( high(FieldObjects[MainFieldType])>=0) then
    begin
      Subclass :=Random(high(FieldObjects[MainFieldType])+1);
      Fieldclass := FieldObjects[MainFieldType][Subclass];
    end;
  result := Fieldclass.Create(Board);
  WITH result DO
    BEGIN
      FieldType := trunc(sqr(TG4(vx, vy)) * 20);
    END;
END;

PROCEDURE TGame.UpDateScreen;
BEGIN
  IF assigned(HMI) THEN
    BEGIN
      HMI.UpdateStatus(Game.Player);
      HMI.UpdatePlayfield(Game.Board, Game.Player);
    END;
END;

PROCEDURE TGame.UpDateBoard;
VAR
  X, Y: integer;

BEGIN
  FOR X := 0 TO Board.SizeX - 1 DO
    FOR Y := 0 TO Board.Sizey - 1 DO
      continue;
END;

PROCEDURE TGame.UserAction;

BEGIN

END;

PROCEDURE TGame.PlayerAction(Action: TPlayerAction; Sender: TObject);

BEGIN
  TRY
    Action
  FINALLY

  END;
END;

PROCEDURE TGame.SearchStartSpot(OUT X: integer; OUT Y: integer);
BEGIN
  REPEAT
    X := Random(Board.SizeX);
    Y := Random(Board.Sizey);
  UNTIL Board.Field[X, Y].FieldType IN [4 .. 10];
END;

PROCEDURE Init;

VAR
  X, Y: integer;
BEGIN
  IF NOT assigned(Game) THEN
    Game := TGame.CreateGame;
  Game.InitTerrain;
  // Done: Init Player
  Game.SearchStartSpot(X, Y);
  Game.Player.SetKoor(X, Y);
  // Todo -oC. Rosewich -cGameStart: Init Enemies

  // Todo -oC. Rosewich -cGameStart: Init Objects
  if assigned(HMI) then
    begin
      HMI.InitHMI;
      HMI.OnPlayerAction := Game.PlayerAction;
    end;
END;

PROCEDURE Execute;

BEGIN
  WITH Game DO
    WHILE NOT Ended DO
      BEGIN
        UpDateBoard;
        UpDateScreen;
        UserAction;
      END;
END;

PROCEDURE Done;

BEGIN
  Game.Done;
END;

procedure registerObject;
begin
  setlength(GameObjects,high(GameObjects)+2);
  GameObjects[high(GameObjects)]:=ObjClass;
end;

procedure registerEnemy;
begin
  setlength(EnemyObjects,high(EnemyObjects)+2);
  EnemyObjects[high(EnemyObjects)]:=EnemyClass;
end;

procedure registerField;
  var Fieldtypes : TFieldTypes;
      FT:byte;
begin
  FieldTypes := FieldClass.FieldTypes;
  for FT in Fieldtypes do
     begin
       if FT>high(FieldObjects) then
         setlength(FieldObjects,FT+1);
        setlength(FieldObjects[FT],high(FieldObjects[FT])+2);
        FieldObjects[FT][high(FieldObjects)]:=FieldClass;
     end;
end;

END.
