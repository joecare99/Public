program Fancy; 
uses 
  Forms, 
  Frm_FancyMAIN in '..\Source\FANCY\Frm_FancyMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Fancy'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
