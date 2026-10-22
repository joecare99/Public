program Hello; 
uses 
  Forms, 
  frm_HelloMAIN in '..\source\HELLO\view\Frm_HelloMAIN.pas' {Form1}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Hello'; 
  Application.CreateForm(TForm1, Form1); 
  Application.Run; 
end. 
