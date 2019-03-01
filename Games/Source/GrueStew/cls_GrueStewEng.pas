unit cls_GrueStewEng;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
    Classes, SysUtils, unt_GrueStewBase;

type
    TRoom = record
        Desc: string;
        Reachable: integer;
        MappedR: boolean;
        MappedT: array[TDir] of boolean;
        Transition: array[TDir] of integer;
    end;

    { TGrueStewEng }

    TGrueStewEng = class
    private
        FRooms: array of TRoom;
        FStep: integer;
        FPlayerRoom: integer;
        FExitRoom: integer;
        FGrueRoom: integer;
        FGameEnded, FGrueKilled: boolean;
        FLastMRes: TMoveResult;
        FBatRoom1: integer;
        FBatRoom2: integer;
        FPitRoom1: integer;
        FPitRoom2: integer;
        function GetSensSet: TSensSet;
        procedure DoEarthQuake;
        function SetTransition(i: integer; dir: TDir; Force: integer = 0): boolean;
        function GetRoomDesc: string;
        function GetMap(dir: Tdir): integer;
    protected
        // Debug-Functions
        function GetRoom(index: integer): TRoom;
        function GetRoomCount: integer;
        property rExit: integer read FExitRoom;
        property rGrue: integer read FGrueRoom;
        property rBat1: integer read FBatRoom1;
        property rBat2: integer read FBatRoom2;
        property rPit1: integer read FPitRoom1;
        property rPit2: integer read FPitRoom2;
    public
        Constructor Create;
        function GetDescription: string;
        procedure NewGame;
        procedure InitLaby;
        procedure SetObstacle;
        procedure InitPlayer;
        // Spielaktionen
        function Move(dir: TDir): TMoveResult;
        function Shoot(dir: TDir): TShootResult;
        procedure GiveUp;
        // Spielzustand
        property RoomDesc: string read GetRoomDesc;
        property ActRoom: integer read FPlayerRoom;
        property Sens: TSensSet read GetSensSet;
        property Map[dir: Tdir]: integer read GetMap;
        property HasEnded: boolean read FGameEnded;
        property KilledMonster: boolean read FGrueKilled;
        property Step: integer read FStep;
    end;


implementation

function MyRandom(max, gap: integer): integer;

begin
    Result := random(Max - 1) + 1;
    if Result >= gap then
        Inc(Result);
end;

const NoRoom:TRoom=({%H-});
{TGrueStewEng }

function TGrueStewEng.GetMap(dir: Tdir): integer;

begin
    if not Frooms[FPlayerRoom].MappedT[dir] then
        Result := 0
    else
    if Frooms[FPlayerRoom].transition[dir] = 0 then
        Result := -2
    else
    if not Frooms[Frooms[FPlayerRoom].transition[dir]].mappedR then
        Result := -1
    else
        Result := Frooms[FPlayerRoom].transition[dir];
end;

function TGrueStewEng.GetRoom(index: integer):TRoom;
begin
  if index = -1 then
     index := FPlayerRoom;
  if (index >= 0) and (index <= high(FRooms)) then
    result := FRooms[index]
  else
    result := NoRoom;
end;

function TGrueStewEng.GetRoomCount:integer;
begin
  result := length(FRooms)-1;
  if result < 0 then result :=0;
end;

constructor TGrueStewEng.Create;
begin
  FGameEnded := true;
end;

procedure TGrueStewEng.NewGame;

begin
    InitLaby;
    InitPlayer;
    SetObstacle;
end;

procedure TGrueStewEng.DoEarthQuake;

begin
    SetObstacle;
end;

procedure TGrueStewEng.GiveUp;

begin
    FLastMRes := mvExit;
    FGameEnded := True;
end;

function TGrueStewEng.Move(dir: TDir): TMoveResult;

