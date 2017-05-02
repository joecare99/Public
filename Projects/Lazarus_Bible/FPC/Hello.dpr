program Hello;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_HelloMAIN in '..\Source\HELLO\frm_HelloMAIN.PAS' {Form1}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Hello'; 
  Application.CreateForm(TForm1, Form1); 
  Application.Run; 
end. 
