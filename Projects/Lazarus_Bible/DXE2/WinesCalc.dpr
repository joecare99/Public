program WinesCalc; 
uses 
  Forms, 
  Frm_WinesCalcMain in '..\Source\WinesCalc\Frm_WinesCalcMain.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: WinesCalc'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
