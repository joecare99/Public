unit LazarusProjectContracts;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

const
  ShowcaseRootDirectory = 'C:\Projekte\Delphi\Projekte\Showcase';
  ShowcaseBinaryDirectory = 'C:\Projekte\Delphi\bin';
  LazarusIdeExecutable = 'C:\lazarus\lazarus.exe';
  LazarusBuildExecutable = 'C:\lazarus\lazbuild.exe';

type
  TShowcaseProjectTarget = (
    sptVirtualDesktop,
    sptVirtualDesktopTests,
    sptMcpStdioSidecar,
    sptMcpTests,
    sptGameLogicTests
  );

  TShowcaseProjectTargets = array of TShowcaseProjectTarget;

  TShowcaseOperationStatus = (
    sosSuccess,
    sosUnsupportedPlatform,
    sosExecutableUnavailable,
    sosAlreadyRunning,
    sosNotRunning,
    sosNotATestTarget,
    sosLaunchFailed,
    sosBuildFailed,
    sosTestFailed
  );

  TShowcaseOperationResult = record
    Status: TShowcaseOperationStatus;
    Detail: string;
    ProcessId: Integer;
  end;

  TVirtualDesktopProcessState = (
    vdpsUnsupportedPlatform,
    vdpsNotRunning,
    vdpsRunningOwned
  );

  TVirtualDesktopProcessStatus = record
    State: TVirtualDesktopProcessState;
    ProcessId: Integer;
  end;

  EShowcaseProjectCatalog = class(Exception);

  IShowcaseProjectCatalog = interface
    ['{E8C2B7E3-F343-4399-B5DB-E5BCDE154E0F}']
    function Targets: TShowcaseProjectTargets;
    function ProjectName(const ATarget: TShowcaseProjectTarget): string;
    function ProjectFile(const ATarget: TShowcaseProjectTarget): string;
    function IsTestTarget(const ATarget: TShowcaseProjectTarget): Boolean;
  end;

  ILazarusIdeLauncher = interface
    ['{A0BE9B28-922A-49B6-82B3-159952803A4C}']
    function OpenProject(const ATarget: TShowcaseProjectTarget):
      TShowcaseOperationResult;
  end;

  ILazarusBuildTestRunner = interface
    ['{B51DD0CE-419E-47F3-B2B6-F57E8140A3B2}']
    function BuildProject(const ATarget: TShowcaseProjectTarget):
      TShowcaseOperationResult;
    function RunProjectTests(const ATarget: TShowcaseProjectTarget):
      TShowcaseOperationResult;
  end;

  IVirtualDesktopProcessService = interface
    ['{D7A837B5-26DA-4DDF-A53E-C0647D3587DB}']
    function StartVirtualDesktop: TShowcaseOperationResult;
    function StopVirtualDesktop: TShowcaseOperationResult;
    function ProcessStatus: TVirtualDesktopProcessStatus;
  end;

function NewShowcaseOperationResult(const AStatus: TShowcaseOperationStatus;
  const ADetail: string; const AProcessId: Integer = 0): TShowcaseOperationResult;
function OperationSucceeded(const AResult: TShowcaseOperationResult): Boolean;
function IsVirtualDesktopProcessServiceOwned(
  const AStatus: TVirtualDesktopProcessStatus): Boolean;
function CanonicalShowcaseRoot: string;
function CanonicalShowcasePath(const APath: string): string;
function CanonicalShowcaseBinaryPath(const APath: string): string;
function IsWindowsPlatform: Boolean;

implementation

function NewShowcaseOperationResult(
  const AStatus: TShowcaseOperationStatus; const ADetail: string;
  const AProcessId: Integer): TShowcaseOperationResult;
begin
  Result.Status := AStatus;
  Result.Detail := ADetail;
  Result.ProcessId := AProcessId;
end;

function OperationSucceeded(const AResult: TShowcaseOperationResult): Boolean;
begin
  Result := AResult.Status = sosSuccess;
end;

function IsVirtualDesktopProcessServiceOwned(
  const AStatus: TVirtualDesktopProcessStatus): Boolean;
begin
  Result := AStatus.State = vdpsRunningOwned;
end;

function CanonicalShowcaseRoot: string;
begin
  Result := ExcludeTrailingPathDelimiter(ExpandFileName(ShowcaseRootDirectory));
end;

function CanonicalShowcasePath(const APath: string): string;
var
  RootDirectory, Candidate: string;
begin
  RootDirectory := CanonicalShowcaseRoot;
  Candidate := ExpandFileName(APath);
  if CompareText(Copy(Candidate, 1, Length(RootDirectory) + 1),
    IncludeTrailingPathDelimiter(RootDirectory)) <> 0 then
    raise EShowcaseProjectCatalog.Create('Path is outside the Showcase root.');
  Result := Candidate;
end;

function CanonicalShowcaseBinaryPath(const APath: string): string;
var
  BinaryDirectory, Candidate: string;
begin
  BinaryDirectory := ExcludeTrailingPathDelimiter(
    ExpandFileName(ShowcaseBinaryDirectory));
  Candidate := ExpandFileName(APath);
  if CompareText(Copy(Candidate, 1, Length(BinaryDirectory) + 1),
    IncludeTrailingPathDelimiter(BinaryDirectory)) <> 0 then
    raise EShowcaseProjectCatalog.Create(
      'Path is outside the controlled Showcase binary directory.');
  Result := Candidate;
end;

function IsWindowsPlatform: Boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := True;
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

end.
