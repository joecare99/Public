program Dropfile; 
uses 
  Forms, 
  Frm_DropFileMAIN in '..\source\DROPFILE\Frm_DropFileMAIN.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Dropfile'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
