program Ontop;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_OntopMAIN in '..\source\ONTOP\Frm_OntopMAIN.pas' {MainForm}; 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'Stay On Top Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
