program Direxec; 
uses 
  Forms, 
  Frm_DirExecMAIN in '..\Source\DIREXEC\Frm_DirExecMAIN.PAS' {MainForm}, 
  Frm_Dirdlg in '..\Source\DIREXEC\..\Direx\Frm_Dirdlg.pas' {DirDlgForm};
{$R *.RES}
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Direxec'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TDirDlgForm, DirDlgForm); 
  Application.Run; 
end. 
