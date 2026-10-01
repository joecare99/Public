unit McpDesktopBridgeTests;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fpcunit, testregistry, fpjson, McpCommand,
  McpDesktopBridge, McpRegistry, DesktopMcpBridge, DesktopMcpShellTests;

type
  TMcpDesktopBridgeTest = class(TTestCase)
  private
    FShell: TFakeDesktopMcpShell;
    FBridge: IMcpDesktopCommandBridge;
    FDesktopContext: TMcpCommandContext;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ListsLiveDesktopTools;
    procedure ReportsLiveShellStateAndOpensRegisteredApplication;
    procedure EnforcesContextAndClosedActionArguments;
  end;

implementation

procedure TMcpDesktopBridgeTest.SetUp;
begin
  FShell := TFakeDesktopMcpShell.Create;
  FBridge := TDesktopMcpBridge.Create(FShell);
  FDesktopContext := TMcpCommandContext.Create(GetCurrentDir, True);
end;

procedure TMcpDesktopBridgeTest.TearDown;
begin
  FBridge := nil;
  FDesktopContext.Free;
  FShell := nil;
end;

procedure TMcpDesktopBridgeTest.ListsLiveDesktopTools;
var
  Tools: TJSONArray;
begin
  Tools := FBridge.ListDesktopTools;
  try
    AssertEquals(3, Tools.Count);
    AssertEquals('desktop.status',
      TJSONObject(Tools.Items[0]).Find('name', jtString).AsString);
    AssertEquals('desktop.apps.list',
      TJSONObject(Tools.Items[1]).Find('name', jtString).AsString);
    AssertEquals('desktop.apps.open',
      TJSONObject(Tools.Items[2]).Find('name', jtString).AsString);
  finally
    Tools.Free;
  end;
end;

procedure TMcpDesktopBridgeTest.ReportsLiveShellStateAndOpensRegisteredApplication;
var
  Arguments, McpResult, Data: TJSONObject;
  ToolResult: TMcpCommandResult;
  Client: IMcpToolClient;
begin
  Client := TMcpCommandRouter.Create(nil, nil, FDesktopContext, FBridge);
  try
    Arguments := TJSONObject.Create;
    try
      ToolResult := Client.CallTool('desktop.status', Arguments);
      try
        McpResult := ToolResult.ToMcpJson;
        try
          Data := TJSONObject(McpResult.Find('structuredContent', jtObject));
          AssertTrue(Data.Find('available', jtBoolean).AsBoolean);
          AssertEquals('Calculator',
            Data.Find('activeWindow', jtString).AsString);
          AssertEquals(1, Data.Find('openWindowCount', jtNumber).AsInteger);
        finally
          McpResult.Free;
        end;
      finally
        ToolResult.Free;
      end;
    finally
      Arguments.Free;
    end;

    Arguments := TJSONObject.Create;
    try
      ToolResult := Client.CallTool('desktop.apps.list', Arguments);
      try
        McpResult := ToolResult.ToMcpJson;
        try
          Data := TJSONObject(McpResult.Find('structuredContent', jtObject));
          AssertEquals(2, Data.Find('count', jtNumber).AsInteger);
          AssertEquals('Calendar',
            TJSONArray(Data.Find('applications', jtArray)).Strings[1]);
        finally
          McpResult.Free;
        end;
      finally
        ToolResult.Free;
      end;
    finally
      Arguments.Free;
    end;

    Arguments := TJSONObject.Create;
    try
      Arguments.Add('name', 'Calendar');
      ToolResult := Client.CallTool('desktop.apps.open', Arguments);
      try
        AssertEquals('Calendar', FShell.OpenedApplication);
      finally
        ToolResult.Free;
      end;
    finally
      Arguments.Free;
    end;
  finally
    Client := nil;
  end;
end;

procedure TMcpDesktopBridgeTest.EnforcesContextAndClosedActionArguments;
var
  Arguments: TJSONObject;
  UnprivilegedContext: TMcpCommandContext;
begin
  UnprivilegedContext := TMcpCommandContext.Create(GetCurrentDir);
  try
    Arguments := TJSONObject.Create;
    try
      try
        FBridge.CallDesktopTool('desktop.apps.open', Arguments,
          UnprivilegedContext);
        Fail('Desktop actions must require an explicitly privileged context.');
      except
        on EMcpAccessDenied do
          ;
      end;
      Arguments.Add('name', 'Calculator');
      Arguments.Add('unexpected', 'value');
      try
        FBridge.CallDesktopTool('desktop.apps.open', Arguments,
          FDesktopContext);
        Fail('Desktop action arguments must be closed.');
      except
        on EMcpInvalidParams do
          ;
      end;
    finally
      Arguments.Free;
    end;
  finally
    UnprivilegedContext.Free;
  end;
end;

initialization
  RegisterTest(TMcpDesktopBridgeTest);

end.
