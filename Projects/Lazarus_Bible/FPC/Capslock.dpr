program Capslock;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  Frm_CapslockMAIN in '..\source\CAPSLOCK\Frm_CapslockMAIN.PAS' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
  Application.Scaled:=True;
Application.Initialize;
  Application.Title := 'Demo: Capslock';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

