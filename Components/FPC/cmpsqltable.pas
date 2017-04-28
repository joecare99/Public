{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit CmpSQLTable;

interface

uses
  SQLTable, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('SQLTable', @SQLTable.Register);
end;

initialization
  RegisterPackage('CmpSQLTable', @Register);
end.
