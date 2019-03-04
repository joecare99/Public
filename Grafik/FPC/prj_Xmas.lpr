program prj_Xmas;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, frm_XmasMain
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := true;
  Application.Initialize;
  Application.CreateForm(TfrmXmasMain, frmXmasMain);
  Application.Run;
end.

