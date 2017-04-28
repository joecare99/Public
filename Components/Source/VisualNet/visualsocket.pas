unit VisualSocket;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpsock2;

procedure register;

implementation

uses LazarusPackageIntf;

procedure RegisterUnitfpSock;

begin
  RegisterComponents('fpNet',[TTCPClient,TTCPServer]);
end;

Procedure register;

begin
  RegisterUnit('fpSock',@RegisterUnitfpSock);
end;

end.

