unit testappdomains;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fpcunit, testregistry, Services, UnitConverterViewModel,
  TaskItem, TaskRepository, TaskListViewModel;

type
  TFakeWorkspace = class(TInterfacedObject, IUserWorkspaceService)
  public
    function RootPath: string;
    function ResolveFile(const ARelativePath: string): string;
  end;

  TFakeTaskRepository = class(TInterfacedObject, ITaskRepository)
  private
    FTasks: TTaskItemArray;
  public
    destructor Destroy; override;
    function LoadTasks: TTaskItemArray;
    procedure SaveTasks(const ATasks: TTaskItemArray);
  end;

  TAppDomainTest = class(TTestCase)
  published
    procedure ConvertsLengthMassAndTemperature;
    procedure RejectsUnknownUnits;
    procedure TaskItemFiltersByIdAndTitle;
    procedure TaskListAddsTogglesDeletesAndFilters;
  end;

implementation

function TFakeWorkspace.RootPath: string;
begin
  Result := GetTempDir;
end;

function TFakeWorkspace.ResolveFile(const ARelativePath: string): string;
begin
  Result := IncludeTrailingPathDelimiter(GetTempDir) + ARelativePath;
end;

destructor TFakeTaskRepository.Destroy;
var
  I: Integer;
begin
  for I := 0 to High(FTasks) do
    FTasks[I].Free;
  inherited Destroy;
end;

function TFakeTaskRepository.LoadTasks: TTaskItemArray;
var
  I: Integer;
begin
  SetLength(Result, Length(FTasks));
  for I := 0 to High(FTasks) do
    Result[I] := TTaskItem.Create(FTasks[I].Id, FTasks[I].Title,
      FTasks[I].Completed);
end;

procedure TFakeTaskRepository.SaveTasks(const ATasks: TTaskItemArray);
var
  I: Integer;
begin
  for I := 0 to High(FTasks) do
    FTasks[I].Free;
  SetLength(FTasks, Length(ATasks));
  for I := 0 to High(ATasks) do
    FTasks[I] := TTaskItem.Create(ATasks[I].Id, ATasks[I].Title,
      ATasks[I].Completed);
end;

procedure TAppDomainTest.ConvertsLengthMassAndTemperature;
begin
  AssertEquals(1.0, TUnitConverterViewModel.ConvertLength(100, 'cm', 'm'), 0.0001);
  AssertEquals(1.0, TUnitConverterViewModel.ConvertMass(1000, 'g', 'kg'), 0.0001);
  AssertEquals(212.0, TUnitConverterViewModel.ConvertTemperature(100, 'C', 'F'), 0.0001);
end;

procedure TAppDomainTest.RejectsUnknownUnits;
var
  Value: Double;
  ErrorText: string;
begin
  AssertFalse(TUnitConverterViewModel.TryConvert(ucLength, 1, 'parsec', 'm',
    Value, ErrorText));
  AssertTrue(ErrorText <> '');
end;

procedure TAppDomainTest.TaskItemFiltersByIdAndTitle;
var
  Item: TTaskItem;
begin
  Item := TTaskItem.Create('task-1', 'Write tests');
  try
    AssertTrue(Item.MatchesFilter('TASK-1'));
    AssertTrue(Item.MatchesFilter('tests'));
    AssertFalse(Item.MatchesFilter('calendar'));
  finally
    Item.Free;
  end;
end;

procedure TAppDomainTest.TaskListAddsTogglesDeletesAndFilters;
var
  Repository: ITaskRepository;
  ViewModel: TTaskListViewModel;
  Id: string;
begin
  Repository := TFakeTaskRepository.Create;
  ViewModel := TTaskListViewModel.Create(Repository);
  try
    Id := ViewModel.AddTask('Write tests');
    AssertEquals(1, ViewModel.Count);
    AssertTrue(ViewModel.ToggleTask(Id));
    AssertTrue(ViewModel.TaskAt(0).Completed);
    ViewModel.SetFilter('tests');
    AssertEquals(1, ViewModel.VisibleCount);
    AssertTrue(ViewModel.DeleteTask(Id));
    AssertEquals(0, ViewModel.Count);
  finally
    ViewModel.Free;
  end;
end;

initialization
  RegisterTest(TAppDomainTest);

end.
