program Tabedit;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  About in 'ABOUT.PAS' {AboutForm};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
