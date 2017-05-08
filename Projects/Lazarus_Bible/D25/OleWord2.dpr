program OleWord2; 
uses 
  Forms, 
  Frm_OLEWord2Main in '..\Source\OleWord2\Frm_OLEWord2Main.pas' {MainForm}; 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
