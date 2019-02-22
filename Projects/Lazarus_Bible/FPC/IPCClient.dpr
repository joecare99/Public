program IPCClient;

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
  Frm_CLIENT2 in '..\Source\IPC\Frm_CLIENT2.PAS' {ClientForm};

{.$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Demo: IPC-Client2';
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
