program Strres; 
{$R 'ERRMSG.res' '..\Source\STRRES\ERRMSG.RC'} 
uses 
  Forms, 
  Frm_StrresMAIN in '..\source\STRRES\Frm_StrresMAIN.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Strres - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
