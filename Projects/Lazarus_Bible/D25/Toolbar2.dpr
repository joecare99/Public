program Toolbar2; 
uses 
  Forms, 
  Frm_Toolbar2MAIN in '..\Source\TOOLBAR2\Frm_Toolbar2MAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: Toolbar2'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
