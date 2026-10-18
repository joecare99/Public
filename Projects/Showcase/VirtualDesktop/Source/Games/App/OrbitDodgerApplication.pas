unit OrbitDodgerApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, DesktopApplication, DesktopWorkspace, DesktopWindow,
  DesktopServices,
  OrbitDodgerGameViewModel, SystemGameClock, SystemGameRandom,
  OrbitDodgerView;

type
  TOrbitDodgerApplication = class(TDesktopApplication)
  private
    FViewModel: TOrbitDodgerGameViewModel;
    FView: TOrbitDodgerView;
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

constructor TOrbitDodgerApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Orbit Dodger', AWorkspace, AServices, AOnOpened);
  FViewModel := TOrbitDodgerGameViewModel.Create(
    TSystemGameRandom.Create, TSystemGameClock.Create);
  FViewModel.Restart;
end;

destructor TOrbitDodgerApplication.Destroy;
begin
  FView.Free;
  FViewModel.Free;
  inherited Destroy;
end;

procedure TOrbitDodgerApplication.Open;
var
  Window: TDesktopWindow;
begin
  if Assigned(FView) and FView.IsOpen then
    Exit;
  FView.Free;
  FView := nil;
  Window := FWorkspace.CreateWindow(Name, 430, 120, 430, 360);
  FView := TOrbitDodgerView.Create(Window, FViewModel);
  NotifyOpened(Self);
end;

end.
