program Compstrm; 
uses 
  Forms, 
  frm_CompStrmMAIN in '..\Source\COMPSTRM\frm_CompStrmMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: Compstrm'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
