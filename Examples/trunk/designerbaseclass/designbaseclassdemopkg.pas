{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit DesignBaseClassDemoPkg;

{$warn 5023 off : no warning about unused units}
interface

uses
  CustomComponentClass, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('CustomComponentClass', @CustomComponentClass.Register);
end;

initialization
  RegisterPackage('DesignBaseClassDemoPkg', @Register);
end.
