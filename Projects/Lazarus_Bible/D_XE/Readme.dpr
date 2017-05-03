program Readme;

uses
  Forms,
  Frm_ReadMeMain in '..\source\README\Frm_ReadMeMain.PAS' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Readme - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

