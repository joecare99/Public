program Direx;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_DirExMAIN in '..\source\DIREX\Frm_DirExMAIN.PAS' {MainForm},
  Frm_DIRDLG in '..\source\DIREX\Frm_DIRDLG.PAS' {DirDlgForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
Application.Initialize;
  Application.Title := 'Demo: Direx';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDirDlgForm, DirDlgForm);
  Application.Run;
end.
