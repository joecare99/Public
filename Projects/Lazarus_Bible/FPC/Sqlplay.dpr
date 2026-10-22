program Sqlplay;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_SqlplayMAIN in '..\source\SQLPLAY\Frm_SqlplayMAIN.pas' {MainForm}, 
  Frm_SQLOPENDB in '..\source\SQLPLAY\Frm_SQLOPENDB.pas' {OpenForm}; 
{$E EXE}
begin 
  Application.Initialize; 
  Application.Title := 'Sqlplay - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TOpenForm, OpenForm); 
  Application.Run; 
end. 
