program Combos;

uses
  Forms,
  Frm_CombosMAIN in '..\source\COMBOS\Frm_CombosMAIN.PAS' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Combos';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

