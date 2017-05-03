program PageTabOD;

uses
  Forms,
  Frm_PagetabODMain in '..\source\PageTabOD\Frm_PagetabODMain.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PageTab-OwnerDraw Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
