program fpc_TestStringTable;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, sysutils, GuiTestRunner, fpcunittestrunner, test_StringTable;

{$R *.res}

function GetVendorname: String;
begin
  result := 'JC-Soft'
end;

begin
  OnGetVendorName:=@GetVendorname;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

