program Direx; 
uses 
  Forms, 
  Frm_DirExMAIN in '..\Source\DIREX\Frm_DirExMAIN.PAS' {MainForm}, 
  Frm_DIRDLG in '..\Source\DIREX\Frm_DIRDLG.PAS' {DirDlgForm};
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Direx'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TDirDlgForm, DirDlgForm); 
  Application.Run; 
end. 
