program Server1;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_SERVER in '..\source\DDE1\Frm_SERVER.pas' {ServerForm};

{$R *.res}
{$E EXE}

begin
Application.Initialize;
  Application.Title := 'Demo: Server1';
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
