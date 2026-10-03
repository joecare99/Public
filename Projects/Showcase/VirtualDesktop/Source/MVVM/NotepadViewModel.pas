unit NotepadViewModel;

{$mode objfpc}{$H+}

interface

uses
  Services, Mvvm;

type
  TNotepadViewModel = class(TNotifyPropertyChangedObject)
  private
    FStorage: INoteStorage;
    FText: string;
    FDirty: Boolean;
    FSaveCommandObject: TDelegateCommand;
    FSaveCommand: ICommand;
    procedure ExecuteSave(Sender: TObject; const AParameter: string);
    function CanExecuteSave(Sender: TObject; const AParameter: string): Boolean;
  public
    constructor Create(const AStorage: INoteStorage);
    procedure UpdateText(const AText: string);
    procedure Save;
    property Text: string read FText;
    property Dirty: Boolean read FDirty;
    property SaveCommand: ICommand read FSaveCommand;
  end;

implementation

constructor TNotepadViewModel.Create(const AStorage: INoteStorage);
begin
  inherited Create;
  FStorage := AStorage;
  FText := FStorage.LoadText;
  FSaveCommandObject := TDelegateCommand.Create(@ExecuteSave, @CanExecuteSave);
  FSaveCommand := FSaveCommandObject;
end;

procedure TNotepadViewModel.ExecuteSave(Sender: TObject;
  const AParameter: string);
begin
  Save;
end;

function TNotepadViewModel.CanExecuteSave(Sender: TObject;
  const AParameter: string): Boolean;
begin
  Result := FDirty;
end;

procedure TNotepadViewModel.UpdateText(const AText: string);
begin
  FText := AText;
  FDirty := True;
  NotifyPropertyChanged('Text');
  NotifyPropertyChanged('Dirty');
  FSaveCommandObject.NotifyCanExecuteChanged;
end;

procedure TNotepadViewModel.Save;
begin
  FStorage.SaveText(FText);
  FDirty := False;
  NotifyPropertyChanged('Dirty');
  FSaveCommandObject.NotifyCanExecuteChanged;
end;

end.
