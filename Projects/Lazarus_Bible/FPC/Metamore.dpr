program Metamore;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_MetaMoreMAIN in '..\Source\METAMORE\Frm_MetaMoreMAIN.PAS' {MainForm}; 
{$E exe} 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'MetaMore'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
