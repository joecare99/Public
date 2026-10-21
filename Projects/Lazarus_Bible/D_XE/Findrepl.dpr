program Findrepl; 
uses 
  Forms, 
  Frm_FindReplMAIN in '..\source\FINDREPL\Frm_FindReplMAIN.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Findrepl'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
