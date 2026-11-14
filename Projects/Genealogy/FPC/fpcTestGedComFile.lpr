program fpcTestGedComFile;

{$mode objfpc}{$H+}

uses
  Interfaces, sysutils, Forms, laz2_XMLWrite2, GuiTestRunner, tst_GedComFile,
  tst_GedComHelper, tst_GenHelper, Cls_GedComExt, tst_GedCom2Odf,
  cmp_GedComDocumentWriter, unt_IGenBase2, tst_GedComExt, unt_GenTestBase;

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

