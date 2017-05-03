program Tabs;

uses
  Forms,
  Frm_TabsMAIN in '..\source\tabs\Frm_TabsMAIN.PAS' {MainForm},
  Frm_ABOUT in '..\source\tabs\Frm_ABOUT.PAS' {AboutForm},
  Frm_OPTIONS in '..\source\tabs\Frm_OPTIONS.PAS' {OptionsDialog},
  TABSUNIT in '..\source\tabs\TABSUNIT.PAS',
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

