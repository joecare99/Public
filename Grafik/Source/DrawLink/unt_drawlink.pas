unit unt_DrawLink;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphMath;

type
  TArrayOfInteger=array of Integer;
  TDrawPoints=record
    Actual:TFloatPoint;
    Velocity:TFloatPoint;
    Links:array[0..4] of integer;
  end;

{ TLinksWorker }

 TLinksWorker=Class
 private
   FPointCount: integer;
   Fpoints:array of TDrawPoints;
   FIndex:array[0..31,0..31] of TArrayofInteger;
   procedure SetPointCount(AValue: integer);
 public
     constructor Create(count:integer);
     destructor Destroy; override;
     Procedure AnimationStep(dt:integer);
     Procedure UpdateIndex(idx:integer;old,new:TFloatPoint);virtual;
     procedure SetPoint(idx: integer; newplace, newvelocity: TFloatPoint); virtual;
     property PointCount:integer read FPointCount write SetPointCount;
     Function GetPoint(idx:integer):TDrawPoints;
     Procedure SetVelocity(idx:integer;aVelocity:TFloatPoint);
     Procedure SetLinks(idx,idx2,link:integer);
     Function GetIndex(aPlace:TFloatPoint):TArrayofInteger;
     Function SameIndex(aPlace1,aplace2:TFloatPoint):boolean;
  end;

Function DrawPoints(aPlace,aVelocity:TFloatPoint):TDrawPoints;

implementation

const IndexFactor=31.49999;

function DrawPoints(aPlace, aVelocity: TFloatPoint): TDrawPoints;
begin
  result.Actual := aPlace;
  result.Velocity := aVelocity;
end;

{ TLinksWorker }

procedure TLinksWorker.SetPointCount(AValue: integer);
begin
  if FPointCount=AValue then Exit;
  FPointCount:=AValue;
end;

constructor TLinksWorker.Create(count: integer);
var
  ix, iy: Integer;
begin
  FpointCount := count;
  setlength(Fpoints,count);
  for ix := 0 to high(FIndex) do
     for iy := 0 to high(FIndex[ix]) do
        setlength(FIndex[ix,iy],0);
  setlength(FIndex[0,0],count);
  for ix := 0 to count-1 do
    FIndex[0,0][ix]:=ix;
end;

destructor TLinksWorker.Destroy;
begin
  inherited Destroy;
end;

procedure TLinksWorker.AnimationStep(dt: integer);
var
  i: Integer;
  fpNext : TFloatPoint;
begin
  for i := 0 to high(Fpoints) do
     with Fpoints[i] do
     begin
       fpNext:=Actual+(Velocity*dt*0.001);
       if fpNext.x <0 then
         begin
         // spiegle x an der 0-Linie
         fpNext.x := -fpNext.x;
         Velocity.x := -Velocity.x;
         // Bounce-Event
         end;
       if fpNext.y <0 then
         begin
         // spiegle y an der 0-Linie
         fpNext.y := -fpNext.y;
         Velocity.y := -Velocity.y;
         // Bounce-Event
         end;
       if fpNext.x >1.0 then
         begin
         // spiegle x an der 0-Linie
         fpNext.x := 2.0-fpNext.x;
         Velocity.x := -Velocity.x;
         // Bounce-Event
         end;
       if fpNext.y >1.0 then
         begin
         // spiegle y an der 0-Linie
         fpNext.y := 2.0-fpNext.y;
         Velocity.y := -Velocity.y;
         // Bounce-Event
         end;
       UpdateIndex(I,Actual,fpNext);
       Actual:=fpNext;
     end;
end;

procedure TLinksWorker.UpdateIndex(idx: integer; old, new: TFloatPoint);

var   oldip,newip:Tpoint;

procedure KillIdx(kli:integer;var vIdx:TArrayOfInteger);
var
  I: Integer;

begin
  for I := 0 to high(vIdx) do
    if vIdx[i]=kli then
      begin
        vIdx[i] := vIdx[high(vidx)];
        SetLength(vIdx,high(vIdx));
        break;
      end;
end;

procedure AppendIdx(nwi:integer;var vIdx:TArrayOfInteger);
var
  I: Integer;

begin
  for I := 0 to high(vIdx) do
    if vIdx[i]=nwi then
       exit;
  SetLength(vIdx,high(vIdx)+2);
  vIdx[high(vidx)]:=nwi;
end;

begin
  oldip := old*IndexFactor;
  newip := new*IndexFactor;
  if oldip <> newIp then
    begin
      KillIdx(idx,FIndex[oldip.x and 31,oldip.y and 31]);
      appendIdx(idx,FIndex[newip.x and 31,newip.y and 31]);
    end;
end;

procedure TLinksWorker.SetPoint(idx: integer; newplace, newvelocity: TFloatPoint);
begin
  if (idx>=0) and (idx<FPointCount) then
    with Fpoints[idx] do
    begin
      Velocity := newvelocity;
      UpdateIndex(idx,Actual,newplace);
      Actual:=newplace;
    end;
end;

function TLinksWorker.GetPoint(idx: integer): TDrawPoints;
begin

  if (idx>=0) and (idx<FPointCount) then
    Result:=Fpoints[idx]
  else
    begin
    result.Actual:=FloatPoint(0,0);
    result.Velocity:=FloatPoint(0,0);
    end;
end;

procedure TLinksWorker.SetVelocity(idx: integer; aVelocity: TFloatPoint);
begin
  if (idx>=0) and (idx<FPointCount) then
    Fpoints[idx].Velocity:=aVelocity;
end;

procedure TLinksWorker.SetLinks(idx, idx2, link: integer);
begin
  if (idx>=0) and (idx<FPointCount) then
    Fpoints[idx].Links[idx2]:=link;
end;

function TLinksWorker.GetIndex(aPlace: TFloatPoint): TArrayofInteger;
var
  aPlaceip: TPoint;
begin
  aPlaceip := aPlace*IndexFactor;
  result := FIndex[aPlaceip.x and 31,aPlaceip.y and 31];
end;

function TLinksWorker.SameIndex(aPlace1, aplace2: TFloatPoint): boolean;
var
  aPlace1ip,aPlace2ip: TPoint;
begin
  aPlace1ip := aPlace1*IndexFactor;
  aPlace2ip := aPlace2*IndexFactor;
  result := aPlace1ip = aPlace2ip;
end;

end.

