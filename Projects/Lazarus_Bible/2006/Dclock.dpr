program Dclock;

uses
  Forms,
  Frm_DClockMAIN in '..\DCLOCK\Frm_DClockMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Dclock';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

