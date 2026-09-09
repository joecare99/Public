unit DesktopMcpBridge;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fpjson, McpCommand, McpDesktopBridge;

type
  TDesktopMcpApplicationNames = array of string;

  IDesktopMcpShell = interface
    ['{6E18BCB1-4060-421A-B3CE-6941955E5EBD}']
    function IsRunning: Boolean;
    function ActiveWindowTitle: string;
    function OpenWindowCount: Integer;
    function ApplicationNames: TDesktopMcpApplicationNames;
    function HasApplication(const AName: string): Boolean;
    procedure OpenApplication(const AName: string);
  end;

  TDesktopMcpBridge = class(TInterfacedObject, IMcpDesktopCommandBridge)
  private
    FShell: IDesktopMcpShell;
    function EmptySchema: TJSONObject;
    function OpenApplicationSchema: TJSONObject;
    function ToolDefinition(const AName, ADescription: string;
      const ASchema: TJSONObject): TJSONObject;
    procedure ValidateArguments(const AName: string;
      const AArguments: TJSONObject);
    function StatusResult: TMcpCommandResult;
    function ApplicationsResult: TMcpCommandResult;
    function OpenApplicationResult(const AArguments: TJSONObject):
      TMcpCommandResult;
  public
    constructor Create(const AShell: IDesktopMcpShell);
    function IsAvailable: Boolean;
    function HasDesktopTool(const AName: string): Boolean;
    function ListDesktopTools: TJSONArray;
    function CallDesktopTool(const AName: string;
      const AArguments: TJSONObject; const AContext: TMcpCommandContext):
      TMcpCommandResult;
  end;

implementation

constructor TDesktopMcpBridge.Create(const AShell: IDesktopMcpShell);
begin
  inherited Create;
  if AShell = nil then
    raise EMcpInvalidCommand.Create('A live desktop shell is required.');
  FShell := AShell;
end;

function TDesktopMcpBridge.EmptySchema: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('type', 'object');
  Result.Add('additionalProperties', False);
end;

function TDesktopMcpBridge.OpenApplicationSchema: TJSONObject;
var
  Properties, NameSchema: TJSONObject;
  Required: TJSONArray;
begin
  Result := EmptySchema;
  Properties := TJSONObject.Create;
  NameSchema := TJSONObject.Create;
  NameSchema.Add('type', 'string');
  Properties.Add('name', NameSchema);
  Result.Add('properties', Properties);
  Required := TJSONArray.Create;
  Required.Add('name');
  Result.Add('required', Required);
end;

function TDesktopMcpBridge.ToolDefinition(const AName, ADescription: string;
  const ASchema: TJSONObject): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.Add('name', AName);
  Result.Add('description', ADescription);
  Result.Add('inputSchema', ASchema);
end;

function TDesktopMcpBridge.IsAvailable: Boolean;
begin
  Result := (FShell <> nil) and FShell.IsRunning;
end;

function TDesktopMcpBridge.HasDesktopTool(const AName: string): Boolean;
begin
  Result := IsAvailable and ((AName = 'desktop.status') or
    (AName = 'desktop.apps.list') or (AName = 'desktop.apps.open'));
end;

function TDesktopMcpBridge.ListDesktopTools: TJSONArray;
begin
  Result := TJSONArray.Create;
  try
    if not IsAvailable then
      Exit;
    Result.Add(ToolDefinition('desktop.status',
      'Returns live VirtualDesktop shell status without workspace contents.',
      EmptySchema));
    Result.Add(ToolDefinition('desktop.apps.list',
      'Lists applications registered in the live VirtualDesktop shell.',
      EmptySchema));
    Result.Add(ToolDefinition('desktop.apps.open',
      'Opens one application registered in the live VirtualDesktop shell.',
      OpenApplicationSchema));
  except
    Result.Free;
    raise;
  end;
end;

procedure TDesktopMcpBridge.ValidateArguments(const AName: string;
  const AArguments: TJSONObject);
var
  Schema: TJSONObject;
begin
  Schema := nil;
  try
    if (AName = 'desktop.status') or (AName = 'desktop.apps.list') then
      Schema := EmptySchema
    else if AName = 'desktop.apps.open' then
      Schema := OpenApplicationSchema
    else
      raise EMcpToolNotFound.CreateFmt('Unknown MCP tool "%s".', [AName]);
    ValidateMcpToolArguments(Schema, AArguments);
  finally
    Schema.Free;
  end;
end;

function TDesktopMcpBridge.StatusResult: TMcpCommandResult;
var
  Data: TJSONObject;
begin
  Data := TJSONObject.Create;
  try
    Data.Add('available', True);
    Data.Add('activeWindow', FShell.ActiveWindowTitle);
    Data.Add('openWindowCount', FShell.OpenWindowCount);
    Data.Add('applicationCount', Length(FShell.ApplicationNames));
    Result := TMcpCommandResult.Json(Data);
    Data := nil;
  finally
    Data.Free;
  end;
end;

function TDesktopMcpBridge.ApplicationsResult: TMcpCommandResult;
var
  Data: TJSONObject;
  Applications: TJSONArray;
  Names: TDesktopMcpApplicationNames;
  I: Integer;
begin
  Names := FShell.ApplicationNames;
  Data := TJSONObject.Create;
  try
    Applications := TJSONArray.Create;
    for I := 0 to High(Names) do
      Applications.Add(Names[I]);
    Data.Add('applications', Applications);
    Data.Add('count', Length(Names));
    Result := TMcpCommandResult.Json(Data);
    Data := nil;
  finally
    Data.Free;
  end;
end;

function TDesktopMcpBridge.OpenApplicationResult(
  const AArguments: TJSONObject): TMcpCommandResult;
var
  ApplicationName: string;
  Data: TJSONObject;
  I: Integer;
begin
  ApplicationName := AArguments.Find('name', jtString).AsString;
  if (Trim(ApplicationName) = '') or (Length(ApplicationName) > 96) then
    raise EMcpInvalidParams.Create('The application name is invalid.');
  for I := 1 to Length(ApplicationName) do
    if Ord(ApplicationName[I]) < 32 then
      raise EMcpInvalidParams.Create('The application name is invalid.');
  if not FShell.HasApplication(ApplicationName) then
    raise EMcpToolNotFound.CreateFmt('Application "%s" is not registered.',
      [ApplicationName]);
  FShell.OpenApplication(ApplicationName);
  Data := TJSONObject.Create;
  try
    Data.Add('application', ApplicationName);
    Data.Add('opened', True);
    Result := TMcpCommandResult.Json(Data);
    Data := nil;
  finally
    Data.Free;
  end;
end;

function TDesktopMcpBridge.CallDesktopTool(const AName: string;
  const AArguments: TJSONObject; const AContext: TMcpCommandContext):
  TMcpCommandResult;
begin
  if AContext = nil then
    raise EMcpInvalidCommand.Create('An MCP command context is required.');
  AContext.RequireScope(mcsDesktop);
  if not IsAvailable then
    raise EMcpCommandFailed.Create('The live desktop shell is not available.');
  ValidateArguments(AName, AArguments);
  try
    if AName = 'desktop.status' then
      Exit(StatusResult);
    if AName = 'desktop.apps.list' then
      Exit(ApplicationsResult);
    if AName = 'desktop.apps.open' then
      Exit(OpenApplicationResult(AArguments));
    raise EMcpToolNotFound.CreateFmt('Unknown MCP tool "%s".', [AName]);
  except
    on E: EMcpError do
      raise;
    on E: Exception do
      raise EMcpCommandFailed.Create('The live desktop command failed.');
  end;
end;

end.
