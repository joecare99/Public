program Master;

uses
  Forms,
  Frm_MasterMAIN in '..\MASTER\Frm_MasterMAIN.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
Application.Initialize;
  Application.Title := 'Master-Detail Database Demonstration';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
