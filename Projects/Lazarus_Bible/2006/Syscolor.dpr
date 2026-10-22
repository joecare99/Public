program Syscolor;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  Aboutdlg in 'ABOUTDLG.PAS' {AboutBox};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
