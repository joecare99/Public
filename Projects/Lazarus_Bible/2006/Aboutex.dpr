program Aboutex;

uses
  Forms,
  ABOUT in 'ABOUT.PAS' {AboutForm},
  Frm_AboutExMAIN in 'Frm_AboutExMAIN.PAS' {MainForm};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.

