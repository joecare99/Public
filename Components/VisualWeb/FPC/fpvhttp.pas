{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit fpvhttp;

interface

uses
  VisualHTTP, VisualHTTPClient, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('VisualHTTP', @VisualHTTP.Register);
end;

initialization
  RegisterPackage('fpvhttp', @Register);
end.
