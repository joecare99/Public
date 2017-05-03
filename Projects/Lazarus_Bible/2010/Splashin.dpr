program Splashin; 
uses 
  Forms, 
  Frm_SplashinMAIN in '..\Source\SPLASHIN\Frm_SplashinMAIN.PAS' {MainForm}, 
  Frm_SPLASH in '..\Source\SPLASHIN\Frm_SPLASH.PAS' {SplashForm}; 
{$E EXE} 
{$R *.RES} 
begin 
  Application.Initialize; 
  Application.Title := 'Splashin - Demo'; 
  SplashForm := TSplashForm.Create(Application); 
  SplashForm.Show; 
  SplashForm.Update; 
  Application.CreateForm(TMainForm, MainForm); 
  SplashForm.Close; 
  Application.Run; 
end. 
