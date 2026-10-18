unit GameRandom;

{$mode objfpc}{$H+}

interface

type
  IGameRandom = interface
    ['{D8A118AA-7D20-49E3-8F8E-82D42A6C7593}']
    function NextInteger(const AExclusiveUpperBound: Integer): Integer;
  end;

implementation

end.
