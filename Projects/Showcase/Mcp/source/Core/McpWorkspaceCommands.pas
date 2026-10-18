unit McpWorkspaceCommands;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fpjson, McpCommand;

type
  TMcpWorkspaceInfoCommand = class(TMcpCommandBase)
  protected
    function GetCommandName: string; override;
    function GetDescription: string; override;
  public
    function Execute(const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult; override;
  end;

implementation

function TMcpWorkspaceInfoCommand.GetCommandName: string;
begin
  Result := 'workspace.info';
end;

function TMcpWorkspaceInfoCommand.GetDescription: string;
begin
  Result := 'Returns the configured user-workspace scope for this sidecar.';
end;

function TMcpWorkspaceInfoCommand.Execute(const AArguments: TJSONObject;
  const AContext: TMcpCommandContext): TMcpCommandResult;
var
  Data: TJSONObject;
begin
  if AContext = nil then
    raise EMcpInvalidCommand.Create('A user-workspace context is required.');
  if AArguments = nil then
    raise EMcpInvalidParams.Create('Workspace command arguments are required.');
  Data := TJSONObject.Create;
  Data.Add('scope', 'user-workspace');
  Data.Add('workspaceRoot', AContext.WorkspaceRoot);
  Data.Add('desktopCommandsAllowed', AContext.AllowDesktopCommands);
  Result := TMcpCommandResult.Json(Data);
end;

end.
