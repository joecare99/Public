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
  Frm_ListerMAIN in '..\source\LISTER\Frm_ListerMAIN.pas' {MainForm}; 
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
