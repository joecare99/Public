program TabEdit; 
uses 
  Forms, 
  Frm_AboutTabedit in '..\Source\TABEDIT\Frm_AboutTabedit.PAS' {frmAboutForm}, 
  Frm_TabeditMain in '..\Source\TABEDIT\Frm_TabeditMain.PAS' {frmMainForm}; 
{$R *.res} 
begin 
  Application.Initialize; 
  Application.MainFormOnTaskbar := True; 
  Application.Title := 'Demo: Tabedit'; 
  Application.CreateForm(TfrmMainForm, frmMainForm); 
  Application.CreateForm(TfrmAboutForm, frmAboutForm); 
  Application.Run; 
end. 
