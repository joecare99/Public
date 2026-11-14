unit McpDesktopBridge;

{$mode objfpc}{$H+}

interface

uses
  fpjson, McpCommand;

type
  { A desktop host implements this contract when it can safely service desktop
    commands. It is deliberately transport-neutral: a later live bridge may
    use IPC, while the sidecar remains a standalone in-process executable. }
  IMcpDesktopCommandBridge = interface
    ['{AA1A2AD8-43FB-49CB-BC9B-EF524A84640E}']
    function IsAvailable: Boolean;
    function HasDesktopTool(const AName: string): Boolean;
    { The caller owns the returned array and every item in it. Each item must
      be an MCP tool definition in the desktop namespace. }
    function ListDesktopTools: TJSONArray;
    { The bridge owns execution and must validate arguments against its
      advertised closed schema before returning a non-nil result. The router
      has already checked the command namespace and desktop permission. }
    function CallDesktopTool(const AName: string;
      const AArguments: TJSONObject; const AContext: TMcpCommandContext):
      TMcpCommandResult;
  end;

implementation

end.
