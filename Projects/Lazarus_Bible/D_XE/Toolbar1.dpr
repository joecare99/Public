program Toolbar1;

uses
  Forms,
  Frm_Toolbar1MAIN in '..\source\TOOLBAR1\Frm_Toolbar1MAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Toolbar1';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

