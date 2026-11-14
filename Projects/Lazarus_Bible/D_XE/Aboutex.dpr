program Aboutex;

uses
  Forms,
  ABOUT in '..\Source\AboutEx\ABOUT.PAS' {AboutForm} ,
  Frm_AboutExMAIN in '..\source\AboutEx\Frm_AboutExMAIN.pas' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.Title := 'Demo: AboutEx';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;

end.
