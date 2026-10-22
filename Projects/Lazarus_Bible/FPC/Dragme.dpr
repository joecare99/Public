program Dragme;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_DragMeMAIN in '..\source\DRAGME\Frm_DragMeMAIN.pas' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Dragme'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
