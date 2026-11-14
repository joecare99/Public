unit AlarmClockApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, DesktopApplication, DesktopWorkspace, DesktopServices,
  AlarmClockViewModel, AlarmClockView;

type
  TAlarmClockApplication = class(TDesktopApplication)
  private
    FViewModel: TAlarmClockViewModel;
    FView: TAlarmClockView;
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
    procedure Tick;
  end;

implementation

constructor TAlarmClockApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Analog alarm clock', AWorkspace, AServices, AOnOpened);
  FViewModel := TAlarmClockViewModel.Create(AServices.Clock);
  FView := TAlarmClockView.Create(AWorkspace, FViewModel, @NotifyOpened);
end;

destructor TAlarmClockApplication.Destroy;
begin
  FView.Free;
  FViewModel.Free;
  inherited Destroy;
end;

procedure TAlarmClockApplication.Open;
begin
  if FView.IsOpen then
    Exit;
  FView.Open;
end;

procedure TAlarmClockApplication.Tick;
begin
  FView.Tick;
end;

end.
