program Enumfon;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_EnumFonMAIN in '..\Source\ENUMFON\Frm_EnumFonMAIN.PAS' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Enumfon';
  Application.CreateForm(TfrmEnumFontsMain, frmEnumFontsMain);
  Application.Run; 
end. 
