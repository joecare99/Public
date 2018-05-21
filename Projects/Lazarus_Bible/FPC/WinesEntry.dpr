program WinesEntry; 
{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_WinesEntryMain in '..\Source\WinesEntry\Frm_WinesEntryMain.pas' {MainForm}; 
 {$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin 
  Application.Initialize; 
  Application.Title := 'Demo: WinesEntry'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
