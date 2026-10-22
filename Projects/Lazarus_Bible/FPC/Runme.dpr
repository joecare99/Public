program Runme;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  DefaultTranslator,
  Frm_RunMeTEST in '..\source\README\Frm_RunMeTEST.pas' {TestForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'Runme - Demo'; 
  Application.CreateForm(TTestForm, TestForm); 
  Application.Run; 
end. 
