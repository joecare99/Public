unit fpTcpServer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sockets, ssockets;

Const
  ReadBufLen = 4096;

Type
  TFPTCPConnection = Class;
  TFPTCPConnectionThread = Class;
  TFPCustomTcpServer = Class;
  TRequestErrorHandler = Procedure (Sender : TObject; E : Exception) of object;

  { TFPTCPConnectionRequest }

  TFPTCPConnectionRequest = Class(TRequest)
  private
    FConnection: TFPTCPConnection;
  protected
    Procedure InitRequestVars; override;
  published
    Property Connection : TFPTCPConnection Read FConnection;
  end;

  { TFPTCPConnectionResponse }

  TFPTCPConnectionResponse = Class(TResponse)
  private
    FConnection: TFPTCPConnection;
  Protected
    Procedure DoSendHeaders(Headers : TStrings); override;
    Procedure DoSendContent; override;
    Property Connection : TFPTCPConnection Read FConnection;
  end;


  { TFPTCPConnection }

  TFPTCPConnection = Class(TObject)
  private
    FOnError: TRequestErrorHandler;
    FServer: TFPCustomTcpServer;
    FSocket: TSocketStream;
    FBuffer : Ansistring;
    procedure InterPretHeader(ARequest: TFPTCPConnectionRequest; const AHeader: String);
    function ReadString: String;
    Function GetLookupHostNames : Boolean;
  Protected
    procedure ReadRequestContent(ARequest: TFPTCPConnectionRequest); virtual;
    procedure UnknownHeader(ARequest: TFPTCPConnectionRequest; const AHeader: String); virtual;
    procedure HandleRequestError(E : Exception); virtual;
    Procedure SetupSocket; virtual;
    Function ReadRequestHeaders : TFPTCPConnectionRequest;
  Public
    Constructor Create(AServer : TFPCustomTcpServer; ASocket : TSocketStream);
    Destructor Destroy; override;
    Procedure HandleRequest; virtual;
    Property Socket : TSocketStream Read FSocket;
    Property Server : TFPCustomTcpServer Read FServer;
    Property OnRequestError : TRequestErrorHandler Read FOnError Write FOnError;
    Property LookupHostNames : Boolean Read GetLookupHostNames;
  end;

  { TFPTCPConnectionThread }

  TFPTCPConnectionThread = Class(TThread)
  private
    FConnection: TFPTCPConnection;
  Public
    Constructor CreateConnection(AConnection : TFPTCPConnection); virtual;
    Procedure Execute; override;
    Property Connection : TFPTCPConnection Read FConnection;
  end;

  THTTPServerRequestHandler = Procedure (Sender: TObject;
      Var ARequest: TFPTCPConnectionRequest;
      Var AResponse : TFPTCPConnectionResponse) of object;

  { TFPCustomTcpServer }

  TFPCustomTcpServer = Class(TComponent)
  Private
    FAdminMail: string;
    FAdminName: string;
    FOnAllowConnect: TConnectQuery;
    FOnRequest: THTTPServerRequestHandler;
    FOnRequestError: TRequestErrorHandler;
    FAddress: string;
    FPort: Word;
    FQueueSize: Word;
    FServer : TInetServer;
    FLoadActivate : Boolean;
    FServerBanner: string;
    FLookupHostNames,
    FThreaded: Boolean;
    FConnectionCount : Integer;
    function GetActive: Boolean;
    procedure SetActive(const AValue: Boolean);
    procedure SetOnAllowConnect(const AValue: TConnectQuery);
    procedure SetAddress(const AValue: string);
    procedure SetPort(const AValue: Word);
    procedure SetQueueSize(const AValue: Word);
    procedure SetThreaded(const AValue: Boolean);
    procedure SetupSocket;
    procedure WaitForRequests;
  Protected
    // Override these to create descendents of the request/response instead.
    Function CreateRequest : TFPTCPConnectionRequest; virtual;
    Function CreateResponse(ARequest : TFPTCPConnectionRequest) : TFPTCPConnectionResponse; virtual;
    Procedure InitRequest(ARequest : TFPTCPConnectionRequest); virtual;
    Procedure InitResponse(AResponse : TFPTCPConnectionResponse); virtual;
    // Called on accept errors
    procedure DoAcceptError(Sender: TObject; ASocket: Longint; E: Exception;  var ErrorAction: TAcceptErrorAction);
    // Create a connection handling object.
    function CreateConnection(Data : TSocketStream) : TFPTCPConnection; virtual;
    // Create a connection handling thread.
    Function CreateConnectionThread(Conn : TFPTCPConnection) : TFPTCPConnectionThread; virtual;
    // Check if server is inactive
    Procedure CheckInactive;
    // Called by TInetServer when a new connection is accepted.
    Procedure DoConnect(Sender : TObject; Data : TSocketStream); virtual;
    // Create and configure TInetServer
    Procedure CreateServerSocket; virtual;
    // Start server socket
    procedure StartServerSocket; virtual;
    // Stop server stocket
    procedure StopServerSocket; virtual;
    // free server socket instance
    Procedure FreeServerSocket; virtual;
    // Handle request. This calls OnRequest. It can be overridden by descendants to provide standard handling.
    procedure HandleRequest(Var ARequest: TFPTCPConnectionRequest;
                            Var AResponse : TFPTCPConnectionResponse); virtual;
    // Called when a connection encounters an unexpected error. Will call OnRequestError when set.
    procedure HandleRequestError(Sender: TObject; E: Exception); virtual;
    // Connection count
    Property ConnectionCount : Integer Read FConnectionCount;
  public
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
  protected
    // Set to true to start listening.
    Property Active : Boolean Read GetActive Write SetActive Default false;
    // Address to listen on.
    Property Address : string Read FAddress Write SetAddress;
    // Port to listen on.
    Property Port : Word Read FPort Write SetPort Default 80;
    // Max connections on queue (for Listen call)
    Property QueueSize : Word Read FQueueSize Write SetQueueSize Default 5;
    // Called when deciding whether to accept a connection.
    Property OnAllowConnect : TConnectQuery Read FOnAllowConnect Write SetOnAllowConnect;
    // Use a thread to handle a connection ?
    property Threaded : Boolean read FThreaded Write SetThreaded;
    // Called to handle the request. If Threaded=True, it is called in a the connection thread.
    Property OnRequest : THTTPServerRequestHandler Read FOnRequest Write FOnRequest;
    // Called when an unexpected error occurs during handling of the request. Sender is the TFPTCPConnection.
    Property OnRequestError : TRequestErrorHandler Read FOnRequestError Write FOnRequestError;
  published
    //aditional server information
    property AdminMail: string read FAdminMail write FAdminMail;
    property AdminName: string read FAdminName write FAdminName;
    property ServerBanner: string read FServerBanner write FServerBanner;
    Property LookupHostNames : Boolean Read FLookupHostNames Write FLookupHostNames;
  end;

  { TFPTcpServer }
  TFPTcpServer = Class(TFPCustomTcpServer)
  Published
    Property Active;
    Property Port;
    Property QueueSize;
    Property OnAllowConnect;
    property Threaded;
    Property OnRequest;
    Property OnRequestError;
  end;

  ETcpServer = Class(ETcp);

  Function GetStatusCode (ACode: Integer) : String;

