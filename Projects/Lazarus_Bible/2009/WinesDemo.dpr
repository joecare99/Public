program WinesDemo; 
uses 
  Forms, 
  Frm_WinesDemoMain in '..\source\WinesDemo\Frm_WinesDemoMain.pas' {MainForm};
{$R *.RES} 
{$E EXE}
begin 
  Application.Initialize; 
  Application.Title := 'Demo: WinesDemo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end.
