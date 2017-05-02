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
  Frm_SqlplayMAIN in '..\Source\SQLPLAY\Frm_SqlplayMAIN.PAS' {MainForm}, 
  Frm_SQLOPENDB in '..\Source\SQLPLAY\Frm_SQLOPENDB.PAS' {OpenForm}; 
{$E EXE}
begin 
  Application.Initialize; 
  Application.Title := 'Sqlplay - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.CreateForm(TOpenForm, OpenForm); 
  Application.Run; 
end. 
