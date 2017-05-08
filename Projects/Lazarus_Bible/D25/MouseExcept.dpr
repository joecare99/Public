program MouseExcept; 
uses 
  Forms, 
  frm_MouseExceptMain in '..\Source\MouseExcept\frm_MouseExceptMain.pas' {MainForm}; 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Custom Exceptions'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
