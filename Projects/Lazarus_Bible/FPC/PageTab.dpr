program PageTab;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_PageTabMain in '..\Source\PageTab\Frm_PageTabMain.pas' {MainForm}; 
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'PageTab - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
