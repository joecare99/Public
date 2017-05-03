program Exlist; 
uses 
  Forms, 
  Frm_exListMAIN in '..\Source\EXLIST\Frm_exListMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Exlist'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
