program Prj_TestDocking;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  unt_cdate in 'c:\unt_cdate.pas',
  Frm_DockingMain, anchordockpkg, frm_ProjektExplorer,
frm_ObjectInspector, fra_FormDesigner, frm_ViewDetails, frm_StatusBar, 
frm_Library, fra_MeldeEintraege
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProjectExplorer, frmProjectExplorer);
  Application.CreateForm(TfrmObjectInspector, frmObjectInspector);
  Application.CreateForm(TfrmViewDetails, frmViewDetails);
  Application.CreateForm(TfrmStatusbar, frmStatusbar);
  Application.CreateForm(TfrmLibrary, frmLibrary);
  Application.Run;
end.

