program Prj_VecFontEdit;

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
  Frm_VecFontEdit in '..\source\Frm_VecFontEdit.pas',
  cls_vecfont in '..\source\cls_vecfont.pas',
  unt_cdate in 'c:\unt_cdate.pas'
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TFrmVecFontEditMain, FrmVecFontEditMain);
  Application.Run;
end.

