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
  Frm_HelloMAIN in '..\source\HELLO\view\Frm_HelloMAIN.pas' {Form1},
  HelloViewModel in '..\source\HELLO\viewmodel\HelloViewModel.pas'; 
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
