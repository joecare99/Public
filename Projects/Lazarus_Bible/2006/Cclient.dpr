program Cclient;

uses
  Forms,
  Frm_CLIMAIN in '..\DDECOLOR\Frm_CLIMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Cclient';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
