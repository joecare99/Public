program Except1; 
uses 
  Forms, 
  Frm_Except1MAIN in '..\Source\EXCEPT1\Frm_Except1MAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Except1'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
