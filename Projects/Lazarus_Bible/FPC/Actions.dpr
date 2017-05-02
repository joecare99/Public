program Actions;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_ActionsMain in '..\source\Actions\Frm_ActionsMain.pas' {Form1};

{$IFDEF FPC}
{$E EXE}
{$ENDIF}

{$R *.res}

begin
  {$IFDEF FPC}
  Application.Initialize;
  {$ENDIF}
  Application.Title := 'Demo: Actions';
  Application.CreateForm(TFrmActionsMain, FrmActionsMain);
  Application.Run;
end.
