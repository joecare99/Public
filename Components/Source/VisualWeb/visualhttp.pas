unit VisualHTTP;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, VisualHTTPClient, fphttpserver;

Procedure Register;

implementation

uses LazarusPackageIntf;

procedure RegisterUnitVisualHTTPClient;

begin
  RegisterComponents('fpWeb',[TVisualHTTPClient,TFPHttpServer]);
end;

procedure RegisterUnitfphttpserver;

begin
 //
end;

procedure Register;
begin
  RegisterUnit('VisualHTTPClient',@RegisterUnitVisualHTTPClient);
  RegisterUnitfphttpserver;
end;

{$R registerVHTTP.res}

end.

