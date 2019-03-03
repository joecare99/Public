unit WernerEng;

{$IFDEF FPC}
  {$mode delphi}
{$ENDIF}
interface

uses
  Classes, SysUtils;

type
  TBildData = array[0..19, 0..11] of
    byte;
  TAendBild = array[0..19, 0..11] of
    Boolean;

  { TWernerEng }
  TplayerDir = (
    wpd_NoMove = 0, // Player Stands Still
    wpd_Up,
    wpd_right,
    wpd_Down,
    wpd_Left);

  TSoundReq = (
    wsr_noSound,
    wsr_Step,
    wsr_BoulderOnStone,
    wsr_BoulderOnEarth,
    wsr_Hit);

  TLevelDevProc = procedure(x, y, lev: integer; out bt: byte);

  TWernerEng = class

  private
    FLevDefProc: TLevelDevProc;
    FOldBild: TBildData;
    FPlayerAlive: boolean; // Figur ist noch am leben
    FActLevel: integer; // Aktueller Level
    FNextLevel: boolean; // Nächster LEvel Erreicht
    FFirstCycle : boolean;
    FStartDT:TDateTime;
    FTimeLeft:integer;
    FScore :integer;
    procedure DoBoulder(x, y: integer; var aend: TAendBild);
    procedure PreMove;
    procedure intbild;
    procedure setActLevel(AValue: integer);
    procedure SetNextLevel(AValue: boolean);
    procedure SetPlayerAlive(AValue: boolean);
  public
    BildData: TBildData;
    leb: integer;
    MaxLevel: integer;
    playerDir: TPlayerDir;
    SoundReq: TSoundReq;
    constructor Create(Life, aMaxLevel: integer; ALDP: TLevelDevProc);
    procedure InitLevel;
    procedure GameStep;
    function Ended: boolean;
    property level: integer read FActLevel write setActLevel;
    property AmLeben: boolean read FPlayerAlive write SetPlayerAlive;
    property nxl: boolean read FNextLevel write SetNextLevel;
    property Score: integer read FScore;
    property TimeLeft: Integer read FTimeLeft;
  end;

implementation

uses types;

const
  di: array[0..9] of TSmallPoint =
    ((x: 0; y: 0),
    (x: 0; y: -1),
    (x: 1; y: 0),
    (x: 0; y: 1),
    (x: -1; y: 0),
    (x: 0; y: 0),
    (x: 0; y: -1),
    (x: 1; y: 0),
    (x: 0; y: 1),
    (x: -1; y: 0));

constructor TWernerEng.Create(Life, aMaxLevel: integer; ALDP: TLevelDevProc);

begin
  FNextLevel := False;
  FActLevel := 1;
  MaxLevel := aMaxLevel;
  FLevDefProc := ALDP;
  FPlayerAlive := True;
  leb := Life;
end;

procedure TWernerEng.InitLevel;
var
  x: integer;
  y: integer;
begin
  if not FPlayerAlive then
    leb := leb - 1;
  //    Repeat Until Not tst;
  FPlayerAlive := True;
  FFirstCycle := true;

  if FNextLevel then
    begin
      FActLevel := FActLevel mod MaxLevel + 1;
      if FTimeLeft < 100 then
        FScore := FScore + FTimeLeft;
    end;
  FStartDt := Now;
  FTimeleft := 99;
  FNextLevel := False;
  for x := 0 to 19 do
    for y := 0 to 11 do
      FLevDefProc(x, y, FActLevel, BildData[x, y]);
end;

procedure TWernerEng.PreMove;
begin

end;

procedure TWernerEng.DoBoulder(x, y: integer; var aend: TAendBild);
var
  bo: integer;
