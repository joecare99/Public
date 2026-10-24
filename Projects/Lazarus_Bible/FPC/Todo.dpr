program Todo; 
uses 
  Forms, 
  Frm_TodoMAIN in '..\source\TODO\Frm_TodoMAIN.pas' {MainForm}, 
  TODO_Frm_ABOUT in '..\source\TODO\TODO_Frm_ABOUT.pas' {AboutForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Todo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.Run; 
end. 
