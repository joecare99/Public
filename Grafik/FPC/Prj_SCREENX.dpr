Program Prj_SCREENX;

{$IFDEF FPC}
  {$MODE Delphi}
{$else}
{$E exe}
{$ENDIF}

{ $R 'ScreenX.res' '..\Source\ScreenX.rc'}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  forms,
  Frm_ScreenXMain in '..\source\Frm_ScreenXMain.pas' {FrmScreenXMain},
  Unt_RenderTask in '..\source\Unt_RenderTask.pas';

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.Title := 'ScreenX Translokalisations-Funktionen';
  Application.CreateForm(TFrmScreenXMain, FrmScreenXMain);
  Application.Run;
End.

