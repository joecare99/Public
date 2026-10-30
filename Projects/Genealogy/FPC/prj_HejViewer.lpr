program prj_HejViewer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Frm_HejViewerMain, fra_HejIndView,dm_GenData2, fra_IndIndex, cls_HejDataFilter
  { you can add units after this };

{$R *.res}

begin
  Application.Scaled:=True;
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TdmGenData, dmGenData);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

