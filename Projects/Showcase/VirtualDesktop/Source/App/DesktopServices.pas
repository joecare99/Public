unit DesktopServices;

{$mode objfpc}{$H+}

interface

uses
  Services, TaskRepository;

type
  IDesktopServices = interface
    ['{B3B64D5C-901E-42DE-A99D-1C567B5D0B81}']
    function Clock: IClockService;
    function Notes: INoteStorage;
    function Workspace: IUserWorkspaceService;
    function Configuration: IConfigurationService;
    function Tasks: ITaskRepository;
  end;

implementation

end.
