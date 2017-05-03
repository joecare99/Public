program Spinbutt; 
uses 
  Forms, 
  Frm_SpinButtonMAIN in '..\Source\SPINBUTT\Frm_SpinButtonMAIN.PAS' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'SpinButton - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
