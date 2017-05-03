program Except3; 
uses 
  Forms, 
  frm_except3MAIN in '..\Source\EXCEPT3\frm_except3MAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Except3'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
