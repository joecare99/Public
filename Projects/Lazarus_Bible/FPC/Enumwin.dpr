program Enumwin;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_EnumWinMAIN in '..\source\ENUMWIN\Frm_EnumWinMAIN.PAS' {MainForm},
  unt_GetWindows in '..\source\ENUMWIN\unt_getwindows.pas'; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
  Application.Initialize; 
  Application.Title := 'Demo: Enumwin';
  Application.CreateForm(TfrmEnumWinMain, frmEnumWinMain);
  Application.Run; 
end. 
