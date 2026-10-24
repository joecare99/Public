program Printgr;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_PrintgrMAIN in '..\source\PRINTGR\Frm_PrintgrMAIN.pas' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'Printgr - Demo'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
