program TestCDlg; 
uses 
  Forms, 
  COLORDLG in '..\source\COLORDLG\COLORDLG.pas' {ColorDlgForm}, 
  Frm_TestCdlgMAIN in '..\source\COLORDLG\Frm_TestCdlgMAIN.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: TestCDlg'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TColorDlgForm, ColorDlgForm); 
  Application.Run; 
end. 
