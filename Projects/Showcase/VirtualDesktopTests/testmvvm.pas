unit testmvvm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fpcunit, testregistry, Mvvm, CalculatorViewModel,
  NotepadViewModel, Services;

type
  TPropertyObserver = class
  public
    Count: Integer;
    LastProperty: string;
    procedure PropertyChanged(Sender: TObject; const APropertyName: string);
  end;

  TCommandObserver = class
  public
    Count: Integer;
    procedure CanExecuteChanged(Sender: TObject);
  end;

  TCommandExecutor = class
  public
    Executed: string;
    procedure Execute(Sender: TObject; const AParameter: string);
  end;

  TFakeStorageForMvvm = class(TInterfacedObject, INoteStorage)
  private
    FText: string;
  public
    function LoadText: string;
    procedure SaveText(const AText: string);
  end;

  TMvvmTest = class(TTestCase)
  published
    procedure PropertyChangedNotifiesAllConsumersAndRemovesOne;
    procedure CommandExecutesAndNotifiesCanExecuteConsumers;
    procedure CalculatorInputUsesCommand;
    procedure NotepadSaveCommandTracksDirtyState;
  end;

implementation

procedure TPropertyObserver.PropertyChanged(Sender: TObject;
  const APropertyName: string);
begin
  Inc(Count);
  LastProperty := APropertyName;
end;

procedure TCommandObserver.CanExecuteChanged(Sender: TObject);
begin
  Inc(Count);
end;

procedure TCommandExecutor.Execute(Sender: TObject; const AParameter: string);
begin
  Executed := AParameter;
end;

function TFakeStorageForMvvm.LoadText: string;
begin
  Result := FText;
end;

procedure TFakeStorageForMvvm.SaveText(const AText: string);
begin
  FText := AText;
end;

procedure TMvvmTest.PropertyChangedNotifiesAllConsumersAndRemovesOne;
var
  ViewModel: TCalculatorViewModel;
  First, Second: TPropertyObserver;
begin
  ViewModel := TCalculatorViewModel.Create;
  First := TPropertyObserver.Create;
  Second := TPropertyObserver.Create;
  try
    ViewModel.AddPropertyChanged(@First.PropertyChanged);
    ViewModel.AddPropertyChanged(@Second.PropertyChanged);
    ViewModel.PressDigit('7');
    AssertEquals(1, First.Count);
    AssertEquals(1, Second.Count);
    AssertEquals('Display', First.LastProperty);
    ViewModel.RemovePropertyChanged(@First.PropertyChanged);
    ViewModel.PressClear;
    AssertEquals(1, First.Count);
    AssertEquals(2, Second.Count);
  finally
    First.Free;
    Second.Free;
    ViewModel.Free;
  end;
end;

procedure TMvvmTest.CommandExecutesAndNotifiesCanExecuteConsumers;
var
  Command: ICommand;
  CommandObject: TDelegateCommand;
  Observer: TCommandObserver;
  Executor: TCommandExecutor;
begin
  Executor := TCommandExecutor.Create;
  CommandObject := TDelegateCommand.Create(@Executor.Execute);
  Command := CommandObject;
  Observer := TCommandObserver.Create;
  try
    Command.AddCanExecuteChanged(@Observer.CanExecuteChanged);
    Command.Execute('value');
    CommandObject.NotifyCanExecuteChanged;
    AssertEquals('value', Executor.Executed);
    AssertEquals(1, Observer.Count);
  finally
    Observer.Free;
    Executor.Free;
    Command := nil;
  end;
end;

procedure TMvvmTest.CalculatorInputUsesCommand;
var
  ViewModel: TCalculatorViewModel;
begin
  ViewModel := TCalculatorViewModel.Create;
  try
    ViewModel.InputCommand.Execute('8');
    ViewModel.InputCommand.Execute('+');
    ViewModel.InputCommand.Execute('4');
    ViewModel.InputCommand.Execute('=');
    AssertEquals('12', ViewModel.Display);
  finally
    ViewModel.Free;
  end;
end;

procedure TMvvmTest.NotepadSaveCommandTracksDirtyState;
var
  Storage: INoteStorage;
  ViewModel: TNotepadViewModel;
begin
  Storage := TFakeStorageForMvvm.Create;
  ViewModel := TNotepadViewModel.Create(Storage);
  try
    AssertFalse(ViewModel.SaveCommand.CanExecute(''));
    ViewModel.UpdateText('changed');
    AssertTrue(ViewModel.SaveCommand.CanExecute(''));
    ViewModel.SaveCommand.Execute('');
    AssertFalse(ViewModel.SaveCommand.CanExecute(''));
  finally
    ViewModel.Free;
  end;
end;

initialization
  RegisterTest(TMvvmTest);

end.
