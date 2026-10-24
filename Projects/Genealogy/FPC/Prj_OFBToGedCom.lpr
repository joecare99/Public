program Prj_OFBToGedCom;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Frm_OFBToGedComMain, fra_OFBView, unt_FBParser, Cmp_GedComFile,
  cls_GedComHelper, fra_NavIData, dm_GenData2, Cmp_Parser
  { you can add units after this };

{$R *.res}

//Todo: Handle Locked Documents

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFrmOFBToGedComMain, FrmOFBToGedComMain);
  Application.Run;
end.

