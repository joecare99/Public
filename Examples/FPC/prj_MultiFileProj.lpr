program prj_MultiFileProj;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Frm_MultiFileMain, Fra_CloseButtons, Frm_File2, Frm_File3;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmDialog3, frmDialog3);
  Application.CreateForm(TfrmDialog2, frmDialog2);
  Application.Run;
end.

