program McpStdioSidecar;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, McpCommand, McpConnection, McpJsonRpc,
  McpRegistry, McpWorkspaceCommands, McpLoopbackClient,
  McpDesktopBridge, LazarusMcpBridge;

function TokenFileArgument: string;
var
  I: Integer;
  Value: string;
begin
  Result := '';
  I := 1;
  while I <= ParamCount do
  begin
    Value := ParamStr(I);
    if SameText(Value, '--token-file') then
    begin
      if I < ParamCount then
        Result := ParamStr(I + 1);
      Exit;
    end;
    if Pos('--token-file=', LowerCase(Value)) = 1 then
    begin
      Result := Copy(Value, Length('--token-file=') + 1, MaxInt);
      Exit;
    end;
    Inc(I);
  end;
end;

var
  Details: TMcpConnectionDetails;
  Context: TMcpCommandContext;
  Client: IMcpToolClient;
  Server: TMcpJsonRpcServer;
  WorkspaceInfo: IMcpCommand;
  LoopbackProxy: TMcpLoopbackClient;
  DesktopProxy: IMcpDesktopCommandBridge;
  LazarusProxy: IMcpLazarusCommandBridge;
begin
  Details := nil;
  Context := nil;
  Server := nil;
  Client := nil;
  LoopbackProxy := nil;
  DesktopProxy := nil;
  LazarusProxy := nil;
  try
    Details := TMcpConnectionDetails.Load(TokenFileArgument);
    Context := TMcpCommandContext.Create(Details.WorkspaceRoot,
      Details.HasToken and (Details.LoopbackEndpoint <> ''), True);

    WorkspaceInfo := TMcpWorkspaceInfoCommand.Create;
    if GlobalMcpCommandRegistry.FindCommand('workspace.info') = nil then
      RegisterGlobalMcpCommand(WorkspaceInfo);
    WorkspaceInfo := nil;

    { The registry client is the replaceable seam for a future loopback
      HTTP/JSON-RPC desktop client. This sidecar remains useful standalone. }
    if Details.HasToken and (Details.LoopbackEndpoint <> '') then
    begin
      LoopbackProxy := TMcpLoopbackClient.Create(Details.LoopbackEndpoint,
        Details.Token);
      DesktopProxy := LoopbackProxy;
      LazarusProxy := LoopbackProxy;
    end
    else
    begin
      DesktopProxy := nil;
      LazarusProxy := nil;
    end;
    Client := TMcpCommandRouter.Create(GlobalMcpCommandRegistry,
      ApplicationMcpCommandRegistry, Context, DesktopProxy, LazarusProxy);
    Server := TMcpJsonRpcServer.Create(Client, 'VirtualDesktop MCP sidecar',
      '0.1.0');
    RunMcpStdio(Server);
  except
    on E: Exception do
    begin
      { Never write token contents or connection details to stderr. }
      WriteLn(StdErr, 'MCP sidecar could not start.');
      ExitCode := 1;
    end;
  end;
  Server.Free;
  Client := nil;
  Context.Free;
  Details.Free;
end.
