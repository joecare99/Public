program Keycount; 
uses 
  Forms, 
  Frm_KeyCountMAIN in '..\Source\KEYCOUNT\Frm_KeyCountMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Keycount'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
