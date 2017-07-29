{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit CmpSQLTable;

{$warn 5023 off : no warning about unused units}
interface

uses
  cmp_SQLTable, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('cmp_SQLTable', @cmp_SQLTable.Register);
end;

initialization
  RegisterPackage('CmpSQLTable', @Register);
end.
