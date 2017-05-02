program Client1;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_CLIENT in '..\Source\DDE1\Frm_CLIENT.PAS' {ClientForm};

{.$R *.RES}
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Client1';
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
