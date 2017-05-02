program Toolbar3;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_Toolbar3MAIN in '..\Source\TOOLBAR3\Frm_Toolbar3MAIN.PAS' {MainForm};
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
  Application.Initialize; 
  Application.Title := 'Demo: Toolbar3'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
