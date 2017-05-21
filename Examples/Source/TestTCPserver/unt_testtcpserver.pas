unit unt_TestTCPserver;

interface

uses
  Classes, SysUtils;

procedure Init;
procedure Execute;

implementation

uses
  Sockets, fpAsync, fpSock;

procedure Init;
begin
  // No Initialization needed
end;

procedure Execute;

var
  ClientEventLoop: TEventLoop;

begin
  ClientEventLoop := TEventLoop.Create;
  try
    with TTCPClient.Create(nil) do
    begin
      EventLoop := ClientEventLoop;
      Host := '127.0.0.1';
      Port := 12000;
      Active := True;
      EventLoop.Run;
      Stream.WriteAnsiString('Hello');
      Active := False;
    end;
  finally
    FreeAndNil(ClientEventLoop);
  end;
end;

end.
