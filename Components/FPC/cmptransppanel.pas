{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit cmpTranspPanel;

interface

uses
  cmp_transparentpanel, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('cmp_transparentpanel', @cmp_transparentpanel.Register);
end;

initialization
  RegisterPackage('cmpTranspPanel', @Register);
end.
