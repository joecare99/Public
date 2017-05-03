program Strlist; 
uses 
  Forms, 
  Frm_StrlistMAIN in '..\Source\STRLIST\Frm_StrlistMAIN.PAS' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Strlist - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
