program Ontop;

uses
  Forms,
  Frm_OntopMAIN in '..\ONTOP\Frm_OntopMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Title := 'Stay On Top Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

