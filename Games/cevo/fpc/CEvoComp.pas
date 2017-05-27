{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit CEvoComp;

interface

uses
  ButtonBase, ButtonA, ButtonB, EOTButton, ButtonN, ButtonC, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ButtonA', @ButtonA.Register);
  RegisterUnit('ButtonB', @ButtonB.Register);
  RegisterUnit('EOTButton', @EOTButton.Register);
  RegisterUnit('ButtonN', @ButtonN.Register);
  RegisterUnit('ButtonC', @ButtonC.Register);
end;

initialization
  RegisterPackage('CEvoComp', @Register);
end.
