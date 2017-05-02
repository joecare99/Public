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
  Frm_DragMeMAIN in '..\Source\DRAGME\Frm_DragMeMAIN.PAS' {MainForm}; 
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
