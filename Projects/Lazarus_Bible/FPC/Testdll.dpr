program Testdll;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_TestDLLMAIN in '..\source\COLORDLL\Frm_TestDLLMAIN.PAS' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Initialize;
  Application.Title := 'Demo: Testdll';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