begin
  if (y < 11) and
    not aend[x,y] then
              begin
                bo := FOldBild[x, y];
                if (BildData[x, y + 1] = 0) and (FOldBild[x, y + 1] = 0) then
                begin
                  BildData[x, y + 1] := 10;
                  if (y < 10) and (BildData[x, y + 2] in [5, 2]) then
                    SoundReq := wsr_BoulderOnStone;
                  BildData[x, y] := 0;
                  aend[x,y] := true;
                end
                else if (bo = 10) and (FOldBild[x, y + 1] = 4) then
                begin
                  BildData[x, y ] := 5;
                  SoundReq := wsr_Hit;
                  BildData[x, y+1] := 11; // Dead Werner
                  aend[x,y] := true;
                end
                else if (x>0) and
                  (FOldBild[x - 1, y + 1] = 0) and
                  (FOldBild[x - 1, y] = 0) and
                  (FOldBild[x, y + 1] in [5, 10, 2]) and
                  (BildData[x - 1, y] = 0) and
                  (BildData[x - 1, y + 1] = 0) then
                begin
                  BildData[x - 1, y + 1] := 5;
                  if (y < 10) and (BildData[x - 1, y + 2] in [5, 2]) then
                    SoundReq := wsr_BoulderOnStone;
                  BildData[x, y] := 0;
                  aend[x,y] := true;
                end
                else if (x<19)and
                  (FOldBild[x + 1, y + 1] = 0) and
                  (FOldBild[x + 1, y] = 0) and
                  (FOldBild[x, y + 1] in [5, 10, 2]) and
                  (BildData[x + 1, y + 1] = 0) and
                  (BildData[x + 1, y] = 0) then
                begin
                  BildData[x + 1, y + 1] := 5;
                  if (y < 10) and (BildData[x + 1, y + 2] in [5, 2]) then
                    SoundReq := wsr_BoulderOnStone;
                  BildData[x, y] := 0;
                   aend[x, y ] :=true;
                end
                else
                  BildData[x, y] := 5;
                  aend[x,y] := true;
              end;
end;

procedure TWernerEng.intbild;

var
  aend: TAendBild;


  procedure Check(x, y: integer); forward;

  procedure CalcNewPlace(x, y,dx, dy: integer;
  out
    nx,
    ny: Integer);
  begin
    ny:= y+dy;
    nx := x+dx;
    if nx <0 then
      begin
      nx:=19;
      ny := ny -1;
      end;
    if nx >=20 then
      begin
      nx:=0;
       ny:= ny+1;
      end;
    if ny <0 then
      ny:=0;
    if ny >=12 then
      ny:=11;
  end;

  function MoveEnemy(dx, dy, bo, x, y: integer;var aend:TAendBild): boolean;

  var
    nx,
    ny: Integer;

  begin
    Result := False;
    CalcNewPlace(x, y, dx, dy,nx,ny);
    if (BildData[nx, ny] =bo) then
      check(nx, ny);
    if (BildData[nx, ny] in [5,10])and (bo=8) then
      DoBoulder(nx,ny,aend);
    if BildData[nx, ny] =0 then
    begin
      BildData[x, y] := 0;
      BildData[nx, ny] := bo;
      aend[nx, ny] := True;
      Result := True;
    end
    else
      if FoldBild[nx, ny] =4 then
      begin
        BildData[x, y] := bo;
        BildData[nx, ny] := 11;
        SoundReq := wsr_Hit;
         Result := True;
      end;

  end;


  procedure Check(x, y: integer);

  var
    bo: integer;
    nx: Integer;
    ny: Integer;
    bbo: Byte;

  begin
    if aend[x, y] then
      exit;

    aend[x, y] := True;
    bo := FOldBild[x, y];
    CalcNewPlace(x, y, di[bo].x, di[bo].y,nx,ny);
    bbo := FOldBild[nx, ny];
    if not MoveEnemy(di[bo].x, di[bo].y, bo, x, y,aend) then
    begin
      // geradeaus geht nicht.
      // drehe nach rechts,
      bo := ((FOldBild[x, y] - 5) mod 4) + 6; // Links 90*
      if not moveenemy(di[bo].x, di[bo].y, bo, x, y,aend) then
      begin
        // rechts geht nicht.
        // drehe nach links,
        bo := ((FOldBild[x, y] - 3) mod 4) + 6; // Drehe 180*
        if not moveenemy(di[bo].x, di[bo].y, bo, x, y,aend) then
        begin
          // links geht nicht.
          // drehe nach rückwärts,
          bo := ((FOldBild[x, y] - 4) mod 4) + 6; // Rechts 180*
          if bbo <> 0 then
          begin
          CalcNewPlace(x, y, di[bo].x, di[bo].y,nx,ny);
          if not moveenemy(di[bo].x, di[bo].y, bo, x, y,aend) then
          begin
            if FOldBild[nx, ny] = 0 then
              BildData[x, y] :=bo
            else
              begin
                if bbo in [4..9] then
                  BildData[x, y] := FOldBild[x, y]
                else
                  BildData[x, y] := ((FOldBild[x, y] - 5) mod 4) + 6;
              end;
          end;

          end
          else
            BildData[x, y] :=FOldBild[x, y];
        end;
      end;

    end;

  end;

