program Prj_ParseFBEntry;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Frm_ParseFBEntryMain, unt_FBParser, cls_GedComHelper, Cmp_Parser
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFrmParseFBEntryMain, FrmParseFBEntryMain);
  Application.Run;
end.

