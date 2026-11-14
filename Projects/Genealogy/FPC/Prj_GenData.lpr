program Prj_GenData;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, fpvhttp, frm_GenData, dm_GenData2;

{$R *.res}

begin
  Application.Scaled:=True;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TdmGenData, dmGenData);
  Application.CreateForm(TfrmGenData, frmGenData);
  Application.Run;
end.

