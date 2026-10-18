unit cls_fv2messages;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_fv2controls;

type
  TFvMessageHandler = procedure(Sender: TObject; Command: Word; Data: Pointer) of object;

  TFvMessageBus = class
  private
    FTargets: TFPList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterTarget(ATarget: TControl);
    procedure UnregisterTarget(ATarget: TControl);
    procedure Send(ATarget: TControl; Command: Word; Data: Pointer = nil);
    procedure Broadcast(Command: Word; Data: Pointer = nil);
  end;

implementation

type
  TFvMessageControl = class(TControl)
  private
    FMessageHandler: TFvMessageHandler;
  public
    property MessageHandler: TFvMessageHandler read FMessageHandler
      write FMessageHandler;
  end;

constructor TFvMessageBus.Create;
begin
  inherited Create;
  FTargets := TFPList.Create;
end;

destructor TFvMessageBus.Destroy;
begin
  FreeAndNil(FTargets);
  inherited Destroy;
end;

procedure TFvMessageBus.RegisterTarget(ATarget: TControl);
begin
  if not Assigned(ATarget) then
    raise EArgumentNilException.Create('ATarget');
  if FTargets.IndexOf(ATarget) < 0 then
    FTargets.Add(ATarget);
end;

procedure TFvMessageBus.UnregisterTarget(ATarget: TControl);
begin
  FTargets.Remove(ATarget);
end;

procedure TFvMessageBus.Send(ATarget: TControl; Command: Word; Data: Pointer);
var
  Event: TFvEvent;
begin
  if not Assigned(ATarget) then
    Exit;
  Event := Default(TFvEvent);
  Event.EventType := feCommand;
  Event.Code := Command;
  Event.Data := Data;
  ATarget.BroadcastEvent(Event);
end;

procedure TFvMessageBus.Broadcast(Command: Word; Data: Pointer);
var
  I: Integer;
begin
  for I := 0 to FTargets.Count - 1 do
    Send(TControl(FTargets[I]), Command, Data);
end;

end.
