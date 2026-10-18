unit OrbitDodgerView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, Controls, StdCtrls, ExtCtrls, Graphics, Dialogs,
  DesktopWindow,
  OrbitDodgerGameViewModel, OrbitDodgerTypes;

type
  TOrbitDodgerView = class
  private
    FViewModel: TOrbitDodgerGameViewModel;
    FWindow: TDesktopWindow;
    FStatus: TLabel;
    FArena: TPaintBox;
    FTimer: TTimer;
    procedure Refresh(Sender: TObject);
    procedure Tick(Sender: TObject);
    procedure MoveIn(Sender: TObject);
    procedure MoveOut(Sender: TObject);
    procedure Restart(Sender: TObject);
    procedure ShowHelp(Sender: TObject);
    procedure WindowClosing(Sender: TDesktopWindow);
    procedure PaintArena(Sender: TObject);
  public
    constructor Create(AWindow: TDesktopWindow;
      AViewModel: TOrbitDodgerGameViewModel);
    destructor Destroy; override;
    function IsOpen: Boolean;
  end;

implementation

constructor TOrbitDodgerView.Create(AWindow: TDesktopWindow;
  AViewModel: TOrbitDodgerGameViewModel);
var
  InButton, OutButton, RestartButton, HelpButton: TButton;
begin
  if not Assigned(AWindow) or not Assigned(AViewModel) then
    raise EArgumentNilException.Create('Orbit Dodger view dependencies required.');
  inherited Create;
  FWindow := AWindow;
  FViewModel := AViewModel;
  FStatus := TLabel.Create(FWindow.ClientArea);
  FStatus.Parent := FWindow.ClientArea;
  FStatus.Align := alTop;
  FStatus.Height := 42;
  FStatus.Alignment := taCenter;
  FArena := TPaintBox.Create(FWindow.ClientArea);
  FArena.Parent := FWindow.ClientArea;
  FArena.Align := alClient;
  FArena.OnPaint := @PaintArena;
  InButton := TButton.Create(FWindow.ClientArea);
  InButton.Parent := FWindow.ClientArea;
  InButton.Align := alLeft;
  InButton.Width := 110;
  InButton.Caption := 'Move inward';
  InButton.OnClick := @MoveIn;
  OutButton := TButton.Create(FWindow.ClientArea);
  OutButton.Parent := FWindow.ClientArea;
  OutButton.Align := alRight;
  OutButton.Width := 110;
  OutButton.Caption := 'Move outward';
  OutButton.OnClick := @MoveOut;
  RestartButton := TButton.Create(FWindow.ClientArea);
  RestartButton.Parent := FWindow.ClientArea;
  RestartButton.Align := alBottom;
  RestartButton.Height := 34;
  RestartButton.Caption := 'Restart';
  RestartButton.OnClick := @Restart;
  HelpButton := TButton.Create(FWindow.ClientArea);
  HelpButton.Parent := FWindow.ClientArea;
  HelpButton.Align := alBottom;
  HelpButton.Height := 34;
  HelpButton.Caption := 'Help';
  HelpButton.OnClick := @ShowHelp;
  FViewModel.OnStateChanged := @Refresh;
  FWindow.OnClosing := @WindowClosing;
  FTimer := TTimer.Create(FWindow);
  FTimer.Interval := 100;
  FTimer.OnTimer := @Tick;
  FTimer.Enabled := True;
  Refresh(Self);
end;

destructor TOrbitDodgerView.Destroy;
begin
  FTimer.Free;
  inherited Destroy;
end;

function TOrbitDodgerView.IsOpen: Boolean;
begin
  Result := Assigned(FWindow);
end;

procedure TOrbitDodgerView.Refresh(Sender: TObject);
var
  State: TOrbitDodgerGameState;
begin
  State := FViewModel.State;
  FStatus.Caption := Format('Orbit Dodger  Score: %d  Lives: %d  Orbit: %d/%d',
    [State.Score, State.Lives, State.PlayerOrbit + 1, State.OrbitCount]);
  if Assigned(FArena) then
    FArena.Invalidate;
