unit LazarusBuildTestRunner;

{$mode objfpc}{$H+}

interface

uses
  LazarusProjectContracts;

type
  TLazarusBuildTestRunner = class(TInterfacedObject, ILazarusBuildTestRunner)
  private
    function ExecuteLazBuild(const ATarget: TShowcaseProjectTarget):
      TShowcaseOperationResult;
    function TestExecutable(const ATarget: TShowcaseProjectTarget): string;
  public
    function BuildProject(const ATarget: TShowcaseProjectTarget):
      TShowcaseOperationResult;
    function RunProjectTests(const ATarget: TShowcaseProjectTarget):
      TShowcaseOperationResult;
  end;

implementation

uses
  Process, SysUtils, LazarusProjectCatalog;

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

function TLazarusBuildTestRunner.ExecuteLazBuild(
  const ATarget: TShowcaseProjectTarget): TShowcaseOperationResult;
var
  Catalog: IShowcaseProjectCatalog;
  BuildProcess: TProcess;
  ProjectFile: string;
begin
  if not IsWindowsPlatform then
    Exit(NewShowcaseOperationResult(sosUnsupportedPlatform,
      'Lazarus builds are supported only on Windows.'));
  if not FileExists(LazarusBuildExecutable) then
    Exit(NewShowcaseOperationResult(sosExecutableUnavailable,
      'The configured lazbuild executable is unavailable.'));

  Catalog := TShowcaseProjectCatalog.Create;
  ProjectFile := CanonicalShowcasePath(Catalog.ProjectFile(ATarget));
  BuildProcess := TProcess.Create(nil);
  try
    BuildProcess.Executable := LazarusBuildExecutable;
    BuildProcess.CurrentDirectory := ExtractFileDir(ProjectFile);
    BuildProcess.Parameters.Add(ProjectFile);
    BuildProcess.Options := [poWaitOnExit];
    try
      BuildProcess.Execute;
      if BuildProcess.ExitStatus = 0 then
        Result := NewShowcaseOperationResult(sosSuccess,
          'Allowlisted Showcase project built successfully.')
      else
        Result := NewShowcaseOperationResult(sosBuildFailed,
          'lazbuild returned exit code ' + IntToStr(BuildProcess.ExitStatus) + '.');
    except
      on E: EProcess do
        Result := NewShowcaseOperationResult(sosBuildFailed, E.Message);
    end;
  finally
    BuildProcess.Free;
  end;
end;

function TLazarusBuildTestRunner.TestExecutable(
  const ATarget: TShowcaseProjectTarget): string;
begin
  case ATarget of
    sptVirtualDesktopTests:
      Result := CanonicalShowcaseBinaryPath(ShowcaseBinaryDirectory +
        '\' + CurrentTargetCpu + '-' + CurrentTargetOs +
        '\VirtualDesktopTests.exe');
    sptMcpTests:
      Result := CanonicalShowcaseBinaryPath(ShowcaseBinaryDirectory +
        '\' + CurrentTargetCpu + '-' + CurrentTargetOs +
        '\McpTests.exe');
    sptGameLogicTests:
      Result := CanonicalShowcaseBinaryPath(ShowcaseBinaryDirectory +
        '\' + CurrentTargetCpu + '-' + CurrentTargetOs +
        '\GameLogicTests.exe');
  else
    raise EShowcaseProjectCatalog.Create('Target does not define a test executable.');
  end;
end;

function TLazarusBuildTestRunner.BuildProject(
  const ATarget: TShowcaseProjectTarget): TShowcaseOperationResult;
begin
  Result := ExecuteLazBuild(ATarget);
end;

function TLazarusBuildTestRunner.RunProjectTests(
  const ATarget: TShowcaseProjectTarget): TShowcaseOperationResult;
var
  Catalog: IShowcaseProjectCatalog;
  BuildResult: TShowcaseOperationResult;
  TestProcess: TProcess;
  ExecutableFile: string;
begin
  Catalog := TShowcaseProjectCatalog.Create;
  if not Catalog.IsTestTarget(ATarget) then
    Exit(NewShowcaseOperationResult(sosNotATestTarget,
      'The allowlisted target is not a test project.'));

  BuildResult := ExecuteLazBuild(ATarget);
  if not OperationSucceeded(BuildResult) then
    Exit(BuildResult);
  ExecutableFile := TestExecutable(ATarget);
  if not FileExists(ExecutableFile) then
    Exit(NewShowcaseOperationResult(sosTestFailed,
      'The controlled test executable was not produced by lazbuild.'));

  TestProcess := TProcess.Create(nil);
  try
    TestProcess.Executable := ExecutableFile;
    TestProcess.CurrentDirectory := ExtractFileDir(ExecutableFile);
    TestProcess.Options := [poWaitOnExit];
    try
      TestProcess.Execute;
      if TestProcess.ExitStatus = 0 then
        Result := NewShowcaseOperationResult(sosSuccess,
          'Allowlisted Showcase tests passed.')
      else
        Result := NewShowcaseOperationResult(sosTestFailed,
          'Test executable returned exit code ' +
          IntToStr(TestProcess.ExitStatus) + '.');
    except
      on E: EProcess do
        Result := NewShowcaseOperationResult(sosTestFailed, E.Message);
    end;
  finally
    TestProcess.Free;
  end;
end;

end.
