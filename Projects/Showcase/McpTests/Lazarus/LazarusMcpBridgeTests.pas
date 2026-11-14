unit LazarusMcpBridgeTests;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fpcunit, testregistry, fpjson, McpCommand, McpRegistry,
  LazarusMcpBridge, LazarusProjectCatalog, LazarusIdeLauncher,
  LazarusBuildTestRunner, VirtualDesktopProcessService;

type
  TLazarusMcpBridgeTest = class(TTestCase)
  published
    procedure ListsOnlyAllowlistedLazarusToolsWithClosedSchemas;
    procedure RejectsUnknownProjectBeforeExecution;
    procedure RoutesLazarusCallsThroughInjectedBridge;
  end;

implementation

type
  TFakeLazarusBridge = class(TInterfacedObject, IMcpLazarusCommandBridge)
  public
    Calls: Integer;
    function IsAvailable: Boolean;
    function HasLazarusTool(const AName: string): Boolean;
    function ListLazarusTools: TJSONArray;
    function CallLazarusTool(const AName: string; const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult;
  end;

function TFakeLazarusBridge.IsAvailable: Boolean;
begin Result := True; end;
function TFakeLazarusBridge.HasLazarusTool(const AName: string): Boolean;
begin Result := AName = 'lazarus.status'; end;
function TFakeLazarusBridge.ListLazarusTools: TJSONArray;
var O, S: TJSONObject;
begin
  Result := TJSONArray.Create; O := TJSONObject.Create; S := TJSONObject.Create;
  S.Add('type', 'object'); S.Add('additionalProperties', False);
  O.Add('name', 'lazarus.status'); O.Add('description', 'status');
  O.Add('inputSchema', S); Result.Add(O);
end;
function TFakeLazarusBridge.CallLazarusTool(const AName: string;
  const AArguments: TJSONObject; const AContext: TMcpCommandContext):
  TMcpCommandResult;
begin Inc(Calls); Result := TMcpCommandResult.Text('proxied'); end;

procedure TLazarusMcpBridgeTest.ListsOnlyAllowlistedLazarusToolsWithClosedSchemas;
var B: IMcpLazarusCommandBridge; T: TJSONArray; I: Integer;
begin
  B := TLazarusMcpBridge.Create(TShowcaseProjectCatalog.Create,
    TLazarusIdeLauncher.Create, TLazarusBuildTestRunner.Create,
    TVirtualDesktopProcessService.Create);
  T := B.ListLazarusTools;
  try
    AssertEquals(7, T.Count);
    for I := 0 to T.Count - 1 do
      AssertFalse(TJSONObject(T.Items[I]).Find('name', jtString).AsString = '');
  finally T.Free; end;
end;

procedure TLazarusMcpBridgeTest.RejectsUnknownProjectBeforeExecution;
var B: IMcpLazarusCommandBridge; C: TMcpCommandContext; A: TJSONObject;
begin
  B := TLazarusMcpBridge.Create(TShowcaseProjectCatalog.Create,
    TLazarusIdeLauncher.Create, TLazarusBuildTestRunner.Create,
    TVirtualDesktopProcessService.Create);
  C := TMcpCommandContext.Create(GetCurrentDir, False, True);
  A := TJSONObject.Create; A.Add('project', 'free-path');
  try
    try B.CallLazarusTool('lazarus.project.open', A, C); Fail('allowlist'); except
      on EMcpInvalidParams do ; end;
  finally A.Free; C.Free; end;
end;

procedure TLazarusMcpBridgeTest.RoutesLazarusCallsThroughInjectedBridge;
var F: TFakeLazarusBridge; B: IMcpLazarusCommandBridge; C: TMcpCommandContext;
    R: TMcpCommandResult; A: TJSONObject;
begin
  F := TFakeLazarusBridge.Create; B := F;
  C := TMcpCommandContext.Create(GetCurrentDir, False, True);
  A := TJSONObject.Create;
  try
    R := TMcpCommandRouter.Create(nil, nil, C, nil, B).CallTool('lazarus.status', A);
    R.Free; AssertEquals(1, F.Calls);
  finally A.Free; C.Free; B := nil; end;
end;

initialization
  RegisterTest(TLazarusMcpBridgeTest);
end.
