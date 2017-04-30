
unit PathFUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  SysUtils, SokoEngine, types;

type
  TMovePlayerProc = procedure(New: TPoint) of object;
  T2DArrayOfBoolean = array of array of boolean;
  T2DArrayOfInteger = array of array of integer;
  { TPathFinder }

  TPathFinder = class
  private
    FSokobanEngine: TSokobanEngine;
    FReachable: T2DArrayOfBoolean;
    FDestField: T2DArrayOfInteger;
    Visited: array of array of array[1..4] of boolean;
    SVisited: array of array of array[1..4] of integer;
    PVisited: T2DArrayOfBoolean;
    // Identication-Data
    FPlayer: TPoint;

    FLevel, FPushes, FLevelHeight, FLevelWidth, ArrayPos,
    NewCall, APosCount, Score, TrackLength, AbsoluteShortestPath: integer;
    HasTarget, StopLoop: boolean;
    FBoxPos: array of TPoint;
    AList, SortedList: array[1..4] of integer;

    function AllowNextStep(ANext: Tpoint; Dir: integer): boolean;
    function AllowPNextStep(p: TPoint): boolean;
    procedure CheckMove(p, d: Tpoint; dir: integer; APlayer: TPoint;
      ACount: integer; const FSokobanEngine: TSokobanEngine);
    procedure CheckNext(p: Tpoint; dir: integer; Field: TPuzzleField;
      var ACount: integer; const GameData: TGameData);
    procedure CheckPlayer(p, Old: TPoint; var Done: boolean);
    function GetBoxPosCount: integer;
    function GetBoxPos(index: integer): Tpoint;
    function GetReachable(p: TPoint): boolean;
    function IsReachableForPlayer(APos: TPoint; ADir: integer): boolean;
    procedure SetBoxPos(index: integer; AValue: Tpoint);
    procedure SetReachable(p: TPoint; AValue: boolean);
    procedure SetSokobanEngine(AValue: TSokobanEngine);
    procedure TrackBack2(const AVisited: T2DArrayOfInteger;
      const PathLength: integer; const fMovePlayer: TMovePlayerProc; const d: TPoint);
  public
    procedure Clear;
    procedure BuildDestField(const ASokobanEngine: TSokobanEngine);
    procedure FindPath(BeginP, Target: TPoint; Field: TPuzzleField;
      fMovePlayer: TMovePlayerProc);
    function FindAllPos(p: TPoint; const Field: TPuzzleField;
      const GameData: TGameData): boolean;
    function MoveBox(Pos, Dest: TPoint; const FSokobanEngine: TSokobanEngine
      ): boolean;

    function MovePathPlayer(p, d: TPoint; const Field: TPuzzleField;
      const GameData: TGameData; fMovePlayer: TMovePlayerProc): boolean;
    property SokobanEngine: TSokobanEngine read FSokobanEngine write SetSokobanEngine;
    property Reachable[p: Tpoint]: boolean read GetReachable write SetReachable;
    property BoxPos[index: integer]: TPoint read GetBoxPos write SetBoxPos;
    property BoxPosCount: integer read GetBoxPosCount;
  end;

implementation

{ TPathFinder }

function KDist(p1,p2:Tpoint):integer;inline;

begin
  result := abs(p1.x-p2.x)+abs(p1.y-p2.y);
end;

