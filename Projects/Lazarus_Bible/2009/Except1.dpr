program Except1; 
uses 
  Forms, 
  Frm_Except1MAIN in '..\source\EXCEPT1\Frm_Except1MAIN.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Except1'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
