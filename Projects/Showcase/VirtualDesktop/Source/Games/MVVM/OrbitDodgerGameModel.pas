unit OrbitDodgerGameModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, GameRandom, OrbitDodgerTypes;

type
  TOrbitDodgerGameModel = class
  private
    const
      InitialObstacleDistance = 1000;
      ObstacleSpeedPerSecond = 120;
      SpawnIntervalMilliseconds = 750;
      MaximumTickMilliseconds = 60000;
    var
      FRandom: IGameRandom;
      FOrbitCount: Integer;
      FInitialLives: Integer;
      FStatus: TOrbitDodgerStatus;
      FScore: Integer;
      FLives: Integer;
      FPlayerOrbit: Integer;
      FObstacleMovementRemainder: Integer;
      FSpawnMilliseconds: Integer;
      FObstacles: array of TOrbitDodgerObstacle;
    procedure AddObstacle;
    procedure AdvanceObstacles(const ADistance: Integer);
    procedure RequireObstacleIndex(const AIndex: Integer);
  public
    constructor Create(const ARandom: IGameRandom; const AOrbitCount: Integer = 3;
      const AInitialLives: Integer = 3);
    procedure Start;
    procedure Move(const AMove: TOrbitDodgerMove);
    procedure Tick(const AElapsedMilliseconds: Integer);
    function State: TOrbitDodgerGameState;
    function ObstacleAt(const AIndex: Integer): TOrbitDodgerObstacle;
  end;

implementation

constructor TOrbitDodgerGameModel.Create(const ARandom: IGameRandom;
  const AOrbitCount, AInitialLives: Integer);
begin
  inherited Create;
  if not Assigned(ARandom) then
    raise Exception.Create('Orbit Dodger requires a random source.');
  if (AOrbitCount < 2) or (AOrbitCount > 16) then
    raise Exception.Create('Orbit count must be between 2 and 16.');
  if (AInitialLives < 1) or (AInitialLives > 99) then
    raise Exception.Create('Initial lives must be between 1 and 99.');

  FRandom := ARandom;
  FOrbitCount := AOrbitCount;
  FInitialLives := AInitialLives;
  Start;
end;

procedure TOrbitDodgerGameModel.Start;
begin
  FStatus := odsRunning;
  FScore := 0;
  FLives := FInitialLives;
  FPlayerOrbit := FOrbitCount div 2;
  FObstacleMovementRemainder := 0;
  FSpawnMilliseconds := 0;
  SetLength(FObstacles, 0);
end;

procedure TOrbitDodgerGameModel.Move(const AMove: TOrbitDodgerMove);
begin
  if not (Ord(AMove) in [Ord(Low(TOrbitDodgerMove))..Ord(High(TOrbitDodgerMove))]) then
    raise Exception.Create('Unknown Orbit Dodger move.');
  if FStatus <> odsRunning then
    Exit;

  case AMove of
    odmInward:
      if FPlayerOrbit > 0 then
        Dec(FPlayerOrbit);
    odmOutward:
      if FPlayerOrbit < FOrbitCount - 1 then
        Inc(FPlayerOrbit);
  end;
end;

procedure TOrbitDodgerGameModel.Tick(const AElapsedMilliseconds: Integer);
var
  TotalMovement: Int64;
  Movement: Integer;
begin
  if (AElapsedMilliseconds < 0) or
     (AElapsedMilliseconds > MaximumTickMilliseconds) then
    raise Exception.Create('Elapsed milliseconds must be between 0 and 60000.');
  if (AElapsedMilliseconds = 0) or (FStatus <> odsRunning) then
    Exit;

  TotalMovement := Int64(AElapsedMilliseconds) * ObstacleSpeedPerSecond +
    FObstacleMovementRemainder;
  Movement := TotalMovement div 1000;
  FObstacleMovementRemainder := TotalMovement mod 1000;
  AdvanceObstacles(Movement);
  if FStatus <> odsRunning then
    Exit;

  Inc(FSpawnMilliseconds, AElapsedMilliseconds);
  while FSpawnMilliseconds >= SpawnIntervalMilliseconds do
  begin
    Dec(FSpawnMilliseconds, SpawnIntervalMilliseconds);
    AddObstacle;
  end;
end;

procedure TOrbitDodgerGameModel.AddObstacle;
var
  OrbitIndex: Integer;
  ObstacleCount: Integer;
begin
  OrbitIndex := FRandom.NextInteger(FOrbitCount);
  if (OrbitIndex < 0) or (OrbitIndex >= FOrbitCount) then
    raise Exception.Create('Random source returned an invalid orbit index.');

  ObstacleCount := Length(FObstacles);
  SetLength(FObstacles, ObstacleCount + 1);
  FObstacles[ObstacleCount].OrbitIndex := OrbitIndex;
  FObstacles[ObstacleCount].Distance := InitialObstacleDistance;
end;

procedure TOrbitDodgerGameModel.AdvanceObstacles(const ADistance: Integer);
var
  SourceIndex: Integer;
  TargetIndex: Integer;
begin
  TargetIndex := 0;
  for SourceIndex := 0 to High(FObstacles) do
  begin
    Dec(FObstacles[SourceIndex].Distance, ADistance);
    if FObstacles[SourceIndex].Distance > 0 then
    begin
      FObstacles[TargetIndex] := FObstacles[SourceIndex];
      Inc(TargetIndex);
    end
    else if FObstacles[SourceIndex].OrbitIndex = FPlayerOrbit then
      Dec(FLives)
    else
      Inc(FScore);
  end;
  SetLength(FObstacles, TargetIndex);
  if FLives <= 0 then
  begin
    FLives := 0;
    FStatus := odsGameOver;
  end;
end;

procedure TOrbitDodgerGameModel.RequireObstacleIndex(const AIndex: Integer);
begin
  if (AIndex < 0) or (AIndex >= Length(FObstacles)) then
    raise Exception.Create('Obstacle index is out of range.');
end;

function TOrbitDodgerGameModel.State: TOrbitDodgerGameState;
begin
  Result.Status := FStatus;
  Result.Score := FScore;
  Result.Lives := FLives;
  Result.PlayerOrbit := FPlayerOrbit;
  Result.OrbitCount := FOrbitCount;
  Result.ObstacleCount := Length(FObstacles);
end;

function TOrbitDodgerGameModel.ObstacleAt(
  const AIndex: Integer): TOrbitDodgerObstacle;
begin
  RequireObstacleIndex(AIndex);
  Result := FObstacles[AIndex];
end;

end.
