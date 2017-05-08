program Polyflow; 
uses 
  Forms, 
  Frm_PolyflowMain in '..\Source\POLYFLOW\Frm_PolyflowMain.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Polyflow - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
