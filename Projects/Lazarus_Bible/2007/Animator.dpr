program Animator;

uses
  Forms,
  Frm_AnimatorMain in '..\Animator\Frm_AnimatorMain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
