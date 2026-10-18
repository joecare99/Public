unit McpLoopbackServer;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, WinSock2, McpCommand, McpConnectionFile, McpJsonRpc;

type
  EMcpLoopbackError = class(EMcpError);

  TMcpLoopbackServer = class
  private
    FClient: IMcpToolClient;
    FSocket: TSocket;
    FPort: Word;
    FToken: string;
    FWorkspaceRoot: string;
    FWinsockStarted: Boolean;
    FConnectionFile: TMcpConnectionFile;
    FJsonRpcServer: TMcpJsonRpcServer;
    FClients: array of record
      Socket: TSocket;
      InputBuffer: RawByteString;
      OutputBuffer: RawByteString;
      Authenticated: Boolean;
      LastActivity: QWord;
    end;
    function Endpoint: string;
    procedure CloseClient(const AIndex: Integer);
    procedure CloseAllClients;
    procedure AcceptClients;
    procedure ProcessClient(const AIndex: Integer);
    procedure ProcessInput(const AIndex: Integer);
    procedure QueueResponse(const AIndex: Integer; const AResponse: string);
    procedure FlushOutput(const AIndex: Integer);
    procedure CheckClientTimeouts;
    function NewToken: string;
  public
    constructor Create(const AClient: IMcpToolClient;
      const AWorkspaceRoot: string);
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    procedure Process;
    function IsStarted: Boolean;
    function ConnectionFileName: string;
    property LoopbackEndpoint: string read Endpoint;
  end;

implementation

uses
  Classes, fpjson, jsonparser, Windows;

const
  MCP_MAX_LINE_BYTES = 65536;
  MCP_MAX_CLIENTS = 16;
  MCP_CLIENT_TIMEOUT_MS = 30000;
  IOCTL_FIONBIO: LongInt = -2147195266;

function RtlGenRandom(RandomBuffer: Pointer; RandomBufferLength: ULONG): BOOL;
  stdcall; external 'advapi32.dll' name 'SystemFunction036';

function NowTicks: QWord;
begin
  Result := GetTickCount64;
end;

function IsSocketReady(const ASocket: TSocket; const AWrite: Boolean): Boolean;
var
  ReadSet, WriteSet: TFDSet;
  Timeout: timeval;
begin
  FD_ZERO(ReadSet);
  FD_ZERO(WriteSet);
  if AWrite then
    FD_SET(ASocket, WriteSet)
  else
    FD_SET(ASocket, ReadSet);
  Timeout.tv_sec := 0;
  Timeout.tv_usec := 0;
  if AWrite then
    Result := select(0, nil, @WriteSet, nil, @Timeout) > 0
  else
    Result := select(0, @ReadSet, nil, nil, @Timeout) > 0;
end;

procedure SetNonBlocking(const ASocket: TSocket);
var
  Mode: u_long;
begin
  Mode := 1;
  if ioctlsocket(ASocket, IOCTL_FIONBIO, Mode) <> 0 then
    raise EMcpLoopbackError.Create('The MCP loopback socket could not start.');
end;

function ConstantTimeEquals(const ALeft, ARight: string): Boolean;
var
  I, Difference, MaxLength, LeftByte, RightByte: Integer;
begin
  MaxLength := Length(ALeft);
  if Length(ARight) > MaxLength then
    MaxLength := Length(ARight);
  Difference := Length(ALeft) xor Length(ARight);
  for I := 1 to MaxLength do
  begin
    if I <= Length(ALeft) then
      LeftByte := Ord(ALeft[I])
    else
      LeftByte := 0;
    if I <= Length(ARight) then
      RightByte := Ord(ARight[I])
    else
      RightByte := 0;
    Difference := Difference or (LeftByte xor RightByte);
  end;
  Result := Difference = 0;
end;

function IsAuthenticationLine(const ALine, AToken: string): Boolean;
var
  Data: TJSONData;
  Value: TJSONData;
begin
  Result := False;
  try
    Data := GetJSON(ALine, True);
  except
    Exit;
  end;
  try
    if not (Data is TJSONObject) then
      Exit;
    Value := TJSONObject(Data).Find('token', jtString);
    if Value <> nil then
      Result := ConstantTimeEquals(Value.AsString, AToken);
  finally
    Data.Free;
  end;
end;

constructor TMcpLoopbackServer.Create(const AClient: IMcpToolClient;
  const AWorkspaceRoot: string);
begin
  inherited Create;
  if AClient = nil then
    raise EMcpLoopbackError.Create('An MCP tool client is required.');
  if Trim(AWorkspaceRoot) = '' then
    raise EMcpLoopbackError.Create('An MCP workspace root is required.');
  FClient := AClient;
  FWorkspaceRoot := ExpandFileName(AWorkspaceRoot);
  FSocket := INVALID_SOCKET;
end;

destructor TMcpLoopbackServer.Destroy;
begin
  Stop;
  FClient := nil;
  inherited Destroy;