var
  x, y: integer;
  nx: Integer;
  ny: Integer;
  FoundPlayer: Boolean;

begin
  fillchar(aend, sizeof(aend), 0);
  SoundReq := wsr_noSound;
  //  for i := 1 to 240 do
  FoundPlayer := false;
  for y := 14 downto 0 do
    for x := 0 to 19 do
      begin
        if (y>2) and
          not aend[x, y-3] and
          (FOldBild[x,y-3]in[ 5, 10]) and
          not FFirstCycle then DoBoulder(x, y-3, aend);
        if (y>0) and
           (y<13) and
          not aend[x, y-1] and
          (FOldBild[x,y-1]in[ 6..9]) and
          not FFirstCycle then
            check(x, y-1);

        if (y<12) and
           not aend[x, y] and
          (FOldBild[x,y]in[ 4, 11])  then
           if FOldBild[x,y]=    11 then FPlayerAlive:=false
           else
           begin
            CalcNewPlace(x,y,di[Ord(PlayerDir)].x,di[Ord(PlayerDir)].y,nx,ny);
            if (FOldBild[nx,ny] in [6..9]) and not FFirstCycle then
              check(nx,ny);
            if (((FOldBild[nx,ny] in [0, 1, 3] ) and not aend[nx,ny]) or
              ((FOldBild[nx,ny]in[5..10]) and (BildData[nx,ny]=0)))
               and not FoundPlayer  then
            begin
              if (BildData[nx,ny] in [0, 1, 3]) then
              begin    // ???
                SoundReq := wsr_Hit;
              end;
              if FOldBild[nx,ny] = 3 then
                // Flaschbier
                FNextLevel := True;
              BildData[nx,ny] := 4;
              SoundReq := wsr_Step;
              BildData[x, y] := 0;
            end
            else if FOldBild[nx,ny] in [6..10] then
            begin
              SoundReq := wsr_Hit;
            end;
            Foundplayer :=true;
          end;

        end;

  FFirstCycle:=false;
  FTimeleft := 99-trunc((now -FStartDT)*24*60*60);
  if Ftimeleft <=0 then
    FTimeLeft :=0;
  if (not Foundplayer) or (FTimeLeft = 0) then
     FPlayerAlive:=false;
end;

procedure TWernerEng.setActLevel(AValue: integer);
begin
  if FActLevel = AValue then
    Exit;
  FActLevel := AValue;
end;

procedure TWernerEng.SetNextLevel(AValue: boolean);
begin
  if FNextLevel = AValue then
    Exit;
  FNextLevel := AValue;
end;

procedure TWernerEng.SetPlayerAlive(AValue: boolean);
begin
  if FPlayerAlive or FPlayerAlive = AValue then
    Exit;
  FPlayerAlive := AValue;
end;


procedure TWernerEng.GameStep;
begin
  move(BildData, FOldBild, sizeof(BildData));
  if FPlayerAlive then
  begin
    PreMove;
    intbild;
  end;
end;

function TWernerEng.Ended: boolean;
begin
  Result := not FPlayerAlive and (leb <= 1);
end;


end.
