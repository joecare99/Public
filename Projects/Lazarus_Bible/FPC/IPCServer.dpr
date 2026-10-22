program IPCServer;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$E EXE}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_SERVER2 in '..\source\IPC\Frm_SERVER2.pas' {ServerForm};

{.$R *.res}

begin
Application.Initialize;
  Application.Title := 'Demo: Server1';
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
