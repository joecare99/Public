program Animator;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_AnimatorMain in '..\source\Animator\Frm_AnimatorMain.pas' {MainForm};

{$E EXE}
{$R *.res}

begin
  {$IFDEF FPC}
  Application.Initialize;
  {$ENDIF}
  Application.Title := 'Demo: Animator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
