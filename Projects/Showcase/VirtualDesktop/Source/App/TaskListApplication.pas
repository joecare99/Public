unit TaskListApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, StdCtrls, DesktopApplication, DesktopWindow,
  DesktopWorkspace,
  DesktopServices, TaskListViewModel;

type
  TTaskListApplication = class(TDesktopApplication)
  private
    FViewModel: TTaskListViewModel;
    FList: TListBox;
    procedure AddDemoTask(Sender: TObject);
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

constructor TTaskListApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Task list', AWorkspace, AServices, AOnOpened);
  FViewModel := TTaskListViewModel.Create(AServices.Tasks);
  FViewModel.Load;
end;

destructor TTaskListApplication.Destroy;
begin
  FViewModel.Free;
  inherited Destroy;
end;

procedure TTaskListApplication.Open;
var
  Window: TDesktopWindow;
  AddButton: TButton;
  I: Integer;
begin
  Window := FWorkspace.CreateWindow(Name, 350, 360, 390, 260);
  FList := TListBox.Create(Window.ClientArea);
  FList.Parent := Window.ClientArea;
  FList.Align := alClient;
  for I := 0 to FViewModel.VisibleCount - 1 do
    FList.Items.Add(FViewModel.VisibleTaskAt(I).Title);
  AddButton := TButton.Create(Window.ClientArea);
  AddButton.Parent := Window.ClientArea;
  AddButton.Align := alBottom;
  AddButton.Height := 34;
  AddButton.Caption := 'Add demo task';
  AddButton.OnClick := @AddDemoTask;
  NotifyOpened(Self);
end;

procedure TTaskListApplication.AddDemoTask(Sender: TObject);
begin
  FViewModel.AddTask('Review MVVM boundaries');
  if Assigned(FList) then
    FList.Items.Add('Review MVVM boundaries');
end;

end.
