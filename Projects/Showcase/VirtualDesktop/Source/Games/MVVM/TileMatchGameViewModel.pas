unit TileMatchGameViewModel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GameClock, GameRandom, TileMatchTypes,
  TileMatchGameModel;

type
  TTileMatchGameViewModel = class
  private
    FClock: IGameClock;
    FModel: TTileMatchGameModel;
    FMismatchDelayMilliseconds: Integer;
    FHideAtMilliseconds: Int64;
    FOnStateChanged: TNotifyEvent;
    procedure StateChanged;
  public
    constructor Create(const ARandom: IGameRandom; const AClock: IGameClock;
      const AColumns: Integer = 4; const ARows: Integer = 4;
      const AMismatchDelayMilliseconds: Integer = 1000);
    destructor Destroy; override;
    procedure Restart;
    function SelectTile(const ATileIndex: Integer): Boolean;
    procedure Tick;
    function State: TTileMatchGameState;
    function TileAt(const ATileIndex: Integer): TTileMatchTile;
    property OnStateChanged: TNotifyEvent read FOnStateChanged write FOnStateChanged;
  end;

implementation

constructor TTileMatchGameViewModel.Create(const ARandom: IGameRandom;
  const AClock: IGameClock; const AColumns, ARows,
  AMismatchDelayMilliseconds: Integer);
begin
  inherited Create;
  if not Assigned(AClock) then
    raise Exception.Create('Tile Match requires a clock.');
  if (AMismatchDelayMilliseconds < 1) or
     (AMismatchDelayMilliseconds > 60000) then
    raise Exception.Create('Mismatch delay must be between 1 and 60000.');

  FClock := AClock;
  FMismatchDelayMilliseconds := AMismatchDelayMilliseconds;
  FHideAtMilliseconds := -1;
  FModel := TTileMatchGameModel.Create(ARandom, AColumns, ARows);
end;

destructor TTileMatchGameViewModel.Destroy;
begin
  FModel.Free;
  inherited Destroy;
end;

procedure TTileMatchGameViewModel.Restart;
begin
  FModel.Start;
  FHideAtMilliseconds := -1;
  StateChanged;
end;

function TTileMatchGameViewModel.SelectTile(const ATileIndex: Integer): Boolean;
var
  CurrentMilliseconds: Int64;
begin
  Result := FModel.Reveal(ATileIndex);
  if Result and FModel.HasPendingMismatch then
  begin
    CurrentMilliseconds := FClock.MonotonicMilliseconds;
    if CurrentMilliseconds > High(Int64) - FMismatchDelayMilliseconds then
      FHideAtMilliseconds := High(Int64)
    else
      FHideAtMilliseconds := CurrentMilliseconds + FMismatchDelayMilliseconds;
  end;
  if Result then
    StateChanged;
end;

procedure TTileMatchGameViewModel.Tick;
begin
  if FModel.HasPendingMismatch and
     (FClock.MonotonicMilliseconds >= FHideAtMilliseconds) then
  begin
    FModel.HidePendingMismatch;
    FHideAtMilliseconds := -1;
    StateChanged;
  end;
end;

procedure TTileMatchGameViewModel.StateChanged;
begin
  if Assigned(FOnStateChanged) then
    FOnStateChanged(Self);
end;

function TTileMatchGameViewModel.State: TTileMatchGameState;
begin
  Result := FModel.State;
end;

function TTileMatchGameViewModel.TileAt(
  const ATileIndex: Integer): TTileMatchTile;
begin
  Result := FModel.TileAt(ATileIndex);
end;

end.
