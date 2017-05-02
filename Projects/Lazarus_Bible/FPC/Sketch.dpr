program Sketch;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_SketchMAIN in '..\Source\SKETCH\Frm_SketchMAIN.PAS' {MainForm}; 
{$IFNDEF FPC}
  {$E EXE}
{$ENDIF}
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'Sketch - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
