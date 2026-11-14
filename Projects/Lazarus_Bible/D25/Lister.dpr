program Lister; 
uses 
  Forms, 
  Frm_ListerMAIN in '..\source\LISTER\Frm_ListerMAIN.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Lister'; 
  Application.Title := 'Text-File-Lister'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