end;

procedure TOrbitDodgerView.Tick(Sender: TObject);
begin
  FViewModel.Tick;
end;

procedure TOrbitDodgerView.MoveIn(Sender: TObject);
begin
  FViewModel.Move(odmInward);
end;

procedure TOrbitDodgerView.MoveOut(Sender: TObject);
begin
  FViewModel.Move(odmOutward);
end;

procedure TOrbitDodgerView.Restart(Sender: TObject);
begin
  FViewModel.Restart;
end;

procedure TOrbitDodgerView.ShowHelp(Sender: TObject);
begin
  ShowMessage(
    'Orbit Dodger' + LineEnding +
    'Move inward or outward to avoid incoming obstacles.' + LineEnding +
    'A missed obstacle scores; an obstacle on your orbit costs a life.' +
    LineEnding + 'Survive as long as possible.');
end;

procedure TOrbitDodgerView.WindowClosing(Sender: TDesktopWindow);
begin
  if Assigned(FTimer) then
    FTimer.Enabled := False;
  FTimer := nil;
  FArena := nil;
  FWindow := nil;
end;

procedure TOrbitDodgerView.PaintArena(Sender: TObject);
var
  Box: TPaintBox;
  State: TOrbitDodgerGameState;
  I: Integer;
  Obstacle: TOrbitDodgerObstacle;
  CenterX, CenterY, InnerRadius, OuterRadius, Radius: Integer;
  Angle: Double;
begin
  Box := TPaintBox(Sender);
  State := FViewModel.State;
  CenterX := Box.Width div 2;
  CenterY := Box.Height div 2;
  OuterRadius := (Min(Box.Width, Box.Height) div 2) - 12;
  InnerRadius := Max(18, OuterRadius div 3);
  Box.Canvas.Brush.Color := RGBToColor(231, 239, 250);
  Box.Canvas.FillRect(Box.ClientRect);
  Box.Canvas.Pen.Width := 2;
  for I := 0 to State.OrbitCount - 1 do
  begin
    Radius := InnerRadius + ((OuterRadius - InnerRadius) * I) div
      Max(1, State.OrbitCount - 1);
    Box.Canvas.Pen.Color := RGBToColor(137, 164, 198);
    Box.Canvas.Brush.Style := bsClear;
    Box.Canvas.Ellipse(CenterX - Radius, CenterY - Radius,
      CenterX + Radius, CenterY + Radius);
  end;
  Box.Canvas.Brush.Style := bsSolid;
  Radius := InnerRadius + ((OuterRadius - InnerRadius) * State.PlayerOrbit) div
    Max(1, State.OrbitCount - 1);
  Box.Canvas.Brush.Color := RGBToColor(55, 145, 105);
  Box.Canvas.Pen.Color := RGBToColor(37, 90, 70);
  Box.Canvas.Ellipse(CenterX - 8, CenterY - Radius - 8,
    CenterX + 8, CenterY - Radius + 8);
  for I := 0 to State.ObstacleCount - 1 do
  begin
    Obstacle := FViewModel.ObstacleAt(I);
    Radius := InnerRadius + ((OuterRadius - InnerRadius) *
      (1000 - Obstacle.Distance)) div 1000;
    Angle := (2 * Pi * Obstacle.OrbitIndex) / Max(1, State.OrbitCount);
    Box.Canvas.Brush.Color := RGBToColor(205, 91, 81);
    Box.Canvas.Pen.Color := RGBToColor(145, 50, 45);
    Box.Canvas.Ellipse(
      CenterX + Round(Sin(Angle) * Radius) - 7,
      CenterY - Round(Cos(Angle) * Radius) - 7,
      CenterX + Round(Sin(Angle) * Radius) + 7,
      CenterY - Round(Cos(Angle) * Radius) + 7);
  end;
end;

end.
