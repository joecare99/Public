program prj_SendTest;
{$APPTYPE CONSOLE}
uses
  SysUtils,
  windows,
  winsock;

var
  MyData:WSADATA;
  Rslt:Integer;
  s:TSocket;
  SendBuf:Array[0..31] of AnsiChar;
  clientservice:sockaddr_in;
  BytesSent:Integer;
begin
 try
   Rslt := WSAStartup(MAKEWORD (2,2), MyData);
   if Rslt = NO_ERROR then
   begin
    s := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if s <> INVALID_SOCKET then
    begin
      clientservice.sin_family := AF_INET;
      clientservice.sin_addr.s_addr := inet_addr('127.0.0.1');
      clientservice.sin_port := htons(8080);
      if connect(s,clientservice,sizeof(clientservice)) <> SOCKET_ERROR then
       begin
        sendbuf := 'la la la la la la la :)';
        bytesSent := send(s,sendbuf,Length(sendbuf),0);
        writeln('Bytes send: ',bytesSent);
      end else writeln('Failed to connect');
    end else writeln('Error at Socket: ',WSAGetLastError);
   end else writeln('Error at WSAStartup');
 finally
  Writeln(SysErrorMessage(GetLastError));
  WSACleanUp;
  Readln;
 end;
end.
