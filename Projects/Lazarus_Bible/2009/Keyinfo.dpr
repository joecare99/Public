program Keyinfo; 
uses 
  Forms, 
  Frm_KeyInfoMAIN in '..\Source\KEYINFO\Frm_KeyInfoMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Keyinfo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
