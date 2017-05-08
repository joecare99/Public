program Lister; 
uses 
  Forms, 
  Frm_ListerMAIN in '..\Source\LISTER\Frm_ListerMAIN.PAS' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Lister'; 
  Application.Title := 'Text-File-Lister'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
