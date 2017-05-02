program Nonclien;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_NonClientMAIN in '..\Source\NONCLIEN\frm_NonClientMAIN.PAS' {MainForm}; 
{$E EXE} 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'Nonclient Area Message Handling'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
