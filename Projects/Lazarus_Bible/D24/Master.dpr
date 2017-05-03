program Master; 
uses 
  Forms, 
  Frm_MasterMAIN in '..\Source\MASTER\Frm_MasterMAIN.PAS' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
Application.Initialize; 
  Application.Title := 'Master-Detail Database Demonstration'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
