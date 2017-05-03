program TestDing; 
uses 
  Forms, 
  Frm_TestDingMain in '..\Source\DING\Frm_TestDingMain.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: TestDing'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
