program Prj_Infectious;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$IFDEF FPC}
  Interfaces, // this includes the LCL widgetset
  {$ENDIF}
  Forms,
  Frm_InfectiousBoard,
  cls_InfectiousEng,
  Unt_CDate in 'c:\unt_cdate.pas'
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmInfectiousBoard, frmInfectiousBoard);
  Application.Run;
end.

