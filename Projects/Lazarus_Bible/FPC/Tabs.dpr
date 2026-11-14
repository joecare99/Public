program Tabs; 
uses 
  Forms, 
  Frm_TabsMAIN in '..\source\TABS\Frm_TabsMAIN.PAS' {MainForm}, 
  TABS_Frm_ABOUT in '..\source\TABS\TABS_Frm_ABOUT.pas' {AboutForm}, 
  Frm_OPTIONS in '..\source\TABS\Frm_OPTIONS.PAS' {OptionsDialog}, 
  TabsUnit in '..\source\TABS\TABSUNIT.PAS', 
  Inidata in '..\source\Inidata\Inidata.pas'; 
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
