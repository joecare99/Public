program Mdidemo; 
uses 
  Forms, 
  Frm_MDIDemoMAIN in '..\Source\MDIDEMO\Frm_MDIDemoMAIN.PAS' {MainForm}, 
  CHILD1 in '..\Source\MDIDEMO\CHILD1.PAS' {ChildForm}, 
  Frm_MDIDemoABOUT in '..\Source\MDIDEMO\Frm_MDIDemoABOUT.PAS' {AboutForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Title := 'MDI Demonstration'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.Run; 
end. 
