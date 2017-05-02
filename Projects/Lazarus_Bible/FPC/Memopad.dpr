program Memopad;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_MemoPadMAIN in '..\Source\MEMOPAD\Frm_MemoPadMAIN.PAS' {MainForm}; 
{$E EXE} 
{$R *.res}
begin 
  Application.Title := 'Memo Pad'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
