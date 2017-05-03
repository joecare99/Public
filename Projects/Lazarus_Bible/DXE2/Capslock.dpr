program Capslock;

uses
  Forms,
  Frm_CapslockMAIN in '..\source\CAPSLOCK\Frm_CapslockMAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Capslock';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

