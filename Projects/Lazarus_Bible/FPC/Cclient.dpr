program Cclient;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_CLIMAIN in '..\source\DDEColor\Frm_CLIMAIN.PAS' {MainForm};

{.$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Cclient';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
