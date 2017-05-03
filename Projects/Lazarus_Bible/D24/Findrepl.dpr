program Findrepl; 
uses 
  Forms, 
  Frm_FindReplMAIN in '..\Source\FINDREPL\Frm_FindReplMAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Findrepl'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
