program Checks2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_Checks2Main in '..\source\CHECKS\Frm_Checks2Main.PAS' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Initialize;
  Application.Title := 'Demo: Checks2';
  Application.CreateForm(TfrmChecks2Main, frmChecks2Main);
  Application.Run;
end.

