program Tabs; 
uses 
  Forms, 
  Frm_TabsMAIN in '..\source\TABS\Frm_TabsMAIN.pas' {MainForm}, 
  TABS_Frm_ABOUT in '..\source\TABS\TABS_Frm_ABOUT.pas' {AboutForm}, 
  Frm_OPTIONS in '..\source\TABS\Frm_OPTIONS.pas' {OptionsDialog}, 
  TabsUnit in '..\source\TABS\TabsUnit.pas', 
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
