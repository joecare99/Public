unit McpFoundationTests;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, fpjson, jsonparser,
  McpCommand, McpJsonRpc, McpRegistry;

type
  TEchoCommand = class(TMcpCommandBase)
  protected
    function GetCommandName: string; override;
    function GetDescription: string; override;
  public
    function Execute(const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult; override;
  end;

  TDesktopEchoCommand = class(TEchoCommand)
  protected
    function GetCommandName: string; override;
    function GetScope: TMcpCommandScope; override;
  end;

  TSchemaCommand = class(TMcpCommandBase)
  protected
    function GetCommandName: string; override;
    function GetDescription: string; override;
    function GetInputSchema: TJSONObject; override;
  public
    function Execute(const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult; override;
  end;

  TUnsafeCommand = class(TEchoCommand)
  protected
    function GetCommandName: string; override;
  end;

  TMcpFoundationTest = class(TTestCase)
  private
    FContext: TMcpCommandContext;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ContextRejectsParentPaths;
    procedure RegistryMergesApplicationAndGlobalCommands;
    procedure JsonRpcHandlesToolLifecycle;
    procedure RegistryRejectsUnsafeCommandContracts;
    procedure RouterEnforcesSchemaAndDesktopPermission;
  end;

implementation

function TEchoCommand.GetCommandName: string;
begin
  Result := 'workspace.echo';
end;

function TEchoCommand.GetDescription: string;
begin
  Result := 'Test command.';
end;

function TEchoCommand.Execute(const AArguments: TJSONObject;
  const AContext: TMcpCommandContext): TMcpCommandResult;
begin
  if (AContext = nil) or (AArguments = nil) then
    raise EMcpInvalidParams.Create('Test command arguments are required.');
  Result := TMcpCommandResult.Text('ok');
end;

function TDesktopEchoCommand.GetCommandName: string;
begin
  Result := 'desktop.echo';
end;

function TDesktopEchoCommand.GetScope: TMcpCommandScope;
begin
  Result := mcsDesktop;
end;

function TSchemaCommand.GetCommandName: string;
begin
  Result := 'workspace.schema';
end;

function TSchemaCommand.GetDescription: string;
begin
  Result := 'Validates a required string argument.';
end;

function TSchemaCommand.GetInputSchema: TJSONObject;
var
  Properties, PropertySchema: TJSONObject;
  Required: TJSONArray;
begin
  Result := inherited GetInputSchema;
  Properties := TJSONObject.Create;
  PropertySchema := TJSONObject.Create;
  PropertySchema.Add('type', 'string');
  Properties.Add('message', PropertySchema);
  Result.Add('properties', Properties);
  Required := TJSONArray.Create;
  Required.Add('message');
  Result.Add('required', Required);
end;

function TSchemaCommand.Execute(const AArguments: TJSONObject;
  const AContext: TMcpCommandContext): TMcpCommandResult;
begin
  Result := TMcpCommandResult.Text(
    AArguments.Find('message', jtString).AsString);
end;

function TUnsafeCommand.GetCommandName: string;
begin
  Result := 'unsafe-name';
end;

procedure TMcpFoundationTest.SetUp;
begin
  FContext := TMcpCommandContext.Create(
    IncludeTrailingPathDelimiter(GetCurrentDir) + 'mcp-test-workspace');
end;

procedure TMcpFoundationTest.TearDown;
begin
  FContext.Free;
end;

procedure TMcpFoundationTest.ContextRejectsParentPaths;
begin
  try
    FContext.ResolveWorkspacePath('..\outside.txt');
    Fail('Parent paths must be rejected.');
  except
    on EMcpAccessDenied do
      ;
  end;
end;

procedure TMcpFoundationTest.RegistryMergesApplicationAndGlobalCommands;
var
  GlobalRegistry, ApplicationRegistry: TMcpCommandRegistry;
  Command: IMcpCommand;
  Client: IMcpToolClient;
  Tools: TJSONArray;
begin
  GlobalRegistry := TMcpCommandRegistry.Create;
  ApplicationRegistry := TMcpCommandRegistry.Create;
  try
    Command := TEchoCommand.Create;
    GlobalRegistry.RegisterCommand(Command);
    Command := nil;
    Client := TMcpCommandRouter.Create(GlobalRegistry, ApplicationRegistry,
      FContext);
    Tools := Client.ListTools;
    try
      AssertEquals(1, Tools.Count);
      AssertEquals('workspace.echo',
        TJSONObject(Tools.Items[0]).Find('name', jtString).AsString);
    finally
      Tools.Free;
      Client := nil;
    end;
  finally
    ApplicationRegistry.Free;
    GlobalRegistry.Free;
  end;
end;

procedure TMcpFoundationTest.JsonRpcHandlesToolLifecycle;
var
  GlobalRegistry, ApplicationRegistry: TMcpCommandRegistry;
  Command: IMcpCommand;
  Client: IMcpToolClient;
  Server: TMcpJsonRpcServer;
  ResponseText: string;
  Parsed: TJSONData;
begin
  GlobalRegistry := TMcpCommandRegistry.Create;
  ApplicationRegistry := TMcpCommandRegistry.Create;
  try
    Command := TEchoCommand.Create;
    GlobalRegistry.RegisterCommand(Command);
    Command := nil;
    Client := TMcpCommandRouter.Create(GlobalRegistry, ApplicationRegistry,
      FContext);
    Server := TMcpJsonRpcServer.Create(Client, 'test', '1');
    try
      ResponseText := Server.HandleLine(
        '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}');
      try
        Parsed := GetJSON(ResponseText, True);
        try
          AssertTrue(Parsed is TJSONObject);
          AssertTrue(TJSONObject(Parsed).Find('result', jtObject) <> nil);
        finally
          Parsed.Free;
        end;
      finally
        ResponseText := '';
      end;

      AssertEquals('', Server.HandleLine(
        '{"jsonrpc":"2.0","method":"notifications/initialized"}'));
      ResponseText := Server.HandleLine(
        '{"jsonrpc":"2.0","id":2,"method":"tools/call",' +
        '"params":{"name":"workspace.echo","arguments":{}}}');
      try
        AssertTrue(Pos('"isError" : false', ResponseText) > 0);
      finally
        ResponseText := '';
      end;
    finally
      Server.Free;
      Client := nil;
    end;
  finally
    ApplicationRegistry.Free;
    GlobalRegistry.Free;
  end;
end;

procedure TMcpFoundationTest.RegistryRejectsUnsafeCommandContracts;
var
  Registry: TMcpCommandRegistry;
  Command: IMcpCommand;
begin
  Registry := TMcpCommandRegistry.Create;
  try
    Command := TUnsafeCommand.Create;
    try
      Registry.RegisterCommand(Command);
      Fail('A non-namespaced command must be rejected.');
    except
      on EMcpInvalidCommand do
        ;
    end;
  finally
    Command := nil;
    Registry.Free;
  end;
end;

procedure TMcpFoundationTest.RouterEnforcesSchemaAndDesktopPermission;
var
  Registry: TMcpCommandRegistry;
  Command: IMcpCommand;
  Client: IMcpToolClient;
  Arguments: TJSONObject;
  ToolResult: TMcpCommandResult;
begin
  Registry := TMcpCommandRegistry.Create;
  try
    Command := TSchemaCommand.Create;
    Registry.RegisterCommand(Command);
    Command := TDesktopEchoCommand.Create;
    Registry.RegisterCommand(Command);
    Client := TMcpCommandRouter.Create(Registry, nil, FContext);
    try
      Arguments := TJSONObject.Create;
      try
        try
          Client.CallTool('workspace.schema', Arguments);
          Fail('Required arguments must be enforced before command execution.');
        except
          on EMcpInvalidParams do
            ;
        end;
        Arguments.Add('message', 'ok');
        ToolResult := Client.CallTool('workspace.schema', Arguments);
        try
          AssertEquals('ok', ToolResult.TextValue);
        finally
          ToolResult.Free;
        end;
      finally
        Arguments.Free;
      end;
      Arguments := TJSONObject.Create;
      try
        try
          ToolResult := Client.CallTool('desktop.echo', Arguments);
          ToolResult.Free;
          Fail('Desktop tools require explicit desktop permission.');
        except
          on EMcpAccessDenied do
            ;
        end;
      finally
        Arguments.Free;
      end;
    finally
      Client := nil;
    end;
  finally
    Command := nil;
    Registry.Free;
  end;
end;

initialization
  RegisterTest(TMcpFoundationTest);

end.
