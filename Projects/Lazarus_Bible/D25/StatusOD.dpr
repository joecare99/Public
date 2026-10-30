program StatusOD; 
uses 
  Forms, 
  Frm_StatusODMain in '..\source\StatusOD\Frm_StatusODMain.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'StatusOD - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
