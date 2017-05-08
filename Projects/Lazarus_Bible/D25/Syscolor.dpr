program Syscolor; 
uses 
  Forms, 
  Frm_SyscolorMAIN in '..\Source\SYSCOLOR\Frm_SyscolorMAIN.PAS' {MainForm}, 
  Frm_ABOUTDLG in '..\Source\SYSCOLOR\Frm_ABOUTDLG.PAS' {AboutBox}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Syscolor - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutBox, AboutBox); 
  Application.Run; 
end. 
