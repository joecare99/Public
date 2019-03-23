program prj_XMLDoc2Po;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  DefaultTranslator,
  sysutils,
  unt_cdate in 'c:\unt_CDate.pas',
  Forms, frm_XMLDoc2po, unt_PoFile, fra_PoFile, fra_XMLFile
  { you can add units after this };

{$R *.res}

function GetApplicationName: String;
begin
  result:='XMLDoc2Po'
end;

function GetVendorName: String;
begin
  Result:='JCSoft';
end;

begin
  RequireDerivedFormResource:=True;
  OnGetApplicationName:=@GetApplicationName;
  OnGetVendorName:=@GetVendorName;
  Application.Initialize;
  Application.CreateForm(TfrmXml2PoMain, frmXml2PoMain);
  Application.Run;
end.

