program StaticDemo; 
uses 
  Forms, 
  Frm_StaticDemoMain in '..\Source\StaticDemo\Frm_StaticDemoMain.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'StaticDemo - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
