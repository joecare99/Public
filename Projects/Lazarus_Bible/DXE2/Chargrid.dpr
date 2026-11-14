program Chargrid;

uses
  Forms,
  Frm_CharGridMAIN in '..\source\CharGrid\Frm_CharGridMAIN.pas' {MainForm},
  Frm_CharGridABOUT in '..\source\CharGrid\Frm_CharGridABOUT.pas' {AboutForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Chargrid';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
