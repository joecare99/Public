program TabEdit; 
uses 
  Forms, 
  Frm_AboutTabedit in '..\source\TABEDIT\Frm_AboutTabedit.pas' {frmAboutForm}, 
  Frm_TabeditMain in '..\source\TABEDIT\Frm_TabeditMain.pas' {frmMainForm}; 
{$R *.res} 
begin 
  Application.Initialize; 
  Application.MainFormOnTaskbar := True; 
  Application.Title := 'Demo: Tabedit'; 
  Application.CreateForm(TfrmMainForm, frmMainForm); 
  Application.CreateForm(TfrmAboutForm, frmAboutForm); 
  Application.Run; 
end. 
