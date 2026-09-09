unit testgameclock;

{$mode objfpc}{$H+}

interface

uses
  GameClock;

type
  TManualClock = class(TInterfacedObject, IGameClock)
  private
    FMilliseconds: Int64;
  public
    procedure SetMilliseconds(const AValue: Int64);
    function MonotonicMilliseconds: Int64;
  end;

implementation

procedure TManualClock.SetMilliseconds(const AValue: Int64);
begin
  FMilliseconds := AValue;
end;

function TManualClock.MonotonicMilliseconds: Int64;
begin
  Result := FMilliseconds;
end;

end.
