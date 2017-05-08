program Dropfile; 
uses 
  Forms, 
  Frm_DropFileMAIN in '..\Source\DROPFILE\Frm_DropFileMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Dropfile'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
