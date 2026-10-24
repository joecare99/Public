program Keyinfo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_KeyInfoMAIN in '..\source\KEYINFO\Frm_KeyInfoMAIN.pas' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Keyinfo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
