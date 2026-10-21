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
  frm_HelloMAIN in '..\Source\HELLO\view\Frm_HelloMAIN.pas' {Form1},
  HelloViewModel in '..\Source\HELLO\viewmodel\HelloViewModel.pas'; 
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
