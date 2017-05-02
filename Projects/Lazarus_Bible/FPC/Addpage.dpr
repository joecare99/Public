program Addpage;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$E EXE}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_AddpageMAIN in '..\source\Addpage\Frm_AddpageMAIN.pas' {MainForm};


begin
  {$IFDEF FPC}
  Application.Initialize;
  {$ENDIF}
  Application.Title := 'Demo: Add Page';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
