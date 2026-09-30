unit DesktopWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, ExtCtrls, StdCtrls, ComCtrls, Graphics, Types, Math;

type
  TDesktopWindow = class;
  TDesktopWindowEvent = procedure(Sender: TDesktopWindow) of object;

  TDesktopWindow = class(TPanel)
  private
    FHeaderBar: TPanel;
    FClientArea: TPanel;
    FTitleLabel: TLabel;
    FMinimizeButton: TButton;
    FCloseButton: TButton;
    FResizeGrip: TPanel;
    FDragStart: TPoint;
    FResizeStart: TPoint;
    FResizeBounds: TRect;
    FBoundsBeforeMaximize: TRect;
    FDragging: Boolean;
    FResizing: Boolean;
    FClosing: Boolean;
    FMaximized: Boolean;
    FOnActivated: TDesktopWindowEvent;
    FOnClosing: TDesktopWindowEvent;
    FOnClosed: TDesktopWindowEvent;
    FOnMinimized: TDesktopWindowEvent;
    FOnDragFinished: TDesktopWindowEvent;
    FOnUndockRequested: TDesktopWindowEvent;
    procedure HeaderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure HeaderMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HeaderDblClick(Sender: TObject);
    procedure MinimizeClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure ResizeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ResizeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ResizeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetActive(const AValue: Boolean);
    function GetTitle: string;
    procedure SetTitle(const AValue: string);
    procedure ClampToParent;
  public
    constructor Create(AOwner: TComponent); override;
    procedure MaximizeOrRestore;
    procedure RestoreFloatingBounds;
    procedure CloseWindow;
    property ClientArea: TPanel read FClientArea;
    property Title: string read GetTitle write SetTitle;
    property OnActivated: TDesktopWindowEvent read FOnActivated write FOnActivated;
    property OnClosing: TDesktopWindowEvent read FOnClosing write FOnClosing;
    property OnClosed: TDesktopWindowEvent read FOnClosed write FOnClosed;
    property OnMinimized: TDesktopWindowEvent read FOnMinimized write FOnMinimized;
    property OnDragFinished: TDesktopWindowEvent read FOnDragFinished write FOnDragFinished;
    property OnUndockRequested: TDesktopWindowEvent read FOnUndockRequested write FOnUndockRequested;
    property Active: Boolean write SetActive;
  end;

implementation

constructor TDesktopWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BevelOuter := bvRaised;
  Color := RGBToColor(242, 246, 252);
  Caption := '';
  Width := 360;
  Height := 280;

  FHeaderBar := TPanel.Create(Self);
  FHeaderBar.Parent := Self;
  FHeaderBar.Align := alTop;
  FHeaderBar.Height := 34;
  FHeaderBar.BevelOuter := bvNone;
  FHeaderBar.Color := RGBToColor(37, 59, 91);
  FHeaderBar.OnMouseDown := @HeaderMouseDown;
  FHeaderBar.OnMouseMove := @HeaderMouseMove;
  FHeaderBar.OnMouseUp := @HeaderMouseUp;
  FHeaderBar.OnDblClick := @HeaderDblClick;

  FTitleLabel := TLabel.Create(Self);
  FTitleLabel.Parent := FHeaderBar;
  FTitleLabel.SetBounds(10, 8, 230, 20);
  FTitleLabel.Font.Color := clWhite;
  FTitleLabel.Font.Style := [fsBold];
  FTitleLabel.OnMouseDown := @HeaderMouseDown;
  FTitleLabel.OnMouseMove := @HeaderMouseMove;
  FTitleLabel.OnMouseUp := @HeaderMouseUp;
  FTitleLabel.OnDblClick := @HeaderDblClick;

  FMinimizeButton := TButton.Create(Self);
  FMinimizeButton.Parent := FHeaderBar;
  FMinimizeButton.SetBounds(Width - 92, 3, 28, 27);
  FMinimizeButton.Anchors := [akTop, akRight];
  FMinimizeButton.Caption := '_';
  FMinimizeButton.OnClick := @MinimizeClick;

  FCloseButton := TButton.Create(Self);
  FCloseButton.Parent := Self;
  FCloseButton.SetBounds(Width - 58, 3, 52, 27);
  FCloseButton.Anchors := [akTop, akRight];
  FCloseButton.Caption := 'Close';
  FCloseButton.Font.Style := [fsBold];
  FCloseButton.Font.Color := clMaroon;
  FCloseButton.Hint := 'Close window';
  FCloseButton.ShowHint := True;
  FCloseButton.OnClick := @CloseClick;
  FCloseButton.BringToFront;

  FClientArea := TPanel.Create(Self);
  FClientArea.Parent := Self;
  FClientArea.Align := alClient;
  FClientArea.BevelOuter := bvNone;
  FClientArea.Color := Color;

  FResizeGrip := TPanel.Create(Self);
  FResizeGrip.Parent := Self;
  FResizeGrip.Align := alBottom;
  FResizeGrip.Height := 8;
  FResizeGrip.BevelOuter := bvNone;
  FResizeGrip.Cursor := crSizeNWSE;
  FResizeGrip.OnMouseDown := @ResizeMouseDown;
  FResizeGrip.OnMouseMove := @ResizeMouseMove;
  FResizeGrip.OnMouseUp := @ResizeMouseUp;
