program Tabs; 
uses 
  Forms, 
  Frm_TabsMAIN in '..\Source\TABS\Frm_TabsMAIN.PAS' {MainForm}, 
  Frm_ABOUT in '..\Source\TABS\Frm_ABOUT.PAS' {AboutForm}, 
  Frm_OPTIONS in '..\Source\TABS\Frm_OPTIONS.PAS' {OptionsDialog}, 
  TABSUNIT in '..\Source\TABS\TABSUNIT.PAS', 
  Inidata in '..\Source\TABS\..\Inidata\Inidata.pas'; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Tabs'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TAboutForm, AboutForm); 
  Application.CreateForm(TOptionsDialog, OptionsDialog); 
  Application.Run; 
end. 
