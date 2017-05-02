program Contcomp;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  frm_ContCompMAIN in '..\source\ContComp\frm_ContCompMAIN.PAS' {MainForm};

{$R *.res}
{$IFNDEF FPC}
{$E EXE}
{$ENDIF}

begin
Application.Initialize;
  Application.Title := 'Demo: Contcomp';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
