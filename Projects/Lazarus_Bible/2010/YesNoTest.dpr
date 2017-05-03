program YesNoTest; 
uses 
  Forms, 
  Frm_YesNoMAIN in '..\Source\YESNO\Frm_YesNoMAIN.PAS' {MainForm}, 
  YESNO in '..\Source\YESNO\YESNO.PAS' {YesNoDlg}; 
{$R *.RES} 
{$E EXE} 
begin 
  Application.Initialize; 
  Application.title:='Demo: YesNoTest'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TYesNoDlg, YesNoDlg); 
  Application.Run; 
end. 
