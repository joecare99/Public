program Compstrm; 
uses 
  Forms, 
  frm_CompStrmMAIN in '..\source\COMPSTRM\frm_CompStrmMAIN.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: Compstrm'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
