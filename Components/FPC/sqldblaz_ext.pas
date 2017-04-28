{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit SQLDBLaz_ext;

interface

uses
  registersqldb_ext, mariadbdyn, mariadbconn, mysql60conn, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('registersqldb_ext', @registersqldb_ext.Register);
end;

initialization
  RegisterPackage('SQLDBLaz_ext', @Register);
end.
