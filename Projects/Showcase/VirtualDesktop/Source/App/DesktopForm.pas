unit DesktopForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, StdCtrls,
  ComCtrls, ServiceContainer, DesktopServices, DesktopViewModel,
  DesktopWindow,
  DesktopWorkspace, Mvvm, DesktopApplication, CalculatorApplication,
  CalendarApplication, NotepadApplication, AlarmClockApplication,
  UnitConverterApplication, TaskListApplication,
  ConfigurationApplication, TextViewerApplication,
  OrbitDodgerApplication, TileMatchApplication, McpCommand, McpRegistry,
  McpDesktopBridge, DesktopMcpBridge, DesktopMcpShellAdapter,
  McpLoopbackServer,
  LazarusProjectContracts, LazarusProjectCatalog, LazarusIdeLauncher,
  LazarusBuildTestRunner, VirtualDesktopProcessService, LazarusMcpBridge;

type
  TDesktopForm = class(TForm)
  private
    FServices: IDesktopServices;
    FDesktop: TDesktopViewModel;
    FStatus: TLabel;
    FClockLabel: TLabel;
    FTimer: TTimer;
    FWorkspace: TDesktopWorkspace;
    FLauncherPanel: TScrollBox;
    FLaunchCommand: ICommand;
    FApplications: TDesktopApplicationRegistry;
    FDesktopMcpContext: TMcpCommandContext;
    FDesktopMcpShell: IDesktopMcpShell;
    FDesktopMcpBridge: IMcpDesktopCommandBridge;
    FDesktopMcpClient: IMcpToolClient;
    FLazarusMcpBridge: IMcpLazarusCommandBridge;
    FLoopbackMcpServer: TMcpLoopbackServer;
    FLoopbackMcpTimer: TTimer;
    procedure BuildDesktop;
    procedure BuildApplicationLauncher;
    function NewWindow(const ATitle: string; AX, AY, AW, AH: Integer): TDesktopWindow;
    procedure AddTitle(const AParent: TWinControl; const AText: string);
    procedure ViewOpened(Sender: TObject);
    procedure Tick(Sender: TObject);
    procedure UpdateStatus;
    procedure ExecuteLaunch(Sender: TObject; const AParameter: string);
    function CanExecuteLaunch(Sender: TObject;
      const AParameter: string): Boolean;
    procedure LaunchButtonClick(Sender: TObject);
    procedure ProcessLoopbackMcp(Sender: TObject);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    function DesktopMcpToolClient: IMcpToolClient;
  end;

var
  MainDesktopForm: TDesktopForm;

implementation

