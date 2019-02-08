program Direxec2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_DirExecMain2 in '..\source\Direxec\Frm_DirExecMAIN2.PAS' {MainForm};


{$IFNDEF FPC} {$E EXE}   {$ENDIF}

begin
Application.Initialize;
  Application.Title := 'Demo: Direxec';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
