program Ontop;

uses
  Forms,
  Frm_OntopMAIN in '..\source\ONTOP\Frm_OntopMAIN.PAS' {MainForm};

{$R *.RES}

begin
  Application.Title := 'Stay On Top Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

