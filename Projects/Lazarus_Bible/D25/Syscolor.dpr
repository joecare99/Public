program Syscolor; 
uses 
  Forms, 
  Frm_SyscolorMAIN in '..\source\SYSCOLOR\Frm_SyscolorMAIN.pas' {MainForm}, 
  Frm_ABOUTDLG in '..\source\SYSCOLOR\Frm_ABOUTDLG.pas' {AboutBox}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Syscolor - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutBox, AboutBox); 
  Application.Run; 
end. 
