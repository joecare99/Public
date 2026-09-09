unit testgames;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, GameRandom,
  OrbitDodgerGameModel, OrbitDodgerGameViewModel, OrbitDodgerTypes,
  TileMatchGameModel, TileMatchGameViewModel, TileMatchTypes,
  testgameclock, testgamerandom;

type
  TGameLogicTest = class(TTestCase)
  private
    function FindMatchingTile(const AModel: TTileMatchGameModel;
      const AIndex: Integer): Integer;
  published
    procedure OrbitDodgerSpawnsAndAwardsDodges;
    procedure OrbitDodgerViewModelUsesInjectedClock;
    procedure TileMatchDefersMismatchUntilDelayExpires;
    procedure TileMatchWinsAfterAllPairsAreSelected;
    procedure GameModelsRejectInvalidDimensions;
  end;

implementation

procedure TGameLogicTest.OrbitDodgerSpawnsAndAwardsDodges;
var
  Random: IGameRandom;
  Model: TOrbitDodgerGameModel;
  GameState: TOrbitDodgerGameState;
begin
  Random := TSequenceRandom.Create([0]);
  Model := TOrbitDodgerGameModel.Create(Random, 3, 2);
  try
    Model.Tick(750);
    AssertEquals(1, Model.State.ObstacleCount);
    Model.Tick(8334);

    GameState := Model.State;
    AssertEquals(1, GameState.Score);
    AssertEquals(2, GameState.Lives);
    AssertEquals(Ord(odsRunning), Ord(GameState.Status));
  finally
    Model.Free;
  end;
end;

procedure TGameLogicTest.OrbitDodgerViewModelUsesInjectedClock;
var
  Random: IGameRandom;
  Clock: TManualClock;
  ViewModel: TOrbitDodgerGameViewModel;
begin
  Random := TSequenceRandom.Create([0]);
  Clock := TManualClock.Create;
  ViewModel := TOrbitDodgerGameViewModel.Create(Random, Clock, 3, 1);
  try
    Clock.SetMilliseconds(750);
    ViewModel.Tick;
    ViewModel.Move(odmInward);
    Clock.SetMilliseconds(9084);
    ViewModel.Tick;

    AssertEquals(0, ViewModel.State.Lives);
    AssertEquals(Ord(odsGameOver), Ord(ViewModel.State.Status));
  finally
    ViewModel.Free;
  end;
end;

procedure TGameLogicTest.TileMatchDefersMismatchUntilDelayExpires;
var
  Random: IGameRandom;
  Clock: TManualClock;
  ViewModel: TTileMatchGameViewModel;
begin
  Random := TSequenceRandom.Create([0]);
  Clock := TManualClock.Create;
  ViewModel := TTileMatchGameViewModel.Create(Random, Clock, 2, 2, 100);
  try
    AssertTrue(ViewModel.SelectTile(0));
    AssertTrue(ViewModel.SelectTile(1));
    AssertTrue(ViewModel.State.PendingMismatch);
    AssertFalse(ViewModel.SelectTile(2));

    Clock.SetMilliseconds(99);
    ViewModel.Tick;
    AssertTrue(ViewModel.State.PendingMismatch);

    Clock.SetMilliseconds(100);
    ViewModel.Tick;
    AssertFalse(ViewModel.State.PendingMismatch);
    AssertEquals(Ord(tmtsHidden), Ord(ViewModel.TileAt(0).State));
    AssertEquals(Ord(tmtsHidden), Ord(ViewModel.TileAt(1).State));
  finally
    ViewModel.Free;
  end;
end;

procedure TGameLogicTest.TileMatchWinsAfterAllPairsAreSelected;
var
  Random: IGameRandom;
  Model: TTileMatchGameModel;
  Index: Integer;
  MatchingIndex: Integer;
begin
  Random := TSequenceRandom.Create([0]);
  Model := TTileMatchGameModel.Create(Random, 2, 2);
  try
    for Index := 0 to 3 do
      if Model.TileAt(Index).State = tmtsHidden then
      begin
        MatchingIndex := FindMatchingTile(Model, Index);
        AssertTrue(Model.Reveal(Index));
        AssertTrue(Model.Reveal(MatchingIndex));
      end;

    AssertEquals(2, Model.State.MatchedPairCount);
    AssertEquals(Ord(tmsWon), Ord(Model.State.Status));
  finally
    Model.Free;
  end;
end;

procedure TGameLogicTest.GameModelsRejectInvalidDimensions;
var
  Random: IGameRandom;
  Raised: Boolean;
begin
  Random := TSequenceRandom.Create([0]);

  Raised := False;
  try
    TOrbitDodgerGameModel.Create(Random, 1, 1);
  except
    on E: Exception do
      Raised := True;
  end;
  AssertTrue(Raised);

  Raised := False;
  try
    TTileMatchGameModel.Create(Random, 3, 3);
  except
    on E: Exception do
      Raised := True;
  end;
  AssertTrue(Raised);
end;

function TGameLogicTest.FindMatchingTile(const AModel: TTileMatchGameModel;
  const AIndex: Integer): Integer;
var
  Index: Integer;
begin
  for Index := 0 to 3 do
    if (Index <> AIndex) and
       (AModel.TileAt(Index).Value = AModel.TileAt(AIndex).Value) then
      Exit(Index);
  Fail('Matching tile was not found.');
  Result := -1;
end;

initialization
  RegisterTest(TGameLogicTest);

end.
