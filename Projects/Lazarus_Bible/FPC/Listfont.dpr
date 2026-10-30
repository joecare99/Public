program Listfont;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_ListFontMAIN in '..\source\LISTFONT\Frm_ListFontMAIN.pas' {MainForm}; 
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
{$R *.res}
begin 
Application.Initialize; 
  Application.Title := 'Font-Lister'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
