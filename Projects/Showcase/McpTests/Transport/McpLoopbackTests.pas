unit McpLoopbackTests;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, fpjson, WinSock2,
  McpCommand, McpConnection, McpLoopbackServer;

type
  TCountingToolClient = class(TInterfacedObject, IMcpToolClient)
  private
    FCallCount: Integer;
  public
    function ListTools: TJSONArray;
    function CallTool(const AName: string; const AArguments: TJSONObject):
      TMcpCommandResult;
    property CallCount: Integer read FCallCount;
  end;

  TMcpLoopbackTest = class(TTestCase)
  private
    FWorkspaceRoot: string;
    FToolClient: TCountingToolClient;
    FClient: IMcpToolClient;
    FServer: TMcpLoopbackServer;
    function ConnectToServer: TSocket;
    procedure SendLine(const ASocket: TSocket; const ALine: string);
    function ReadLine(const ASocket: TSocket): string;
    function ConnectionToken: string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure CreatesLoopbackConnectionFileAndRemovesIt;
    procedure RequiresAuthenticationBeforeRoutingRequests;
    procedure RejectsOversizedLinesBeforeRoutingRequests;
  end;

implementation

function TCountingToolClient.ListTools: TJSONArray;
begin
  Result := TJSONArray.Create;
end;

function TCountingToolClient.CallTool(const AName: string;
  const AArguments: TJSONObject): TMcpCommandResult;
begin
  Inc(FCallCount);
  Result := TMcpCommandResult.Text('called');
end;

procedure TMcpLoopbackTest.SetUp;
begin
  FWorkspaceRoot := IncludeTrailingPathDelimiter(GetCurrentDir) +
    'mcp-loopback-test';
  DeleteFile(IncludeTrailingPathDelimiter(FWorkspaceRoot) +
    'mcp-connection.json');
  ForceDirectories(FWorkspaceRoot);
  FToolClient := TCountingToolClient.Create;
  FClient := FToolClient;
  FServer := TMcpLoopbackServer.Create(FClient, FWorkspaceRoot);
  FServer.Start;
end;

procedure TMcpLoopbackTest.TearDown;
begin
  FreeAndNil(FServer);
  FClient := nil;
  FToolClient := nil;
  DeleteFile(IncludeTrailingPathDelimiter(FWorkspaceRoot) +
    'mcp-connection.json');
  RemoveDir(FWorkspaceRoot);
end;

function TMcpLoopbackTest.ConnectToServer: TSocket;
var
  Address: TSockAddrIn;
  PortText: string;
  Separator: Integer;
begin
  Result := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  if Result = INVALID_SOCKET then
    Fail('Could not create a test socket.');
  FillChar(Address, SizeOf(Address), 0);
  Address.sin_family := AF_INET;
  Address.sin_addr.S_addr := inet_addr('127.0.0.1');
  Separator := LastDelimiter(':', FServer.LoopbackEndpoint);
  PortText := Copy(FServer.LoopbackEndpoint, Separator + 1, MaxInt);
  Address.sin_port := htons(StrToInt(PortText));
  if connect(Result, TSockAddr(Address), SizeOf(Address)) <> 0 then
  begin
    closesocket(Result);
    Fail('Could not connect to the loopback server.');
  end;
end;

procedure TMcpLoopbackTest.SendLine(const ASocket: TSocket; const ALine: string);
var
  Data: RawByteString;
  Sent, Offset: Integer;
