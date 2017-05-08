program Options; 
uses 
  Forms, 
  Frm_OptionsMain in '..\Source\OPTIONS\Frm_OptionsMain.PAS' {MainForm}, 
  Inidata in '..\Source\OPTIONS\..\Inidata\Inidata.pas'; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Title := 'Options - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
