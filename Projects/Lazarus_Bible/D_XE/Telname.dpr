program Telname;

uses
  Forms,
  Frm_TelnameMAIN in '..\source\TELNAME\Frm_TelnameMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Telname';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
