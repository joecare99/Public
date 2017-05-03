program MayTemp;

uses
  Forms,
  Frm_MayMain in '..\source\MayTemp\Frm_MayMain.pas' {MainForm};

{$E EXE}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Key West Temperatures May 1871 - 1996';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
