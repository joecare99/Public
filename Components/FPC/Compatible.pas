{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit Compatible;

{$warn 5023 off : no warning about unused units}
interface

uses
  Win32Crt, int_Graph, graph, unt_FARBGR, Fra_Graph, Unt_PasMouse, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Fra_Graph', @Fra_Graph.Register);
end;

initialization
  RegisterPackage('Compatible', @Register);
end.
