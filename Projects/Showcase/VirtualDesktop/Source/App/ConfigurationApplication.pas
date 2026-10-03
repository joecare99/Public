unit ConfigurationApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, SysUtils, StdCtrls, DesktopApplication, DesktopWindow,
  DesktopWorkspace,
  DesktopServices, ConfigurationEditorViewModel;

type
  TConfigurationApplication = class(TDesktopApplication)
  private
    FViewModel: TConfigurationEditorViewModel;
    procedure SaveDemoPreference(Sender: TObject);
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

constructor TConfigurationApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Configuration', AWorkspace, AServices, AOnOpened);
  FViewModel := TConfigurationEditorViewModel.Create(AServices.Configuration);
end;

destructor TConfigurationApplication.Destroy;
begin
  FViewModel.Free;
  inherited Destroy;
end;

procedure TConfigurationApplication.Open;
var
  Window: TDesktopWindow;
  Memo: TMemo;
  SaveButton: TButton;
begin
  Window := FWorkspace.CreateWindow(Name, 430, 80, 390, 260);
  Memo := TMemo.Create(Window.ClientArea);
  Memo.Parent := Window.ClientArea;
  Memo.Align := alClient;
  Memo.Lines.Add('Configuration service ready.');
  Memo.Lines.Add('Sections: ' + IntToStr(Length(FViewModel.Sections)));
  SaveButton := TButton.Create(Window.ClientArea);
  SaveButton.Parent := Window.ClientArea;
  SaveButton.Align := alBottom;
  SaveButton.Height := 34;
  SaveButton.Caption := 'Save demo preference';
  SaveButton.OnClick := @SaveDemoPreference;
  FViewModel.WriteValue('showcase', 'last_opened', DateTimeToStr(Now));
  FViewModel.SaveCommand.Execute('');
  NotifyOpened(Self);
end;

procedure TConfigurationApplication.SaveDemoPreference(Sender: TObject);
begin
  FViewModel.WriteValue('showcase', 'last_saved', DateTimeToStr(Now));
  FViewModel.SaveCommand.Execute('');
end;

end.
