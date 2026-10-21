program Listtext;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_ListTextMAIN in '..\source\LISTTEXT\Frm_ListTextMAIN.pas' {MainForm}; 
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
{$R *.res}
begin 
Application.Initialize; 
  Application.Title := 'List Text Files'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
