program Bitview;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_BitViewMAIN in '..\source\BITVIEW\Frm_BitViewMAIN.PAS' {frmBitmapViewerMain};
{$E EXE}

begin
  Application.Initialize;
  Application.Title := 'Demo: Bitview';
  Application.CreateForm(TfrmBitmapViewerMain, frmBitmapViewerMain);
  Application.Run;
end.

