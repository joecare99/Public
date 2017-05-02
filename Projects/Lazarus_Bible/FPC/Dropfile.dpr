program Dropfile;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses 
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_DropFileMAIN in '..\Source\DROPFILE\Frm_DropFileMAIN.PAS' {MainForm}; 
{$R *.res}
{$IFNDEF FPC} {$E EXE}     {$ENDIF}
begin 
Application.Initialize; 
  Application.Title := 'Demo: Dropfile'; 
  Application.CreateForm(TMainForm, MainForm); 
  Application.Run; 
end. 
