{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit fv;

interface

uses
  App, AsciiTab, buildfv, ColorTxt, Dialogs, Drivers, Editors, FVCommon, 
  FVConsts, Gadgets, HistList, InpLong, Memory, Menus, MsgBox, outline, 
  Statuses, StdDlg, sysmsg, tabs, Time, timeddlg, Validate, Views, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('fv', @Register);
end.
