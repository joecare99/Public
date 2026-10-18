unit VirtualDesktopProcessService;

{$mode objfpc}{$H+}

interface

uses
  Process, LazarusProjectContracts;

type
  TVirtualDesktopProcessService = class(TInterfacedObject,
    IVirtualDesktopProcessService)
  private
    FProcess: TProcess;
    function VirtualDesktopExecutable: string;
  public
    destructor Destroy; override;
    function StartVirtualDesktop: TShowcaseOperationResult;
    function StopVirtualDesktop: TShowcaseOperationResult;
    function ProcessStatus: TVirtualDesktopProcessStatus;
  end;

implementation

uses
  SysUtils;

const
  {$IFDEF CPUX86_64}
  CurrentTargetCpu = 'x86_64';
  {$ELSE}
  CurrentTargetCpu = 'i386';
  {$ENDIF}
  {$IFDEF WIN64}
  CurrentTargetOs = 'win64';
  {$ELSE}
  CurrentTargetOs = 'win32';
  {$ENDIF}

function TVirtualDesktopProcessService.VirtualDesktopExecutable: string;
begin
  Result := CanonicalShowcaseBinaryPath(ShowcaseBinaryDirectory +
    '\' + CurrentTargetCpu + '-' + CurrentTargetOs +
    '\VirtualDesktop.exe');
end;

destructor TVirtualDesktopProcessService.Destroy;
begin
  if (FProcess <> nil) and FProcess.Running then
    FProcess.Terminate(1);
  FProcess.Free;
  inherited Destroy;
end;

function TVirtualDesktopProcessService.StartVirtualDesktop:
  TShowcaseOperationResult;
var
  ExecutableFile: string;
  NewProcess: TProcess;
begin
  if not IsWindowsPlatform then
    Exit(NewShowcaseOperationResult(sosUnsupportedPlatform,
      'VirtualDesktop process control is supported only on Windows.'));
  if IsVirtualDesktopProcessServiceOwned(ProcessStatus) then
    Exit(NewShowcaseOperationResult(sosAlreadyRunning,
      'The service-owned VirtualDesktop process is already running.',
      FProcess.ProcessID));

  ExecutableFile := VirtualDesktopExecutable;
  if not FileExists(ExecutableFile) then
    Exit(NewShowcaseOperationResult(sosExecutableUnavailable,
      'The controlled VirtualDesktop executable is unavailable.'));

  NewProcess := TProcess.Create(nil);
  try
    NewProcess.Executable := ExecutableFile;
    NewProcess.CurrentDirectory := ExtractFileDir(ExecutableFile);
    NewProcess.Options := [poNoConsole];
    try
      NewProcess.Execute;
      FProcess := NewProcess;
      NewProcess := nil;
      Result := NewShowcaseOperationResult(sosSuccess,
        'VirtualDesktop was started by this service.', FProcess.ProcessID);
    except
      on E: EProcess do
        Result := NewShowcaseOperationResult(sosLaunchFailed, E.Message);
    end;
  finally
    NewProcess.Free;
  end;
end;

function TVirtualDesktopProcessService.StopVirtualDesktop:
  TShowcaseOperationResult;
var
  ProcessId: Integer;
begin
  if not IsWindowsPlatform then
    Exit(NewShowcaseOperationResult(sosUnsupportedPlatform,
      'VirtualDesktop process control is supported only on Windows.'));
  if not IsVirtualDesktopProcessServiceOwned(ProcessStatus) then
    Exit(NewShowcaseOperationResult(sosNotRunning,
      'No service-owned VirtualDesktop process is running.'));

  ProcessId := FProcess.ProcessID;
  if not FProcess.Terminate(1) then
    Exit(NewShowcaseOperationResult(sosLaunchFailed,
      'The service-owned VirtualDesktop process could not be stopped.',
      ProcessId));
  FProcess.Free;
  FProcess := nil;
  Result := NewShowcaseOperationResult(sosSuccess,
    'The service-owned VirtualDesktop process was stopped.', ProcessId);
end;

function TVirtualDesktopProcessService.ProcessStatus:
  TVirtualDesktopProcessStatus;
begin
  Result.ProcessId := 0;
  if not IsWindowsPlatform then
  begin
    Result.State := vdpsUnsupportedPlatform;
    Exit;
  end;

  if (FProcess <> nil) and FProcess.Running then
  begin
    Result.State := vdpsRunningOwned;
    Result.ProcessId := FProcess.ProcessID;
    Exit;
  end;

  FreeAndNil(FProcess);
  Result.State := vdpsNotRunning;
end;

end.
