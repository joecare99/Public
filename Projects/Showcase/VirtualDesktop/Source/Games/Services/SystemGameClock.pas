unit SystemGameClock;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, GameClock;

type
  TSystemGameClock = class(TInterfacedObject, IGameClock)
  public
    function MonotonicMilliseconds: Int64;
  end;

implementation

function TSystemGameClock.MonotonicMilliseconds: Int64;
begin
  Result := GetTickCount64;
end;

end.
