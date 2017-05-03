program Animator; 
uses 
  Forms, 
  Frm_AnimatorMain in '..\Source\Animator\Frm_AnimatorMain.pas' {MainForm}; 
{$E EXE}

{$R *.RES}
begin 
  Application.Initialize; 
  Application.Title := 'Demo: Animator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run; 
end. 
