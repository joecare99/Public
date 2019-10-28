program fpcTestGedComFile;

{$mode objfpc}{$H+}

uses
  Interfaces, sysutils, Forms, GuiTestRunner, tst_GedComFile, tst_GedComHelper,
  tst_GenHelper, Cls_GedComExt;

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

