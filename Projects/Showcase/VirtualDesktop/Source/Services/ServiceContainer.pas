unit ServiceContainer;

{$mode objfpc}{$H+}

interface

uses
  Services, DesktopServices, ClockService, FileNoteStorage, UserWorkspaceService,
  ConfigurationService, TaskRepository, FileTaskRepository;

type
  TServiceContainer = class(TInterfacedObject, IDesktopServices)
  private
    FClock: IClockService;
    FNotes: INoteStorage;
    FWorkspace: IUserWorkspaceService;
    FConfiguration: IConfigurationService;
    FTasks: ITaskRepository;
  public
    constructor Create;
    function Clock: IClockService;
    function Notes: INoteStorage;
    function Workspace: IUserWorkspaceService;
    function Configuration: IConfigurationService;
    function Tasks: ITaskRepository;
  end;

implementation

constructor TServiceContainer.Create;
begin
  FClock := TSystemClockService.Create;
  FWorkspace := TUserWorkspaceService.Create('LazarusVirtualDesktop');
  FConfiguration := TIniConfigurationService.Create(FWorkspace);
  FNotes := TFileNoteStorage.Create(FWorkspace);
  FTasks := TFileTaskRepository.Create(FWorkspace);
end;

function TServiceContainer.Clock: IClockService;
begin
  Result := FClock;
end;

function TServiceContainer.Notes: INoteStorage;
begin
  Result := FNotes;
end;

function TServiceContainer.Workspace: IUserWorkspaceService;
begin
  Result := FWorkspace;
end;

function TServiceContainer.Configuration: IConfigurationService;
begin
  Result := FConfiguration;
end;

function TServiceContainer.Tasks: ITaskRepository;
begin
  Result := FTasks;
end;

end.
