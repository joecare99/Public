unit TaskRepository;

{$mode objfpc}{$H+}

interface

uses
  Services, TaskItem;

type
  ITaskRepository = interface
    ['{0A5C4A0A-9A1F-4E41-8C86-3CFC8F65B2B9}']
    function LoadTasks: TTaskItemArray;
    procedure SaveTasks(const ATasks: TTaskItemArray);
  end;

implementation

end.
