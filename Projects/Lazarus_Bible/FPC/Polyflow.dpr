program Polyflow;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_PolyflowMain in '..\Source\POLYFLOW\Frm_PolyflowMain.pas' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'Polyflow - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
