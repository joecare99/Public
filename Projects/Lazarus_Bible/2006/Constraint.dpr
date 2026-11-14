program Constraint;

uses
  Forms,
  frm_ConstraintMain in '..\Constraint\frm_ConstraintMain.pas' {MainForm};

{$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Constraint';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
