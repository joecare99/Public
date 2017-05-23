{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit dcl_KGSoft;

interface

uses
  Unt_DCL, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Unt_DCL', @Unt_DCL.Register);
end;

initialization
  RegisterPackage('dcl_KGSoft', @Register);
end.
