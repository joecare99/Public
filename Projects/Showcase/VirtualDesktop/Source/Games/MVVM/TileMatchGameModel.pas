unit TileMatchGameModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, GameRandom, TileMatchTypes;

type
  TTileMatchGameModel = class
  private
    FRandom: IGameRandom;
    FColumns: Integer;
    FRows: Integer;
    FStatus: TTileMatchStatus;
    FMatchedPairCount: Integer;
    FAttemptCount: Integer;
    FFirstSelectedIndex: Integer;
    FSecondSelectedIndex: Integer;
    FTiles: array of TTileMatchTile;
    function CellCount: Integer;
    procedure RequireTileIndex(const AIndex: Integer);
    procedure ShuffleTiles;
  public
    constructor Create(const ARandom: IGameRandom; const AColumns: Integer = 4;
      const ARows: Integer = 4);
    procedure Start;
    function Reveal(const ATileIndex: Integer): Boolean;
    procedure HidePendingMismatch;
    function HasPendingMismatch: Boolean;
    function State: TTileMatchGameState;
    function TileAt(const ATileIndex: Integer): TTileMatchTile;
  end;

implementation

constructor TTileMatchGameModel.Create(const ARandom: IGameRandom;
  const AColumns, ARows: Integer);
begin
  inherited Create;
  if not Assigned(ARandom) then
    raise Exception.Create('Tile Match requires a random source.');
  if (AColumns < 2) or (ARows < 2) then
    raise Exception.Create('Tile Match needs at least two rows and columns.');
  if (AColumns > 10) or (ARows > 10) then
    raise Exception.Create('Tile Match dimensions must not exceed 10.');
  if Odd(AColumns * ARows) then
    raise Exception.Create('Tile Match needs an even number of tiles.');

  FRandom := ARandom;
  FColumns := AColumns;
  FRows := ARows;
  Start;
end;

procedure TTileMatchGameModel.Start;
var
  Index: Integer;
begin
  SetLength(FTiles, CellCount);
  for Index := 0 to High(FTiles) do
  begin
    FTiles[Index].Value := (Index div 2) + 1;
    FTiles[Index].State := tmtsHidden;
  end;
  ShuffleTiles;

  FStatus := tmsPlaying;
  FMatchedPairCount := 0;
  FAttemptCount := 0;
  FFirstSelectedIndex := -1;
  FSecondSelectedIndex := -1;
end;

function TTileMatchGameModel.Reveal(const ATileIndex: Integer): Boolean;
begin
  RequireTileIndex(ATileIndex);
  Result := False;
  if (FStatus <> tmsPlaying) or HasPendingMismatch or
     (FTiles[ATileIndex].State <> tmtsHidden) then
    Exit;

  FTiles[ATileIndex].State := tmtsRevealed;
  if FFirstSelectedIndex < 0 then
    FFirstSelectedIndex := ATileIndex
  else
  begin
    FSecondSelectedIndex := ATileIndex;
    Inc(FAttemptCount);
    if FTiles[FFirstSelectedIndex].Value = FTiles[FSecondSelectedIndex].Value then
    begin
      FTiles[FFirstSelectedIndex].State := tmtsMatched;
      FTiles[FSecondSelectedIndex].State := tmtsMatched;
      FFirstSelectedIndex := -1;
      FSecondSelectedIndex := -1;
      Inc(FMatchedPairCount);
      if FMatchedPairCount = CellCount div 2 then
        FStatus := tmsWon;
    end;
  end;
  Result := True;
end;

procedure TTileMatchGameModel.HidePendingMismatch;
begin
  if not HasPendingMismatch then
    Exit;

  FTiles[FFirstSelectedIndex].State := tmtsHidden;
  FTiles[FSecondSelectedIndex].State := tmtsHidden;
  FFirstSelectedIndex := -1;
  FSecondSelectedIndex := -1;
end;

function TTileMatchGameModel.HasPendingMismatch: Boolean;
begin
  Result := (FFirstSelectedIndex >= 0) and (FSecondSelectedIndex >= 0);
end;

function TTileMatchGameModel.State: TTileMatchGameState;
begin
  Result.Status := FStatus;
  Result.Columns := FColumns;
  Result.Rows := FRows;
  Result.MatchedPairCount := FMatchedPairCount;
  Result.AttemptCount := FAttemptCount;
  Result.PendingMismatch := HasPendingMismatch;
end;

function TTileMatchGameModel.TileAt(const ATileIndex: Integer): TTileMatchTile;
begin
  RequireTileIndex(ATileIndex);
  Result := FTiles[ATileIndex];
end;

function TTileMatchGameModel.CellCount: Integer;
begin
  Result := FColumns * FRows;
end;

procedure TTileMatchGameModel.RequireTileIndex(const AIndex: Integer);
begin
  if (AIndex < 0) or (AIndex >= CellCount) then
    raise Exception.Create('Tile index is out of range.');
end;

procedure TTileMatchGameModel.ShuffleTiles;
var
  Index: Integer;
  SwapIndex: Integer;
  TemporaryValue: Integer;
begin
  for Index := High(FTiles) downto 1 do
  begin
    SwapIndex := FRandom.NextInteger(Index + 1);
    if (SwapIndex < 0) or (SwapIndex > Index) then
      raise Exception.Create('Random source returned an invalid tile index.');
    TemporaryValue := FTiles[Index].Value;
    FTiles[Index].Value := FTiles[SwapIndex].Value;
    FTiles[SwapIndex].Value := TemporaryValue;
  end;
end;

end.
