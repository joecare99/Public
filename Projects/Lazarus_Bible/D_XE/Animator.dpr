program Animator;

uses
  Forms,
  Frm_AnimatorMain in '..\source\Animator\Frm_AnimatorMain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
