program Constraint;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_ConstraintMain in '..\source\Constraint\frm_ConstraintMain.pas' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Initialize;
  Application.Title := 'Demo: Constraint';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
