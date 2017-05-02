program Lister;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_ListerMAIN in '..\Source\LISTER\Frm_ListerMAIN.PAS' {MainForm}; 
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
{$R *.res}
begin 
Application.Initialize; 
  Application.Title := 'Demo: Lister'; 
  Application.Title := 'Text-File-Lister'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
