program prj_XMLDoc2Po;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  DefaultTranslator,
  unt_cdate in 'c:\unt_CDate.pas',
  Forms, frm_XMLDoc2po, unt_PoFile, fra_PoFile, fra_XMLFile
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmXml2PoMain, frmXml2PoMain);
  Application.Run;
end.

