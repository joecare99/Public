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
  Frm_ListTextMAIN in '..\Source\LISTTEXT\Frm_ListTextMAIN.PAS' {MainForm}; 
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
