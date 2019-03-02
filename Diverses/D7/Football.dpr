program Football;

uses
  Forms,
  Main in '..\Source\D7Demos\Football\Main.pas' {MainForm},
  about in '..\Source\D7Demos\Football\about.pas' {AboutForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
