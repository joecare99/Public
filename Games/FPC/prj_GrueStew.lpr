program prj_GrueStew;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
    DefaultTranslator,
  Forms, Frm_GrueStewHmi, cls_GrueStewEng, unt_GrueStewBase
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmGrueStewMain, frmGrueStewMain);
  Application.Run;
end.

