program prj_FpServerSock;

uses sysutils, fpsock;
{$apptype Console}
var AServer:TTCPServer;
    st:string;

begin
  AServer := TTCPServer.Create(nil);
  try
    AServer.Port:=25;
    AServer.Active:=true;
    repeat
       if Aserver.Stream.Size > Aserver.Stream.Position then
          begin
            setlength(st,Aserver.Stream.Size-Aserver.Stream.Position)
            Aserver.Stream.Read(st[1],length(st));
            writeln(st);
          end;
    until not AServer.Active;
  finally
    freeandnil(AServer);
  end;
end.

