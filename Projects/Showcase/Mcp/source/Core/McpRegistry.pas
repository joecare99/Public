unit McpRegistry;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, McpCommand, McpDesktopBridge,
  LazarusMcpBridge;

type
  TMcpCommandRegistry = class
  private
    FCommands: array of IMcpCommand;
    function GetCount: Integer;
    function GetCommand(const AIndex: Integer): IMcpCommand;
    function FindIndex(const AName: string): Integer;
    procedure ValidateCommandContract(const ACommand: IMcpCommand);
    function ToolDefinition(const ACommand: IMcpCommand): TJSONObject;
  public
    procedure RegisterCommand(const ACommand: IMcpCommand);
    function UnregisterCommand(const AName: string): Boolean;
    function FindCommand(const AName: string): IMcpCommand;
    function ListTools: TJSONArray;
    function CallTool(const AName: string; const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult;
    property Count: Integer read GetCount;
    property Commands[const AIndex: Integer]: IMcpCommand read GetCommand;
  end;

  TMcpCommandRouter = class(TInterfacedObject, IMcpToolClient)
  private
    FGlobalRegistry: TMcpCommandRegistry;
    FApplicationRegistry: TMcpCommandRegistry;
    FContext: TMcpCommandContext;
    FDesktopBridge: IMcpDesktopCommandBridge;
    FLazarusBridge: IMcpLazarusCommandBridge;
    function FindInRegistries(const AName: string): IMcpCommand;
    procedure AddCommandToTools(const ACommand: IMcpCommand;
      const ANames: TStringList; const ATools: TJSONArray);
    procedure AddRegistryToTools(const ARegistry: TMcpCommandRegistry;
      const ANames: TStringList; const ATools: TJSONArray);
    procedure AddDesktopBridgeTools(const ANames: TStringList;
      const ATools: TJSONArray);
    function DesktopBridgeAvailable: Boolean;
    function DesktopBridgeHasTool(const AName: string): Boolean;
  public
    constructor Create(const AGlobalRegistry, AApplicationRegistry:
      TMcpCommandRegistry; const AContext: TMcpCommandContext); overload;
    constructor Create(const AGlobalRegistry, AApplicationRegistry:
      TMcpCommandRegistry; const AContext: TMcpCommandContext;
      const ADesktopBridge: IMcpDesktopCommandBridge); overload;
    constructor Create(const AGlobalRegistry, AApplicationRegistry:
      TMcpCommandRegistry; const AContext: TMcpCommandContext;
      const ADesktopBridge: IMcpDesktopCommandBridge;
      const ALazarusBridge: IMcpLazarusCommandBridge); overload;
    function ListTools: TJSONArray;
    function CallTool(const AName: string; const AArguments: TJSONObject):
      TMcpCommandResult;
  end;

function GlobalMcpCommandRegistry: TMcpCommandRegistry;
function ApplicationMcpCommandRegistry: TMcpCommandRegistry;
procedure RegisterGlobalMcpCommand(const ACommand: IMcpCommand);
procedure RegisterApplicationMcpCommand(const ACommand: IMcpCommand);

implementation

var
  GGlobalRegistry: TMcpCommandRegistry;
  GApplicationRegistry: TMcpCommandRegistry;

procedure ValidateToolDescription(const ADescription: string);
var
  I: Integer;
begin
  if (Trim(ADescription) = '') or (Length(ADescription) > 1024) then
    raise EMcpInvalidCommand.Create(
      'MCP tool descriptions must be between 1 and 1024 characters.');
  for I := 1 to Length(ADescription) do
    if Ord(ADescription[I]) < 32 then
      raise EMcpInvalidCommand.Create(
        'MCP tool descriptions cannot contain control characters.');
end;

procedure ValidateCallName(const AName: string);
begin
  if not IsValidMcpToolName(AName) then
    raise EMcpInvalidParams.Create('The MCP tool name is invalid.');
  if (Copy(AName, 1, Length('workspace.')) <> 'workspace.') and
     (Copy(AName, 1, Length('desktop.')) <> 'desktop.') and
     (Copy(AName, 1, Length('lazarus.')) <> 'lazarus.') then
    raise EMcpInvalidParams.Create('The MCP tool namespace is not allowed.');
end;

function ExecuteValidatedCommand(const ACommand: IMcpCommand;
  const AArguments: TJSONObject; const AContext: TMcpCommandContext):
  TMcpCommandResult;
var
  Schema: TJSONObject;
begin
  if ACommand = nil then
    raise EMcpToolNotFound.Create('The requested MCP tool is not available.');
  if AContext = nil then
    raise EMcpInvalidCommand.Create('An MCP command context is required.');
  AContext.RequireScope(ACommand.Scope);
  Schema := nil;
  try
    try
      Schema := ACommand.InputSchema;
      ValidateMcpToolArguments(Schema, AArguments);
      Result := ACommand.Execute(AArguments, AContext);
    except
      on E: EMcpError do
        raise;
      on E: Exception do
        raise EMcpCommandFailed.Create('The MCP tool execution failed.');
    end;
  finally
    Schema.Free;
  end;
  if Result = nil then
    raise EMcpCommandFailed.Create('The MCP tool returned no result.');
end;

function TMcpCommandRegistry.GetCount: Integer;
begin
  Result := Length(FCommands);
end;

function TMcpCommandRegistry.GetCommand(const AIndex: Integer): IMcpCommand;
begin
  if (AIndex < 0) or (AIndex >= Length(FCommands)) then
    raise ERangeError.CreateFmt('MCP command index %d is out of range.',
      [AIndex]);
  Result := FCommands[AIndex];
end;

function TMcpCommandRegistry.FindIndex(const AName: string): Integer;
var
  I: Integer;
begin
  for I := 0 to High(FCommands) do
    if FCommands[I].CommandName = AName then
      Exit(I);
  Result := -1;
end;

procedure TMcpCommandRegistry.ValidateCommandContract(
  const ACommand: IMcpCommand);
var
  Schema: TJSONObject;
begin
  if ACommand = nil then
    raise EMcpInvalidCommand.Create('An MCP command is required.');
  ValidateMcpToolName(ACommand.CommandName);
  if McpToolNamespace(ACommand.CommandName) <>
     McpScopeNamespace(ACommand.Scope) then
    raise EMcpInvalidCommand.Create(
      'The MCP tool namespace must match its command scope.');
  ValidateToolDescription(ACommand.Description);
  Schema := nil;
  try
    try
      Schema := ACommand.InputSchema;
      ValidateMcpInputSchema(Schema);
    except
      on E: EMcpError do
        raise;
      on E: Exception do
        raise EMcpInvalidCommand.Create('The MCP input schema is invalid.');
    end;
  finally
    Schema.Free;
  end;
end;

function TMcpCommandRegistry.ToolDefinition(
  const ACommand: IMcpCommand): TJSONObject;
var
  Schema: TJSONObject;
begin
  ValidateCommandContract(ACommand);
  Schema := nil;
  Result := nil;
  try
    try
      Schema := ACommand.InputSchema;
      ValidateMcpInputSchema(Schema);
      Result := TJSONObject.Create;
      Result.Add('name', ACommand.CommandName);
      Result.Add('description', ACommand.Description);
      Result.Add('inputSchema', Schema);
      Schema := nil;
    except
      Result.Free;
      raise;
    end;
  finally
    Schema.Free;
  end;
end;

procedure TMcpCommandRegistry.RegisterCommand(const ACommand: IMcpCommand);
var
  Index: Integer;
begin
  ValidateCommandContract(ACommand);
  Index := FindIndex(ACommand.CommandName);
  if Index >= 0 then
    raise EMcpInvalidCommand.CreateFmt('MCP command "%s" is already registered.',
      [ACommand.CommandName]);
  SetLength(FCommands, Length(FCommands) + 1);
  FCommands[High(FCommands)] := ACommand;
end;

function TMcpCommandRegistry.UnregisterCommand(const AName: string): Boolean;
var
  Index, I: Integer;
begin
  Index := FindIndex(AName);
  if Index < 0 then
    Exit(False);
  for I := Index to High(FCommands) - 1 do
    FCommands[I] := FCommands[I + 1];
  SetLength(FCommands, Length(FCommands) - 1);
  Result := True;
end;

function TMcpCommandRegistry.FindCommand(const AName: string): IMcpCommand;
var
  Index: Integer;
begin
  Index := FindIndex(AName);
  if Index < 0 then
    Exit(nil);
  Result := FCommands[Index];
end;

function TMcpCommandRegistry.ListTools: TJSONArray;
var
  I: Integer;
begin
  Result := TJSONArray.Create;
  try
    for I := 0 to High(FCommands) do
      Result.Add(ToolDefinition(FCommands[I]));
  except
    Result.Free;
    raise;
  end;
end;

function TMcpCommandRegistry.CallTool(const AName: string;
  const AArguments: TJSONObject; const AContext: TMcpCommandContext):
  TMcpCommandResult;
var
  Command: IMcpCommand;
begin
  ValidateCallName(AName);
  if AArguments = nil then
    raise EMcpInvalidParams.Create('Tool arguments must be an object.');
  Command := FindCommand(AName);
  if Command = nil then
    raise EMcpToolNotFound.CreateFmt('Unknown MCP tool "%s".', [AName]);
  Result := ExecuteValidatedCommand(Command, AArguments, AContext);
end;

constructor TMcpCommandRouter.Create(const AGlobalRegistry,
  AApplicationRegistry: TMcpCommandRegistry; const AContext: TMcpCommandContext);
begin
  inherited Create;
  if AContext = nil then
    raise EMcpInvalidCommand.Create('An MCP command context is required.');
  FGlobalRegistry := AGlobalRegistry;
  FApplicationRegistry := AApplicationRegistry;
  FContext := AContext;
  FDesktopBridge := nil;
  FLazarusBridge := nil;
end;

constructor TMcpCommandRouter.Create(const AGlobalRegistry,
  AApplicationRegistry: TMcpCommandRegistry; const AContext: TMcpCommandContext;
  const ADesktopBridge: IMcpDesktopCommandBridge);
begin
  inherited Create;
  if AContext = nil then
    raise EMcpInvalidCommand.Create('An MCP command context is required.');
  FGlobalRegistry := AGlobalRegistry;
  FApplicationRegistry := AApplicationRegistry;
  FContext := AContext;
  FDesktopBridge := ADesktopBridge;
  FLazarusBridge := nil;
end;

constructor TMcpCommandRouter.Create(const AGlobalRegistry,
  AApplicationRegistry: TMcpCommandRegistry; const AContext: TMcpCommandContext;
  const ADesktopBridge: IMcpDesktopCommandBridge;
  const ALazarusBridge: IMcpLazarusCommandBridge);
begin
  inherited Create;
  if AContext = nil then
    raise EMcpInvalidCommand.Create('An MCP command context is required.');
  FGlobalRegistry := AGlobalRegistry;
  FApplicationRegistry := AApplicationRegistry;
  FContext := AContext;
  FDesktopBridge := ADesktopBridge;
  FLazarusBridge := ALazarusBridge;
end;

function TMcpCommandRouter.DesktopBridgeAvailable: Boolean;
begin
  if FDesktopBridge = nil then
    Exit(False);
  try
    Result := FDesktopBridge.IsAvailable;
  except
    on E: EMcpError do
      raise;
    on E: Exception do
      raise EMcpCommandFailed.Create(
        'The desktop bridge availability check failed.');
  end;
end;

function TMcpCommandRouter.DesktopBridgeHasTool(const AName: string): Boolean;
begin
  try
    Result := FDesktopBridge.HasDesktopTool(AName);
  except
    on E: EMcpError do
      raise;
    on E: Exception do
      raise EMcpCommandFailed.Create(
        'The desktop bridge could not resolve the tool.');
  end;
end;

function TMcpCommandRouter.FindInRegistries(const AName: string): IMcpCommand;
begin
  Result := nil;
  if FApplicationRegistry <> nil then
    Result := FApplicationRegistry.FindCommand(AName);
  if (Result = nil) and (FGlobalRegistry <> nil) then
    Result := FGlobalRegistry.FindCommand(AName);
end;

procedure TMcpCommandRouter.AddCommandToTools(const ACommand: IMcpCommand;
  const ANames: TStringList; const ATools: TJSONArray);
var
  Tool: TJSONObject;
begin
  if (ACommand = nil) or not FContext.AllowsScope(ACommand.Scope) or
     (ANames.IndexOf(ACommand.CommandName) >= 0) then
    Exit;
  Tool := nil;
  try
    Tool := TJSONObject.Create;
    Tool.Add('name', ACommand.CommandName);
    Tool.Add('description', ACommand.Description);
    Tool.Add('inputSchema', ACommand.InputSchema);
    ValidateMcpToolName(ACommand.CommandName);
    if McpToolNamespace(ACommand.CommandName) <>
       McpScopeNamespace(ACommand.Scope) then
      raise EMcpInvalidCommand.Create(
        'The MCP tool namespace must match its command scope.');
    ValidateToolDescription(ACommand.Description);
    ValidateMcpInputSchema(TJSONObject(Tool.Find('inputSchema', jtObject)));
    ANames.Add(ACommand.CommandName);
    ATools.Add(Tool);
    Tool := nil;
  finally
    Tool.Free;
  end;
end;

procedure TMcpCommandRouter.AddRegistryToTools(
  const ARegistry: TMcpCommandRegistry; const ANames: TStringList;
  const ATools: TJSONArray);
var
  I: Integer;
begin
  if ARegistry = nil then
    Exit;
  for I := 0 to ARegistry.Count - 1 do
    AddCommandToTools(ARegistry.Commands[I], ANames, ATools);
end;

procedure TMcpCommandRouter.AddDesktopBridgeTools(const ANames: TStringList;
  const ATools: TJSONArray);
var
  BridgeTools: TJSONArray;
  I: Integer;
  Tool, Schema: TJSONObject;
  NameValue, DescriptionValue: TJSONData;
begin
  if not FContext.AllowsScope(mcsDesktop) or not DesktopBridgeAvailable then Exit;
  BridgeTools := FDesktopBridge.ListDesktopTools;
  try
    for I := 0 to BridgeTools.Count - 1 do
    begin
      Tool := TJSONObject(BridgeTools.Items[I]);
      NameValue := Tool.Find('name', jtString);
      DescriptionValue := Tool.Find('description', jtString);
      Schema := TJSONObject(Tool.Find('inputSchema', jtObject));
      if (NameValue = nil) or (DescriptionValue = nil) or (Schema = nil) then
        raise EMcpCommandFailed.Create('The desktop bridge returned an incomplete tool definition.');
      ValidateMcpToolName(NameValue.AsString);
      if McpToolNamespace(NameValue.AsString) <> 'desktop' then
        raise EMcpCommandFailed.Create('The desktop bridge returned a non-desktop tool.');
      ValidateToolDescription(DescriptionValue.AsString);
      ValidateMcpInputSchema(Schema);
      if ANames.IndexOf(NameValue.AsString) < 0 then
      begin
        ANames.Add(NameValue.AsString);
        ATools.Add(Tool.Clone);
      end;
    end;
  finally
    BridgeTools.Free;
  end;
end;

procedure AddLazarusBridgeTools(const ABridge: IMcpLazarusCommandBridge;
  const AContext: TMcpCommandContext; const ANames: TStringList;
  const ATools: TJSONArray);
var
  BridgeTools: TJSONArray;
  I: Integer;
  Tool: TJSONObject;
  NameValue, DescriptionValue, Schema: TJSONData;
begin
  if (ABridge = nil) or not AContext.AllowsScope(mcsLazarus) or
     not ABridge.IsAvailable then Exit;
  BridgeTools := ABridge.ListLazarusTools;
  try
    for I := 0 to BridgeTools.Count - 1 do
    begin
      Tool := TJSONObject(BridgeTools.Items[I]);
      NameValue := Tool.Find('name', jtString);
      DescriptionValue := Tool.Find('description', jtString);
      Schema := Tool.Find('inputSchema', jtObject);
      if (NameValue = nil) or (DescriptionValue = nil) or (Schema = nil) or
         (McpToolNamespace(NameValue.AsString) <> 'lazarus') then
        raise EMcpCommandFailed.Create('The Lazarus bridge returned an invalid tool.');
      ValidateMcpToolName(NameValue.AsString);
      ValidateMcpInputSchema(TJSONObject(Schema));
      if ANames.IndexOf(NameValue.AsString) < 0 then
      begin
        ANames.Add(NameValue.AsString);
        ATools.Add(Tool.Clone);
      end;
    end;
  finally
    BridgeTools.Free;
  end;
end;
function TMcpCommandRouter.ListTools: TJSONArray;
var
  Names: TStringList;
begin
  Result := TJSONArray.Create;
  Names := TStringList.Create;
  try
    try
      Names.CaseSensitive := True;
      AddDesktopBridgeTools(Names, Result);
      AddLazarusBridgeTools(FLazarusBridge, FContext, Names, Result);
      AddRegistryToTools(FApplicationRegistry, Names, Result);
      AddRegistryToTools(FGlobalRegistry, Names, Result);
    except
      Result.Free;
      raise;
    end;
  finally
    Names.Free;
  end;
end;

function TMcpCommandRouter.CallTool(const AName: string;
  const AArguments: TJSONObject): TMcpCommandResult;
var
  Command: IMcpCommand;
begin
  ValidateCallName(AName);
  if AArguments = nil then
    raise EMcpInvalidParams.Create('Tool arguments must be an object.');
  if McpToolNamespace(AName) = 'desktop' then
  begin
    FContext.RequireScope(mcsDesktop);
    if DesktopBridgeAvailable and DesktopBridgeHasTool(AName) then
    begin
      try
        Result := FDesktopBridge.CallDesktopTool(AName, AArguments, FContext);
      except
        on E: EMcpError do
          raise;
        on E: Exception do
          raise EMcpCommandFailed.Create(
            'The desktop bridge could not call the tool.');
      end;
      if Result = nil then
        raise EMcpCommandFailed.Create(
          'The desktop bridge returned no result.');
      Exit;
    end;
  end;
  if (McpToolNamespace(AName) = 'lazarus') and
     (FLazarusBridge <> nil) and FLazarusBridge.IsAvailable and
     FLazarusBridge.HasLazarusTool(AName) then
  begin
    FContext.RequireScope(mcsLazarus);
    Result := FLazarusBridge.CallLazarusTool(AName, AArguments, FContext);
    if Result = nil then
      raise EMcpCommandFailed.Create('The Lazarus bridge returned no result.');
    Exit;
  end;
  Command := FindInRegistries(AName);
  if Command = nil then
    raise EMcpToolNotFound.CreateFmt('Unknown MCP tool "%s".', [AName]);
  Result := ExecuteValidatedCommand(Command, AArguments, FContext);
end;

function GlobalMcpCommandRegistry: TMcpCommandRegistry;
begin
  if GGlobalRegistry = nil then
    GGlobalRegistry := TMcpCommandRegistry.Create;
  Result := GGlobalRegistry;
end;

function ApplicationMcpCommandRegistry: TMcpCommandRegistry;
begin
  if GApplicationRegistry = nil then
    GApplicationRegistry := TMcpCommandRegistry.Create;
  Result := GApplicationRegistry;
end;

procedure RegisterGlobalMcpCommand(const ACommand: IMcpCommand);
begin
  GlobalMcpCommandRegistry.RegisterCommand(ACommand);
end;

procedure RegisterApplicationMcpCommand(const ACommand: IMcpCommand);
begin
  ApplicationMcpCommandRegistry.RegisterCommand(ACommand);
end;

finalization
  GApplicationRegistry.Free;
  GGlobalRegistry.Free;

end.
