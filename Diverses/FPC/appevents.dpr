program AppEvents;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  DefaultTranslator,
  Forms,
  frm_AppEventsMain {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmAppEventsMain, frmAppEventsMain);
  Application.Run;
end.
