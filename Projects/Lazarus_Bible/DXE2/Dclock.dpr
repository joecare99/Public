program Dclock;

uses
  Forms,
  Frm_DClockMAIN in '..\source\DCLOCK\Frm_DClockMAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Dclock';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

