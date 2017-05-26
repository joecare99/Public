{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit BarChartp;

{$warn 5023 off : no warning about unused units}
interface

uses
  BarChart, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('BarChart', @BarChart.Register);
end;

initialization
  RegisterPackage('BarChartp', @Register);
end.
