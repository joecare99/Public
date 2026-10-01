unit TileMatchView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, StdCtrls, ExtCtrls, Graphics, DesktopWindow,
  TileMatchGameViewModel, TileMatchTypes;

type
  TTileMatchView = class
  private
    FViewModel: TTileMatchGameViewModel;
    FWindow: TDesktopWindow;
    FStatus: TLabel;
    FGrid: TPanel;
    FTimer: TTimer;
    FFlipFrames: array[0..15] of Integer;
    procedure Refresh(Sender: TObject);
    procedure Tick(Sender: TObject);
    procedure TileClick(Sender: TObject);
    procedure Restart(Sender: TObject);
    procedure WindowClosing(Sender: TDesktopWindow);
    procedure RenderTile(const AIndex: Integer);
  public
    constructor Create(AWindow: TDesktopWindow;
      AViewModel: TTileMatchGameViewModel);
    destructor Destroy; override;
    function IsOpen: Boolean;
  end;

implementation

constructor TTileMatchView.Create(AWindow: TDesktopWindow;
  AViewModel: TTileMatchGameViewModel);
var
  I: Integer;
  TileButton: TButton;
  RestartButton: TButton;
begin
  if not Assigned(AWindow) or not Assigned(AViewModel) then
    raise EArgumentNilException.Create('Tile Match view dependencies required.');
  inherited Create;
  FWindow := AWindow;
  FViewModel := AViewModel;
  FStatus := TLabel.Create(FWindow.ClientArea);
  FStatus.Parent := FWindow.ClientArea;
  FStatus.Align := alTop;
  FStatus.Height := 34;
  FStatus.Alignment := taCenter;
  FGrid := TPanel.Create(FWindow.ClientArea);
  FGrid.Parent := FWindow.ClientArea;
  FGrid.Align := alClient;
  for I := 0 to 15 do
  begin
    TileButton := TButton.Create(FGrid);
    TileButton.Parent := FGrid;
    TileButton.SetBounds((I mod 4) * 88, (I div 4) * 62, 82, 56);
    TileButton.Tag := I;
    TileButton.Caption := '?';
    TileButton.Font.Size := 18;
    TileButton.Font.Style := [fsBold];
    TileButton.OnClick := @TileClick;
    FFlipFrames[I] := 0;
  end;
  RestartButton := TButton.Create(FWindow.ClientArea);
  RestartButton.Parent := FWindow.ClientArea;
  RestartButton.Align := alBottom;
  RestartButton.Height := 32;
  RestartButton.Caption := 'Restart';
  RestartButton.OnClick := @Restart;
  FViewModel.OnStateChanged := @Refresh;
  FWindow.OnClosing := @WindowClosing;
  FTimer := TTimer.Create(FWindow);
  FTimer.Interval := 100;
  FTimer.OnTimer := @Tick;
  FTimer.Enabled := True;
  Refresh(Self);
end;

destructor TTileMatchView.Destroy;
begin
  FTimer.Free;
  inherited Destroy;
end;

procedure TTileMatchView.Refresh(Sender: TObject);
var
  I: Integer;
  Tile: TTileMatchTile;
  State: TTileMatchGameState;
begin
  State := FViewModel.State;
  FStatus.Caption := Format('Tile Match  Pairs: %d  Attempts: %d',
    [State.MatchedPairCount, State.AttemptCount]);
  for I := 0 to FGrid.ControlCount - 1 do
  begin
    Tile := FViewModel.TileAt(I);
    if Tile.State = tmtsHidden then
      FFlipFrames[I] := 0
    else if FFlipFrames[I] = 0 then
      FFlipFrames[I] := 3;
    RenderTile(I);
  end;
end;

procedure TTileMatchView.Tick(Sender: TObject);
var
  I: Integer;
begin
  FViewModel.Tick;
  for I := 0 to High(FFlipFrames) do
    if FFlipFrames[I] > 0 then
    begin
      Dec(FFlipFrames[I]);
      RenderTile(I);
    end;
end;

procedure TTileMatchView.TileClick(Sender: TObject);
begin
  FViewModel.SelectTile(TButton(Sender).Tag);
end;

procedure TTileMatchView.Restart(Sender: TObject);
begin
  FViewModel.Restart;
end;

procedure TTileMatchView.WindowClosing(Sender: TDesktopWindow);
begin
  if Assigned(FTimer) then
    FTimer.Enabled := False;
  FTimer := nil;
  FWindow := nil;
end;

procedure TTileMatchView.RenderTile(const AIndex: Integer);
var
  Tile: TTileMatchTile;
  Button: TButton;
begin
  if not Assigned(FGrid) or (AIndex < 0) or (AIndex >= FGrid.ControlCount) then
    Exit;
  Tile := FViewModel.TileAt(AIndex);
  Button := TButton(FGrid.Controls[AIndex]);
  if Tile.State = tmtsHidden then
  begin
    Button.Caption := '?';
    Button.Font.Color := clNavy;
  end
  else if FFlipFrames[AIndex] >= 2 then
  begin
    Button.Caption := '|';
    Button.Font.Color := clGray;
  end
  else
  begin
    Button.Caption := IntToStr(Tile.Value);
    if Tile.State = tmtsMatched then
      Button.Font.Color := clGreen
    else
      Button.Font.Color := clNavy;
  end;
end;

function TTileMatchView.IsOpen: Boolean;
begin
  Result := Assigned(FWindow);
end;

end.
