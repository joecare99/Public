program Fishy; 
uses 
  Forms, 
  Frm_Fishy2MAIN in '..\Source\FISHY\Frm_Fishy2MAIN.PAS' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  application.initialize; 
  Application.Title := 'Demo: Fishy'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
