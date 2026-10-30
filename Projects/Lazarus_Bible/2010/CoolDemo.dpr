program CoolDemo; 
uses 
  Forms, 
  frm_CooldemoMain in '..\source\Cooldemo\frm_CooldemoMain.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: CoolDemo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
