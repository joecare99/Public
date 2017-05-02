program Except1;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_Except1MAIN in '..\Source\EXCEPT1\Frm_Except1MAIN.PAS' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Except1'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
