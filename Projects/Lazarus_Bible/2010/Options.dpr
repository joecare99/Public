program Options;
uses
  Forms,
  Frm_OptionsMain in '..\Source\OPTIONS\Frm_OptionsMain.PAS' {MainForm},
  Inidata in '..\Source\Inidata\Inidata.pas';

{$E EXE}
{$R *.RES} 
begin
  Application.Initialize;
  Application.Title := 'Options - Demo'; 
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
