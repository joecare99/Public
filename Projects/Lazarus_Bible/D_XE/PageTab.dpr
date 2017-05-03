program PageTab;

uses
  Forms,
  Frm_PageTabMain in '..\source\PageTab\Frm_PageTabMain.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PageTab - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
