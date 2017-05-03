program StatusOD; 
uses 
  Forms, 
  Frm_StatusODMain in '..\Source\StatusOD\Frm_StatusODMain.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'StatusOD - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
