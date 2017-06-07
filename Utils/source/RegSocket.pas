unit RegSocket;

interface

uses
  SysUtils, Classes, ScktComp;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Sockets', [TClientSocket]);
end;

end.
