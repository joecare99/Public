program Direx;

uses
  Forms,
  Frm_DirExMAIN in '..\DIREX\Frm_DirExMAIN.pas' {MainForm},
  DIRDLG in '..\DIRDLG.PAS' {DirDlgForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Direx';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDirDlgForm, DirDlgForm);
  Application.Run;
end.
