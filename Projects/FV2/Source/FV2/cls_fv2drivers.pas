unit cls_fv2drivers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_fv2application, cls_fv2controls;

type
  TEvent = TFvEvent;
  TEventType = TFvEventType;
  TEventProvider = function(out Event: TEvent): Boolean of object;

  TEventDriver = class(TComponent)
  private
    FApplication: TFvApplication;
    FProvider: TEventProvider;
  public
    constructor Create(AOwner: TComponent; AApplication: TFvApplication;
      AProvider: TEventProvider); reintroduce;
    procedure Poll(Sender: TObject; out Event: TEvent);
    property Application: TFvApplication read FApplication;
    property Provider: TEventProvider read FProvider write FProvider;
  end;

implementation

constructor TEventDriver.Create(AOwner: TComponent;
  AApplication: TFvApplication; AProvider: TEventProvider);
begin
  inherited Create(AOwner);
  FApplication := AApplication;
  FProvider := AProvider;
end;

procedure TEventDriver.Poll(Sender: TObject; out Event: TEvent);
begin
  Event := Default(TEvent);
  if not Assigned(FProvider) or not FProvider(Event) then
    Event.EventType := feNone;
end;

end.
