unit TileMatchTypes;

{$mode objfpc}{$H+}

interface

type
  TTileMatchTileState = (tmtsHidden, tmtsRevealed, tmtsMatched);
  TTileMatchStatus = (tmsPlaying, tmsWon);

  TTileMatchTile = record
    Value: Integer;
    State: TTileMatchTileState;
  end;

  TTileMatchGameState = record
    Status: TTileMatchStatus;
    Columns: Integer;
    Rows: Integer;
    MatchedPairCount: Integer;
    AttemptCount: Integer;
    PendingMismatch: Boolean;
  end;

implementation

end.
