unit McpLoopbackClient;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fpjson, WinSock2, McpCommand, McpConnection,
  LazarusMcpBridge, McpDesktopBridge;

type
  TMcpLoopbackClient = class(TInterfacedObject, IMcpLazarusCommandBridge,
    IMcpDesktopCommandBridge)
  private
    FEndpoint: string;
    FToken: string;
    FWinsockStarted: Boolean;
    function Request(const ARequest: string): TJSONObject;
    function Connect: TSocket;
    procedure SendLine(const S: TSocket; const ALine: string);
    function ReadLine(const S: TSocket): string;
    function ParseResult(const AResponse: TJSONObject): TMcpCommandResult;
  public
    constructor Create(const AEndpoint, AToken: string);
    destructor Destroy; override;
    function IsAvailable: Boolean;
    function HasLazarusTool(const AName: string): Boolean;
    function ListLazarusTools: TJSONArray;
    function CallLazarusTool(const AName: string; const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult;
    function HasDesktopTool(const AName: string): Boolean;
    function ListDesktopTools: TJSONArray;
    function CallDesktopTool(const AName: string; const AArguments: TJSONObject;
      const AContext: TMcpCommandContext): TMcpCommandResult;
  end;

implementation

constructor TMcpLoopbackClient.Create(const AEndpoint, AToken: string);
var
  WsaData: TWSAData;
begin
  inherited Create;
  if Pos('tcp://127.0.0.1:', LowerCase(AEndpoint)) <> 1 then
    raise EMcpConnectionError.Create('Only the authenticated loopback endpoint is allowed.');
  if Trim(AToken) = '' then
    raise EMcpConnectionError.Create('A loopback token is required.');
  if WSAStartup($0202, WsaData) <> 0 then
    raise EMcpConnectionError.Create('The loopback transport could not initialize.');
  FEndpoint := AEndpoint;
  FToken := AToken;
  FWinsockStarted := True;
end;

destructor TMcpLoopbackClient.Destroy;
begin
  if FWinsockStarted then
    WSACleanup;
  inherited Destroy;
end;

function TMcpLoopbackClient.Connect: TSocket;
var
  A: TSockAddrIn;
  P, PortText: string;
  N: Integer;
begin
  Result := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  if Result = INVALID_SOCKET then
    raise EMcpConnectionError.Create('The loopback connection could not start.');
  P := Copy(FEndpoint, Length('tcp://127.0.0.1:') + 1, MaxInt);
  N := StrToIntDef(P, 0);
  if (N < 1) or (N > 65535) then
    raise EMcpConnectionError.Create('The loopback endpoint is invalid.');
  FillChar(A, SizeOf(A), 0);
  A.sin_family := AF_INET;
  A.sin_addr.S_addr := inet_addr('127.0.0.1');
  A.sin_port := htons(N);
  if WinSock2.connect(Result, TSockAddr(A), SizeOf(A)) <> 0 then
  begin
    closesocket(Result);
    raise EMcpConnectionError.Create('The loopback connection failed.');
  end;
end;

procedure TMcpLoopbackClient.SendLine(const S: TSocket; const ALine: string);
var
  B: RawByteString;
  O, Sent: Integer;
begin
  B := RawByteString(ALine + #10);
  O := 1;
  while O <= Length(B) do
  begin
    Sent := send(S, B[O], Length(B) - O + 1, 0);
    if Sent <= 0 then
      raise EMcpConnectionError.Create('The loopback request could not be sent.');
    Inc(O, Sent);
  end;
end;

function TMcpLoopbackClient.ReadLine(const S: TSocket): string;
var
  B: array[0..4095] of Byte;
  R, I: Integer;
  D: RawByteString;
begin
  Result := '';
  while Length(Result) < 65536 do
  begin
    R := recv(S, B[0], SizeOf(B), 0);
    if R <= 0 then
      raise EMcpConnectionError.Create('The loopback response was closed.');
    SetString(D, PAnsiChar(@B[0]), R);
    for I := 1 to Length(D) do
      if D[I] = #10 then
        Exit(string(Copy(D, 1, I - 1)));
    Result := Result + string(D);
  end;
  raise EMcpConnectionError.Create('The loopback response is oversized.');
end;

function TMcpLoopbackClient.Request(const ARequest: string): TJSONObject;
var
  S: TSocket;
  Auth, Line: string;
  D: TJSONData;
begin
  S := Connect;
  try
    SendLine(S, '{"token":"' + FToken + '"}');
    Auth := ReadLine(S);
    if Auth <> '{"authenticated":true}' then
      raise EMcpAccessDenied.Create('The loopback authentication failed.');
    SendLine(S, ARequest);
    Line := ReadLine(S);
    D := GetJSON(Line, True);
    if not (D is TJSONObject) then
    begin
      D.Free;
      raise EMcpConnectionError.Create('The loopback response is invalid.');
    end;
    Result := TJSONObject(D);
  finally
    closesocket(S);
  end;
end;

function TMcpLoopbackClient.ParseResult(const AResponse: TJSONObject):
  TMcpCommandResult;
var
  R, C, V: TJSONData;
begin
  R := AResponse.Find('result', jtObject);
  if R = nil then
    raise EMcpCommandFailed.Create('The loopback tool call failed.');
  if TJSONObject(R).Find('isError', jtBoolean) <> nil then
    if TJSONObject(R).Find('isError', jtBoolean).AsBoolean then
      Exit(TMcpCommandResult.Error('The remote Lazarus tool failed.'));
  C := TJSONObject(R).Find('structuredContent');
  if C <> nil then
    Exit(TMcpCommandResult.Json(C.Clone));
  V := TJSONObject(R).Find('content', jtArray);
  if (V <> nil) and (TJSONArray(V).Count > 0) then
  begin
    C := TJSONObject(TJSONArray(V).Items[0]).Find('text', jtString);
    if C <> nil then
      Exit(TMcpCommandResult.Text(C.AsString));
  end;
  Result := TMcpCommandResult.Text('');
end;

function TMcpLoopbackClient.IsAvailable: Boolean;
begin
  Result := (FEndpoint <> '') and (FToken <> '');
end;

function TMcpLoopbackClient.HasLazarusTool(const AName: string): Boolean;
begin
  Result := (AName = 'lazarus.status') or (AName = 'lazarus.projects.list') or
    (AName = 'lazarus.project.open') or (AName = 'lazarus.project.build') or
    (AName = 'lazarus.tests.run') or (AName = 'lazarus.desktop.start') or
    (AName = 'lazarus.desktop.stop');
end;

function TMcpLoopbackClient.HasDesktopTool(const AName: string): Boolean;
begin
  Result := (AName = 'desktop.status') or (AName = 'desktop.apps.list') or
    (AName = 'desktop.apps.open');
end;

function TMcpLoopbackClient.ListDesktopTools: TJSONArray;
var
  R: TJSONObject;
  V: TJSONData;
  I: Integer;
  Tool, Name: TJSONData;
begin
  R := Request('{"jsonrpc":"2.0","id":1,"method":"tools/list"}');
  try
    V := TJSONObject(R.Find('result', jtObject)).Find('tools', jtArray);
    if V = nil then
      raise EMcpConnectionError.Create('The loopback tool list is invalid.');
    Result := TJSONArray.Create;
    for I := 0 to TJSONArray(V).Count - 1 do
    begin
      Tool := TJSONArray(V).Items[I];
      if Tool is TJSONObject then
      begin
        Name := TJSONObject(Tool).Find('name', jtString);
        if (Name <> nil) and (Pos('desktop.', Name.AsString) = 1) then
          Result.Add(Tool.Clone);
      end;
    end;
  finally
    R.Free;
  end;
end;

function TMcpLoopbackClient.ListLazarusTools: TJSONArray;
var
  R: TJSONObject;
  V: TJSONData;
  I: Integer;
  Tool, Name: TJSONData;
begin
  R := Request('{"jsonrpc":"2.0","id":1,"method":"tools/list"}');
  try
    V := TJSONObject(R.Find('result', jtObject)).Find('tools', jtArray);
    if V = nil then
      raise EMcpConnectionError.Create('The loopback tool list is invalid.');
    Result := TJSONArray.Create;
    for I := 0 to TJSONArray(V).Count - 1 do
    begin
      Tool := TJSONArray(V).Items[I];
      if Tool is TJSONObject then
      begin
        Name := TJSONObject(Tool).Find('name', jtString);
        if (Name <> nil) and (Pos('lazarus.', Name.AsString) = 1) then
          Result.Add(Tool.Clone);
      end;
    end;
  finally
    R.Free;
  end;
end;

function TMcpLoopbackClient.CallDesktopTool(const AName: string;
  const AArguments: TJSONObject; const AContext: TMcpCommandContext):
  TMcpCommandResult;
var
  R: TJSONObject;
begin
  if not HasDesktopTool(AName) then
    raise EMcpToolNotFound.CreateFmt('Unknown MCP tool "%s".', [AName]);
  R := Request('{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":' +
    TJSONString.Create(AName).AsJSON + ',"arguments":' + AArguments.AsJSON + '}}');
  try
    Result := ParseResult(R);
  finally
    R.Free;
  end;
end;

function TMcpLoopbackClient.CallLazarusTool(const AName: string;
  const AArguments: TJSONObject; const AContext: TMcpCommandContext):
  TMcpCommandResult;
var
  R: TJSONObject;
begin
  if not HasLazarusTool(AName) then
    raise EMcpToolNotFound.CreateFmt('Unknown MCP tool "%s".', [AName]);
  R := Request('{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":' +
    TJSONString.Create(AName).AsJSON + ',"arguments":' + AArguments.AsJSON + '}}');
  try
    Result := ParseResult(R);
  finally
    R.Free;
  end;
end;

end.
