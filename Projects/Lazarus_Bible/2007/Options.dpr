program Options;

uses
  Forms,
  Frm_OptionsMain in '..\OPTIONS\Frm_OptionsMain.pas' {MainForm},
  Inidata in '..\..\Inidata\Inidata.pas';

{$E EXE}

{$R *.RES}

begin
  Application.Title := 'Options - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
