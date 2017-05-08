program Toolbar3; 
uses 
  Forms, 
  Frm_Toolbar3MAIN in '..\Source\TOOLBAR3\Frm_Toolbar3MAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: Toolbar3'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
