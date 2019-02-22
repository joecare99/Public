program Capslock2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_Capslock2MAIN in '..\source\CAPSLOCK\Frm_Capslock2MAIN.PAS' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.Title := 'Demo: Capslock2';
  Application.CreateForm(TfrmCapsLock2Main, frmCapsLock2Main);
  Application.Run;
end.

