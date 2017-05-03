program Aboutex;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  ABOUT in '..\source\ABOUTEX\ABOUT.PAS' {AboutForm} ,
  Frm_AboutExMAIN in '..\source\ABOUTEX\Frm_AboutExMAIN.PAS' {MainForm};

{$E EXE}
{$R *.res}

begin
  Application.Title := 'Demo: AboutEx';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;

end.