end;

procedure TDesktopWindow.SetTitle(const AValue: string);
begin
  FTitleLabel.Caption := AValue;
end;

function TDesktopWindow.GetTitle: string;
begin
  Result := FTitleLabel.Caption;
end;

procedure TDesktopWindow.SetActive(const AValue: Boolean);
begin
  if AValue then
    FHeaderBar.Color := RGBToColor(45, 102, 164)
  else
    FHeaderBar.Color := RGBToColor(37, 59, 91);
end;

procedure TDesktopWindow.HeaderMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then
    Exit;
  if Assigned(FOnActivated) then
    FOnActivated(Self);
  if Assigned(FOnUndockRequested) and (Parent is TTabSheet) then
    FOnUndockRequested(Self);
  if FMaximized then
    Exit;
  FDragging := True;
  FDragStart := FHeaderBar.ScreenToClient(Mouse.CursorPos);
  Mouse.Capture := FHeaderBar.Handle;
end;

procedure TDesktopWindow.HeaderMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Current: TPoint;
begin
  if not FDragging then
    Exit;
  Current := FHeaderBar.ScreenToClient(Mouse.CursorPos);
  Left := Left + Current.X - FDragStart.X;
  Top := Top + Current.Y - FDragStart.Y;
  ClampToParent;
end;

procedure TDesktopWindow.HeaderMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FDragging then
    Exit;
  FDragging := False;
  Mouse.Capture := 0;
  if Assigned(FOnDragFinished) then
    FOnDragFinished(Self);
end;

procedure TDesktopWindow.HeaderDblClick(Sender: TObject);
begin
  MaximizeOrRestore;
end;

procedure TDesktopWindow.MinimizeClick(Sender: TObject);
begin
  Visible := False;
  if Assigned(FOnMinimized) then
    FOnMinimized(Self);
end;

procedure TDesktopWindow.CloseClick(Sender: TObject);
begin
  CloseWindow;
end;

procedure TDesktopWindow.CloseWindow;
begin
  if FClosing then
    Exit;
  FClosing := True;
  if Assigned(FOnClosing) then
    FOnClosing(Self);
  if Assigned(FOnClosed) then
    FOnClosed(Self)
  else
    Free;
end;

procedure TDesktopWindow.ResizeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button <> mbLeft) or FMaximized then
    Exit;
  if Assigned(FOnActivated) then
    FOnActivated(Self);
  FResizing := True;
  FResizeStart := Mouse.CursorPos;
  FResizeBounds := BoundsRect;
  Mouse.Capture := FResizeGrip.Handle;
end;

procedure TDesktopWindow.ResizeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Current: TPoint;
  NewWidth, NewHeight: Integer;
begin
  if not FResizing then
    Exit;
  Current := Mouse.CursorPos;
  NewWidth := FResizeBounds.Width + Current.X - FResizeStart.X;
  NewHeight := FResizeBounds.Height + Current.Y - FResizeStart.Y;
  SetBounds(FResizeBounds.Left, FResizeBounds.Top,
    Max(220, NewWidth), Max(120, NewHeight));
  ClampToParent;
end;

procedure TDesktopWindow.ResizeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FResizing then
    Exit;
  FResizing := False;
  Mouse.Capture := 0;
end;

procedure TDesktopWindow.ClampToParent;
begin
  if not Assigned(Parent) then
    Exit;
  Left := EnsureRange(Left, 0, Max(0, Parent.ClientWidth - Width));
  Top := EnsureRange(Top, 0, Max(0, Parent.ClientHeight - Height));
end;

procedure TDesktopWindow.MaximizeOrRestore;
begin
  if not Assigned(Parent) then
    Exit;
  if FMaximized then begin
    BoundsRect := FBoundsBeforeMaximize;
    FMaximized := False;
    ClampToParent;
  end else begin
    FBoundsBeforeMaximize := BoundsRect;
    SetBounds(0, 0, Parent.ClientWidth, Parent.ClientHeight);
    FMaximized := True;
  end;
end;

procedure TDesktopWindow.RestoreFloatingBounds;
begin
  FMaximized := False;
  ClampToParent;
end;

end.
