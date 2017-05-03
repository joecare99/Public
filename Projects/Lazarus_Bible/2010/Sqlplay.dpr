program Sqlplay; 
uses 
  Forms, 
  Frm_SqlplayMAIN in '..\Source\SQLPLAY\Frm_SqlplayMAIN.PAS' {MainForm}, 
  Frm_SQLOPENDB in '..\Source\SQLPLAY\Frm_SQLOPENDB.PAS' {OpenForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Sqlplay - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TOpenForm, OpenForm); 
  Application.Run; 
end. 
