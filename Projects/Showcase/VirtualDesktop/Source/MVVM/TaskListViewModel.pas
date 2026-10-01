unit TaskListViewModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, TaskItem, TaskRepository, Mvvm;

type
  TTaskListViewModel = class(TNotifyPropertyChangedObject)
  private
    class var FIdSequence: QWord;
    FRepository: ITaskRepository;
    FTasks: TTaskItemArray;
    FFilter: string;
    function FindTaskIndex(const AId: string): Integer;
    function CreateUniqueId: string;
    procedure FreeTasks;
    function GetCount: Integer;
    function GetVisibleCount: Integer;
    function GetFilter: string;
  public
    constructor Create(const ARepository: ITaskRepository);
    destructor Destroy; override;
    procedure Load;
    procedure Save;
    procedure SetFilter(const AValue: string);
    function AddTask(const ATitle: string): string;
    function ToggleTask(const AId: string): Boolean;
    function DeleteTask(const AId: string): Boolean;
    function TaskAt(const AIndex: Integer): TTaskItem;
    function VisibleTaskAt(const AIndex: Integer): TTaskItem;
    function GetVisibleTasks: TTaskItemArray;
    property FilterText: string read GetFilter;
    property Count: Integer read GetCount;
    property VisibleCount: Integer read GetVisibleCount;
  end;

implementation

constructor TTaskListViewModel.Create(const ARepository: ITaskRepository);
begin
  inherited Create;
  if ARepository = nil then
    raise EArgumentNilException.Create('A task repository is required.');
  FRepository := ARepository;
  SetLength(FTasks, 0);
end;

destructor TTaskListViewModel.Destroy;
begin
  FreeTasks;
  inherited Destroy;
end;

procedure TTaskListViewModel.FreeTasks;
var
  I: Integer;
begin
  for I := 0 to High(FTasks) do
    FTasks[I].Free;
  SetLength(FTasks, 0);
end;

procedure TTaskListViewModel.Load;
begin
  FreeTasks;
  FTasks := FRepository.LoadTasks;
  NotifyPropertyChanged('Count');
  NotifyPropertyChanged('VisibleCount');
end;

procedure TTaskListViewModel.Save;
begin
  FRepository.SaveTasks(FTasks);
end;

function TTaskListViewModel.FindTaskIndex(const AId: string): Integer;
var
  I: Integer;
begin
  for I := 0 to High(FTasks) do
    if FTasks[I].Id = AId then
      Exit(I);
  Result := -1;
end;

function TTaskListViewModel.CreateUniqueId: string;
begin
  repeat
    Inc(FIdSequence);
    Result := 'task-' + IntToStr(Int64(GetTickCount64)) + '-' +
      IntToStr(Int64(FIdSequence));
  until FindTaskIndex(Result) < 0;
end;

function TTaskListViewModel.AddTask(const ATitle: string): string;
var
  Item: TTaskItem;
begin
  if Trim(ATitle) = '' then
    raise EArgumentException.Create('A task title is required.');
  Item := TTaskItem.Create(CreateUniqueId, ATitle);
  SetLength(FTasks, Length(FTasks) + 1);
  FTasks[High(FTasks)] := Item;
  Save;
  NotifyPropertyChanged('Count');
  NotifyPropertyChanged('VisibleCount');
  Result := Item.Id;
end;

function TTaskListViewModel.ToggleTask(const AId: string): Boolean;
var
  Index: Integer;
begin
  Index := FindTaskIndex(AId);
  if Index < 0 then
    Exit(False);
  FTasks[Index].Completed := not FTasks[Index].Completed;
  Save;
  NotifyPropertyChanged('VisibleCount');
  Result := True;
end;

function TTaskListViewModel.DeleteTask(const AId: string): Boolean;
var
  Index, I: Integer;
  Deleted: TTaskItem;
begin
  Index := FindTaskIndex(AId);
  if Index < 0 then
    Exit(False);
  Deleted := FTasks[Index];
  for I := Index to High(FTasks) - 1 do
    FTasks[I] := FTasks[I + 1];
  SetLength(FTasks, Length(FTasks) - 1);
  Deleted.Free;
  Save;
  NotifyPropertyChanged('Count');
  NotifyPropertyChanged('VisibleCount');
  Result := True;
end;

function TTaskListViewModel.TaskAt(const AIndex: Integer): TTaskItem;
begin
  if (AIndex < 0) or (AIndex >= Length(FTasks)) then
    raise EArgumentOutOfRangeException.CreateFmt('Task index %d is out of range.',
      [AIndex]);
  Result := FTasks[AIndex];
end;

function TTaskListViewModel.VisibleTaskAt(const AIndex: Integer): TTaskItem;
var
  I, VisibleIndex: Integer;
begin
  if AIndex < 0 then
    raise EArgumentOutOfRangeException.CreateFmt(
      'Visible task index %d is out of range.', [AIndex]);
  VisibleIndex := 0;
  for I := 0 to High(FTasks) do
    if FTasks[I].MatchesFilter(FFilter) then
    begin
      if VisibleIndex = AIndex then
        Exit(FTasks[I]);
      Inc(VisibleIndex);
    end;
  raise EArgumentOutOfRangeException.CreateFmt(
    'Visible task index %d is out of range.', [AIndex]);
end;

function TTaskListViewModel.GetVisibleTasks: TTaskItemArray;
var
  I, OutputIndex: Integer;
begin
  Result := nil;
  SetLength(Result, GetVisibleCount);
  OutputIndex := 0;
  for I := 0 to High(FTasks) do
    if FTasks[I].MatchesFilter(FFilter) then
    begin
      Result[OutputIndex] := FTasks[I];
      Inc(OutputIndex);
    end;
end;

procedure TTaskListViewModel.SetFilter(const AValue: string);
begin
  FFilter := Trim(AValue);
  NotifyPropertyChanged('FilterText');
  NotifyPropertyChanged('VisibleCount');
end;

function TTaskListViewModel.GetCount: Integer;
begin
  Result := Length(FTasks);
end;

function TTaskListViewModel.GetFilter: string;
begin
  Result := FFilter;
end;

function TTaskListViewModel.GetVisibleCount: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(FTasks) do
    if FTasks[I].MatchesFilter(FFilter) then
      Inc(Result);
end;

end.
