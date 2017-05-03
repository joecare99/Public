program OleCont; 
uses 
  Forms, 
  Frm_OleContMain in '..\Source\OleCont\Frm_OleContMain.pas' {MainForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'OLE Container Demonstration'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
