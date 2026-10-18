unit SystemGameRandom;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, GameRandom;

type
  TSystemGameRandom = class(TInterfacedObject, IGameRandom)
  public
    function NextInteger(const AExclusiveUpperBound: Integer): Integer;
  end;

implementation

function TSystemGameRandom.NextInteger(
  const AExclusiveUpperBound: Integer): Integer;
begin
  if AExclusiveUpperBound <= 0 then
    raise EArgumentOutOfRangeException.Create('Random bound must be positive.');
  Result := Random(AExclusiveUpperBound);
end;

end.
