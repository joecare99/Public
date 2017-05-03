program Metamore; 
uses 
  Forms, 
  Frm_MetaMoreMAIN in '..\Source\METAMORE\Frm_MetaMoreMAIN.PAS' {MainForm}; 
{$E exe} 
{$R *.RES} 
begin 
  Application.Title := 'MetaMore'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
