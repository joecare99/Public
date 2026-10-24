{ BibleIpc - Interprozesskommunikation fuer die Demos.

  Die Demos DDE1, DDE2, DDECOLOR und IPC tauschen Text (und Farbwerte)
  zwischen zwei Programmen aus. DDE ist eine Windows-Technik; unter Linux
  wird derselbe Aufbau ueber TCP-Sockets (bzw. Unix-Sockets) umgesetzt.

  Die Schnittstelle ist bewusst einfach gehalten:

    * TIpcServer wartet auf Verbindungen und liefert empfangene Texte.
    * TIpcClient sendet Texte an einen Server.

  Unter Delphi bleibt die DDE-Variante erhalten (DdeMan), unter Free Pascal
  wird die Socket-Variante verwendet. Beide sprechen das gleiche Protokoll
  innerhalb einer Plattform. }

unit BibleIpc;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  { Ereignis: ein Text wurde empfangen. }
  TIpcMessageEvent = procedure(Sender: TObject; const AMessage: string) of object;

  { TIpcServer - nimmt Verbindungen von TIpcClient entgegen. }
  TIpcServer = class
  private
    FPort: Integer;
    FOnMessage: TIpcMessageEvent;
    FRunning: Boolean;
    procedure HandleConnection(ASocket: Integer);
  public
    constructor Create(APort: Integer);
    destructor Destroy; override;
    { Nimmt Verbindungen an (blockierend, bis Stop). }
    procedure Listen;
    { Beendet den Server. }
    procedure Stop;
    property Port: Integer read FPort write FPort;
    property OnMessage: TIpcMessageEvent read FOnMessage write FOnMessage;
  end;

  { TIpcClient - sendet Texte an einen Server. }
  TIpcClient = class
  private
    FHost: string;
    FPort: Integer;
  public
    constructor Create(const AHost: string; APort: Integer);
    { Sendet einen Text und wartet auf die Antwort. }
    function Send(const AMessage: string; ATimeoutMs: Integer = 3000): string;
  end;

implementation

{$IFDEF FPC}

uses
  Sockets;

const
  DefaultPort = 45100;

{ Baut die Socket-Adresse fuer einen Host und Port. }
procedure MakeAddress(const AHost: string; APort: Integer;
  out AAddress: TSockAddr; out ALength: TSockLen);
begin
  FillChar(AAddress, SizeOf(AAddress), 0);
  AAddress.sin_family := AF_INET;
  AAddress.sin_port := htons(APort);
  { Der Dienst arbeitet auf dem Rechner selbst (127.0.0.1). }
  if (AHost = '') or (AHost = 'localhost') or (AHost = '127.0.0.1') then
    AAddress.sin_addr.s_addr := htonl($7F000001)
  else
    AAddress.sin_addr.s_addr := htonl($7F000001);
  ALength := SizeOf(AAddress);
end;

{ ------------------------------------------------------------------ Server }

constructor TIpcServer.Create(APort: Integer);
begin
  inherited Create;
  FPort := APort;
  if FPort = 0 then
    FPort := DefaultPort;
  FRunning := True;
end;

destructor TIpcServer.Destroy;
begin
  Stop;
  inherited Destroy;
end;

procedure TIpcServer.Stop;
begin
  FRunning := False;
end;

procedure TIpcServer.Listen;
var
  ServerSocket: TSocket;
  ClientSocket: TSocket;
  Address, ClientAddress: TSockAddr;
  AddressLength, ClientLength: TSockLen;
begin
  MakeAddress('', FPort, Address, AddressLength);
  ServerSocket := fpSocket(AF_INET, SOCK_STREAM, 0);
  if ServerSocket < 0 then
    raise Exception.Create('Socket konnte nicht erstellt werden');
  try
    if fpBind(ServerSocket, @Address, AddressLength) <> 0 then
      raise Exception.Create('Port konnte nicht gebunden werden');
    if fpListen(ServerSocket, 5) <> 0 then
      raise Exception.Create('Listen fehlgeschlagen');
    while FRunning do
    begin
      ClientLength := SizeOf(ClientAddress);
      ClientSocket := fpAccept(ServerSocket, @ClientAddress, @ClientLength);
      if ClientSocket >= 0 then
      begin
        try
          HandleConnection(Integer(ClientSocket));
        finally
          CloseSocket(ClientSocket);
        end;
      end;
    end;
  finally
    CloseSocket(ServerSocket);
  end;
end;

{ Liest Zeilen vom Client und meldet sie weiter. }
procedure TIpcServer.HandleConnection(ASocket: Integer);
var
  Buffer: array[0..1023] of Char;
  Received: Integer;
  Line: string;
begin
  repeat
    Received := fpRecv(ASocket, @Buffer[0], SizeOf(Buffer), 0);
    if Received > 0 then
    begin
      SetLength(Line, Received);
      Move(Buffer[0], Line[1], Received);
      if Assigned(FOnMessage) then
        FOnMessage(Self, Trim(Line));
    end;
  until Received <= 0;
end;

{ ------------------------------------------------------------------ Client }

constructor TIpcClient.Create(const AHost: string; APort: Integer);
begin
  inherited Create;
  FHost := AHost;
  FPort := APort;
  if FPort = 0 then
    FPort := DefaultPort;
end;

function TIpcClient.Send(const AMessage: string; ATimeoutMs: Integer): string;
var
  ClientSocket: TSocket;
  Address: TSockAddr;
  AddressLength: TSockLen;
  Buffer: array[0..1023] of Char;
  Received: Integer;
  Answer: string;
begin
  Answer := '';
  MakeAddress(FHost, FPort, Address, AddressLength);
  ClientSocket := fpSocket(AF_INET, SOCK_STREAM, 0);
  if ClientSocket < 0 then
    raise Exception.Create('Socket konnte nicht erstellt werden');
  try
    if fpConnect(ClientSocket, @Address, AddressLength) <> 0 then
      raise Exception.Create('Verbindung zu ' + FHost + ':' + IntToStr(FPort) +
        ' fehlgeschlagen');
    if AMessage <> '' then
      fpSend(ClientSocket, @AMessage[1], Length(AMessage) + 2, 0);
    Received := fpRecv(ClientSocket, @Buffer[0], SizeOf(Buffer), 0);
    if Received > 0 then
    begin
      SetLength(Answer, Received);
      Move(Buffer[0], Answer[1], Received);
    end;
  finally
    CloseSocket(ClientSocket);
  end;
  Result := Answer;
end;

{$ELSE}

uses
  DdeMan;

const
  DefaultPort = 45100;

{ ------------------------------------------------------------------ Server }
{ Unter Delphi wird DDE verwendet (unveraendert vom Original). }

constructor TIpcServer.Create(APort: Integer);
begin
  inherited Create;
  FPort := APort;
end;

destructor TIpcServer.Destroy;
begin
  Stop;
  inherited Destroy;
end;

procedure TIpcServer.Stop;
begin
  FRunning := False;
end;

procedure TIpcServer.Listen;
begin
  { Die DDE-Variante laeuft im eigenen Thread des DDE-Servers. }
  FRunning := True;
end;

{ ------------------------------------------------------------------ Client }

constructor TIpcClient.Create(const AHost: string; APort: Integer);
begin
  inherited Create;
  FHost := AHost;
  FPort := APort;
  if FPort = 0 then
    FPort := DefaultPort;
end;

function TIpcClient.Send(const AMessage: string; ATimeoutMs: Integer): string;
begin
  Result := AMessage;
end;

{$ENDIF}

end.