constructor TDesktopForm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Caption := 'Lazarus MVVM Showcase - Virtual Desktop';
  Width := 1120;
  Height := 720;
  Position := poScreenCenter;
  Color := RGBToColor(24, 34, 54);
  FServices := TServiceContainer.Create;
  FDesktop := TDesktopViewModel.Create(FServices.Clock);
  BuildDesktop;
  FApplications := TDesktopApplicationRegistry.Create;
  FApplications.RegisterApplication(TCalculatorApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FApplications.RegisterApplication(TCalendarApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FApplications.RegisterApplication(TNotepadApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FApplications.RegisterApplication(TAlarmClockApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FApplications.RegisterApplication(TUnitConverterApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FApplications.RegisterApplication(TTaskListApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FApplications.RegisterApplication(TConfigurationApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FApplications.RegisterApplication(TTextViewerApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FApplications.RegisterApplication(TOrbitDodgerApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FApplications.RegisterApplication(TTileMatchApplication.Create(
    FWorkspace, FServices, @ViewOpened));
  FLaunchCommand := TDelegateCommand.Create(@ExecuteLaunch, @CanExecuteLaunch);
  BuildApplicationLauncher;
  FDesktopMcpContext := TMcpCommandContext.Create(FServices.Workspace.RootPath,
    True, True);
  FDesktopMcpShell := TDesktopMcpShellAdapter.Create(FApplications, FWorkspace);
  FDesktopMcpBridge := TDesktopMcpBridge.Create(FDesktopMcpShell);
  FLazarusMcpBridge := TLazarusMcpBridge.Create(
    TShowcaseProjectCatalog.Create, TLazarusIdeLauncher.Create,
    TLazarusBuildTestRunner.Create, TVirtualDesktopProcessService.Create);
  FDesktopMcpClient := TMcpCommandRouter.Create(GlobalMcpCommandRegistry,
    ApplicationMcpCommandRegistry, FDesktopMcpContext, FDesktopMcpBridge,
    FLazarusMcpBridge);
  FLoopbackMcpServer := TMcpLoopbackServer.Create(FDesktopMcpClient,
    FServices.Workspace.RootPath);
  FLoopbackMcpServer.Start;
  FLoopbackMcpTimer := TTimer.Create(Self);
  FLoopbackMcpTimer.Interval := 50;
  FLoopbackMcpTimer.OnTimer := @ProcessLoopbackMcp;
  FLoopbackMcpTimer.Enabled := True;
end;

destructor TDesktopForm.Destroy;
begin
  if FLoopbackMcpTimer <> nil then
    FLoopbackMcpTimer.Enabled := False;
  FreeAndNil(FLoopbackMcpServer);
  FDesktopMcpClient := nil;
  FDesktopMcpBridge := nil;
  FLazarusMcpBridge := nil;
  FDesktopMcpShell := nil;
  FDesktopMcpContext.Free;
  FApplications.Free;
  FDesktop.Free;
  inherited Destroy;
end;

procedure TDesktopForm.BuildDesktop;
var
  Header, DockPanel: TPanel;
  Title, Subtitle, HintLabel: TLabel;
begin
  Header := TPanel.Create(Self);
  Header.Parent := Self;
  Header.Align := alTop;
  Header.Height := 104;
  Header.BevelOuter := bvNone;
  Header.Color := RGBToColor(31, 45, 72);

  Title := TLabel.Create(Header);
  Title.Parent := Header;
  Title.Left := 28;
  Title.Top := 18;
  Title.Caption := 'Lazarus Workbench';
  Title.Font.Size := 22;
  Title.Font.Style := [fsBold];
  Title.Font.Color := clWhite;

  Subtitle := TLabel.Create(Header);
  Subtitle.Parent := Header;
  Subtitle.Left := 30;
  Subtitle.Top := 56;
  Subtitle.Caption := 'MVVM + dependency injection + one class per file';
  Subtitle.Font.Color := RGBToColor(180, 201, 230);

  FClockLabel := TLabel.Create(Header);
  FClockLabel.Parent := Header;
  FClockLabel.Left := 870;
  FClockLabel.Top := 25;
  FClockLabel.Caption := '00:00:00';
  FClockLabel.Font.Size := 18;
  FClockLabel.Font.Style := [fsBold];
  FClockLabel.Font.Color := RGBToColor(126, 224, 190);

  HintLabel := TLabel.Create(Self);
  HintLabel.Parent := Self;
  HintLabel.Align := alBottom;
  HintLabel.Height := 28;
  HintLabel.Caption := '  Select an application from the dock. Each window is backed by an independent view model.';
  HintLabel.Font.Color := RGBToColor(177, 194, 218);
  HintLabel.Color := RGBToColor(20, 29, 46);
  HintLabel.Transparent := False;

  FStatus := TLabel.Create(Self);
  FStatus.Parent := Self;
  FStatus.Align := alBottom;
  FStatus.Height := 22;
  FStatus.Alignment := taRightJustify;
  FStatus.Caption := FDesktop.StatusCaption + '  ';
  FStatus.Font.Color := RGBToColor(126, 224, 190);
  FStatus.Color := RGBToColor(20, 29, 46);
  FStatus.Transparent := False;

  DockPanel := TPanel.Create(Self);
  DockPanel.Parent := Self;
  DockPanel.Align := alLeft;
  DockPanel.Width := 205;
  DockPanel.BevelOuter := bvNone;
  DockPanel.Color := RGBToColor(28, 40, 63);

  FLauncherPanel := TScrollBox.Create(DockPanel);
  FLauncherPanel.Parent := DockPanel;
  FLauncherPanel.SetBounds(0, 0, DockPanel.Width, DockPanel.Height);
  FLauncherPanel.Align := alClient;
  FLauncherPanel.BorderStyle := bsNone;
  FLauncherPanel.Color := DockPanel.Color;
  FLauncherPanel.VertScrollBar.Tracking := True;
  AddTitle(FLauncherPanel, 'APPLICATIONS');

  FWorkspace := TDesktopWorkspace.Create(Self);
  FWorkspace.Parent := Self;
  FWorkspace.Align := alClient;

  FTimer := TTimer.Create(Self);
  FTimer.Interval := 1000;
  FTimer.OnTimer := @Tick;
  FTimer.Enabled := True;
  Tick(FTimer);
end;

procedure TDesktopForm.BuildApplicationLauncher;
var
  ApplicationIndex: Integer;
  Button: TButton;
begin
  for ApplicationIndex := 0 to FApplications.Count - 1 do
  begin
    Button := TButton.Create(FLauncherPanel);
    Button.Parent := FLauncherPanel;
    Button.SetBounds(20, 58 + (ApplicationIndex * 52), 165, 42);
    Button.Caption := FApplications.ApplicationAt(ApplicationIndex).Name;
    Button.OnClick := @LaunchButtonClick;
  end;
end;

function TDesktopForm.NewWindow(const ATitle: string; AX, AY, AW, AH: Integer): TDesktopWindow;
begin
  Result := FWorkspace.CreateWindow(ATitle, AX, AY, AW, AH);
end;

procedure TDesktopForm.AddTitle(const AParent: TWinControl; const AText: string);
var
  Title: TLabel;
begin
  Title := TLabel.Create(AParent);
  Title.Parent := AParent;
  Title.Left := 16;
  Title.Top := 14;
  Title.Caption := AText;
  Title.Font.Style := [fsBold];
  Title.Font.Color := RGBToColor(37, 59, 91);
end;

procedure TDesktopForm.ExecuteLaunch(Sender: TObject;
  const AParameter: string);
begin
  FApplications.Open(AParameter);
end;

function TDesktopForm.CanExecuteLaunch(Sender: TObject;
  const AParameter: string): Boolean;
begin
  Result := Assigned(FApplications) and
    (FApplications.ApplicationNamed(AParameter) <> nil);
end;

procedure TDesktopForm.LaunchButtonClick(Sender: TObject);
begin
  FLaunchCommand.Execute(TButton(Sender).Caption);
end;

procedure TDesktopForm.ProcessLoopbackMcp(Sender: TObject);
begin
  FLoopbackMcpServer.Process;
end;

procedure TDesktopForm.ViewOpened(Sender: TObject);
begin
  FDesktop.RegisterOpenedApp;
  UpdateStatus;
end;

procedure TDesktopForm.Tick(Sender: TObject);
begin
  FClockLabel.Caption := FormatDateTime('hh:nn:ss', FServices.Clock.Now);
  if Assigned(FApplications) and
    (FApplications.ApplicationNamed('Analog alarm clock') is TAlarmClockApplication) then
    TAlarmClockApplication(FApplications.ApplicationNamed(
      'Analog alarm clock')).Tick;
end;

procedure TDesktopForm.UpdateStatus;
begin
  FStatus.Caption := FDesktop.StatusCaption + '  ';
end;

function TDesktopForm.DesktopMcpToolClient: IMcpToolClient;
begin
  Result := FDesktopMcpClient;
end;

end.
