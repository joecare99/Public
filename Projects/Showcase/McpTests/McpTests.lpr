program McpTests;

{$mode objfpc}{$H+}

uses
  consoletestrunner, McpFoundationTests, McpDesktopBridgeTests,
  DesktopMcpShellTests, LazarusProjectCatalogTests, McpLoopbackTests,
  LazarusMcpBridgeTests;

var
  Application: TTestRunner;

begin
  DefaultRunAllTests := True;
  DefaultFormat := fPlain;
  Application := TTestRunner.Create(nil);
  Application.Initialize;
  Application.Title := 'VirtualDesktop MCP foundation tests';
  Application.Run;
  Application.Free;
end.
