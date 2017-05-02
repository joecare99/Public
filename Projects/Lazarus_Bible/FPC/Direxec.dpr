program Direxec;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_DirExecMAIN in '..\source\Direxec\Frm_DirExecMAIN.PAS' {MainForm},
  frm_Dirdlg in '..\source\Direx\Frm_Dirdlg.pas' {DirDlgForm};

{$R *.res}
{$IFNDEF FPC} {$E EXE}   {$ENDIF}

begin
Application.Initialize;
  Application.Title := 'Demo: Direxec';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDirDlgForm, DirDlgForm);
  Application.Run;
end.