procedure TPathFinder.FindPath(BeginP, Target: TPoint; Field: TPuzzleField;
  fMovePlayer: TMovePlayerProc);
{Based on this article:
http://www.gamedev.net/reference/articles/article2003.asp by Patrick Lester}

type
  TList = (lOnOpenList, lOnClosedList, lUndefined);

const
  TileGCost = 10;

var
  OnWhichList: array of array of TList;
  GCost: array of array of integer;
  ParentList: array of array of Tpoint;
  OpenList, FCost, HCost: array of integer;
  PathBank, Open: array of TPoint;
  Parent, Path: TPoint;
  PathLength, x, a, b, m, u, v, TempInt, OpenListCount, PathBankPos,
  NewOpenListItemID: integer;
  CanAccess: boolean;

  procedure InitializeLengths(ALevelWidth, ALevelHeight: integer);
  var
    x, y: integer;
  begin
    x := ALevelWidth * ALevelHeight + 2;
    SetLength(OnWhichList, ALevelWidth + 1, ALevelHeight + 1);
    SetLength(ParentList, ALevelWidth + 1, ALevelHeight + 1);
    SetLength(GCost, ALevelWidth + 1, ALevelHeight + 1);
    SetLength(OpenList, x);
    SetLength(Open, x);
    SetLength(FCost, x);
    SetLength(HCost, x);

    NewOpenListItemID := 0;
    PathLength := 0;
    GCost[Beginp.X, Beginp.Y] := 0;
    OpenListCount := 1;
    OpenList[1] := 1;
    Open[1] := BeginP;

    for x := Low(OnWhichList) to High(OnWhichList) do
      for y := Low(OnWhichList[0]) to High(OnWhichList[0]) do
        OnWhichList[x][y] := lUndefined;
  end;

begin
  if Field[Target.X, Target.Y].FPartType <> ptNone then
    Exit; // if the target pos isn't ptNone, there is no path

  InitializeLengths(Length(Field), Length(Field[0]));

  while (1 = 1) and (OpenListCount <> 0) and not
    (OnWhichList[Target.x][Target.Y] = lOnClosedList) do
  begin
    Parent := Open[OpenList[1]];
    OnWhichList[Parent.x][Parent.Y] := lOnClosedList;
    Dec(OpenListCount);
    OpenList[1] := OpenList[OpenListCount + 1];

    v := 1;
    while 1 = 1 do
    begin
      u := v;
      if 2 * u + 1 <= OpenListCount then
      begin
        if FCost[OpenList[u]] >= FCost[OpenList[2 * u]] then
          v := 2 * u;
        if FCost[OpenList[v]] >= FCost[OpenList[2 * u + 1]] then
          v := 2 * u + 1;
      end
      else
      if 2 * u <= OpenListCount then
        if FCost[OpenList[u]] >= fcost[OpenList[2 * u]] then
          v := 2 * u;

      if u <> v then
      begin
        TempInt := OpenList[u];
        OpenList[u] := OpenList[v]; // swap the values
        OpenList[v] := TempInt;
      end
      else
        Break;
    end;

    for b := Parent.Y - 1 to Parent.Y + 1 do
      for a := Parent.x - 1 to Parent.x + 1 do
      begin
        CanAccess := True;
        if ((a = Parent.x - 1) and ((b = Parent.Y - 1) or (b = Parent.y + 1))) or
          ((a = Parent.x + 1) and ((b = Parent.Y - 1) or (b = Parent.y + 1))) then
          CanAccess := False; // Don't accept diagonal tiles

        if (CanAccess) and (OnWhichList[a][b] <> lOnClosedList) and
          (Field[a, b].FPartType = ptNone) then
          if OnWhichList[a][b] <> lOnOpenList then
          begin
            Inc(newOpenListItemID); // Create a unique ID
            m := Succ(OpenListCount);
            OpenList[m] := newOpenListItemID;
            Open[newOpenListItemID] := point(a, b);
            GCost[a][b] := GCost[Parent.x][Parent.y] + TileGCost;
            HCost[OpenList[m]] :=
              TileGCost * (Abs(a - Target.x) + Abs(b - Target.Y));
            FCost[OpenList[m]] := GCost[a][b] + HCost[OpenList[m]];
            ParentList[a][b] := Parent;

            while m <> 1 do
            begin
              if FCost[OpenList[m]] <= FCost[OpenList[m div 2]] then
              begin
                TempInt := OpenList[m div 2];
                OpenList[m div 2] := OpenList[m];
                OpenList[m] := TempInt;
                m := m div 2;
              end
              else
                Break;
            end;

            Inc(OpenListCount);
            OnWhichList[a][b] := lOnOpenList;
          end
          else
          if GCost[Parent.x][Parent.y] + TileGCost < GCost[a][b] then
          begin
            ParentList[a][b] := Parent;
            GCost[a][b] := GCost[Parent.x][Parent.y] + TileGCost;
            for x := 1 to OpenListCount do
            begin
              if (Open[OpenList[x]] = point(a, b)) then
              begin
                FCost[OpenList[x]] := GCost[a][b] + HCost[OpenList[x]];

                m := x;
                while m <> 1 do
                begin
                  if FCost[OpenList[m]] < FCost[OpenList[m div 2]] then
                  begin
                    TempInt := OpenList[m div 2];
                    OpenList[m div 2] := OpenList[m];
                    OpenList[m] := TempInt;
                    m := m div 2;
                  end
                  else
                    Break;
                end;
                Break;
              end;
            end;
          end;
      end;
  end;

  if OnWhichList[Target.x][Target.Y] = lOnClosedList then
  begin
    Path := Target;
    while (Path <> Beginp) do
    begin
      Path := ParentList[Path.X][Path.Y];
      Inc(PathLength);
    end;

    SetLength(PathBank, PathLength);
    Path := Target;
    PathBankPos := PathLength;

    while (Path <> BeginP) and (PathBankPos > 0) do
    begin
      Dec(PathBankPos, 1);
      PathBank[PathBankPos] := Path;

      Path := ParentList[Path.X][Path.Y];
    end;

    a := 0;
    while a <= PathLength  - 1 do
    begin
      fMovePlayer(PathBank[a]);
      // frmSokoban.Repaint;
      Inc(a, 1);
    end;
  end
  else
    Beep; // path not found
end;

function TPathFinder.AllowPNextStep(p: TPoint): boolean;
begin
  Result := (FSokobanEngine.PuzzleField[p.x, p.y].FPartType = ptNone) and
    (PVisited[p.x, p.y] = False);
end;

procedure TPathFinder.CheckPlayer(p, Old: TPoint; var Done: boolean);

var
  dd: integer;
begin
  PVisited[p.x, p.y] := True;

  if (p = Old) then
    Done := True;

  if not Done then
  begin
    for dd := 1 to 4 do
      if AllowPNextStep(p + dir4[dd]) then
        CheckPlayer(p + dir4[dd], Old, Done);
  end;
end;

function TPathFinder.GetBoxPosCount: integer;
begin
  Result := succ(high(FBoxPos));
end;

function TPathFinder.GetBoxPos(index: integer): Tpoint;
begin
  Result := FBoxPos[index];
end;

function TPathFinder.GetReachable(p: TPoint): boolean;
begin
  if assigned(FReachable) then
    Result := FReachable[p.x, p.y]
  else
    Result := False;
end;

function TPathFinder.IsReachableForPlayer(APos: TPoint; ADir: integer): boolean;
var
  i, j: integer; //Old player position
  Done: boolean;
  Old: TPoint;
begin
  Result := False;

  Old := aPos+Dir4[Adir];

  if (Old.X > FSokobanEngine.PuzzleWidth - 1) or (Old.X < 0) or
    (Old.Y > FSokobanEngine.PuzzleHeight - 1) or (Old.Y < 0) then
    Exit;

  if not AllowPNextStep(Old) then
    Exit;

  for i := 0 to Length(PVisited) - 1 do
    for j := 0 to Length(PVisited[0]) - 1 do
      PVisited[i][j] := False;

  Done := False;

  CheckPlayer(APos, Old, Done);
  if Done then
  begin
    FPlayer := Old;
    Result := True;
  end;

end;

procedure TPathFinder.SetBoxPos(index: integer; AValue: Tpoint);
begin
  FBoxPos[index] := AValue;
end;

procedure TPathFinder.SetReachable(p: TPoint; AValue: boolean);
begin
  FReachable[p.x, p.y] := AValue;
end;

procedure TPathFinder.SetSokobanEngine(AValue: TSokobanEngine);
begin
  if FSokobanEngine = AValue then
    Exit;
  FSokobanEngine := AValue;
end;

function TPathFinder.AllowNextStep(ANext: Tpoint; Dir: integer): boolean;
begin
  Result := False;

  if (ANext.X > FSokobanEngine.PuzzleWidth - 1) or (ANext.X < 0) or
    (ANext.Y > FSokobanEngine.PuzzleHeight - 1) or (ANext.Y < 0) then
    Exit;

  Result := (FSokobanEngine.PuzzleField[ANext.X, ANext.Y].FPartType = ptNone) and
    (Visited[ANext.X, ANext.Y, dir] = False) and IsReachableForPlayer(ANext, dir);
end; // the old box pos is the parameter

procedure TPathFinder.CheckNext(p: Tpoint; dir: integer; Field: TPuzzleField;
  var ACount: integer; const GameData: TGameData);

var
  dd: integer;
begin
  if dir <> 0 then
    Visited[p.x, p.y, dir] := True;

  for dd := 1 to 4 do
    if AllowNextStep(p + dir4[dd], dd) then
      CheckNext(p + dir4[dd], dd, Field, ACount, GameData);

  Reachable[p] := True;
  Inc(ACount);
end;

// returns false if there is no pos

function TPathFinder.FindAllPos(p: TPoint; const Field: TPuzzleField;
  const GameData: TGameData): boolean;
var
  i, j, k, APosCount: integer;
begin
  SetLength(Visited, GameData.FLevelWidth,
    GameData.FLevelHeight);
  SetLength(PVisited, GameData.FLevelWidth,
    GameData.FLevelHeight);

  for i := 0 to Length(Visited) - 1 do
    for j := 0 to Length(Visited[0]) - 1 do
      for k := 1 to 4 do
        Visited[i, j, k] := False;

  Field[GameData.FPlayerPos.X,
    GameData.FPlayerPos.Y].FPartType := ptNone;
  Field[p.x, p.y].FPartType := ptNone;

  FPlayer := GameData.FPlayerPos;

  APosCount := 0;
  CheckNext(p, 0, Field, APosCount, Gamedata); // box pos

  Field[GameData.FPlayerPos.X,
    GameData.FPlayerPos.Y].FPartType := ptPlayer;
  Field[p.x, p.y].FPartType := ptCrate;

  Result := APosCount > 1;
end;

procedure TPathFinder.TrackBack2(const AVisited: T2DArrayOfInteger;
  const PathLength: integer; const fMovePlayer: TMovePlayerProc; const d: TPoint);
var
  Path: array of Tpoint;
  Cur: Tpoint;
  b: integer;
  a: integer;
  New: Tpoint;

begin
  SetLength(Path, PathLength);

  Cur := d;

  Path[PathLength - 1] := d;

  for a := PathLength downto 2 do
    for b := 1 to 4 do
    begin
      New := Cur + dir4[b];

      if AVisited[New.X, New.Y] = a - 1 then
      begin
        Path[a - 2] := New;
        Cur := New;
        Break;
      end;
    end;

  for a := 0 to PathLength - 1 do
  begin
    fMovePlayer(Path[a]);
  end;
end;

procedure TPathFinder.Clear;
var
  i, j: Integer;
begin
  for i := 0  to FLevelWidth-1 do
    for j := 0 to FLevelHeight-1 do
      begin
      FReachable[i,j]:=false;
       FDestField[i,j]:=0;
      end;
end;

procedure TPathFinder.BuildDestField(const ASokobanEngine: TSokobanEngine);
begin
  FSokobanEngine := ASokobanEngine;
  if (FPlayer = FSokobanEngine.GameData.FPlayerPos) and
    (FPushes = FSokobanEngine.GameData.FPushes) and
    (FLevel = FSokobanEngine.GameData.FAktLevel) then
    exit;
  {ELSE}
  // set identication -Data
  with FSokobanEngine.gamedata do
  begin
    FPlayer := FPlayerPos;
    self.FPushes := FPushes;
    FLevel := FAktLevel;
    self.FLevelWidth := FLevelWidth;
    self.FLevelHeight := FLevelHeight;
  end;
  SetLength(FDestField, FLevelWidth, FLevelHeight);
  setlength(FReachable, FLevelWidth, FLevelHeight);
end;

function TPathFinder.MovePathPlayer(p, d: TPoint; const Field: TPuzzleField;
  const GameData: TGameData; fMovePlayer: TMovePlayerProc): boolean;
var
  i, j, PathLength, AbsoluteShortestPath: integer;
  Done: boolean;
  APList, PSortedList: array[1..4] of integer;
  AVisited: T2DArrayOfInteger;
  CanReach: boolean;


  procedure CheckPlayer(x, y, ACount: integer);
  var
    z: integer;
    pp: TPoint;

    function AllowPNextStep(x, y, Count: integer): boolean;
    begin
      Result := False;

      if (Field[x, y].FPartType <> ptNone) or (Count >= AVisited[x, y]) then
        Exit;

      if CanReach and (Count + KDist(p,d) >= PathLength) then
        Exit;

      Result := True; { or
          (Field[x, y].FPartType = ptReachable)}
    end;

    function BestFound2(Index: integer): integer;
    var
      i, j, k: integer;
    begin
      for i := 1 to 4 do
      begin
        Score := Kdist(point(x,y)+Dir4[i],d);
        APList[i] := Score;
        PSortedList[i] := i;
      end;

      for k := 2 to 4 do
      begin
        j := k;
        while j <> 1 do
        begin
          if APList[j - 1] > APList[j] then
          begin
            i := APList[j - 1];
            APList[j - 1] := APList[j];
            APList[j] := i;
            i := PSortedList[j - 1];
            PSortedList[j - 1] := PSortedList[j];
            PSortedList[j] := i;
            Dec(j);
          end
          else
            j := 1;
        end;
      end;
      Result := PSortedList[Index];
    end;

  begin
    AVisited[x, y] := ACount;

    if point(x,y) = d then
    begin
      CanReach := True;
      PathLength := ACount;

      if ACount = AbsoluteShortestPath then
        Done := True;
    end;

    for z := 1 to 4 do
      if not Done then
      begin
        pp:=point(x,y)+dir4[BestFound2(z)];

            if AllowPNextStep(pp.x, pp.y, ACount + 1) then
              CheckPlayer(pp.x, pp.y , ACount + 1);
        end;

  end;

begin
  Result := False;

  if Field[d.x, d.y].FPartType <> ptNone then
    Exit;

  SetLength(AVisited, GameData.FLevelWidth,
    GameData.FLevelHeight);

  for i := 0 to Length(AVisited) - 1 do
    for j := 0 to Length(AVisited[0]) - 1 do
      AVisited[i][j] := MaxInt;

  AbsoluteShortestPath := KDist(p,d);
  Done := False;
  CanReach := False;

  //Field[x, y].FPartType := ptCrate;
  CheckPlayer(p.x, p.y, 0);

  if AVisited[d.x, d.y] = MaxInt then
    Beep
  else
  begin
    TrackBack2(AVisited, PathLength, fMovePlayer, d);

    Result := True; // MovePlayer has found a path
  end;

  //Field[x, y].FPartType := ptReachable;
end;

procedure TPathFinder.CheckMove(p, d: Tpoint; dir: integer; APlayer: TPoint;
  ACount: integer; const FSokobanEngine: TSokobanEngine);
var
  i, bfDir: integer;
  pp: TPoint;

  function IsReachableForPlayer_(AXPos, AYPos, ADir: integer): boolean;
  var
    OldX, OldY, i, j: integer;
    Done: boolean;
    APList, PSortedList: array[1..4] of integer;

    procedure CheckPlayer(x, y: integer);
    var
      z: integer;
      pp: TPoint;


      function BestFound2(Index: integer): integer;
      var
        i, j, k: integer;
      begin
        for i := 1 to 4 do
        begin
          case i of
            1: Score := Abs(x - OldX) + Abs(y - 1 - OldY);
            2: Score := Abs(x + 1 - OldX) + Abs(y - OldY);
            3: Score := Abs(x - OldX) + Abs(y + 1 - OldY);
            4: Score := Abs(x - 1 - OldX) + Abs(y - OldY);
          end;
          APList[i] := Score;
          PSortedList[i] := i;
        end;

        for k := 2 to 4 do
        begin
          j := k;
          while j <> 1 do
          begin
            if APList[j - 1] > APList[j] then
            begin
              i := APList[j - 1];
              APList[j - 1] := APList[j];
              APList[j] := i;
              i := PSortedList[j - 1];
              PSortedList[j - 1] := PSortedList[j];
              PSortedList[j] := i;
              Dec(j);
            end
            else
              j := 1;
          end;
        end;
        Result := PSortedList[Index];
      end;

    begin
      PVisited[x, y] := True;

      if (x = OldX) and (y = OldY) then
        Done := True;

      for z := 1 to 4 do
        if not Done then
        begin
          pp := point(x,y)+Dir4[BestFound2(z)];
              if AllowPNextStep(pp) then
                CheckPlayer(pp.x, pp.y);
        end;
    end;

  begin
    Result := False;

    OldX := AXPos;
    OldY := AYPos;

    case ADir of
      1: Inc(OldY);
      2: Dec(OldX);
      3: Dec(OldY);
      4: Inc(OldX);
    end;

    if (OldX > FSokobanEngine.PuzzleWidth - 1) or (OldX < 0) or
      (OldY > FSokobanEngine.PuzzleHeight - 1) or (OldY < 0) then
      Exit;
    if (FSokobanEngine.PuzzleField[OldX, OldY].FPartType <> ptNone) then
      Exit;

    for i := 0 to Length(PVisited) - 1 do
      for j := 0 to Length(PVisited[0]) - 1 do
        PVisited[i][j] := False;

    Done := False;

    //!!  FSokobanEngine.PuzzleField[x, y].FPartType := ptCrate;

    CheckPlayer(APlayer.X, APlayer.Y);
    if Done then
    begin
      FPlayer.X := OldX;
      FPlayer.Y := OldY;
      Result := True;
    end;

    //!!  Field[x, y].FPartType := ptReachable;
  end;

  function AllowNextStep(ANext:TPoint; Dir: integer): boolean;
  begin
    Result := False;

    if (ANext.X > FLevelWidth - 1) or (ANext.X < 0) or (ANext.Y > FLevelHeight - 1) or
      (ANext.Y < 0) then
      Exit;

    if HasTarget and ((ACount > TrackLength) or
      (Acount + Kdist(ANext, d) > TrackLength)) then
      Exit;

    Result := (FReachable[ANext.X, ANext.Y]) and
      (SVisited[ANext.X, ANext.Y, dir] > ACount) and IsReachableForPlayer(p, dir);
  end;

  function BestFound(x, y, dx, dy, Index: integer): integer;
  var
    i, j, k: integer;
  begin
    for i := 1 to 4 do
    begin
      case i of
        1: Score := Abs(x - dx) + Abs(y - 1 - dy);
        2: Score := Abs(x + 1 - dx) + Abs(y - dy);
        3: Score := Abs(x - dx) + Abs(y + 1 - dy);
        4: Score := Abs(x - 1 - dx) + Abs(y - dy);
      end;

      AList[i] := Score;
      SortedList[i] := i;
    end;

    // Bubble-Sort
    for k := 2 to 4 do
    begin
      j := k;
      while (j > 1) and (AList[SortedList[j - 1]] > AList[SortedList[j]]) do
      begin
        i := SortedList[j - 1];
        SortedList[j - 1] := SortedList[j];
        SortedList[j] := i;

        Dec(j);
      end;
    end;
    Result := SortedList[Index];
  end;

begin
  if dir <> 0 then
  begin
    SVisited[p.x, p.y, dir] := ACount;
  end;


  if HasTarget then
    Inc(NewCall);

  if p=d then
  begin
  {  if HasTarget and (ACount >= TrackLength) then
    begin

    end
    else
    begin   }

    HasTarget := True;
    TrackLength := ACount;

    ArrayPos := 0;
    NewCall := 0;

    SetLength(FBoxPos, TrackLength);

    //if TrackLength = AbsoluteShortestPath + 1 then // check if it is the
    //  StopLoop := True; // shortest path
    // end;
  end;

  for i := 1 to 4 do
  begin
    if not StopLoop then
      begin
        bfDir:=BestFound(p.x, p.y, d.x, d.y, i);
      pp:=p+dir4[bfDir];
      if AllowNextStep(pp, bfDir) then
            CheckMove(pp , d, bfDir, FPlayer,
              ACount + 1, FSokobanEngine);
      end;
  end;

  if HasTarget and (NewCall = 0) then
  begin
    FBoxPos[ArrayPos] := p;
    Inc(ArrayPos);
  end;
  if HasTarget and (NewCall > 0) then
    Dec(NewCall);
end;

function TPathFinder.MoveBox(Pos, Dest: TPoint; const FSokobanEngine: TSokobanEngine): boolean;

var
  i, j, k: integer;
  tb: Tpoint;

begin
  tb := Pos;

  SetLength(SVisited, FSokobanEngine.PuzzleWidth,
    FSokobanEngine.PuzzleHeight);
  SetLength(PVisited, FSokobanEngine.PuzzleWidth,
    FSokobanEngine.PuzzleHeight);

  for i := 0 to Length(SVisited) - 1 do
    for j := 0 to Length(SVisited[0]) - 1 do
      for k := 1 to 4 do
        SVisited[i, j, k] := MaxInt;

  FPlayer := FSokobanEngine.GameData.FPlayerPos;

  APosCount := 1; // count the steps
  NewCall := 0;
  HasTarget := False;
  StopLoop := False;

  TrackLength := 0;
  AbsoluteShortestPath := KDist(Dest,tb);
  CheckMove(tb, Dest, 0, FPlayer,
    APosCount, FSokobanEngine);
 { SetLength(FBoxPos, TrackLength);
  TraceBack(x, y);  }

  Result := TrackLength > 0;
end;

end.
