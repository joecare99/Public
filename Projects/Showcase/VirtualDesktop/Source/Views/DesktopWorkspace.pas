unit DesktopWorkspace;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, ExtCtrls, ComCtrls, StdCtrls, Graphics, DesktopWindow;

type
  TDesktopDockTarget = (ddNone, ddLeft, ddRight, ddTop, ddBottom, ddMaximize, ddTab);

  TDesktopWorkspace = class(TPanel)
  private
    FTabHost: TPageControl;
    FTaskStrip: TPanel;
    FActiveWindow: TDesktopWindow;
    procedure WindowActivated(Sender: TDesktopWindow);
    procedure WindowClosed(Sender: TDesktopWindow);
    procedure WindowMinimized(Sender: TDesktopWindow);
    procedure WindowUndockRequested(Sender: TDesktopWindow);
    procedure WindowDragFinished(Sender: TDesktopWindow);
    procedure RestoreTaskWindow(Sender: TObject);
    procedure RemoveTaskButton(const AWindow: TDesktopWindow);
    function DockTargetFor(const AWindow: TDesktopWindow): TDesktopDockTarget;
    procedure DockAsTab(const AWindow: TDesktopWindow);
  public
    constructor Create(AOwner: TComponent); override;
    function CreateWindow(const ATitle: string; AX, AY, AW, AH: Integer): TDesktopWindow;
    procedure ActivateWindow(const AWindow: TDesktopWindow);
    procedure SnapWindow(const AWindow: TDesktopWindow; const ATarget: TDesktopDockTarget);
    procedure RestoreWindow(const AWindow: TDesktopWindow);
    function WindowCount: Integer;
    property ActiveWindow: TDesktopWindow read FActiveWindow;
  end;

implementation

constructor TDesktopWorkspace.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BevelOuter := bvNone;
  Color := RGBToColor(24, 34, 54);
  FTabHost := TPageControl.Create(Self);
  FTabHost.Parent := Self;
  FTabHost.Visible := False;
  FTaskStrip := TPanel.Create(Self);
  FTaskStrip.Parent := Self;
  FTaskStrip.Align := alBottom;
  FTaskStrip.Height := 36;
  FTaskStrip.BevelOuter := bvNone;
  FTaskStrip.Color := RGBToColor(28, 40, 63);
end;

function TDesktopWorkspace.CreateWindow(const ATitle: string; AX, AY, AW, AH: Integer): TDesktopWindow;
begin
  Result := TDesktopWindow.Create(Self);
  Result.Parent := Self;
  Result.SetBounds(AX, AY, AW, AH);
  Result.Title := ATitle;
  Result.OnActivated := @WindowActivated;
  Result.OnClosed := @WindowClosed;
  Result.OnMinimized := @WindowMinimized;
  Result.OnDragFinished := @WindowDragFinished;
  Result.OnUndockRequested := @WindowUndockRequested;
  ActivateWindow(Result);
end;

procedure TDesktopWorkspace.ActivateWindow(const AWindow: TDesktopWindow);
begin
  if not Assigned(AWindow) then
    Exit;
  if Assigned(FActiveWindow) and (FActiveWindow <> AWindow) then
    FActiveWindow.Active := False;
  FActiveWindow := AWindow;
  FActiveWindow.Active := True;
  FActiveWindow.BringToFront;
end;

procedure TDesktopWorkspace.WindowActivated(Sender: TDesktopWindow);
begin
  ActivateWindow(Sender);
end;

procedure TDesktopWorkspace.WindowClosed(Sender: TDesktopWindow);
var
  Sheet: TTabSheet;
begin
  RemoveTaskButton(Sender);
  if FActiveWindow = Sender then
    FActiveWindow := nil;
  if Sender.Parent is TTabSheet then
  begin
    Sheet := TTabSheet(Sender.Parent);
    Sheet.Free;
    FTabHost.Visible := FTabHost.PageCount > 0;
  end;
  Sender.Free;
end;

procedure TDesktopWorkspace.WindowMinimized(Sender: TDesktopWindow);
var
  Button: TButton;
