unit LazarusMcpBridge;

{$mode objfpc}{$H+}

interface

uses
  fpjson, McpCommand, LazarusProjectContracts;

type
  IMcpLazarusCommandBridge = interface
    ['{B1B7A1CF-2D5A-4C2D-9DB2-B3A5CF5AA190}']
    function IsAvailable: Boolean;
    function HasLazarusTool(const AName: string): Boolean;
    function ListLazarusTools: TJSONArray;
    function CallLazarusTool(const AName: string; const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult;
  end;

  TLazarusMcpBridge = class(TInterfacedObject, IMcpLazarusCommandBridge)
  private
    FCatalog: IShowcaseProjectCatalog;
    FLauncher: ILazarusIdeLauncher;
    FRunner: ILazarusBuildTestRunner;
    FDesktop: IVirtualDesktopProcessService;
    function EmptySchema: TJSONObject;
    function ProjectSchema: TJSONObject;
    function Tool(const N, D: string; S: TJSONObject): TJSONObject;
    function Target(const AArguments: TJSONObject): TShowcaseProjectTarget;
    function TargetName(const T: TShowcaseProjectTarget): string;
    function Status: TMcpCommandResult;
    function Projects: TMcpCommandResult;
    function Operation(const R: TShowcaseOperationResult): TMcpCommandResult;
  public
    constructor Create(const ACatalog: IShowcaseProjectCatalog;
      const ALauncher: ILazarusIdeLauncher;
      const ARunner: ILazarusBuildTestRunner;
      const ADesktop: IVirtualDesktopProcessService);
    function IsAvailable: Boolean;
    function HasLazarusTool(const AName: string): Boolean;
    function ListLazarusTools: TJSONArray;
    function CallLazarusTool(const AName: string; const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult;
  end;

implementation

constructor TLazarusMcpBridge.Create(const ACatalog: IShowcaseProjectCatalog;
  const ALauncher: ILazarusIdeLauncher; const ARunner: ILazarusBuildTestRunner;
  const ADesktop: IVirtualDesktopProcessService);
begin
  inherited Create;
  if (ACatalog = nil) or (ALauncher = nil) or (ARunner = nil) or
     (ADesktop = nil) then
    raise EMcpInvalidCommand.Create('Lazarus bridge contracts are required.');
  FCatalog := ACatalog;
  FLauncher := ALauncher;
  FRunner := ARunner;
  FDesktop := ADesktop;
end;

function TLazarusMcpBridge.IsAvailable: Boolean;
begin
  Result := True;
end;

function TLazarusMcpBridge.HasLazarusTool(const AName: string): Boolean;
begin
  Result := (AName = 'lazarus.status') or (AName = 'lazarus.projects.list') or
    (AName = 'lazarus.project.open') or (AName = 'lazarus.project.build') or
    (AName = 'lazarus.tests.run') or (AName = 'lazarus.desktop.start') or
    (AName = 'lazarus.desktop.stop');
end;

function TLazarusMcpBridge.EmptySchema: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('type', 'object');
  Result.Add('additionalProperties', False);
end;

function TLazarusMcpBridge.ProjectSchema: TJSONObject;
var
  P: TJSONObject;
  R: TJSONArray;
begin
  Result := EmptySchema;
  P := TJSONObject.Create;
  P.Add('project', TJSONObject.Create);
  TJSONObject(P.Find('project')).Add('type', 'string');
  Result.Add('properties', P);
  R := TJSONArray.Create;
  R.Add('project');
  Result.Add('required', R);
end;

function TLazarusMcpBridge.Tool(const N, D: string; S: TJSONObject): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('name', N);
  Result.Add('description', D);
  Result.Add('inputSchema', S);
end;

function TLazarusMcpBridge.TargetName(const T: TShowcaseProjectTarget): string;
begin
  case T of
    sptVirtualDesktop: Result := 'virtual-desktop';
    sptVirtualDesktopTests: Result := 'virtual-desktop-tests';
    sptMcpStdioSidecar: Result := 'mcp-stdio-sidecar';
    sptMcpTests: Result := 'mcp-tests';
    sptGameLogicTests: Result := 'game-logic-tests';
  end;
end;

function TLazarusMcpBridge.Target(const AArguments: TJSONObject):
  TShowcaseProjectTarget;
var
  N: string;
  T: TShowcaseProjectTarget;
begin
  N := AArguments.Find('project', jtString).AsString;
  for T := Low(TShowcaseProjectTarget) to High(TShowcaseProjectTarget) do
    if N = TargetName(T) then
      Exit(T);
  raise EMcpInvalidParams.Create('The Lazarus project is not allowlisted.');
end;

function TLazarusMcpBridge.Status: TMcpCommandResult;
var
  D: TJSONObject;
  S: TVirtualDesktopProcessStatus;
begin
  S := FDesktop.ProcessStatus;
  D := TJSONObject.Create;
  if IsWindowsPlatform then
    D.Add('platform', 'windows')
  else
    D.Add('platform', 'unsupported');
  D.Add('desktopState', Ord(S.State));
  D.Add('desktopProcessId', S.ProcessId);
  Result := TMcpCommandResult.Json(D);
end;

function TLazarusMcpBridge.Projects: TMcpCommandResult;
var
  D: TJSONObject;
  A: TJSONArray;
  T: TShowcaseProjectTarget;
begin
  D := TJSONObject.Create;
  A := TJSONArray.Create;
  for T := Low(TShowcaseProjectTarget) to High(TShowcaseProjectTarget) do
    A.Add(TargetName(T));
  D.Add('projects', A);
  Result := TMcpCommandResult.Json(D);
end;

function TLazarusMcpBridge.Operation(const R: TShowcaseOperationResult):
  TMcpCommandResult;
var
  D: TJSONObject;
begin
  D := TJSONObject.Create;
  D.Add('status', Ord(R.Status));
  D.Add('detail', R.Detail);
  D.Add('processId', R.ProcessId);
  Result := TMcpCommandResult.Json(D);
end;

function TLazarusMcpBridge.ListLazarusTools: TJSONArray;
begin
  Result := TJSONArray.Create;
  Result.Add(Tool('lazarus.status', 'Returns Lazarus bridge and desktop status.',
    EmptySchema));
  Result.Add(Tool('lazarus.projects.list', 'Lists allowlisted Showcase projects.',
    EmptySchema));
  Result.Add(Tool('lazarus.project.open', 'Opens an allowlisted project in Lazarus.',
    ProjectSchema));
  Result.Add(Tool('lazarus.project.build', 'Builds an allowlisted Lazarus project.',
    ProjectSchema));
  Result.Add(Tool('lazarus.tests.run', 'Runs tests for an allowlisted test project.',
    ProjectSchema));
  Result.Add(Tool('lazarus.desktop.start', 'Starts the owned VirtualDesktop process.',
    EmptySchema));
  Result.Add(Tool('lazarus.desktop.stop', 'Stops only the owned VirtualDesktop process.',
    EmptySchema));
end;

function TLazarusMcpBridge.CallLazarusTool(const AName: string;
  const AArguments: TJSONObject; const AContext: TMcpCommandContext):
  TMcpCommandResult;
var
  T: TShowcaseProjectTarget;
  S: TJSONObject;
begin
  if AContext = nil then
    raise EMcpInvalidCommand.Create('An MCP command context is required.');
  AContext.RequireScope(mcsLazarus);
  if not HasLazarusTool(AName) then
    raise EMcpToolNotFound.CreateFmt('Unknown MCP tool "%s".', [AName]);
  if (AName = 'lazarus.project.open') or (AName = 'lazarus.project.build') or
     (AName = 'lazarus.tests.run') then
    S := ProjectSchema
  else
    S := EmptySchema;
  try
    ValidateMcpToolArguments(S, AArguments);
  finally
    S.Free;
  end;
  if AName = 'lazarus.status' then Exit(Status);
  if AName = 'lazarus.projects.list' then Exit(Projects);
  if AName = 'lazarus.desktop.start' then Exit(Operation(FDesktop.StartVirtualDesktop));
  if AName = 'lazarus.desktop.stop' then Exit(Operation(FDesktop.StopVirtualDesktop));
  T := Target(AArguments);
  if AName = 'lazarus.project.open' then Exit(Operation(FLauncher.OpenProject(T)));
  if AName = 'lazarus.project.build' then Exit(Operation(FRunner.BuildProject(T)));
  Result := Operation(FRunner.RunProjectTests(T));
end;

end.
