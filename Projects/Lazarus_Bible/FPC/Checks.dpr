program Checks;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_ChecksMAIN in '..\source\CHECKS\Frm_ChecksMAIN.PAS' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Initialize;
  Application.Title := 'Demo: Checks';
  Application.CreateForm(TfrmChecksMain, frmChecksMain);
  Application.Run;
end.

