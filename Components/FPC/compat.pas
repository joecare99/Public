{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit Compat;

interface

uses
  graph, int_Graph, Unt_FARBGR, Unt_PasMouse, Win32Crt, Fra_Graph, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('Compat', @Register);
end.
