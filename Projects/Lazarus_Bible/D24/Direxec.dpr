program Direxec;

uses
  Forms,
  Frm_DirExecMAIN in '..\source\Direxec\Frm_DirExecMAIN.PAS' {MainForm},
  frm_Dirdlg in '..\source\Direx\Frm_Dirdlg.pas' {DirDlgForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Direxec';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDirDlgForm, DirDlgForm);
  Application.Run;
end.
