unit ConfigurationEditorViewModel;

{$mode objfpc}{$H+}

interface

uses
  Services, Mvvm;

type
  TConfigurationEditorViewModel = class(TNotifyPropertyChangedObject)
  private
    FConfiguration: IConfigurationService;
    FSaveCommand: ICommand;
    procedure ExecuteSave(Sender: TObject; const AParameter: string);
  public
    constructor Create(const AConfiguration: IConfigurationService);
    function Sections: TStringArray;
    function ReadValue(const ASection, AKey, ADefault: string): string;
    procedure WriteValue(const ASection, AKey, AValue: string);
    procedure DeleteValue(const ASection, AKey: string);
    procedure Save;
    property SaveCommand: ICommand read FSaveCommand;
  end;

implementation

constructor TConfigurationEditorViewModel.Create(
  const AConfiguration: IConfigurationService);
begin
  inherited Create;
  FConfiguration := AConfiguration;
  FSaveCommand := TDelegateCommand.Create(@ExecuteSave);
end;

procedure TConfigurationEditorViewModel.ExecuteSave(Sender: TObject;
  const AParameter: string);
begin
  Save;
end;

function TConfigurationEditorViewModel.Sections: TStringArray;
begin
  Result := FConfiguration.ReadSections;
end;

function TConfigurationEditorViewModel.ReadValue(const ASection, AKey,
  ADefault: string): string;
begin
  Result := FConfiguration.ReadString(ASection, AKey, ADefault);
end;

procedure TConfigurationEditorViewModel.WriteValue(const ASection, AKey,
  AValue: string);
begin
  FConfiguration.WriteString(ASection, AKey, AValue);
  NotifyPropertyChanged('Sections');
end;

procedure TConfigurationEditorViewModel.DeleteValue(const ASection, AKey: string);
begin
  FConfiguration.DeleteKey(ASection, AKey);
  NotifyPropertyChanged('Sections');
end;

procedure TConfigurationEditorViewModel.Save;
begin
  FConfiguration.Save;
end;

end.
