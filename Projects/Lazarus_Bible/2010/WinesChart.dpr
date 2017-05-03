program WinesChart; 
uses 
  Forms, 
  frm_WinesChartMain in '..\Source\WinesChart\frm_WinesChartMain.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: WinesChart'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
