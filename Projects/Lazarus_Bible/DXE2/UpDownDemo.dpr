program UpDownDemo; 
uses 
  Forms, 
  frm_UpDownDemoMain in '..\Source\UpDownDemo\frm_UpDownDemoMain.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: UpDownDemo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
