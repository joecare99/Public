program Keycount;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_KeyCountMAIN in '..\source\KEYCOUNT\Frm_KeyCountMAIN.pas' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Keycount'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
