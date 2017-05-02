program BarTest;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_BartestMain in '..\source\BARCHART\Frm_BartestMain.pas' {frmBarChartMain};
{$E EXE}

begin
  {$IFDEF FPC}
  Application.Initialize;
  {$ENDIF}
  Application.Title := 'Demo: BarTest';
  Application.CreateForm(TfrmBarChartMain, frmBarChartMain);
  Application.Run;
end.
