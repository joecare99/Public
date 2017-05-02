program Todo; 
uses 
  Forms, 
  Frm_TodoMAIN in '..\Source\TODO\Frm_TodoMAIN.PAS' {MainForm}, 
  Frm_ABOUT in '..\Source\TODO\Frm_ABOUT.PAS' {AboutForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Todo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.Run; 
end. 
