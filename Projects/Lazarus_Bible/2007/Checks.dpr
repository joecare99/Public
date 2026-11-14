program Checks;

uses
  Forms,
  Frm_ChecksMAIN in '..\CHECKS\Frm_ChecksMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Checks';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

