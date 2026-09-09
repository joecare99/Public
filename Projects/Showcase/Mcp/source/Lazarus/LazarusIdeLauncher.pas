unit LazarusIdeLauncher;

{$mode objfpc}{$H+}

interface

uses
  LazarusProjectContracts;

type
  TLazarusIdeLauncher = class(TInterfacedObject, ILazarusIdeLauncher)
  public
    function OpenProject(const ATarget: TShowcaseProjectTarget):
      TShowcaseOperationResult;
  end;

implementation

uses
  Process, SysUtils, LazarusProjectCatalog;

function TLazarusIdeLauncher.OpenProject(
  const ATarget: TShowcaseProjectTarget): TShowcaseOperationResult;
var
  Catalog: IShowcaseProjectCatalog;
  LazarusProcess: TProcess;
  ProjectFile: string;
begin
  if not IsWindowsPlatform then
    Exit(NewShowcaseOperationResult(sosUnsupportedPlatform,
      'Lazarus IDE launching is supported only on Windows.'));
  if not FileExists(LazarusIdeExecutable) then
    Exit(NewShowcaseOperationResult(sosExecutableUnavailable,
      'The configured Lazarus IDE executable is unavailable.'));

  Catalog := TShowcaseProjectCatalog.Create;
  ProjectFile := CanonicalShowcasePath(Catalog.ProjectFile(ATarget));
  LazarusProcess := TProcess.Create(nil);
  try
    LazarusProcess.Executable := LazarusIdeExecutable;
    LazarusProcess.CurrentDirectory := CanonicalShowcaseRoot;
    LazarusProcess.Parameters.Add(ProjectFile);
    try
      LazarusProcess.Execute;
      Result := NewShowcaseOperationResult(sosSuccess,
        'Lazarus IDE was started for the allowlisted project.',
        LazarusProcess.ProcessID);
    except
      on E: EProcess do
        Result := NewShowcaseOperationResult(sosLaunchFailed, E.Message);
    end;
  finally
    LazarusProcess.Free;
  end;
end;

end.
