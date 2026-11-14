unit cls_fv2controls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, cls_fv2canvas;

type
  TFvEventType = (feNone, feKey, feMouse, feCommand, fePaint, feQuit);

  TFvEvent = record
    EventType: TFvEventType;
    Code: Integer;
    X: Integer;
    Y: Integer;
    Text: string;
    Data: Pointer;
  end;

  TFvEventHandler = procedure(Sender: TObject; var Event: TFvEvent) of object;

  TControl = class(TComponent)
  private
    FChildren: TFPList;
    FParent: TControl;
    FBounds: TRect;
    FVisible: Boolean;
    FEnabled: Boolean;
    FOnEvent: TFvEventHandler;
    FOnInvalidate: TNotifyEvent;
    function GetChildCount: Integer;
    function GetChildControl(Index: Integer): TControl;
    procedure SetBounds(const AValue: TRect);
    procedure SetParent(AValue: TControl);
    procedure SetVisible(AValue: Boolean);
    procedure SetEnabled(AValue: Boolean);
  protected
    procedure DispatchEvent(var Event: TFvEvent); virtual;
    procedure DrawSelf(ACanvas: TFvCanvas); virtual;
    procedure ChildEvent(Sender: TObject; var Event: TFvEvent); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddControl(AControl: TControl);
    procedure RemoveControl(AControl: TControl);
    procedure PostEvent(var Event: TFvEvent); virtual;
    procedure HandleEvent(var Event: TFvEvent); virtual;
    procedure BroadcastEvent(var Event: TFvEvent); virtual;
    procedure Invalidate; virtual;
    procedure Paint(ACanvas: TFvCanvas); virtual;
    function ControlAt(X, Y: Integer): TControl;
    property Bounds: TRect read FBounds write SetBounds;
    property Parent: TControl read FParent write SetParent;
    property ControlCount: Integer read GetChildCount;
    property Controls[Index: Integer]: TControl read GetChildControl;
    property Visible: Boolean read FVisible write SetVisible;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property OnEvent: TFvEventHandler read FOnEvent write FOnEvent;
    property OnInvalidate: TNotifyEvent read FOnInvalidate write FOnInvalidate;
  end;

  TFvControlClass = class of TControl;

implementation

constructor TControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FChildren := TFPList.Create;
  FBounds := Rect(0, 0, 0, 0);
  FVisible := True;
  FEnabled := True;
end;

destructor TControl.Destroy;
begin
  SetParent(nil);
  while FChildren.Count > 0 do
    RemoveControl(TControl(FChildren[FChildren.Count - 1]));
  FreeAndNil(FChildren);
  inherited Destroy;
end;

function TControl.GetChildCount: Integer;
begin
  Result := FChildren.Count;
end;

function TControl.GetChildControl(Index: Integer): TControl;
begin
  Result := TControl(FChildren[Index]);
end;

procedure TControl.SetBounds(const AValue: TRect);
begin
  if (FBounds.Left = AValue.Left) and (FBounds.Top = AValue.Top) and
     (FBounds.Right = AValue.Right) and (FBounds.Bottom = AValue.Bottom) then
    Exit;
  FBounds := AValue;
  Invalidate;
end;

procedure TControl.SetParent(AValue: TControl);
var
  LAncestor: TControl;
begin
  if FParent = AValue then
    Exit;
  if AValue = Self then
    raise EInvalidOperation.Create('A control cannot be its own parent.');
  LAncestor := AValue;
  while Assigned(LAncestor) do
  begin
    if LAncestor = Self then
      raise EInvalidOperation.Create('A control hierarchy cannot contain a cycle.');
    LAncestor := LAncestor.Parent;
  end;
  if Assigned(FParent) then
    FParent.RemoveControl(Self);
  if Assigned(AValue) then
  begin
    FParent := AValue;
    AValue.FChildren.Add(Self);
  end;
  Invalidate;
end;

procedure TControl.SetVisible(AValue: Boolean);
begin
  if FVisible = AValue then
    Exit;
  FVisible := AValue;
  Invalidate;
end;

procedure TControl.SetEnabled(AValue: Boolean);
begin
  FEnabled := AValue;
end;

procedure TControl.AddControl(AControl: TControl);
begin
  if not Assigned(AControl) then
    raise EArgumentNilException.Create('AControl');
  if AControl = Self then
    raise EInvalidOperation.Create('A control cannot contain itself.');
  AControl.Parent := Self;
end;

procedure TControl.RemoveControl(AControl: TControl);
begin
  if not Assigned(AControl) then
    Exit;
  if FChildren.Remove(AControl) >= 0 then
  begin
    AControl.FParent := nil;
    Invalidate;
  end;
end;

procedure TControl.PostEvent(var Event: TFvEvent);
var
  I: Integer;
begin
  if not FVisible or not FEnabled or (Event.EventType = feNone) then
    Exit;
  HandleEvent(Event);
  for I := FChildren.Count - 1 downto 0 do
  begin
    TControl(FChildren[I]).PostEvent(Event);
    if Event.EventType = feNone then
      Exit;
  end;
end;

procedure TControl.HandleEvent(var Event: TFvEvent);
begin
  DispatchEvent(Event);
end;

procedure TControl.BroadcastEvent(var Event: TFvEvent);
var
  I: Integer;
begin
  if not FVisible then
    Exit;
  HandleEvent(Event);
  for I := 0 to FChildren.Count - 1 do
  begin
    TControl(FChildren[I]).BroadcastEvent(Event);
    if Event.EventType = feNone then
      Exit;
  end;
end;

procedure TControl.Invalidate;
begin
  if Assigned(FOnInvalidate) then
    FOnInvalidate(Self)
  else if Assigned(FParent) then
    FParent.Invalidate;
end;

procedure TControl.DispatchEvent(var Event: TFvEvent);
begin
  if Assigned(FOnEvent) then
    FOnEvent(Self, Event);
end;

procedure TControl.ChildEvent(Sender: TObject; var Event: TFvEvent);
begin
  DispatchEvent(Event);
end;

procedure TControl.Paint(ACanvas: TFvCanvas);
var
  I: Integer;
begin
  if not FVisible or not Assigned(ACanvas) then
    Exit;
  ACanvas.PushOrigin(FBounds.Left, FBounds.Top, Rect(0, 0,
    FBounds.Right - FBounds.Left, FBounds.Bottom - FBounds.Top));
  try
    DrawSelf(ACanvas);
    for I := 0 to FChildren.Count - 1 do
      TControl(FChildren[I]).Paint(ACanvas);
  finally
    ACanvas.PopOrigin;
  end;
end;

procedure TControl.DrawSelf(ACanvas: TFvCanvas);
begin
end;

function TControl.ControlAt(X, Y: Integer): TControl;
var
  I: Integer;
  LChild: TControl;
begin
  Result := nil;
  if not FVisible or not PtInRect(FBounds, Point(X, Y)) then
    Exit;
  for I := FChildren.Count - 1 downto 0 do
  begin
    LChild := TControl(FChildren[I]).ControlAt(X - FBounds.Left, Y - FBounds.Top);
    if Assigned(LChild) then
      Exit(LChild);
  end;
  Result := Self;
end;

end.
