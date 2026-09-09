unit NotepadApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, DesktopApplication, DesktopWorkspace, DesktopServices,
  NotepadViewModel, NotepadView;

type
  TNotepadApplication = class(TDesktopApplication)
  private
    FViewModel: TNotepadViewModel;
    FView: TNotepadView;
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

constructor TNotepadApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Notepad', AWorkspace, AServices, AOnOpened);
  FViewModel := TNotepadViewModel.Create(AServices.Notes);
  FView := TNotepadView.Create(AWorkspace, FViewModel, @NotifyOpened);
end;

destructor TNotepadApplication.Destroy;
begin
  FView.Free;
  FViewModel.Free;
  inherited Destroy;
end;

procedure TNotepadApplication.Open;
begin
  FView.Open;
end;

end.
