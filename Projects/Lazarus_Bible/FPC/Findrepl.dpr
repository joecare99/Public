program Findrepl;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_FindReplMAIN in '..\source\FINDREPL\Frm_FindReplMAIN.pas' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Findrepl'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
