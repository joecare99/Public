program Combos;

uses
  Forms,
  Frm_CombosMAIN in '..\COMBOS\Frm_CombosMAIN.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Combos';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

