program Fishy2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_Fishy2MAIN in '..\Source\FISHY\Frm_Fishy2MAIN.PAS' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
  application.initialize; 
  Application.Title := 'Demo: Fishy'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
