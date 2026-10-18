unit GameClock;

{$mode objfpc}{$H+}

interface

type
  IGameClock = interface
    ['{61CB7B74-B76A-46B6-AF9F-0C1B678E679E}']
    function MonotonicMilliseconds: Int64;
  end;

implementation

end.
