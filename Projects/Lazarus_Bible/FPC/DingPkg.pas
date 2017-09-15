{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit DingPkg;

interface

uses
  Ctrl_DingButton, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Ctrl_DingButton', @Ctrl_DingButton.Register);
end;

initialization
  RegisterPackage('DingPkg', @Register);
end.
