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
  frm_NonClientMAIN in '..\source\NONCLIEN\frm_NonClientMAIN.pas' {MainForm}; 
{$E EXE} 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'Nonclient Area Message Handling'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
