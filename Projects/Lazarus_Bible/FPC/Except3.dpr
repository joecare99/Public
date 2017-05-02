program Except3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_except3MAIN in '..\Source\EXCEPT3\frm_except3MAIN.PAS' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Except3'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
