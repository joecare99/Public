program Direxec;

uses
  Forms,
  Frm_DirExecMAIN in '..\source\DIREXEC\Frm_DirExecMAIN.pas' {MainForm},
  frm_Dirdlg in '..\source\DIREX\Frm_DIRDLG.pas' {DirDlgForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Direxec';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDirDlgForm, DirDlgForm);
  Application.Run;
end.
