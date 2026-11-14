program Capslock;

uses
  Forms,
  Frm_CapslockMAIN in '..\Capslock\Frm_CapslockMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Capslock';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

