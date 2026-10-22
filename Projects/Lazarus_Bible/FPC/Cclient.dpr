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
  Frm_CLIMAIN in '..\source\DDECOLOR\Frm_CLIMAIN.pas' {MainForm};

{.$R *.RES}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Cclient';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
