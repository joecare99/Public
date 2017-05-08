program Enumwin; 
uses 
  Forms, 
  Frm_EnumWinMAIN in '..\Source\ENUMWIN\Frm_EnumWinMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: Enumwin'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
