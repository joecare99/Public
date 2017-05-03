program Report1; 
uses 
  Forms, 
  Frm_Report1Main in '..\Source\Report1\Frm_Report1Main.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'PrnInfo - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
