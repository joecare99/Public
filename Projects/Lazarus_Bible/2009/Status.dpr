program Status; 
uses 
  Forms, 
  Frm_StatusMain in '..\Source\Status\Frm_StatusMain.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Status - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
