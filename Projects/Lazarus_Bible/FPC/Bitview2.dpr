program Bitview2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_BitView2MAIN in '..\source\Bitview2\Frm_BitView2MAIN.pas' {frmBitmapViewer2Main};

{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Initialize;
  Application.Title := 'Demo: Bitview2';
  Application.CreateForm(TfrmBitmapViewer2Main, frmBitmapViewer2Main);
  Application.Run;
end.