begin
    if FGameEnded then
        exit(FLastMRes);
    Inc(FStep);
    if Random(15) = 4 then
      begin
        DoEarthQuake;
        exit(mvEarthquake);
      end;
    if FRooms[FPlayerRoom].Transition[dir] = 0 then
      begin
        FRooms[FPlayerRoom].MappedT[dir] := True;
        Exit(mvWall);
      end;
    if FRooms[FPlayerRoom].Transition[dir] = FExitRoom then
      begin
        FGameEnded := True;
        if FGrueKilled then
            FLastMRes := mvExitwMonst
        else
            FLastMRes := mvExit;
        Exit(FLastMRes);
      end;
    if FRooms[FPlayerRoom].Transition[dir] = FGrueRoom then
      begin
        FGameEnded := True;
        FLastMRes := mvMonster;
        Exit(mvMonster);
      end;
    if (FRooms[FPlayerRoom].Transition[dir] = FPitRoom1) or (FRooms[FPlayerRoom].Transition[dir] = FPitRoom2) then
      begin
        FGameEnded := True;
        FLastMRes := mvPit;
        Exit(mvPit);
      end;
    if (FRooms[FPlayerRoom].Transition[dir] = FBatRoom1) or (FRooms[FPlayerRoom].Transition[dir] = FBatRoom2) then
      begin
        FRooms[FPlayerRoom].MappedT[dir] := True;
        FPlayerRoom := Random(20) + 1;
        FRooms[FPlayerRoom].MappedR := True;
        Exit(mvBat);
      end;
    FRooms[FPlayerRoom].MappedT[dir] := True;
    FPlayerRoom := FRooms[FPlayerRoom].Transition[dir];
    FRooms[FPlayerRoom].MappedT[TDir((Ord(Dir) + 2) mod (Ord(high(TDir)) + 1))] := True;
    FRooms[FPlayerRoom].MappedR := True;
    FLastMRes := mvOK;
    Result := mvOK;
end;

function TGrueStewEng.Shoot(dir: TDir): TShootResult;

begin
    if FGameEnded then
        exit(shMiss);
    Inc(FStep);
    if Random(15) = 4 then
      begin
        DoEarthQuake;
        exit(shEarthquake);
      end;
    FRooms[FPlayerRoom].MappedT[dir] := True;
    if FRooms[FPlayerRoom].Transition[dir] = 0 then
        Exit(shWall);
    if FRooms[FPlayerRoom].Transition[dir] = FGrueRoom then
      begin
        FGrueKilled := True;
        FGrueRoom := -1;
        Exit(shHit);
      end;
    if (FRooms[FPlayerRoom].Transition[dir] = FPitRoom1) or (FRooms[FPlayerRoom].Transition[dir] = FPitRoom2) then
        Exit(shMiss2);
    Result := shMiss;
end;

function TGrueStewEng.GetRoomDesc: string;
var
    asens: Tsens;
begin
    Result := FRooms[FPlayerRoom].Desc;
    for asens in Sens do
        Result := Result + LineEnding + SensTxt[asens];
end;

function TGrueStewEng.GetSensSet: TSensSet;
var
    dir: TDir;
begin
    Result := [];
    for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
        if FRooms[FPlayerRoom].Transition[dir] <> 0 then
          begin
            if FRooms[FPlayerRoom].Transition[dir] = FGrueRoom then
                Result := Result + [snSnMonster];
            if FRooms[FPlayerRoom].Transition[dir] = FExitRoom then
                Result := Result + [snExit];
            if FRooms[FPlayerRoom].Transition[dir] = FPitRoom1 then
                Result := Result + [snPit];
            if FRooms[FPlayerRoom].Transition[dir] = FPitRoom2 then
                Result := Result + [snPit];
            if FRooms[FPlayerRoom].Transition[dir] = FBatRoom1 then
                Result := Result + [snBat];
            if FRooms[FPlayerRoom].Transition[dir] = FBatRoom2 then
                Result := Result + [snBat];
          end;
end;

function TGrueStewEng.SetTransition(i: integer; dir: TDir; Force: integer = 0): boolean;
var
    Dest: int64;
    rDir: TDir;
    flag: boolean;