end;

function TMcpLoopbackServer.NewToken: string;
const
  HexDigits = '0123456789abcdef';
var
  Bytes: array[0..31] of Byte;
  I: Integer;
begin
  if not RtlGenRandom(@Bytes[0], SizeOf(Bytes)) then
    raise EMcpLoopbackError.Create('The MCP loopback server could not start.');
  SetLength(Result, Length(Bytes) * 2);
  for I := 0 to High(Bytes) do
  begin
    Result[(I * 2) + 1] := HexDigits[(Bytes[I] shr 4) + 1];
    Result[(I * 2) + 2] := HexDigits[(Bytes[I] and $0F) + 1];
  end;
end;

function TMcpLoopbackServer.Endpoint: string;
begin
  if FSocket = INVALID_SOCKET then
    Exit('');
  Result := Format('tcp://127.0.0.1:%d', [FPort]);
end;

function TMcpLoopbackServer.IsStarted: Boolean;
begin
  Result := FSocket <> INVALID_SOCKET;
end;

function TMcpLoopbackServer.ConnectionFileName: string;
begin
  if FConnectionFile = nil then
    Exit('');
  Result := FConnectionFile.FileName;
end;

procedure TMcpLoopbackServer.Start;
var
  WsaData: TWSAData;
  Address: TSockAddrIn;
  AddressLength: Integer;
  Server: TMcpJsonRpcServer;
  Connection: TMcpConnectionFile;
begin
  if IsStarted then
    Exit;
  if WSAStartup($0202, WsaData) <> 0 then
    raise EMcpLoopbackError.Create('The MCP loopback server could not start.');
  FWinsockStarted := True;
  try
    FSocket := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if FSocket = INVALID_SOCKET then
      raise EMcpLoopbackError.Create('The MCP loopback server could not start.');
    FillChar(Address, SizeOf(Address), 0);
    Address.sin_family := AF_INET;
    Address.sin_addr.S_addr := inet_addr('127.0.0.1');
    Address.sin_port := htons(0);
    if bind(FSocket, @Address, SizeOf(Address)) <> 0 then
      raise EMcpLoopbackError.Create('The MCP loopback server could not start.');
    if listen(FSocket, MCP_MAX_CLIENTS) <> 0 then
      raise EMcpLoopbackError.Create('The MCP loopback server could not start.');
    AddressLength := SizeOf(Address);
    if getsockname(FSocket, Address, AddressLength) <> 0 then
      raise EMcpLoopbackError.Create('The MCP loopback server could not start.');
    FPort := ntohs(Address.sin_port);
    SetNonBlocking(FSocket);
    FToken := NewToken;
    Server := TMcpJsonRpcServer.Create(FClient, 'VirtualDesktop MCP loopback',
      '0.1.0');
    FJsonRpcServer := Server;
    Connection := TMcpConnectionFile.Create(FWorkspaceRoot, FToken, Endpoint);
    FConnectionFile := Connection;
    Connection.Write;
  except
    Stop;
    raise;
  end;
end;

procedure TMcpLoopbackServer.Stop;
begin
  CloseAllClients;
  FreeAndNil(FJsonRpcServer);
  if FSocket <> INVALID_SOCKET then
  begin
    closesocket(FSocket);
    FSocket := INVALID_SOCKET;
  end;
  if FWinsockStarted then
  begin
    WSACleanup;
    FWinsockStarted := False;
  end;
  if FConnectionFile <> nil then
    FConnectionFile.Delete;
  FreeAndNil(FConnectionFile);
  FPort := 0;
  FToken := '';
end;

procedure TMcpLoopbackServer.CloseClient(const AIndex: Integer);
var
  I: Integer;
begin
  if (AIndex < 0) or (AIndex >= Length(FClients)) then
    Exit;
  closesocket(FClients[AIndex].Socket);
  for I := AIndex to High(FClients) - 1 do
    FClients[I] := FClients[I + 1];
  SetLength(FClients, Length(FClients) - 1);
end;

procedure TMcpLoopbackServer.CloseAllClients;
begin
  while Length(FClients) > 0 do
    CloseClient(High(FClients));
end;

procedure TMcpLoopbackServer.AcceptClients;
var
  ClientSocket: TSocket;
  ClientAddress: TSockAddrIn;
  ClientAddressLength: Integer;
  ClientIndex: Integer;
begin
  while (Length(FClients) < MCP_MAX_CLIENTS) and
    IsSocketReady(FSocket, False) do
  begin
    ClientAddressLength := SizeOf(ClientAddress);
    ClientSocket := accept(FSocket, @ClientAddress, @ClientAddressLength);
    if ClientSocket = INVALID_SOCKET then
      Exit;
    try
      SetNonBlocking(ClientSocket);
    except
      closesocket(ClientSocket);
      raise;
    end;
    ClientIndex := Length(FClients);
    SetLength(FClients, ClientIndex + 1);
    FClients[ClientIndex].Socket := ClientSocket;
    FClients[ClientIndex].InputBuffer := '';
    FClients[ClientIndex].OutputBuffer := '';
    FClients[ClientIndex].Authenticated := False;
    FClients[ClientIndex].LastActivity := NowTicks;
  end;
