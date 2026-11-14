program Except3; 
uses 
  Forms, 
  frm_except3MAIN in '..\source\EXCEPT3\frm_except3MAIN.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Except3'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
