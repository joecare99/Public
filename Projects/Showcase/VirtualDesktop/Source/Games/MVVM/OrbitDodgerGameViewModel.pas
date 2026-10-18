unit OrbitDodgerGameViewModel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GameClock, GameRandom, OrbitDodgerTypes,
  OrbitDodgerGameModel;

type
  TOrbitDodgerGameViewModel = class
  private
    const
      MaximumTickMilliseconds = 60000;
    var
      FClock: IGameClock;
      FModel: TOrbitDodgerGameModel;
      FLastTickMilliseconds: Int64;
      FOnStateChanged: TNotifyEvent;
    procedure StateChanged;
  public
    constructor Create(const ARandom: IGameRandom; const AClock: IGameClock;
      const AOrbitCount: Integer = 3; const AInitialLives: Integer = 3);
    destructor Destroy; override;
    procedure Restart;
    procedure Move(const AMove: TOrbitDodgerMove);
    procedure Tick;
    function State: TOrbitDodgerGameState;
    function ObstacleAt(const AIndex: Integer): TOrbitDodgerObstacle;
    property OnStateChanged: TNotifyEvent read FOnStateChanged write FOnStateChanged;
  end;

implementation

constructor TOrbitDodgerGameViewModel.Create(const ARandom: IGameRandom;
  const AClock: IGameClock; const AOrbitCount, AInitialLives: Integer);
begin
  inherited Create;
  if not Assigned(AClock) then
    raise Exception.Create('Orbit Dodger requires a clock.');
  FClock := AClock;
  FModel := TOrbitDodgerGameModel.Create(ARandom, AOrbitCount, AInitialLives);
  FLastTickMilliseconds := FClock.MonotonicMilliseconds;
end;

destructor TOrbitDodgerGameViewModel.Destroy;
begin
  FModel.Free;
  inherited Destroy;
end;

procedure TOrbitDodgerGameViewModel.Restart;
begin
  FModel.Start;
  FLastTickMilliseconds := FClock.MonotonicMilliseconds;
  StateChanged;
end;

procedure TOrbitDodgerGameViewModel.Move(const AMove: TOrbitDodgerMove);
begin
  FModel.Move(AMove);
  StateChanged;
end;

procedure TOrbitDodgerGameViewModel.Tick;
var
  CurrentMilliseconds: Int64;
  ElapsedMilliseconds: Int64;
begin
  CurrentMilliseconds := FClock.MonotonicMilliseconds;
  if CurrentMilliseconds < FLastTickMilliseconds then
  begin
    FLastTickMilliseconds := CurrentMilliseconds;
    Exit;
  end;

  ElapsedMilliseconds := CurrentMilliseconds - FLastTickMilliseconds;
  while ElapsedMilliseconds > 0 do
  begin
    if ElapsedMilliseconds > MaximumTickMilliseconds then
    begin
      FModel.Tick(MaximumTickMilliseconds);
      Dec(ElapsedMilliseconds, MaximumTickMilliseconds);
    end
    else
    begin
      FModel.Tick(ElapsedMilliseconds);
      ElapsedMilliseconds := 0;
    end;
  end;
  FLastTickMilliseconds := CurrentMilliseconds;
  StateChanged;
end;

procedure TOrbitDodgerGameViewModel.StateChanged;
begin
  if Assigned(FOnStateChanged) then
    FOnStateChanged(Self);
end;

function TOrbitDodgerGameViewModel.State: TOrbitDodgerGameState;
begin
  Result := FModel.State;
end;

function TOrbitDodgerGameViewModel.ObstacleAt(
  const AIndex: Integer): TOrbitDodgerObstacle;
begin
  Result := FModel.ObstacleAt(AIndex);
end;

end.
