program Strlist; 
uses 
  Forms, 
  Frm_StrlistMAIN in '..\source\STRLIST\Frm_StrlistMAIN.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Strlist - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
