program Readme;

uses
  Forms,
  Frm_ReadMeMain in '..\README\Frm_ReadMeMain.pas' {MainForm};

{$E EXE}
{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Readme - Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