begin
  Data := RawByteString(ALine + #10);
  Offset := 1;
  while Offset <= Length(Data) do
  begin
    Sent := send(ASocket, Data[Offset], Length(Data) - Offset + 1, 0);
    AssertTrue('The test line could not be sent.', Sent > 0);
    Inc(Offset, Sent);
  end;
end;

function TMcpLoopbackTest.ReadLine(const ASocket: TSocket): string;
var
  Mode: u_long;
  Buffer: array[0..4095] of Byte;
  Received, ErrorCode, I: Integer;
  Data: RawByteString;
  Started: QWord;
begin
  Mode := 1;
  if ioctlsocket(ASocket, -2147195266, Mode) <> 0 then
    Fail('Could not configure the test socket.');
  Started := GetTickCount64;
  repeat
    FServer.Process;
    Received := recv(ASocket, Buffer[0], SizeOf(Buffer), 0);
    if Received > 0 then
    begin
      SetString(Data, PAnsiChar(@Buffer[0]), Received);
      for I := 1 to Length(Data) do
        if Data[I] = #10 then
          Exit(string(Copy(Data, 1, I - 1)));
    end
    else if Received < 0 then
    begin
      ErrorCode := WSAGetLastError;
      if ErrorCode <> WSAEWOULDBLOCK then
        Fail('The loopback connection was closed unexpectedly.');
    end;
    Sleep(5);
  until GetTickCount64 - Started > 2000;
  Fail('The loopback server did not return a response.');
end;

function TMcpLoopbackTest.ConnectionToken: string;
var
  Details: TMcpConnectionDetails;
begin
  Details := TMcpConnectionDetails.Load(FServer.ConnectionFileName);
  try
    Result := Details.Token;
  finally
    Details.Free;
  end;
end;

procedure TMcpLoopbackTest.CreatesLoopbackConnectionFileAndRemovesIt;
var
  Details: TMcpConnectionDetails;
begin
  AssertTrue(FServer.IsStarted);
  AssertTrue(Pos('tcp://127.0.0.1:', FServer.LoopbackEndpoint) = 1);
  AssertTrue(FileExists(FServer.ConnectionFileName));
  Details := TMcpConnectionDetails.Load(FServer.ConnectionFileName);
  try
    AssertTrue(Details.HasToken);
    AssertEquals('A 256-bit token must be encoded as 64 hex characters.', 64,
      Length(Details.Token));
    AssertEquals(FServer.LoopbackEndpoint, Details.LoopbackEndpoint);
    AssertEquals(ExpandFileName(FWorkspaceRoot), Details.WorkspaceRoot);
  finally
    Details.Free;
  end;
  FServer.Stop;
  AssertFalse(FileExists(IncludeTrailingPathDelimiter(FWorkspaceRoot) +
    'mcp-connection.json'));
end;

procedure TMcpLoopbackTest.RequiresAuthenticationBeforeRoutingRequests;
var
  Socket: TSocket;
  Response: string;
begin
  Socket := ConnectToServer;
  try
    SendLine(Socket,
      '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"workspace.echo","arguments":{}}}');
    FServer.Process;
    FServer.Process;
    AssertEquals('Unauthenticated requests must not be routed.', 0,
      FToolClient.CallCount);
  finally
    closesocket(Socket);
  end;

  Socket := ConnectToServer;
  try
    SendLine(Socket, '{"token":"' + ConnectionToken + '"}');
    Response := ReadLine(Socket);
    AssertEquals('{"authenticated":true}', Response);
    AssertEquals('The authentication response must not disclose the token.', 0,
      Pos(ConnectionToken, Response));
    SendLine(Socket,
      '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"workspace.echo","arguments":{}}}');
    Response := ReadLine(Socket);
    AssertTrue(Pos('"isError" : false', Response) > 0);
    AssertEquals('Authenticated requests must reach the tool client.', 1,
      FToolClient.CallCount);
  finally
    closesocket(Socket);
  end;
end;

procedure TMcpLoopbackTest.RejectsOversizedLinesBeforeRoutingRequests;
var
  Socket: TSocket;
  I: Integer;
begin
  Socket := ConnectToServer;
  try
    SendLine(Socket, '{"token":"' + ConnectionToken + '"}');
    ReadLine(Socket);
    SendLine(Socket, StringOfChar('x', 65537));
    for I := 1 to 20 do
      FServer.Process;
    AssertEquals('Oversized lines must be rejected before tool routing.', 0,
      FToolClient.CallCount);
  finally
    closesocket(Socket);
  end;
end;

initialization
  RegisterTest(TMcpLoopbackTest);

end.