begin
    // Mit einer Chance von 33% gibt es hier keine verbindung
    while (random(3) + 1 <> 2) and (FRooms[i].Transition[dir] = 0) do
      begin
        // Bestimme den Zielraum
        Dest := Myrandom(20, i);

        // Wenn i größer als 7 muß einer der beiden Räume "erreicht" worden sein
        if (force > 0) and (FRooms[i].Reachable = 0) and (FRooms[dest].Reachable = 0) then
            Continue;

        // Wenn i größer als 12 muß genau einer der beiden Räume "erreicht" worden sein
        if (force > 1) and ((FRooms[i].Reachable = 0) = (FRooms[dest].Reachable = 0)) then
            Continue;

        // Prüfe ob schon eine Verbindung zw. Zielraum und Aktuellem Raum besteht.
        flag := False;
        for rDir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
            if FRooms[Dest].Transition[rDir] = i then
              begin
                flag := True;
                break;
              end;

        // Berechne "Rückwärts"-Richtung
        rDir := TDir((Ord(Dir) + 2) mod (Ord(high(TDir)) + 1));
        if not flag and (FRooms[Dest].Transition[rDir] = 0) then
          begin
            // Setze Verbindung
            FRooms[i].Transition[dir] := Dest;
            FRooms[Dest].Transition[rdir] := i;
            // Prüfe/setze Erreichbarkeit
            if (FRooms[i].Reachable <> 0) and (FRooms[dest].Reachable = 0) then
              begin
                FRooms[dest].Reachable := FRooms[i].Reachable + 1;
                for rDir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
                    if (FRooms[dest].Transition[rdir] <> 0) and
                        (FRooms[FRooms[dest].Transition[rdir]].Reachable = 0) then
                        FRooms[FRooms[dest].Transition[rdir]].Reachable :=
                            FRooms[i].Reachable + 2;
              end
            else if (FRooms[i].Reachable = 0) and (FRooms[dest].Reachable <> 0) then
              begin
                FRooms[i].Reachable := FRooms[dest].Reachable + 1;
                for rDir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
                    if (FRooms[i].Transition[rdir] <> 0) and
                        (FRooms[FRooms[i].Transition[rdir]].Reachable = 0) then
                        FRooms[FRooms[i].Transition[rdir]].Reachable :=
                            FRooms[dest].Reachable + 2;
              end;
          end;
      end;
    Result := (FRooms[i].Transition[dir] <> 0);
end;

function TGrueStewEng.GetDescription: string;
begin
    Result := Anleitung;
end;

procedure TGrueStewEng.InitLaby;
var
    flag: boolean;
    dir: TDir;
    i: integer;

begin
    FGrueKilled := False;
    FGameEnded := False;
    Fstep := 0;
    setlength(FRooms, high(RaumTxt) + 1);
    for i := 1 to high(RaumTxt) do
      begin
        FRooms[i].mappedR := False;
        FRooms[i].reachable := 0;
        for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
            FRooms[i].mappedT[dir] := False;
        FRooms[i].Desc := RaumTxt[i];
      end;
    FRooms[1].Reachable := 1;
    for i := 1 to high(RaumTxt) do
      begin
        flag := False;
        while not flag do
          begin
            for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
                flag := SetTransition(i, dir, i div 7) or flag;
            if i > 7 then
                flag := flag and (Frooms[i].reachable <> 0);
          end;
      end;
    for i := 1 to 7 do
      while Frooms[i].reachable=0 do
          for dir {$IFDEF FPC}in TDir{$ELSE}:=Low(TDIR) to high(TDir){$ENDIF} do
              SetTransition(i, dir, 1);
end;

procedure TGrueStewEng.SetObstacle;

begin
    if FGrueKilled then
        FGrueRoom := -1
    else
        FGrueRoom := MyRandom(20, FPlayerRoom);
    FExitRoom := Random(20) + 1;
    FBatRoom1 := MyRandom(20, FPlayerRoom);
    FBatRoom2 := MyRandom(20, FPlayerRoom);
    FPitRoom1 := MyRandom(20, FPlayerRoom);
    FPitRoom2 := MyRandom(20, FPlayerRoom);
end;

procedure TGrueStewEng.InitPlayer;
begin
    FPlayerRoom := Random(20) + 1;
    FRooms[FPlayerRoom].MappedR := True;
end;


end.
