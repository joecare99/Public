program Fishy; 
uses 
  Forms, 
  Frm_FishyMAIN in '..\Source\FISHY\Frm_FishyMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Fishy'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
