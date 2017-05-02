program Except2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_Except2MAIN in '..\Source\EXCEPT2\frm_Except2MAIN.PAS' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Except2'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
