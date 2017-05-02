program Dclock;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_DClockMAIN in '..\source\DCLOCK\Frm_DClockMAIN.PAS' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
Application.Initialize;
  Application.Title := 'Demo: Dclock';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

