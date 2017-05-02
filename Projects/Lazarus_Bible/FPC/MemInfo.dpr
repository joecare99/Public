program MemInfo;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_MemInfoMain in '..\Source\MemInfo\frm_MemInfoMain.pas' {MainForm}; 
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}
{$R *.res}
begin 
  Application.Initialize; 
  Application.Title := 'Program Memory Information'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
