unit TextViewerApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, StdCtrls, DesktopApplication, DesktopWindow,
  DesktopWorkspace,
  DesktopServices, TextViewerViewModel;

type
  TTextViewerApplication = class(TDesktopApplication)
  private
    FViewModel: TTextViewerViewModel;
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

constructor TTextViewerApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Text viewer', AWorkspace, AServices, AOnOpened);
  FViewModel := TTextViewerViewModel.Create(AServices.Workspace);
end;

destructor TTextViewerApplication.Destroy;
begin
  FViewModel.Free;
  inherited Destroy;
end;

procedure TTextViewerApplication.Open;
var
  Window: TDesktopWindow;
  Memo: TMemo;
begin
  Window := FWorkspace.CreateWindow(Name, 820, 80, 280, 260);
  Memo := TMemo.Create(Window.ClientArea);
  Memo.Parent := Window.ClientArea;
  Memo.Align := alClient;
  Memo.ReadOnly := True;
  Memo.Lines.Text := 'Workspace: ' + FServices.Workspace.RootPath;
  NotifyOpened(Self);
end;

end.
