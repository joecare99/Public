unit TileMatchApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, DesktopApplication, DesktopWorkspace, DesktopWindow,
  DesktopServices,
  TileMatchGameViewModel, SystemGameClock, SystemGameRandom,
  TileMatchView;

type
  TTileMatchApplication = class(TDesktopApplication)
  private
    FViewModel: TTileMatchGameViewModel;
    FView: TTileMatchView;
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

constructor TTileMatchApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Tile Match', AWorkspace, AServices, AOnOpened);
  FViewModel := TTileMatchGameViewModel.Create(
    TSystemGameRandom.Create, TSystemGameClock.Create);
  FViewModel.Restart;
end;

destructor TTileMatchApplication.Destroy;
begin
  FView.Free;
  FViewModel.Free;
  inherited Destroy;
end;

procedure TTileMatchApplication.Open;
var
  Window: TDesktopWindow;
begin
  if Assigned(FView) and FView.IsOpen then
    Exit;
  FView.Free;
  FView := nil;
  Window := FWorkspace.CreateWindow(Name, 440, 100, 470, 500);
  FView := TTileMatchView.Create(Window, FViewModel);
  NotifyOpened(Self);
end;

end.
