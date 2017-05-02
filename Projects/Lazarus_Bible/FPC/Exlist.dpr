program Exlist;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_exListMAIN in '..\Source\EXLIST\Frm_exListMAIN.PAS' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Exlist'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
