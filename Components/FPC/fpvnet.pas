{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit fpvnet;

{$warn 5023 off : no warning about unused units}
interface

uses
  VisualSocket, fpsock2, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('VisualSocket', @VisualSocket.Register);
end;

initialization
  RegisterPackage('fpvnet', @Register);
end.
