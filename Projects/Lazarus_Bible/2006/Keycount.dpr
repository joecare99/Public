program Keycount;

uses
  Forms,
  Frm_KeyCountMAIN in '..\KEYCOUNT\Frm_KeyCountMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Keycount';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

