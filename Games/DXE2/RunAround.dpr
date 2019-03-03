program RunAround;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  uMain in '..\RunAround\uMain.pas' {frm_game};

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF MSWINDOWS}
  {%H-}Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(Tfrm_game, frm_game);
  Application.Run;
end.
