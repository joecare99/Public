program fpc_TestParseFBEntry;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, sysutils, GuiTestRunner, cls_TestParseFBEntry,
  unt_TestFBData, unt_FBParser, Cmp_Parser;

{$R *.res}

function GetVendorname: String;
begin
  result:='JCSoft'
end;

function GetApplicationName: String;
begin
  result := 'GenData'
end;

begin
  Application.Initialize;
  OnGetVendorName:=@GetVendorname;
  OnGetApplicationName:=@GetApplicationName;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

