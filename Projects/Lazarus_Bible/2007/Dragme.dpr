program Dragme;

uses
  Forms,
  Frm_DragMeMAIN in '..\source\Dragme\Frm_DragMeMAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Dragme';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
