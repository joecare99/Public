program Fishy;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_FishyMAIN in '..\Source\FISHY\Frm_FishyMAIN.PAS' {MainForm}; 
{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
begin
Application.Initialize; 
  Application.Title := 'Demo: Fishy'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