end;

procedure TMcpLoopbackServer.QueueResponse(const AIndex: Integer;
  const AResponse: string);
begin
  if (AIndex < 0) or (AIndex >= Length(FClients)) then
    Exit;
  if Length(AResponse) > MCP_MAX_LINE_BYTES then
  begin
    CloseClient(AIndex);
    Exit;
  end;
  FClients[AIndex].OutputBuffer := FClients[AIndex].OutputBuffer +
    RawByteString(AResponse) + #10;
end;

procedure TMcpLoopbackServer.FlushOutput(const AIndex: Integer);
var
  Sent: Integer;
begin
  if (AIndex < 0) or (AIndex >= Length(FClients)) or
    (FClients[AIndex].OutputBuffer = '') or
    not IsSocketReady(FClients[AIndex].Socket, True) then
    Exit;
  Sent := send(FClients[AIndex].Socket, FClients[AIndex].OutputBuffer[1],
    Length(FClients[AIndex].OutputBuffer), 0);
  if Sent > 0 then
  begin
    Delete(FClients[AIndex].OutputBuffer, 1, Sent);
    FClients[AIndex].LastActivity := NowTicks;
  end
  else if (Sent = 0) or (WSAGetLastError <> WSAEWOULDBLOCK) then
    CloseClient(AIndex);
end;

procedure TMcpLoopbackServer.ProcessInput(const AIndex: Integer);
var
  NewLine, Line: Integer;
  Response: string;
begin
  while (AIndex < Length(FClients)) do
  begin
    NewLine := Pos(#10, FClients[AIndex].InputBuffer);
    if NewLine = 0 then
      Break;
    Line := NewLine - 1;
    if (Line > 0) and (FClients[AIndex].InputBuffer[Line] = #13) then
      Dec(Line);
    if Line > MCP_MAX_LINE_BYTES then
    begin
      CloseClient(AIndex);
      Exit;
    end;
    if Line = 0 then
      Delete(FClients[AIndex].InputBuffer, 1, NewLine)
    else
    begin
      Response := string(Copy(FClients[AIndex].InputBuffer, 1, Line));
      Delete(FClients[AIndex].InputBuffer, 1, NewLine);
      if not FClients[AIndex].Authenticated then
      begin
        if not IsAuthenticationLine(Response, FToken) then
        begin
          CloseClient(AIndex);
          Exit;
        end;
        FClients[AIndex].Authenticated := True;
        QueueResponse(AIndex, '{"authenticated":true}');
      end
      else
      begin
        Response := FJsonRpcServer.HandleLine(Response);
        if Response <> '' then
          QueueResponse(AIndex, Response);
      end;
    end;
  end;
  if (AIndex < Length(FClients)) and
    (Length(FClients[AIndex].InputBuffer) > MCP_MAX_LINE_BYTES) then
    CloseClient(AIndex);
end;

procedure TMcpLoopbackServer.ProcessClient(const AIndex: Integer);
var
  Buffer: array[0..4095] of Byte;
  Chunk: RawByteString;
  Received: Integer;
  ErrorCode: Integer;
begin
  if (AIndex < 0) or (AIndex >= Length(FClients)) then
    Exit;
  if IsSocketReady(FClients[AIndex].Socket, False) then
  begin
    Received := recv(FClients[AIndex].Socket, Buffer[0], SizeOf(Buffer), 0);
    if Received > 0 then
    begin
      SetString(Chunk, PAnsiChar(@Buffer[0]), Received);
      FClients[AIndex].InputBuffer := FClients[AIndex].InputBuffer +
        Chunk;
      FClients[AIndex].LastActivity := NowTicks;
      ProcessInput(AIndex);
    end
    else if Received = 0 then
      CloseClient(AIndex)
    else
    begin
      ErrorCode := WSAGetLastError;
      if ErrorCode <> WSAEWOULDBLOCK then
        CloseClient(AIndex);
    end;
  end;
  if AIndex < Length(FClients) then
    FlushOutput(AIndex);
end;

procedure TMcpLoopbackServer.CheckClientTimeouts;
var
  I: Integer;
begin
  I := High(FClients);
  while I >= 0 do
  begin
    if NowTicks - FClients[I].LastActivity > MCP_CLIENT_TIMEOUT_MS then
      CloseClient(I);
    Dec(I);
  end;
end;

procedure TMcpLoopbackServer.Process;
var
  I: Integer;
begin
  if not IsStarted then
    Exit;
  AcceptClients;
  I := High(FClients);
  while I >= 0 do
  begin
    ProcessClient(I);
    Dec(I);
  end;
  CheckClientTimeouts;
end;

end.
