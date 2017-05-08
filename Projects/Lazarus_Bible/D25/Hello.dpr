program Hello; 
uses 
  Forms, 
  frm_HelloMAIN in '..\Source\HELLO\frm_HelloMAIN.PAS' {Form1}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Hello'; 
  Application.CreateForm(TForm1, Form1); 
  Application.Run; 
end. 
