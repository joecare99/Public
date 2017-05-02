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
  Frm_OntopMAIN in '..\Source\ONTOP\Frm_OntopMAIN.PAS' {MainForm}; 
{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'Stay On Top Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
