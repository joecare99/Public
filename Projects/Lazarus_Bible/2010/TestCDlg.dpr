program TestCDlg; 
uses 
  Forms, 
  COLORDLG in '..\Source\COLORDLG\COLORDLG.PAS' {ColorDlgForm}, 
  Frm_TestCdlgMAIN in '..\Source\COLORDLG\Frm_TestCdlgMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: TestCDlg'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TColorDlgForm, ColorDlgForm); 
  Application.Run; 
end. 
