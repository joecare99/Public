program AboutEx;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_AboutExMAIN in '..\source\ABOUTEX\frm_aboutexmain.pas',
  About in '..\source\ABOUTEX\About.pas' {MainForm};

{$IFnDEF FPC}
{$E EXE}
{$ENDIF}

{$R *.res}

begin
  {$IFDEF FPC}
  Application.Initialize;
  {$ENDIF}
  Application.Title := 'Demo: AboutEx';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