begin
  Button := TButton.Create(FTaskStrip);
  Button.Parent := FTaskStrip;
  Button.Left := FTaskStrip.ControlCount * 120;
  Button.Top := 3;
  Button.Width := 115;
  Button.Height := 30;
  Button.Caption := Sender.Title;
  Button.Tag := PtrInt(Sender);
  Button.OnClick := @RestoreTaskWindow;
end;

procedure TDesktopWorkspace.RemoveTaskButton(const AWindow: TDesktopWindow);
var
  Index: Integer;
begin
  for Index := FTaskStrip.ControlCount - 1 downto 0 do
    if FTaskStrip.Controls[Index].Tag = PtrInt(AWindow) then
      FTaskStrip.Controls[Index].Free;
end;

procedure TDesktopWorkspace.RestoreTaskWindow(Sender: TObject);
var
  Window: TDesktopWindow;
begin
  Window := TDesktopWindow(TButton(Sender).Tag);
  RemoveTaskButton(Window);
  RestoreWindow(Window);
end;

procedure TDesktopWorkspace.WindowUndockRequested(Sender: TDesktopWindow);
var
  Sheet: TTabSheet;
begin
  if not (Sender.Parent is TTabSheet) then
    Exit;
  Sheet := TTabSheet(Sender.Parent);
  Sender.Align := alNone;
  Sender.Parent := Self;
  Sender.SetBounds(80, 80, 360, 280);
  Sheet.Free;
  if FTabHost.PageCount = 0 then
    FTabHost.Visible := False;
end;

function TDesktopWorkspace.DockTargetFor(const AWindow: TDesktopWindow): TDesktopDockTarget;
const
  Margin = 36;
begin
  if (AWindow.Left < Margin) and (AWindow.Top < Margin) then
    Exit(ddTab);
  if AWindow.Left < Margin then
    Exit(ddLeft);
  if AWindow.Left + AWindow.Width > ClientWidth - Margin then
    Exit(ddRight);
  if AWindow.Top < Margin then
    Exit(ddTop);
  if AWindow.Top + AWindow.Height > ClientHeight - Margin then
    Exit(ddBottom);
  Result := ddNone;
end;

procedure TDesktopWorkspace.WindowDragFinished(Sender: TDesktopWindow);
begin
  SnapWindow(Sender, DockTargetFor(Sender));
end;

procedure TDesktopWorkspace.DockAsTab(const AWindow: TDesktopWindow);
var
  Sheet: TTabSheet;
begin
  if not FTabHost.Visible then begin
    FTabHost.SetBounds(0, 0, ClientWidth, ClientHeight);
    FTabHost.Visible := True;
  end;
  Sheet := TTabSheet.Create(FTabHost);
  Sheet.PageControl := FTabHost;
  Sheet.Caption := AWindow.Title;
  AWindow.Parent := Sheet;
  AWindow.Align := alClient;
  AWindow.BringToFront;
  FTabHost.ActivePage := Sheet;
  ActivateWindow(AWindow);
end;

procedure TDesktopWorkspace.SnapWindow(const AWindow: TDesktopWindow;
  const ATarget: TDesktopDockTarget);
begin
  if not Assigned(AWindow) then
    Exit;
  case ATarget of
    ddLeft: AWindow.SetBounds(0, 0, ClientWidth div 2, ClientHeight);
    ddRight: AWindow.SetBounds(ClientWidth div 2, 0, ClientWidth - (ClientWidth div 2), ClientHeight);
    ddTop: AWindow.SetBounds(0, 0, ClientWidth, ClientHeight div 2);
    ddBottom: AWindow.SetBounds(0, ClientHeight div 2, ClientWidth, ClientHeight - (ClientHeight div 2));
    ddMaximize: AWindow.SetBounds(0, 0, ClientWidth, ClientHeight);
    ddTab: DockAsTab(AWindow);
  end;
  ActivateWindow(AWindow);
end;

procedure TDesktopWorkspace.RestoreWindow(const AWindow: TDesktopWindow);
begin
  if not Assigned(AWindow) then
    Exit;
  if not AWindow.Visible then
    AWindow.Visible := True;
  ActivateWindow(AWindow);
end;

function TDesktopWorkspace.WindowCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ComponentCount - 1 do
    if (Components[I] is TDesktopWindow) and
       not (csDestroying in Components[I].ComponentState) then
      Inc(Result);
end;

end.
