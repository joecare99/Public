unit CalendarApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, DesktopApplication, DesktopWorkspace, DesktopServices,
  CalendarViewModel, CalendarView;

type
  TCalendarApplication = class(TDesktopApplication)
  private
    FViewModel: TCalendarViewModel;
    FView: TCalendarView;
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

constructor TCalendarApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Calendar', AWorkspace, AServices, AOnOpened);
  FViewModel := TCalendarViewModel.Create(AServices.Clock);
  FView := TCalendarView.Create(AWorkspace, FViewModel, @NotifyOpened);
end;

destructor TCalendarApplication.Destroy;
begin
  FView.Free;
  FViewModel.Free;
  inherited Destroy;
end;

procedure TCalendarApplication.Open;
begin
  FView.Open;
end;

end.
