program Prj_GedCom2Odf;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Frm_GedCom2OdfMain, cmp_GedComDocumentWriter, unt_IGenBase2,
  Cls_GedComExt, cls_GenealogieHelper, Cmp_GedComFile, fra_GenShowIndivid,
  fra_GenIndivData, fra_GenIndivEvent
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmGedCom2OdfMain, frmGedCom2OdfMain);
  Application.Run;
end.

