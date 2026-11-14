program Options;
uses
  Forms,
  Frm_OptionsMain in '..\source\OPTIONS\Frm_OptionsMain.pas' {MainForm},
  Inidata in '..\source\Inidata\Inidata.pas';

{$E EXE}
{$R *.RES} 
begin
  Application.Initialize;
  Application.Title := 'Options - Demo'; 
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