implementation


resourcestring
  SErrSocketActive    =  'Operation not allowed while server is active';
  SErrReadingSocket   = 'Error reading data from the socket';


procedure TFPTCPConnectionRequest.InitRequestVars;
Var
  P : Integer;
  S : String;
begin
  S:=URL;
  P:=Pos('?',S);
  if (P<>0) then
    SetHTTPVariable(hvQuery,Copy(S,P+1,Length(S)-P));
  if Assigned(FConnection) and FConnection.LookupHostNames then
    SetHTTPVariable(hvRemoteHost,GetHostNameByAddress(RemoteAddress));
  inherited InitRequestVars;
end;

Function SocketAddrToString(ASocketAddr: TSockAddr): String;
begin
  if ASocketAddr.sa_family = AF_INET then
    Result := NetAddrToStr(ASocketAddr.sin_addr)
  else // no ipv6 support yet
    Result := '';
end;



procedure TFPTCPConnectionResponse.DoSendHeaders(Headers: TStrings);

Var
  S : String;
  I : Integer;
begin
  S:=Format('HTTP/1.1 %3d %s'#13#10,[Code,GetStatusCode(Code)]);
  For I:=0 to Headers.Count-1 do
    S:=S+Headers[i]+#13#10;
  // Last line in headers is empty.
  Connection.Socket.WriteBuffer(S[1],Length(S));
end;

procedure TFPTCPConnectionResponse.DoSendContent;
begin
  If Assigned(ContentStream) then
    Connection.Socket.CopyFrom(ContentStream,0)
  else
    Contents.SaveToStream(Connection.Socket);
end;

{ TFPTCPConnection }

function TFPTCPConnection.ReadString : String;

  Procedure FillBuffer;

  Var
    R : Integer;

  begin
    SetLength(FBuffer,ReadBufLen);
    r:=FSocket.Read(FBuffer[1],ReadBufLen);
    If r<0 then
      Raise ETcpServer.Create(SErrReadingSocket);
    if (r<ReadBuflen) then
      SetLength(FBuffer,r);
  end;

Var
  CheckLF,Done : Boolean;
  P,L : integer;

begin
  Result:='';
  Done:=False;
  CheckLF:=False;
  Repeat
    if Length(FBuffer)=0 then
      FillBuffer;
    if Length(FBuffer)=0 then
      Done:=True
    else if CheckLF then
      begin
      If (FBuffer[1]<>#10) then
        Result:=Result+#13
      else
        begin
        Delete(FBuffer,1,1);
        Done:=True;
        end;
      CheckLF:=False;  
      end;
    if not Done then
      begin
      P:=Pos(#13#10,FBuffer);
      If P=0 then
        begin
        L:=Length(FBuffer);
        CheckLF:=FBuffer[L]=#13;
        if CheckLF then
          Result:=Result+Copy(FBuffer,1,L-1)
        else
          Result:=Result+FBuffer;
        FBuffer:='';
        end
      else
        begin
        Result:=Result+Copy(FBuffer,1,P-1);
        Delete(FBuffer,1,P+1);
        Done:=True;
        end;
      end;
  until Done;
end;

procedure TFPTCPConnection.UnknownHeader(ARequest: TFPTCPConnectionRequest;
  const AHeader: String);
begin
  // Do nothing
end;

procedure TFPTCPConnection.HandleRequestError(E: Exception);
begin
  If Assigned(FOnError) then
    try
      FOnError(Self,E);
    except
      // We really cannot handle this...
    end;
end;

procedure TFPTCPConnection.SetupSocket;
begin
{$if defined(FreeBSD) or defined(Linux)}
  FSocket.ReadFlags:=MSG_NOSIGNAL;
  FSocket.WriteFlags:=MSG_NOSIGNAL;
{$endif}
end;

Procedure TFPTCPConnection.InterPretHeader(ARequest : TFPTCPConnectionRequest; Const AHeader : String);

Var
  P : Integer;
  N,V : String;

begin
  V:=AHeader;
  P:=Pos(':',V);
  if (P=0) then
    begin
    UnknownHeader(ARequest,Aheader);
    Exit;
    end;
  N:=Copy(V,1,P-1);
  Delete(V,1,P+1);
  V:=Trim(V);
  ARequest.SetFieldByName(N,V);
end;

procedure ParseStartLine(Request : TFPTCPConnectionRequest; AStartLine : String);

  Function GetNextWord(Var S : String) : string;

  Var
    P : Integer;

  begin
    P:=Pos(' ',S);
    If (P=0) then
      P:=Length(S)+1;
    Result:=Copy(S,1,P-1);
    Delete(S,1,P);
  end;

Var
  S : String;
  I : Integer;
  
begin
  Request.Method:=GetNextWord(AStartLine);
  Request.URL:=GetNextWord(AStartLine);
  S:=Request.URL;
  If (S<>'') and (S[1]='/') then
    Delete(S,1,1);
  I:=Pos('?',S);
  if (I>0) then
    S:=Copy(S,1,I-1);
  Request.PathInfo:=S;
  S:=GetNextWord(AStartLine);
  If (Pos('HTTP/',S)<>1) then
    Raise ETcpServer.CreateHelp(SErrMissingProtocol,400);
  Delete(S,1,5);
  Request.ProtocolVersion:=trim(S);
end;

Procedure TFPTCPConnection.ReadRequestContent(ARequest : TFPTCPConnectionRequest);

Var
  P,L,R : integer;
  S : String;

begin
  L:=ARequest.ContentLength;
  If (L>0) then
    begin
    SetLength(S,L);
    P:=Length(FBuffer);
    if (P>0) then
      begin
      Move(FBuffer[1],S[1],P);
      L:=L-P;
      end;
    P:=P+1;
    R:=1;
    While (L<>0) and (R>0) do
      begin
      R:=FSocket.Read(S[p],L);
      If R<0 then
        Raise ETcpServer.Create(SErrReadingSocket);
      if (R>0) then
        begin
        P:=P+R;
        L:=L-R;
        end;
      end;  
    end;
  ARequest.InitContent(S);
end;

function TFPTCPConnection.ReadRequestHeaders: TFPTCPConnectionRequest;

Var
  StartLine,S : String;
begin
  Result:=Server.CreateRequest;
  try
    Server.InitRequest(Result);
    Result.FConnection:=Self;
    StartLine:=ReadString;
    ParseStartLine(Result,StartLine);
    Repeat
      S:=ReadString;
      if (S<>'') then
        InterPretHeader(Result,S);
    Until (S='');
    Result.RemoteAddress := SocketAddrToString(FSocket.RemoteAddress);
    Result.ServerPort := FServer.Port;
  except
    FreeAndNil(Result);
    Raise;
  end;
end;

constructor TFPTCPConnection.Create(AServer: TFPCustomTcpServer; ASocket: TSocketStream);
begin
  FSocket:=ASocket;
  FServer:=AServer;
  If Assigned(FServer) then
    InterLockedIncrement(FServer.FConnectionCount)
end;

destructor TFPTCPConnection.Destroy;
begin
  If Assigned(FServer) then
    InterLockedDecrement(FServer.FConnectionCount);
  FreeAndNil(FSocket);
  Inherited;
end;

Function TFPTCPConnection.GetLookupHostNames : Boolean;

begin
  if Assigned(FServer) then
    Result:=FServer.LookupHostNames
  else
    Result:=False;  
end;

procedure TFPTCPConnection.HandleRequest;

Var
  Req : TFPTCPConnectionRequest;
  Resp : TFPTCPConnectionResponse;

begin
  Try
    SetupSocket;
    // Read headers.
    Req:=ReadRequestHeaders;
    try
      //set port
      Req.ServerPort := Server.Port;
      // Read content, if any
      If Req.ContentLength>0 then
        ReadRequestContent(Req);
      Req.InitRequestVars;
      // Create Response
      Resp:= Server.CreateResponse(Req);
      try
        Server.InitResponse(Resp);
        Resp.FConnection:=Self;
        // And dispatch
        if Server.Active then
          Server.HandleRequest(Req,Resp);
        if Assigned(Resp) and (not Resp.ContentSent) then
          Resp.SendContent;
      finally
        FreeAndNil(Resp);
      end;
    Finally
      FreeAndNil(Req);
    end;
  Except
    On E : Exception do
      HandleRequestError(E);
  end;
end;

{ TFPTCPConnectionThread }

constructor TFPTCPConnectionThread.CreateConnection(AConnection: TFPTCPConnection
  );
begin
  FConnection:=AConnection;
  FreeOnTerminate:=True;
  Inherited Create(False);
end;

procedure TFPTCPConnectionThread.Execute;
begin
  try
    try
      FConnection.HandleRequest;
    finally
      FreeAndNil(FConnection);
    end;
  except
    // Silently ignore errors.
  end;
end;

{ TFPCustomTcpServer }

procedure TFPCustomTcpServer.HandleRequestError(Sender: TObject; E: Exception);
begin
  If Assigned(FOnRequestError) then
    try
      FOnRequestError(Sender,E);
    except
      // Do not let errors in user code escape.
    end
end;

procedure TFPCustomTcpServer.DoAcceptError(Sender: TObject; ASocket: Longint;
  E: Exception; var ErrorAction: TAcceptErrorAction);
begin
  If Not Active then
    ErrorAction:=AEAStop
  else
    ErrorAction:=AEARaise
end;

function TFPCustomTcpServer.GetActive: Boolean;
begin
  if (csDesigning in ComponentState) then
    Result:=FLoadActivate
  else
    Result:=Assigned(FServer);
end;

procedure TFPCustomTcpServer.StopServerSocket;
begin
  FServer.StopAccepting(True);
end;

procedure TFPCustomTcpServer.SetActive(const AValue: Boolean);
begin
  If AValue=GetActive then exit;
  FLoadActivate:=AValue;
  if not (csDesigning in Componentstate) then
    if AValue then
      begin
      CreateServerSocket;
      SetupSocket;
      StartServerSocket;
      FreeServerSocket;
      end
    else
      StopServerSocket;
end;

procedure TFPCustomTcpServer.SetOnAllowConnect(const AValue: TConnectQuery);
begin
  if FOnAllowConnect=AValue then exit;
  CheckInactive;
  FOnAllowConnect:=AValue;
end;

procedure TFPCustomTcpServer.SetAddress(const AValue: string);
begin
  if FAddress=AValue then exit;
  CheckInactive;
  FAddress:=AValue;
end;

procedure TFPCustomTcpServer.SetPort(const AValue: Word);
begin
  if FPort=AValue then exit;
  CheckInactive;
  FPort:=AValue;
end;

procedure TFPCustomTcpServer.SetQueueSize(const AValue: Word);
begin
  if FQueueSize=AValue then exit;
  CheckInactive;
  FQueueSize:=AValue;
end;

procedure TFPCustomTcpServer.SetThreaded(const AValue: Boolean);
begin
  if FThreaded=AValue then exit;
  CheckInactive;
  FThreaded:=AValue;
end;

function TFPCustomTcpServer.CreateRequest: TFPTCPConnectionRequest;
begin
  Result:=TFPTCPConnectionRequest.Create;
end;

function TFPCustomTcpServer.CreateResponse(ARequest : TFPTCPConnectionRequest): TFPTCPConnectionResponse;
begin
  Result:=TFPTCPConnectionResponse.Create(ARequest);
end;

procedure TFPCustomTcpServer.InitRequest(ARequest: TFPTCPConnectionRequest);
begin

end;

procedure TFPCustomTcpServer.InitResponse(AResponse: TFPTCPConnectionResponse
  );
begin

end;

function TFPCustomTcpServer.CreateConnection(Data: TSocketStream): TFPTCPConnection;
begin
  Result:=TFPTCPConnection.Create(Self,Data);
end;

function TFPCustomTcpServer.CreateConnectionThread(Conn: TFPTCPConnection
  ): TFPTCPConnectionThread;
begin
   Result:=TFPTCPConnectionThread.CreateConnection(Conn);
end;

procedure TFPCustomTcpServer.CheckInactive;
begin
  If GetActive then
    Raise ETcpServer.Create(SErrSocketActive);
end;

procedure TFPCustomTcpServer.DoConnect(Sender: TObject; Data: TSocketStream);

Var
  Con : TFPTCPConnection;

begin
  Con:=CreateConnection(Data);
  try
    Con.FServer:=Self;
    Con.OnRequestError:=@HandleRequestError;
    if Threaded then
      CreateConnectionThread(Con)
    else
      begin
      Con.HandleRequest;
      end;
  finally
    if not Threaded then
      Con.Free;
  end;
end;

procedure TFPCustomTcpServer.SetupSocket;

begin
  FServer.QueueSize:=Self.QueueSize;
  FServer.ReuseAddress:=true;
end;

procedure TFPCustomTcpServer.CreateServerSocket;
begin
  if FAddress='' then
    FServer:=TInetServer.Create(FPort)
  else
    FServer:=TInetServer.Create(FAddress,FPort);
  FServer.MaxConnections:=-1;
  FServer.OnConnectQuery:=OnAllowConnect;
  FServer.OnConnect:=@DOConnect;
  FServer.OnAcceptError:=@DoAcceptError;
end;

procedure TFPCustomTcpServer.StartServerSocket;
begin
  FServer.Bind;
  FServer.Listen;
  FServer.StartAccepting;
end;

procedure TFPCustomTcpServer.FreeServerSocket;
begin
  FreeAndNil(FServer);
end;

procedure TFPCustomTcpServer.HandleRequest(var ARequest: TFPTCPConnectionRequest;
  var AResponse: TFPTCPConnectionResponse);
begin
  If Assigned(FOnRequest) then
    FonRequest(Self,ARequest,AResponse);
end;

constructor TFPCustomTcpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPort:=80;
  FQueueSize:=5;
  FServerBanner := 'Freepascal';
end;

Procedure TFPCustomTcpServer.WaitForRequests;

Var
  FLastCount,ACount : Integer;

begin
  ACount:=0;
  FLastCount:=FConnectionCount;
  While (FConnectionCount>0) and (ACount<10) do
    begin
    Sleep(100);
    if (FConnectionCount=FLastCount) then
      Dec(ACount)
    else
      FLastCount:=FConnectionCount;
    end;
end;

destructor TFPCustomTcpServer.Destroy;
begin
  Active:=False;
  if Threaded and (FConnectionCount>0) then
    WaitForRequests;
  inherited Destroy;
end;

end.

