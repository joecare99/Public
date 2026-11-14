unit cls_fv2application;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_fv2controls, cls_fv2forms, cls_fv2canvas;

type
  TFvApplicationIdleEvent = procedure(Sender: TObject) of object;
  TFvApplicationWaitEvent = procedure(Sender: TObject) of object;
  TFvApplicationPollEvent = procedure(Sender: TObject; out Event: TFvEvent) of object;
  TFvApplicationRenderEvent = procedure(Sender: TObject;
    ACanvas: TFvCanvas) of object;
  TFvQueuedEvent = record
    Target: TControl;
    Event: TFvEvent;
  end;

  TFvApplication = class(TComponent)
  private
    FEventQueue: array of TFvQueuedEvent;
    FQueueHead: Integer;
    FMainForm: TForm;
    FCanvas: TFvCanvas;
    FRunning: Boolean;
    FTerminated: Boolean;
    FOnIdle: TFvApplicationIdleEvent;
    FOnWaitForEvent: TFvApplicationWaitEvent;
    FOnPollEvent: TFvApplicationPollEvent;
    FOnRender: TFvApplicationRenderEvent;
    procedure SetMainForm(AValue: TForm);
    procedure FormInvalidated(Sender: TObject);
    procedure Render;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize; virtual;
    function CreateForm(AFormClass: TFvControlClass): TControl; virtual;
    procedure PostEvent(ATarget: TControl; const AEvent: TFvEvent);
    function PollEvents: Integer;
    procedure PushEvent(ATarget: TControl; const AEvent: TFvEvent);
    function ProcessEvents: Integer;
    procedure Run; virtual;
    procedure Terminate;
    property MainForm: TForm read FMainForm write SetMainForm;
    property Canvas: TFvCanvas read FCanvas;
    property Running: Boolean read FRunning;
    property Terminated: Boolean read FTerminated;
    property OnIdle: TFvApplicationIdleEvent read FOnIdle write FOnIdle;
    property OnWaitForEvent: TFvApplicationWaitEvent read FOnWaitForEvent
      write FOnWaitForEvent;
    property OnPollEvent: TFvApplicationPollEvent read FOnPollEvent
      write FOnPollEvent;
    property OnRender: TFvApplicationRenderEvent read FOnRender write FOnRender;
  end;

var
  Application: TFvApplication;
  RequireDerivedFormResource: Boolean = True;

implementation

constructor TFvApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TFvCanvas.Create(80, 25);
end;

destructor TFvApplication.Destroy;
begin
  FMainForm := nil;
  FreeAndNil(FCanvas);
  inherited Destroy;
end;

procedure TFvApplication.Initialize;
begin
  FTerminated := False;
  FQueueHead := 0;
  SetLength(FEventQueue, 0);
end;

function TFvApplication.CreateForm(AFormClass: TFvControlClass): TControl;
begin
  if not Assigned(AFormClass) then
    raise EArgumentNilException.Create('AFormClass');
  Result := AFormClass.Create(Self);
  if Result is TForm then
  begin
    TForm(Result).OnInvalidate := @FormInvalidated;
    if not Assigned(FMainForm) then
      MainForm := TForm(Result);
  end;
end;

procedure TFvApplication.SetMainForm(AValue: TForm);
begin
  if FMainForm = AValue then
    Exit;
  FMainForm := AValue;
  if Assigned(FMainForm) then
    FMainForm.OnInvalidate := @FormInvalidated;
end;

procedure TFvApplication.FormInvalidated(Sender: TObject);
begin
  Render;
end;

procedure TFvApplication.Render;
begin
  if not Assigned(FMainForm) or not FMainForm.Shown then
    Exit;
  FCanvas.Clear;
  FMainForm.Paint(FCanvas);
  if Assigned(FOnRender) then
    FOnRender(Self, FCanvas);
end;

procedure TFvApplication.PostEvent(ATarget: TControl;
  const AEvent: TFvEvent);
var
  LLength: Integer;
begin
  if FQueueHead >= Length(FEventQueue) then
  begin
    SetLength(FEventQueue, 1);
    FQueueHead := 0;
    LLength := 0;
  end
  else
    LLength := Length(FEventQueue);
  SetLength(FEventQueue, LLength + 1);
  FEventQueue[LLength].Target := ATarget;
  FEventQueue[LLength].Event := AEvent;
end;

procedure TFvApplication.PushEvent(ATarget: TControl;
  const AEvent: TFvEvent);
var
  I: Integer;
begin
  if FQueueHead >= Length(FEventQueue) then
  begin
    SetLength(FEventQueue, 1);
    FQueueHead := 0;
  end
  else
  begin
    SetLength(FEventQueue, Length(FEventQueue) + 1);
    for I := High(FEventQueue) downto FQueueHead + 1 do
      FEventQueue[I] := FEventQueue[I - 1];
  end;
  FEventQueue[FQueueHead].Target := ATarget;
  FEventQueue[FQueueHead].Event := AEvent;
end;

function TFvApplication.PollEvents: Integer;
var
  Event: TFvEvent;
begin
  Result := 0;
  if not Assigned(FOnPollEvent) then
    Exit;
  while not FTerminated do
  begin
    Event := Default(TFvEvent);
    FOnPollEvent(Self, Event);
    if Event.EventType = feNone then
      Break;
    PostEvent(nil, Event);
    Inc(Result);
  end;
end;

function TFvApplication.ProcessEvents: Integer;
var
  LQueuedEvent: TFvQueuedEvent;
begin
  Result := 0;
  while (FQueueHead < Length(FEventQueue)) and not FTerminated do
  begin
    LQueuedEvent := FEventQueue[FQueueHead];
    Inc(FQueueHead);
    if Assigned(LQueuedEvent.Target) then
      LQueuedEvent.Target.PostEvent(LQueuedEvent.Event)
    else if Assigned(FMainForm) then
      FMainForm.PostEvent(LQueuedEvent.Event);
    Inc(Result);
  end;
  if FQueueHead >= Length(FEventQueue) then
  begin
    SetLength(FEventQueue, 0);
    FQueueHead := 0;
  end;
end;

procedure TFvApplication.Run;
begin
  if FRunning then
    raise EInvalidOperation.Create('The application is already running.');
  FRunning := True;
  FTerminated := False;
  try
    if Assigned(FMainForm) then
      FMainForm.Show;
    while not FTerminated do
    begin
      PollEvents;
      ProcessEvents;
      if (FQueueHead >= Length(FEventQueue)) and Assigned(FOnWaitForEvent) and
         not FTerminated then
        FOnWaitForEvent(Self);
      if (FQueueHead >= Length(FEventQueue)) and Assigned(FOnIdle) and
         not FTerminated then
        FOnIdle(Self)
      else if (FQueueHead >= Length(FEventQueue)) and
         not Assigned(FOnWaitForEvent) then
        Terminate;
    end;
  finally
    FRunning := False;
  end;
end;

procedure TFvApplication.Terminate;
begin
  FTerminated := True;
end;

initialization
  Application := TFvApplication.Create(nil);

finalization
  FreeAndNil(Application);

end.
