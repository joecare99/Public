program fpcTestXMLDoc2Po;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

uses
  Interfaces, Forms, sysutils, GuiTestRunner, tst_XMLDoc2po, fra_PoFile,
  unt_CDate in 'c:\unt_cdate.pas';

{$R *.res}

function GetVendorName: String;
begin
  Result:= 'JCSoft';
end;

function GetApplicationName: String;
begin
  Result:='XMLDoc2Po';
end;

begin
  OnGetVendorName:=@GetVendorName;
  OnGetApplicationName:=@GetApplicationName;
  Application.Initialize;
  Application.Title := 'fpcUnit: Test XMLDoc 2 Po';
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

