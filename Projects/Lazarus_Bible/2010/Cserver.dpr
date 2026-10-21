program Cserver; 
uses 
  Forms, 
  Frm_SERMAIN in '..\source\DDECOLOR\Frm_SERMAIN.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Cserver'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
