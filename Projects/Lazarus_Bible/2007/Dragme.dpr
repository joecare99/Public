program Dragme;

uses
  Forms,
  Frm_DragMeMAIN in '..\source\DRAGME\Frm_DragMeMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Dragme';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
