program prj_GrueStew;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ELSE}
{$E EXE}
{$EndIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$IFDEF FPC}
  Interfaces, // this includes the LCL widgetset
  {$ENDIF}
  Forms,
  { you can add units after this }
  Frm_GrueStewHmi in '..\source\GrueStew\Frm_GrueStewHmi.pas',
  unt_GrueStewBase in '..\source\GrueStew\unt_GrueStewBase.pas',
  cls_GrueStewEng in '..\source\GrueStew\cls_GrueStewEng.pas';

{$R *.res}

begin
 {$IFDEF FPC}
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  {$ENDIF}
  Application.Initialize;
  {$IFDEF MSWINDOWS}
  {%H-}Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TfrmGrueStewMain, frmGrueStewMain);
  Application.Run;
end.

