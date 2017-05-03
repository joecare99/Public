program WinesEntry; 
uses 
  Forms, 
  Frm_WinesEntryMain in '..\Source\WinesEntry\Frm_WinesEntryMain.pas' {MainForm}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.Title := 'Demo: WinesEntry'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
