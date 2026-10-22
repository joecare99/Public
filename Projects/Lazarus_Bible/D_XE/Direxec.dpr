program Direxec;

uses
  Forms,
  Frm_DirExecMAIN in '..\DIREXEC\Frm_DirExecMAIN.pas' {MainForm},
  Dirdlg in '..\..\Direx\Dirdlg.pas' {DirDlgForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Direxec';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDirDlgForm, DirDlgForm);
  Application.Run;
end.
