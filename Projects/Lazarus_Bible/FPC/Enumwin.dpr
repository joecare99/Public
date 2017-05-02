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
  Frm_EnumWinMAIN in '..\Source\ENUMWIN\Frm_EnumWinMAIN.PAS' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
  Application.Initialize; 
  Application.Title := 'Demo: Enumwin'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
