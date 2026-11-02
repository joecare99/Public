program Master;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_MasterMAIN in '..\source\MASTER\Frm_MasterMAIN.PAS' {MainForm}; 
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
{$R *.res}
begin 
Application.Initialize; 
  Application.Title := 'Master-Detail Database Demonstration'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
