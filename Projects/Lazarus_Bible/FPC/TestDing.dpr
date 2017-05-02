program TestDing;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_TestDingMain in '..\source\DING\Frm_TestDingMain.pas' {MainForm};
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: TestDing';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
