unit OrbitDodgerTypes;

{$mode objfpc}{$H+}

interface

type
  TOrbitDodgerMove = (odmInward, odmOutward);
  TOrbitDodgerStatus = (odsRunning, odsGameOver);

  TOrbitDodgerObstacle = record
    OrbitIndex: Integer;
    Distance: Integer;
  end;

  TOrbitDodgerGameState = record
    Status: TOrbitDodgerStatus;
    Score: Integer;
    Lives: Integer;
    PlayerOrbit: Integer;
    OrbitCount: Integer;
    ObstacleCount: Integer;
  end;

implementation

end.
