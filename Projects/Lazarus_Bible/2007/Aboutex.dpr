program Aboutex;

uses
  Forms,
  ABOUT in '..\Source\AboutEx\ABOUT.PAS' {AboutForm},
  Frm_AboutExMAIN in '..\Source\AboutEx\Frm_AboutExMAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Aboutex';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.

