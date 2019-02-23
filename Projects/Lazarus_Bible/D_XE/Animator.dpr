program Animator;

uses
  Forms,
  Frm_AnimatorMain in '..\source\Animator\Frm_AnimatorMain.pas' {frmAnimatorMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAnimatorMain, frmAnimatorMain);
  Application.Run;
end.
